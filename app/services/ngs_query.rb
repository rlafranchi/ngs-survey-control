class NgsQuery
  attr_accessor :latitude, :longitude, :response

  def initialize(latitude, longitude)
    @state = state
    @latitude = latitude
    @longitude = longitude
    send_request
  end

  def results_within_mile(distance)
    JSON.parse(response.body)['features'].select { |feature| distance_to(feature['geometry']) < distance }
  end

  def distance_to(location={})
    # Haversine Formula
    φ1 = latitude.to_f * Math::PI / 180
    φ2 = location['y'].to_f * Math::PI / 180
    long1 = longitude.to_f * Math::PI / 180
    long2 = location['x'].to_f * Math::PI / 180

    earth_radius = (6371000 * 0.000621371).to_f # miles
    Δφ = (φ2-φ1)
    Δλ = (long2-long1)

    a = (Math.sin(Δφ/2) * Math.sin(Δφ/2)) + (Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ/2) * Math.sin(Δλ/2))
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))

    (earth_radius * c).round(2)
  end

  def send_request
    @response = conn.get "/ArcGIS/rest/services/NGS_Survey_Control_Points/MapServer/1/query", request_params
  end

  private

  def conn
    Faraday.new(:url => query_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def request_params
    {
      f: "json",
      outSR: "4326",
      geometryType: 'esriGeometryEnvelope',
      geometry: envelope_distance,
      inSR: "4326",
      outFields: "DATA_SRCE,NAME,LAST_COND,ELEVATION,ELEV_ORDER,STABILITY"
    }
  end

  def query_url
    "http://maps1.arcgisonline.com"
  end

  def envelope_distance
    lat = latitude.to_f * Math::PI / 180

    m1 = 111132.92
    m2 = -559.82
    m3 = 1.175
    m4 = -0.0023
    p1 = 111412.84
    p2 = -93.5
    p3 = 0.118

    latlen = m1 + (m2 * Math.cos(2 * lat)) + (m3 * Math.cos(4 * lat)) + (m4 * Math.cos(6 * lat))
    longlen = (p1 * Math.cos(lat)) + (p2 * Math.cos(3 * lat)) + (p3 * Math.cos(5 * lat))

    latfeet = latlen * 3.280833333
    latsm = latfeet / 5280
    latenv = 10 / latsm

    longfeet = longlen * 3.280833333
    longsm = longfeet / 5280
    longenv = 10 / longsm
    "{xmin: #{longitude.to_f - longenv}, ymin: #{latitude.to_f - latenv}, xmax: #{longitude.to_f + longenv}, ymax: #{latitude.to_f + latenv}}"
  end
end
