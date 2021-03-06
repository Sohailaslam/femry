class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :avatar, AvatarUploader
  # attr_accessible :first_name, :last_name, :tasks_attributes
  has_many :tasks, dependent: :destroy
  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true

  has_many :thoughts, dependent: :destroy
  accepts_nested_attributes_for :thoughts, reject_if: :all_blank, allow_destroy: true

  has_many :tags, dependent: :destroy

  # has_one_attached :avatar

  
  belongs_to :plan, optional: true


  FREE = 1
  PREMIUM = 2

  def is_free?
    self.plan_id == FREE
  end

  def is_premium?
    self.plan_id == PREMIUM
  end

  def incomplete_tasks
    incomplete_tasks = tasks.where(status: 0).where.not("Date(task_date) = ?", Time.current.in_time_zone(self.get_timezone).to_date)
    incomplete_tasks.map{|task| task.update_attributes(task_date: Time.current.in_time_zone(self.get_timezone).to_date)} if incomplete_tasks.present?
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
    resp = client.admin_initiate_auth({  user_pool_id: ENV["AWS_COGNITO_USER_POOL_ID"], client_id: ENV["AWS_COGNITO_CLIENT_ID"], auth_flow: "ADMIN_NO_SRP_AUTH",  auth_parameters: {  "USERNAME" => self.email,   "PASSWORD" => password  },})
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

  def aws_update_password(current_password, password)
    client = Aws::CognitoIdentityProvider::Client.new(access_key_id: ENV["AWS_ACCESS_KEY_ID"], secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])
    begin
      auth_resp = client.initiate_auth({  auth_flow: "USER_PASSWORD_AUTH", auth_parameters: { "USERNAME" => self.email,"PASSWORD" => current_password },  client_id: ENV["AWS_COGNITO_CLIENT_ID"]})
      resp = client.change_password({ previous_password: current_password, proposed_password: password, access_token: auth_resp.authentication_result.access_token })
    rescue
      exception = StandardError.new("No Results Found")
      exception.set_backtrace(caller)
      raise exception
    end
  end

  def delete_inactive_todos
    tasks.deleted_tasks.destroy_all
    thoughts.deleted_thoughts.destroy_all
  end

  def get_initials
    "#{first_name} #{last_name}".split.map(&:first).join.upcase
  end

  def streak
    if self.streak_end && self.streak_start
      self.streak_end > 24.hours.ago ? (self.streak_start.to_date .. self.streak_end.to_date).count : 0
    else
      0
    end
  end

  def active_tasks_in_date_count(date)
    self.tasks.active_tasks.where("Date(task_date) = ?", date).count
  end

  def get_timezone
    self.timezone.present? ? self.timezone : Time.zone.name
  end
end
