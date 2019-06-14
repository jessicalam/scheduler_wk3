require 'tty-prompt'
require 'date'
require 'set'
require_relative '../models/provider'
require_relative '../models/service'
require_relative '../utilities'
require_relative '../seed'
include DaysOfWeek

class ProviderController
  attr_accessor :providers, :days_off, :services
#  $provider_list = [Provider.new('Junius', '234-486-9800', @service_types),     
#                Provider.new('Pearl', '978-123-5768', @service_types),
#                Provider.new('Rifty', '008-111-2590', @service_types)]

  def self.all
    $provider_list
  end

 # def self.index
 #   puts "Here's the current list of providers:"

 #   $provider_list.map do |provider|
 #     puts "#{provider.name}'s phone number is #{provider.phone_number}."
 #     puts "(S)he provides these services: #{provider.services} every day of the week except for:"
 #     provider.days_off.each do |day|
 #             puts day 
 #     end
 #     puts "––––––––––"
 #   end
 # end

  def self.add
    prompt = TTY::Prompt.new(interrupt: :exit)

    name = prompt.ask('Provider Name:')
		while true
			if name != nil
				break
			else
				puts "Error: Not a valid name. Please enter a valid name below. "
				name = prompt.ask('Provider Name:')
			end
		end
    phone_number = prompt.ask('Phone number:')
		while true
			if phone_number != nil
				break
			else
				puts "Error: Not a phone number. Please enter a valid phone number below. "
				phone_number = prompt.ask('Phone number:')
			end
		end
    service_types = $service_list.map { |service| service.name}
    services_names = prompt.multi_select("Please choose services from the
                following list:", service_types)
    services = []
    services_names.each do |selected_service|
	    $service_list.each do |service|
		    if(service.name == selected_service)
			    services << Service.new(service.name, service.price, service.duration)
		    end
	    end
    end

    days_off = prompt.multi_select('Days off:', ['Monday', 'Tuesday', 'Wednesday',
                'Thursday', 'Friday', 'Saturday', 'Sunday'])
    success = add_provider(name, phone_number, services, days_off)
  end

  def self.remove
    prompt = TTY::Prompt.new(interrupt: :exit)
    options = $provider_list.map { |provider| provider.name}
	choice = prompt.select("Pick a provider to remove", options, cycle: true)

	remove_provider(choice)
  end


  def self.add_availability
	prompt = TTY::Prompt.new(interrupt: :exit)
	all_names = []
	$provider_list.each { |provider| all_names << provider.name}

	provider_name = prompt.select("For which provider would you like to add days off?", all_names, cycle: true)

	selected_provider = $provider_list.select { |provider| provider.name == provider_name}[0]
	availability_frequency = prompt.select("Reocurring or unique day off?", ["Reoccuring", "Unique"])
	case availability_frequency
	when "Reoccuring"
		days_off = prompt.multi_select('Days off:', ['Monday', 'Tuesday', 'Wednesday', 
		'Thursday', 'Friday', 'Saturday', 'Sunday'])
		days_off.each do |day|
			first_date_of_day = DaysOfWeek::FIRST_DATE_OF_DAY_IN_2020[day]
			date = Date.new(2020, 1, first_date_of_day)
			loop do
				if date.year > 2020
					break
				end
				if !selected_provider.days_off.include?(date)
					selected_provider.days_off << date
				end
				date = date + 7
			end

		end
	puts "Success"
	when "Unique"
		day = prompt.ask ("Day:")
		month = prompt.ask("Month:")
		date = Date.new(2020,month.to_i,day.to_i)
		if !selected_provider.days_off.include?(date)
			selected_provider.days_off << date
		end
	end

  end

  def self.remove_availability

	prompt = TTY::Prompt.new(interrupt: :exit)
	all_names = []
	$provider_list.each { |provider| all_names << provider.name}

	provider_name = prompt.select("For which provider would you like to remove days off?", all_names, cycle: true)

	selected_provider = $provider_list.select { |provider| provider.name == provider_name}[0]
	availability_frequency = prompt.select("Reocurring or unique day off?", ["Reoccuring", "Unique"])
	case availability_frequency
	when "Reoccuring"
		days_off = prompt.multi_select('Days off:', ['Monday', 'Tuesday', 'Wednesday', 
		'Thursday', 'Friday', 'Saturday', 'Sunday'])
		days_off.each do |day|
			first_date_of_day = DaysOfWeek::FIRST_DATE_OF_DAY_IN_2020[day]
			date = Date.new(2020, 1, first_date_of_day)
			loop do
				if date.year > 2020
					break
				end
				if selected_provider.days_off.include?(date)
					selected_provider.days_off.delete(date)
				end
				date = date + 7
			end

		end
	puts "Success"
	when "Unique"
		day = prompt.ask ("Day:")
		month = prompt.ask("Month:")
		date = Date.new(2020,month.to_i,day.to_i)
		if selected_provider.days_off.include?(date)
			selected_provider.days_off.delete(date)
		end
	end
  end

  #TODO: abstract the puts into something that's in control of input and output
  # move printing into its own function/class
  def self.view_schedule
    prompt = TTY::Prompt.new(interrupt: :exit)
    all_names = []
    $provider_list.each { |provider| all_names << provider.name}

    provider_name = prompt.select("Which provider's schedule would you like to see?", all_names, cycle: true)

    selected_provider = $provider_list.select { |provider| provider.name == provider_name}[0]

    puts "----------\n"
    puts "Below are the appointments on #{selected_provider.name}'s calendar:"
    selected_provider.scheduled_appointments.map do |appt|
      puts "Client name: #{appt.client}
      Service: #{appt.service}
      Date: #{appt.date}
      Start time: #{appt.start_time}
      "
    end
    puts "----------\n"
  end

  def self.add_provider(name, phone_number, services, days_off)
	  dates_off = []
	days_off.each do |day|
		first_date_of_day = DaysOfWeek::FIRST_DATE_OF_DAY_IN_2020[day]
		date = Date.new(2020, 1, first_date_of_day)
		loop do
			if date.year > 2020
				break
			end
			dates_off << date
			date = date + 7
		end

	end
	provider = Provider.new(name, phone_number, services, dates_off)
	$provider_list << provider
	puts "\n"
	puts "#{provider.name} is successfully added."
	puts "\n"
	#puts self.index
  end

  def self.remove_provider(name)
	$provider_list = $provider_list.reject { |provider| provider.name == name}
  end
end
