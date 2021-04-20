class EngineService

  def self.all_purposes
    response = connection.get('/api/v1/purposes')
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.create_yard(yard_params)
    response = connection.post('/api/v1/yards') do |req|
      req.headers["CONTENT_TYPE"] = "application/json"
      req.params = yard_params
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.yard_details(yard_id)
    response = connection.get("/api/v1/yards/#{yard_id}")
    JSON.parse(response.body, symbolize_names: true)[:data]
  end

  def self.host_yards(host_id)
    response = connection.get("/api/v1/hosts/#{host_id}/yards")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.yards_in_location(yard_params)
    response = connection.get('/api/v1/yards/yard_search') do |req|
      req.headers["CONTENT_TYPE"] = "application/json"
      req.params = yard_params
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.connection
    Faraday.new(url: ENV['ys_engine_url'])
  end
end
