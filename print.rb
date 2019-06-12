class Print
    def self.print_providers
        puts "Here's the current list of providers:"
        puts "–––––––––––––––––––––––––––––––––––––"

        $provider_list.map do |provider|
            provider_services = provider.services.map { |service| service.name}

            puts "#{provider.name}'s phone number is #{provider.phone_number}."
            puts "(S)he provides these services: #{provider_services} every day of the week except for:"
            provider.days_off.each do |day|
                puts day
            end
            puts "––––––––––"
        end
        puts
        puts
        puts
    end

    def self.print_services
        puts "Here's the current list of services:"
        puts "––––––––––––––––––––––––––––––––––––"

        $service_list.map do |service|
            puts "#{service.name} costs $#{service.price}, and takes about #{service.duration} hours."
            puts "––––––––––"
        end
        puts
        puts
        puts
    end
end