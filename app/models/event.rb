class Event < ActiveRecord::Base
  has_many :registrations, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  has_many :likers, :through => :likes, :source => :user
  has_many :categorizations, :dependent => :destroy
  has_many :categories, :through => :categorizations

  validates :name, presence: true
  validates :location, presence: true
  validates :description, length: { minimum: 25 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }
  validates :image_file_name, allow_blank: true, format: {
    with:    /\w+\.(gif|jpg|png)\z/i,
    message: "must reference a GIF, JPG, or PNG image"
  }
  
  def self.upcoming
    where('starts_at >= ?', Time.now).order(:starts_at)
  end
    
  def free?
    price.blank? || price.zero?
  end  
  
  def spots_left
    if capacity.zero?
      0
    else
      capacity - registrations.size
    end
  end
  
  def sold_out?
    spots_left.zero?
  end
end
