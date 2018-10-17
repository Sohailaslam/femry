class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # attr_accessible :first_name, :last_name, :tasks_attributes
  has_many :tasks, dependent: :destroy
  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true

  has_many :thoughts, dependent: :destroy
  accepts_nested_attributes_for :thoughts, reject_if: :all_blank, allow_destroy: true       

  validate :password_complexity

  def password_complexity
    if password.present? and !password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)((?=.*\W)).{6,70}./)
      errors.add :password, "must include at least one letter, one digit and one special character"
    end
  end

  def incomplete_tasks
    incomplete_tasks = tasks.where(status: 0).where.not(task_date: Date.today)
    incomplete_tasks.map{|task| task.update_attributes(task_date: Date.today)} if incomplete_tasks.present?
  end

  def add_to_aws_cognito(password)
    client = Aws::CognitoIdentityProvider::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
    resp = client.sign_up({
      client_id: ENV["AWS_COGNITO_CLIENT_ID"],
      username: self.email,
      password: password,
      user_attributes: [
        {
          name: "email",
          value: self.email,
        },
      ],
    })

    resp

    # if !resp.user_confirmed
    #   self.confirm_aws_user(client)
    # end
  end

  def confirm_aws_user client
    client.admin_confirm_sign_up({user_pool_id: ENV["AWS_COGNITO_USER_POOL_ID"], username: self.email,})
  end

  def authenticate_with_aws password
    client = Aws::CognitoIdentityProvider::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
    resp = client.admin_initiate_auth({
      user_pool_id: ENV["AWS_COGNITO_USER_POOL_ID"],
      client_id: ENV["AWS_COGNITO_CLIENT_ID"],
      auth_flow: "ADMIN_NO_SRP_AUTH",
      auth_parameters: {
        "USERNAME" => self.email,
        "PASSWORD" => password
      },
    })
    resp
  end

  def aws_sign_out_resp
    client = Aws::CognitoIdentityProvider::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
    begin
      resp = client.global_sign_out({
        access_token: self.access_token,
      })
    rescue
    end
    self.update(access_token: nil)
    resp
  end

  def aws_update_firstname_and_last_name(first_name, last_name)
    full_name = "#{first_name} #{last_name}"
    client = Aws::CognitoIdentityProvider::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
    begin
      resp = client.update_user_attributes({user_attributes: [{name: "name",value: full_name,},],access_token: self.access_token,})
    rescue
    end
  end
  
end
