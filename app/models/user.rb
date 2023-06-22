class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable
  
  rolify
  
  has_many :courses
  has_many :enrollments

  extend FriendlyId
  friendly_id :email, use: :slugged

  def to_s
    email
  end
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "current_sign_in_at", "current_sign_in_ip", "email", "id", "last_sign_in_at", "last_sign_in_ip", "remember_created_at", "reset_password_sent_at", "sign_in_count", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["courses"]
  end

  def username
    self.email.split(/@/).first
  end

  after_create :assign_default_role
  def assign_default_role
    if User.count == 1
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:teacher)
      self.add_role(:student)
    else
      self.add_role(:student) if self.roles.blank?
      self.add_role(:teacher)
    end
  end

  validate :must_have_a_role, on: :update

  def online?
    updated_at > 2.minutes.ago
  end

  def buy_course(course)
    self.enrollments.create(course: course, price: course.price)
  end

  private
  def must_have_a_role
    unless roles.any?
      errors.add(:roles, "must have at least one role")
    end
  end

end
