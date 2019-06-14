require 'tty-prompt'
require 'colorize'
require_relative './provider_controller'
require_relative './appointment_controller'

class ViewScheduleController
  def self.view_schedule
    prompt = TTY::Prompt.new(interrupt: :exit)
    all_names = []
    $provider_list.each { |provider| all_names << provider.name}

    provider_name = prompt.select("Which provider's schedule would you like to see?", all_names, cycle: true)

    selected_provider = $provider_list.select { |provider| provider.name == provider_name}[0]

    puts "----------\n"
    puts "Below are the appointments on #{selected_provider.name}'s calendar:"
    selected_provider.scheduled_appointments.map do |appt|
      puts "
            Client name: #{appt.client.name}
            Service: #{appt.service}
            Date: #{appt.date}
            Start time: #{appt.start_time}:00
      "
    end
    puts "----------\n"
    puts
    puts
  end
end
