require 'tty-prompt'
require './controllers/service_controller'
require './controllers/provider_controller'
require './controllers/appointment_controller'
require './controllers/view_schedule_controller'
require './print'

class Scheduler
	FUNCTION_LOOKUP = {
		"Add Provider" => {
			controller: ProviderController,
			method_name: :add
		},
		"Remove Provider" => {
			controller: ProviderController,
			method_name: :remove
		},
		"View Providers" => {
			controller: Print,
			method_name: :print_providers
		},
		"Add Service" => {
			controller: ServiceController,
			method_name: :add
		},
		"Remove Service" => {
			controller: ServiceController,
			method_name: :remove
		},
		"View Services" => {
			controller: Print,
			method_name: :print_services
		},
		"Add Provider Availability" => {
			controller: ProviderController,
			method_name: :add_availability
		},
		"Remove Provider Availability" => {
			controller: ProviderController,
			method_name: :remove_availability
		},
		"Schedule an Appointment" => {
			controller: AppointmentController,
			method_name: :add
		},
		"Remove an Appointment" => {
			controller: AppointmentController,
			method_name: :remove
		},
		"View Schedule of a Particular Provider" => {
			controller: ViewScheduleController,
			method_name: :view_schedule
		},
		"Exit program" => {}
	}

	continue_program = true
	prompt = TTY::Prompt.new(interrupt: :exit)

	while continue_program do
		choice = prompt.select("What would you like to do?", FUNCTION_LOOKUP.keys, cycle: true)
		if choice == "Exit program"
			break
		end
		FUNCTION_LOOKUP[choice][:controller].send(FUNCTION_LOOKUP[choice][:method_name])
	end
end
