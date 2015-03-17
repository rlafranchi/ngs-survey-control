class NgsController < ApplicationController
  
  def index
    if lat_param.present? && long_param.present?
      @query = NgsQuery.new(lat_param, long_param)
      @results = @query.results_within_mile(distance_param)
    end
  end
  
  private
  
  def distance_param
    params[:distance] || 5
  end

  def lat_param
    params[:latitude]
  end
  
  def long_param
    params[:longitude]
  end
end
