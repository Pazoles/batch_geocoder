class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_action :correct_user,   only: :destroy
  def import
    require 'csv'
    #GeocoderWorker.perform_async(current_user.id, params[:file].path, params[:file].original_filename)
    @job = Delayed::Job.enqueue ImportJob.new(current_user.id, params[:file].path, params[:file].original_filename)
    #@user = current_user
    #@user.locations.import(params[:file], @user.id)
    sleep 4

    if @job.nil?
      sleep 4
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def update_feed
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def index
    @sources = Location.uniq.pluck(:source)
    #@source = @Location.source
    @locations = Location.order(created_at: :desc).paginate(page: params[:page], :per_page => 10)
    @locationexport = Location.where("source = ? AND location_type = ?", params[:source], 'ROOFTOP')
    #@exportlocations = Location.where("source = ?",@source).order(created_at: :desc)
    respond_to do |format|
      format.html
      format.csv {
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@locationexport.first.source}\""
        render text: @locationexport.to_csv}
    end
  end

  def show
  end

  def new
    @location = Location.new
    @user = current_user
  end

  def edit
  end

  def create
    @location = current_user.locations.build(location_params)
    update_feed

  end

  def destroy
    @location.destroy
    flash[:success] = "Location deleted"
    redirect_to request.referrer || root_url
  end

  private

  def correct_user
    @location = current_user.locations.find_by(id: params[:id])
    redirect_to root_url if @location.nil?
  end

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:address, :latitude, :longitude, :source, :externalid)
  end
end
