class Users::PasswordsController < Devise::PasswordsController
  prepend_before_action :require_no_authentication
  # Render the #edit only if coming from a reset password email link
  append_before_action :assert_reset_token_passed, only: :edit

  # GET /resource/password/new
  def new
    self.resource = resource_class.new
  end

  # POST /resource/password
  def create
    self.resource = User.find_by_email(resource_params[:email])
    yield resource if block_given?

    if resource.present?
      session[:user_id] = resource.id
      client = Aws::CognitoIdentityProvider::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
      begin
        resp = client.forgot_password({
          client_id: ENV["AWS_COGNITO_CLIENT_ID"],
          username: resource_params[:email],
        })
        respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
      rescue => e
        redirect_to new_user_password_path, notice: e.message
      end
    else
      redirect_to new_user_password_path, notice: "Email not found"
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    set_minimum_password_length
    resource.reset_password_token = params[:reset_password_token]
  end

  # PUT /resource/password
  def update
    user = User.find(params[:user_id])
    self.resource = User.find(params[:user_id])
    resource.password = params[:new_password]
    resource.save(validate: false)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        client = Aws::CognitoIdentityProvider::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
        begin
          resp = client.confirm_forgot_password({client_id: ENV["AWS_COGNITO_CLIENT_ID"], username: user.email, confirmation_code: params["verify_code"], password: params["new_password"],})
          set_flash_message!(:notice, flash_message)
          sign_in(resource_name, resource)
        rescue
        end
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      set_minimum_password_length
      respond_with resource
    end
  end

  protected
    def after_resetting_password_path_for(resource)
      Devise.sign_in_after_reset_password ? after_sign_in_path_for(resource) : new_session_path(resource_name)
    end

    # The path used after sending reset password instructions
    def after_sending_reset_password_instructions_path_for(resource_name)
      user = User.find_by_email(params[:user][:email])
      password_auth_path(user_id: user.id) if is_navigational_format?
    end

    # Check if a reset_password_token is provided in the request
    def assert_reset_token_passed
      if params[:reset_password_token].blank?
        set_flash_message(:alert, :no_token)
        redirect_to new_session_path(resource_name)
      end
    end

    # Check if proper Lockable module methods are present & unlock strategy
    # allows to unlock resource on password reset
    def unlockable?(resource)
      resource.respond_to?(:unlock_access!) &&
        resource.respond_to?(:unlock_strategy_enabled?) &&
        resource.unlock_strategy_enabled?(:email)
    end

    def translation_scope
      'devise.passwords'
    end
end
