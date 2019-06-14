# This file contains all tests from the other files in the tests folder
# run this to see coverage for the entire test suite


require 'simplecov'
SimpleCov.start

require_relative '../controllers/service_controller'
require_relative '../controllers/provider_controller'
require_relative '../controllers/appointment_controller'
require_relative '../controllers/client_controller'


RSpec.describe AppointmentController do 
    describe "#add_appointment" do

        clients = ClientController.send :all
        services = ServiceController.send :all
        providers = ProviderController.send :all
        appointments = AppointmentController.send :all

        it "checks no appointments exist" do
            expect(appointments.size()).to eq(0)
            expect(clients[0].appointments.size()).to eq(0)
            expect(providers[0].scheduled_appointments.size()).to eq(0)
        end
        it "adds an appointment to appointment controller" do
            AppointmentController.send :add_appointment, clients[0], services[0].name, providers[0], Date.new(2020,1,1), 12
            expect(appointments.size()).to eq(1)
        end
        it "check provider controller for added appointment" do
            expect(providers[0].scheduled_appointments.size()).to eq(1)
        end
    end

    describe "#check_availability" do

        clients = ClientController.send :all
        services = ServiceController.send :all
        providers = ProviderController.send :all
        appointments = AppointmentController.send :all  

        it "adds an overlapping appointment" do
            AppointmentController.send :add_appointment, clients[0], services[0].name, providers[0], Date.new(2020,1,1), 12
            AppointmentController.send :add_appointment, clients[0], services[1].name, providers[0], Date.new(2020,1,1), 12
            expect(appointments.size()).to eq(1)   #note appointment added from first describe block
        end
    end

    describe "#remove_appointment" do

        clients = ClientController.send :all
        services = ServiceController.send :all
        providers = ProviderController.send :all
        appointments = AppointmentController.send :all

        it "adds an appointment" do
            # expect(appointments.size()).to eq(0)    
            AppointmentController.send :add_appointment, clients[0], services[0].name, providers[0], Date.new(2020,1,1), 12
            expect(appointments.size()).to eq(1)
        end
        it "removes the appointment" do
            AppointmentController.send :remove_appointment, clients[0], providers[0], Date.new(2020,1,1), 12
            expect(appointments.size()).to eq(0)
        end
        it "checks client controller" do
            expect(clients[0].appointments.size()).to eq(0)
        end
        it "checks provider controller" do
            expect(providers[0].scheduled_appointments.size()).to eq(0)
        end
    end
end

RSpec.describe ServiceController do 
    describe "#add_service" do
        it "adds a Service to global service_list" do
		ServiceController.add_service("Test", "1", "1")
		expect($service_list.size()).to eq(5)	
        end
    end

    describe "#remove_service" do
        it "removes a Service from global service_list" do
		ServiceController.remove_service("Liver Transplant")
        	expect($service_list.size()).to eq(4)	
        end
    end

end

RSpec.describe ProviderController do 
    describe "#add_provider" do
        it "add a Provider" do
            ProviderController.send :add_provider, 'Test', '123-456-7890', ['Test Service 1'], ['Monday']
            providers = ProviderController.send :all

            expect(providers.size()).to eq(3)
        end
        it "remove a Provider" do
            ProviderController.send :add_provider, 'Test', '123-456-7890', ['Test Service 1'], ['Monday']
            ProviderController.send :remove_provider , 'Test'
            providers = ProviderController.send :all

            expect(providers.size()).to eq(2)
        end
    end
end
