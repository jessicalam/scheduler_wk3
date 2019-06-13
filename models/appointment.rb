class Appointment
  attr_accessor :client, :service, :provider, :date, :start_time

  def initialize(client, service, provider,date, start_time)
    @client = client
    @service = service
    @provider = provider
    @date = date
    @start_time = start_time
  end

  def getDetails
    "Client: #{@client.name}, Service: #{@service}, Date: #{@date}, Start Time: #{@start_time}:00"
  end

  def equal(other)
    self.service == other.service && self.provider == other.provider && self.date == other.date && self.start_time == other.start_time 
  end

  def conflict(other)
    candidate_service_length = $service_list.find { |service| service.name == self.service}.duration
    other_service_length = $service_list.find { |service| service.name == other.service}.duration
    candidate_starts_within_other = self.start_time.to_i >= other.start_time.to_i && (other.start_time.to_i + other_service_length) > self.start_time.to_i
    other_starts_within_candidate = other.start_time.to_i >= self.start_time.to_i && (self.start_time.to_i + candidate_service_length) > other.start_time.to_i

    return self.provider == other.provider && self.date == other.date && (candidate_starts_within_other || other_starts_within_candidate)
  end
end