class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:landing_page]
  def landing_page
    @latest_good_reviews = Enrollment.reviewed.latest_good_reviews
    @latest = Course.latest
    @top_rated = Course.top_rated
    @popular = Course.popular
    @purchased_courses = Course.purchased(current_user)
  end

  def privacy_policy
  end

  def activity
    if current_user.has_role?(:admin)
      @activities = PublicActivity::Activity.all
    else
      redirect_to root_path, alert: "You are not authorized to access this page"
    end
  end

  def analytics
    redirect_to root_path, alert: "You are not authorized to access this page" unless current_user.has_role?(:admin)
  end
end
