# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# InVaDE - [In]nogames [Va]grant [D]evelopment [E]nvironment
#
# @author Lennart Stein
# @email  lennart.stein@innogames.com
# @web    http://github.com/innogames/invade
#

module Invade
  class Configuration < Base

    MODULE = 'CONFIG'

    def initialize
      if File.exist?('InvadeConfig')
        load 'InvadeConfig'
      else

        path = Dir.pwd

        # Try to get project dist first
        if File.exist?('../InvadeConfig.dist')
          FileUtils.cp('../InvadeConfig.dist', 'InvadeConfig')
          message = "InvadeConfig was not found. Copy of project template file \"../InvadeConfig.dist\" created. \nPath: #{path}/InvadeConfig"
          self.warning(message)
          exec('vagrant up')
        else # Project dist not found. Use InVaDE basic template instread
          FileUtils.cp('InvadeConfig.dist', 'InvadeConfig')
          message = "InvadeConfig was not found. Copy of template file \"InvadeConfig.dist\" created. \nPath: #{path}/InvadeConfig\nPlease edit this config file before using InVaDE."
          self.exit_with_error(message)
        end
      end
    end
  end
end
