class Location < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
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
  
  def Location.uploaded_by(user)
    Location.where("user_id = ?", id)
  end
  
  def self.to_csv
    CSV.generate do |csv|
      csv << ["externalid","address","latitude","longitude", "precision"]
      all.each do |location|
        csv << [location.externalid, location.address, location.latitude, location.longitude, location.location_type]
      end
    end
  end

 # def self.import(file)
  #  numrow = CSV.readlines(file.path).size
  #  time = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
  #  CSV.foreach(file.path, headers: true) do |row|
  ##    new = row.to_hash
   #   new.merge!(source: [time,file.original_filename].join('_'))
   #   Location.create! new
  #  end
 # end
  
  class << self

    def importcsv(file_path, file_name, user_id)
        @user = User.find_by(id: user_id)
        time = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
        CSV.foreach(file_path, headers: true) do |row|
          new = row.to_hash
          new.merge!(source: [time,file_name].join('_'))
          @user.locations.create! new
        end 
    end 
    handle_asynchronously :importcsv
  end

  # My importer as a class method
  def self.import(file, user_id)
    Location.importcsv(file.path,file.original_filename, user_id)
  end


end
