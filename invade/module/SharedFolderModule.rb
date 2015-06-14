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
  class SharedFolder < Base

    MODULE = 'SHAREDFOLDER'

    def initialize()

      $app = false
      $hiera = false

      if $vagrant_shared_folder
        $app = self.handle_shared_folder
        $hiera = self.handle_hiera
      end

    end

    def handle_shared_folder

      shared_folder_path = File.expand_path($vagrant_shared_folder_source)
      vagrant_path = File.expand_path(shared_folder_path + '/' + $vagrant_general_vagrant_folder + '/core')

      unless File.directory?(shared_folder_path)
        self.exit_with_error('The folder you want to mount not exists!')
      end

      unless File.directory?(vagrant_path)
        self.warning('Vagrant is not running inside an application environment! Shared folder will be disabled.')
        return false
      end

      true
    end

    def handle_hiera
      if $vagrant_puppet_hiera_file_path.empty?
        false
      else
        unless File.exists?($vagrant_puppet_hiera_file_path)
          self.warning("Hiera.yml disabled. File not found!\n\t\t\t=> \"#{$vagrant_puppet_hiera_file_path}\"")
          return false
        end

        self.info("Hiera Configuration file found! Hiera enabled.\n\t\t\t=> #{$vagrant_puppet_hiera_file_path}")
        true
      end
    end
  end
end
