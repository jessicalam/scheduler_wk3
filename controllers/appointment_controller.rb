require 'tty-prompt'
require 'date'
require_relative '../models/appointment'
require_relative './provider_controller'
require_relative './client_controller'
require_relative '../utilities'

class AppointmentController
  attr_accessor :appointment_candidate, :appointments

  @appointments = []

  def self.all
    @appointments
  end

  def self.index
    @appointments.map do |appointment|
      puts "Client: #{appointment.client}"
      puts "Service: #{appointment.service}"
      puts "Provider: #{appointment.provider}"
      puts "Date: #{appointment.date}"
      puts "At: #{appointment.start_time}:00"
    end
  end

  def self.add
    continueProgram = true
    prompt = TTY::Prompt.new(interrupt: :exit)


    while continueProgram do
      client_response = prompt.select("Are you a new client?") do |q|
        q.choice name: 'New Client', value: true
        q.choice name: 'Existing Client', value: false
      end

      if client_response
        # add new client
        new_client_name = prompt.ask('New client name:')
        while true
          if new_client_name != nil
            break
          else
            puts "Error: Not a valid name. Please enter a valid name below. "
            new_client_name = prompt.ask('New client name:')
          end
        end
        $client_list << Client.new(new_client_name, [])
        client = new_client_name
      else
        client = prompt.select("Select the client:", $client_list
                                                      .map{|c| c.name}, cycle: true)
      end

      service_names = $service_list.map do |service|
	      service.name
      end
      service = prompt.select('Service wanted:', service_names, cycle: true)

      providers_with_service = []
      $provider_list.each do |provider|
	      provider.services.each do |serv|
          if serv.name == service
            providers_with_service << provider
          end
	      end
      end
      provider = prompt.select("Please select from these providers:", providers_with_service.map{|provider| provider.name}, cycle: true)
      month = prompt.ask("What month in 2020 would you like to have the appointment?")
      while (month.to_i < 1 || month.to_i > 12 || !month)
          puts "Error: Invalid Month"
          month = prompt.ask("What month in 2020 would you like to have the appointment?")
      end
      day = prompt.ask("What day of the month would you like to have the appointment?")
      while (day.to_i < 1 || day.to_i > 31 || !day)
        puts "Error: Invalid Day"
        day = prompt.ask("What day of the month would you like to have the appointment?")
      end
      date = Date.new(2020,month.to_i,day.to_i)
      start_time = prompt.ask("What time would you like to start the appointment?")
      while true
        if start_time != nil
          break
        else
          puts "Error: Not a valid start time. Please enter a valid start time below. "
          start_time = prompt.ask("What time would you like to start the appointment?")
        end
      end

      client_object = ($client_list.select{|client_name| client_name.name == client})[0]
      provider_object = ($provider_list.select{|provider_name| provider_name.name == provider})[0]

      appointment = add_appointment(client_object, service, provider_object, date, start_time)

      if appointment != nil
        puts "Appointment successfully scheduled for #{client}:"

        print(appointment)

        continueProgram = false
      else
        puts "Your requested appointment is not available, please try a different request."
      end
    end
  end

  def self.remove
    # continueProgram = true
    prompt = TTY::Prompt.new(interrupt: :exit)

    # choose provider
    provider = prompt.select("Please select the provider:", $provider_list
                                                                      .map{|p| p.name}, cycle: true)

    provider_object = ($provider_list.select{|provider_name| provider_name.name == provider})[0]

    # choose the name of the client
    # provider_clients = []
    # provider_object.scheduled_appointments.map do |pc|
    #   if !provider_clients.include?(pc.client.name)
    #     provider_clients << pc.client.name
    #   end
    # end

    # if provider_clients.size() > 0
    #   client = prompt.select("Choose the client:", provider_clients, cycle: true)
    #   client_object = ($client_list.select{|client_name| client_name.name == client})[0]
    # else
    #   puts "
    #   No clients for the selected provider
    #   "
    #   return
    # end

    # list appointments
    appointment_hash = {}
    provider_object.scheduled_appointments.each do |pa|
      key = pa.getDetails
      appointment_hash[key] = pa
    end

    # choose a date and start time from the provider
    # provider_dates = client_object.appointments.map{|appt| appt.date.to_s}
    # date = prompt.select('Select the appointment date:', provider_dates, cycle: true)

    # provider_times = client_object.appointments.map{|appt| appt.start_time.to_s}
    # start_time = prompt.select('Select the appointment time:', provider_times, cycle: true)

    appointment_to_be_deleted = prompt.select('Select the appointment:', appointment_hash.keys, cycle: true)

    #delete
    # success = remove_appointment(client, provider, date, start_time)
    provider_object.scheduled_appointments.delete(appointment_hash[appointment_to_be_deleted])


    # are you sure?
    # delete

  end

  def self.check_availability
    key_of_day = @appointment_candidate.date.wday
    day_of_week = DaysOfWeek::DAY_OF_WEEK[key_of_day]
    provider_name = @appointment_candidate.provider.name
    provider_days_off = $provider_list.find { |provider| provider.name == provider_name}.days_off
    
    # return false if provider_days_off.include?(day_of_week) # days_off has specific dates, not days of week
    return false if provider_days_off.include?(@appointment_candidate.date)
    return false if conflict?
    true
  end

  def self.conflict?
    check_conflict = @appointments.map do |appointment|
      @appointment_candidate.conflict(appointment)
    end

    check_conflict.include?(true)
  end

  def self.print(appointment)
    puts "
    Client: #{appointment.client.name}
    Service: #{appointment.service}
    Provider: #{appointment.provider.name}
    Date: #{appointment.date}
    At: #{appointment.start_time}:00
    ----------"
    puts "\n"
  end

  private

  def self.add_appointment(client, service, provider, date, start_time)
    @appointment_candidate = Appointment.new(client, service, provider, date, start_time)


    if check_availability
      selected_provider = $provider_list.select { |p| p.name == provider.name }[0]

      @appointments << @appointment_candidate
      selected_provider.scheduled_appointments << @appointment_candidate
      # client.appointments << @appointment_candidate

      return @appointment_candidate
    else
      return nil
    end
  end

  def self.remove_appointment(client, provider, date, start_time)
    # @appointment_delete = (@appointments.each {|a| a.client == client}) #&& a.provider == provider && a.date == date && a.start_time == start_time}

    @appointments = @appointments.delete_if { |app| app.client == client && app.provider == provider && app.date == date && app.start_time == start_time }
    selected_provider = $provider_list.select { |p| p.name == provider.name }[0]
    selected_provider.scheduled_appointments = selected_provider.scheduled_appointments.delete_if { |app| app.client == client && app.provider == provider && app.date == date && app.start_time == start_time }
    # puts @appointment_delete
  end
end
