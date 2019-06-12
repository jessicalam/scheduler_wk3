#TODO tty stuff
#TODO set client

require 'tty-prompt'
require_relative '../models/client'

class ClientController
    attr_accessor :clients

    def self.all
        $client_list
    end
end