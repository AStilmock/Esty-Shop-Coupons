class Holiday
  attr_reader :data, :url, :name, :date

  def initialize(data)
    @data = data
    @url = data[:url]
    @name = data[:name]
    @date = data[:date]
  end
end