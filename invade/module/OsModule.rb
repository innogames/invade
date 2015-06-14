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
  class Os < Base

    MODULE = 'OS'

    def initialize
      @host_os = RbConfig::CONFIG['host_os']
    end

    def get_os
        case @host_os
        when /cygwin|mswin|mingw|bccwin|wince|emx/
          os = 'windows'
        when /linux/
          os = 'linux'
        when /darwin/
          os = 'mac'
        else
          self.exit_with_error("Can't find out on which operating system you're on. Exit!")
        end

        os
      end

      def is_windows
        return true if get_os == 'windows'
        false
      end

      def is_mac
        return true if get_os == 'mac'
        false
      end

      def is_linux
        return true if get_os == 'linux'
        false
      end

      def is_unix
        return true if get_os == 'mac' || get_os == 'linux'
        false
      end

  end
end
