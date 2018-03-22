class Listing < ActiveRecord::Base
  after_create :check_user_host
  after_destroy :check_user_host

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood

  def average_review_rating
    
  end

  private


  def check_user_host
    if self.host.listings.empty?
      self.host.host = false
    else
      self.host.host = true
    end
    self.host.save
  end
end
