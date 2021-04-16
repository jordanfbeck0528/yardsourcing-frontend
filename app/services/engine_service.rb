class EngineService

  def self.all_purposes
    response = connection.get('/api/v1/purposes')
    data = response.body
    JSON.parse(data, symbolize_names: true)
  end

  def self.create_yard(yard_params)
    response = connection.post('/api/v1/yards') do |req|
       req.headers["CONTENT_TYPE"] = "application/json"
       req.body = JSON.generate(yard: yard_params)
     end
  end

  def self.yard_details(yard_id)
    url = "/api/v1/yards/#{yard_id}"
    response = connection.get(url)
    data = response.body
    JSON.parse(data, symbolize_names: true)
  end

  def self.host_yards(host_id)
    url = "/api/v1/hosts/#{host_id}/yards"
    response = connection.get(url)
    data = response.body
    binding.pry
    JSON.parse(data, symbolize_names: true)
  end

  def self.connection
    Faraday.new(url: ENV['ys_engine_url'])
  end
end
