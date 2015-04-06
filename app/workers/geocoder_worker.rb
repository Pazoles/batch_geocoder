class GeocoderWorker
  include Sidekiq::Worker
   sidekiq_options :retry => false
   
   
   

  def perform(user, file_path, name)
        @user = User.find_by(id: user)
        @user.locations.import(file_path, name)
    end
  
end