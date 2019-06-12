require_relative './models/provider'
require_relative './models/service'
require_relative './models/client'

SERVICES = []
PROVIDERS = []

$service_list = [
  Service.new('Mind Reading', 200, 1),
  Service.new('Demonic Exorcism', 50, 2),
  Service.new('Potion Therapy', 100, 1),
  Service.new('Liver Transplant', 5000, 6),
]

$client_list = [
  Client.new('Vlad', []),
  Client.new('Eddie', [])
]

$provider_list = [
  Provider.new('Matt', 1112223333, [$service_list[0], $service_list[2]]),
  Provider.new('Jessica', 4445556666, [$service_list[1], $service_list[3]]),
]
