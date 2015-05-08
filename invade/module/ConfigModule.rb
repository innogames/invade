# -*- mode: ruby -*-
# vi: set ft=ruby :

module Invade
  class Configuration < Base

    MODULE = "CONFIG"

    def initialize
      unless(File.exist?('InvadeConfig'))

        path = Dir.pwd

        # Try to get project dist first
        if(File.exist?('../InvadeConfig.dist'))
          FileUtils.cp('../InvadeConfig.dist', 'InvadeConfig')
          message = "InvadeConfig was not found. Copy of project template file \"../InvadeConfig.dist\" created. \nPath: #{path}/InvadeConfig"
        else # Project dist not found. Use InVaDE basic template instread
          FileUtils.cp('InvadeConfig.dist', 'InvadeConfig')
          message = "InvadeConfig was not found. Copy of template file \"InvadeConfig.dist\" created. \nPath: #{path}/InvadeConfig\nPlease edit this config file before using InVaDE."
        end

        abort(self.error(message))
      else
        load 'InvadeConfig'
      end
    end
  end
end
