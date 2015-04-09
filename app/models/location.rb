class Location < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  geocoded_by :full_address do |obj,results|
    if geo = results.first
    obj.latitude    = geo.latitude
    obj.longitude = geo.longitude
    obj.location_type = geo.geometry["location_type"]
    end
  end
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  def full_address
    [address, city, state, zip].compact.join(', ')
  end
  
  def Location.uploaded_by(user)
    Location.where("user_id = ?", id)
  end
  
  def self.to_csv
    CSV.generate do |csv|
      csv << ["externalid","address","city","state","zip","latitude","longitude", "precision"]
      all.each do |location|
        csv << [location.externalid, location.address, location.city, location.state, location.zip, location.latitude, location.longitude, location.location_type]
      end
    end
  end


end
