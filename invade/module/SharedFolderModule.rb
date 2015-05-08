# -*- mode: ruby -*-
# vi: set ft=ruby :

module Invade
  class SharedFolder < Base

    MODULE = "SHAREDFOLDER"

    def initialize()

      $app = false
      $hiera = false

      if $vagrant_shared_folder == true
        $app = self.handleSharedFolder()
        $hiera = self.handleHiera()
      end

    end

    def handleSharedFolder()

      shared_folder_path = File.expand_path($vagrant_shared_folder_path)

      unless File.directory?(shared_folder_path)
        self.warning("The folder you want to mount does not exists! Shared Folder is will NOT be mounted.")
        return false
      end

      return true
    end

    def handleHiera()
      unless $vagrant_puppet_hiera_file_path.empty?
        unless File.exists?($vagrant_puppet_hiera_file_path)
          self.warning("Hiera.yml disabled. File not found!\n\t\t\t=> \"#{$vagrant_puppet_hiera_file_path}\"")
          return false
        end

        self.info("Hiera Configuration file found! Hiera enabled.\n\t\t\t=> #{$vagrant_puppet_hiera_file_path}")
        return true
      else
        return false
      end
    end
  end
end
