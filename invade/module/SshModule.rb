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
  class SSH < Base

    MODULE = "SSH"

    def initialize

      $ssh = false

      if $vagrant_ssh
        $ssh = true
        self.info("Use host machines SSH folder \"#{$vagrant_ssh_folder_path}\"")
      end
    end
  end
end
