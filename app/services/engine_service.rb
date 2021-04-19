class EngineService

  def self.all_purposes
    response = connection.get('/api/v1/purposes')
    data = response.body
    JSON.parse(data, symbolize_names: true)
  end

  def self.create_yard(yard_params)

    response = connection.post('/api/v1/yards') do |req|
      req.headers["CONTENT_TYPE"] = "application/json"
      req.params = yard_params
    end
    
    data = response.body
    JSON.parse(data, symbolize_names: true)[:data]
  end

  def self.yard_details(yard_id)
    response = connection.get("/api/v1/yards/#{yard_id}")
    data = response.body
    JSON.parse(data, symbolize_names: true)[:data]
  end

  def self.host_yards(host_id)
    response = connection.get("/api/v1/hosts/#{host_id}/yards")
    data = response.body
    info = JSON.parse(data, symbolize_names: true)
  end

  def self.connection
    Faraday.new(url: ENV['ys_engine_url'])
  end
end
