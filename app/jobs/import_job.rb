class ImportJob < ProgressJob::Base
  def initialize(user_id, file_path, file_name)
    @user = User.find_by(id: user_id)
    @file_path = file_path
    @file_name = file_name
    numrows = CSV.readlines(file_path).size

  end
  
  def perform
    require 'csv'
    update_stage('Geocoding')
    update_progress_max(CSV.readlines(@file_path).size)
        time = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
        CSV.foreach(@file_path, headers: true) do |row|
          new = row.to_hash
          new.merge!(source: [time,@file_name].join('_'))
          @user.locations.create! new
          update_progress
        end 
    end 
  end