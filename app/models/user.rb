class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # attr_accessible :first_name, :last_name, :tasks_attributes
  has_many :tasks, dependent: :destroy
  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true       

  validate :password_complexity

  def password_complexity
    if password.present? and not password.match(/^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){6,}$/)
      errors.add :password, "must include at least one letter, and one digit"
    end
  end
end
