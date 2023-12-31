class Enrollment < ApplicationRecord
  belongs_to :course, counter_cache: true
  belongs_to :user, counter_cache: true
  #Course.find_each { |course| Course.reset_counters(course.id, :enrollments) } 

  validates :user, :course, presence: true
  validates_presence_of :rating, if: :review?
  validates_presence_of :review, if: :rating?
  
  validates_uniqueness_of :user_id, scope: :course_id 
  validates_uniqueness_of :course_id, scope: :user_id  

  validate :cant_subscribe_to_own_course    

  scope :pending_review, -> { where(rating:[0,nil,''], review:[0,nil,''])}
  scope :reviewed, -> { where.not(review: [0, nil, ""]) }
  scope :latest_good_reviews, -> { order(rating: :desc, created_at: :desc).limit(3) }

  extend FriendlyId
  friendly_id :to_s, use: :slugged

  def to_s
    user.to_s + " " + course.to_s
  end

  def self.ransackable_attributes(auth_object = nil)
    ["price", "rating", "review"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["course", "user"]
  end

  after_save do
    unless rating.nil? || rating.zero?
      course.update_rating
    end
  end

  after_destroy do
    course.update_rating
  end


  protected
  def cant_subscribe_to_own_course
    if self.new_record?
      if self.user_id.present?
        if self.user_id == course.user_id
          errors.add(:base, "You can not subscribe to your own course")
        end
      end
    end
  end

end