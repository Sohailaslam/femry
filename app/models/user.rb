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
end
