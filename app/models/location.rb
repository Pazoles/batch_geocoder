class Location < ActiveRecord::Base
  geocoded_by :address do |obj,results|
    if geo = results.first
    obj.latitude    = geo.latitude
    obj.longitude = geo.longitude
    obj.location_type = geo.geometry["location_type"]
    end
  end
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  #def address
  #  [street, city, state, zip].compact.join(', ')
  #end
  
  #def geocode_process
    # geocode
    # if Location.source.present?
      # @locations = Location.where("source = ?", Location.source)
      # send_data @locations.to_csv
    # end
  # end
  
  
  
  def self.to_csv
    CSV.generate do |csv|
      csv << ["externalid","address","latitude","longitude", "precision"]
      all.each do |location|
        csv << [location.externalid, location.address, location.latitude, location.longitude, latitude.location_type]
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      new = row.to_hash
      new.merge!(source: [Time.now.strftime("%Y-%m-%d-%H%M%S"),file.original_filename].join('_'))
      Location.create! new
    end
  end
  


end
