require 'simplecov'
SimpleCov.start

# @appointment = Appointment.new('Bob', 'Test Service 1', 'Test', Date.new(2020,1,1), 12)
require_relative '../controllers/service_controller'
require_relative '../controllers/provider_controller'
require_relative '../controllers/appointment_controller'

# Can I use the service_controller_tests.rb in this area?

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
