class UpdateDrive
  include SuckerPunch::Job
  workers 2
  def initialize
    @@mutex = Mutex.new
  end

  def perform(guest)
    @@mutex.lock
    begin
      ActiveRecord::Base.connection_pool.with_connection do
        @guest = guest
        @guest.update_spreadsheet
      end
    end
  ensure
    @@mutex.unlock
  end

end

