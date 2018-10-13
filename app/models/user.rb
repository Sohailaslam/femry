class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         

  validate :password_complexity

  def password_complexity
    if password.present? and not password.match(/^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){6,}$/)
      errors.add :password, "must include at least one letter, and one digit"
    end
  end

  def add_to_aws_cognito
    client = Aws::CognitoIdentityProvider::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
    resp = client.sign_up({
      client_id: ENV["AWS_COGNITO_CLIENT_ID"],
      username: self.email,
      password: "Hamza!23",
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

  def authenticate_with_aws
    client = Aws::CognitoIdentityProvider::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
    resp = client.admin_initiate_auth({
      user_pool_id: ENV["AWS_COGNITO_USER_POOL_ID"],
      client_id: ENV["AWS_COGNITO_CLIENT_ID"],
      auth_flow: "ADMIN_NO_SRP_AUTH",
      auth_parameters: {
        "USERNAME" => self.email,
        "PASSWORD" => "Hamza!23"
      },
    })
    resp
  end

  def aws_sign_out_resp
    client = Aws::CognitoIdentityProvider::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])

    resp = client.global_sign_out({
      access_token: self.access_token,
    })
    self.update(access_token: nil)
    resp
  end
  
end
