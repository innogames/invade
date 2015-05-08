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

    MODULE = "OS"

    def initialize()
      @host_os = RbConfig::CONFIG['host_os']
    end

    def getOS?
        case @host_os
        when /cygwin|mswin|mingw|bccwin|wince|emx/
          os = 'windows'
        when /linux/
          os = 'linux'
        when /darwin/
          os = 'mac'
        else
          raise(self.error("Can't find out on wich OS you're on. Abort!"))
        end

        return os
      end

      def isWindows?
        if(self.getOS? == 'windows')
          return true
        end

        return false
      end

      def isMac?
        if(self.getOS? == 'mac')
          return true
        end

        return false
      end

      def isLinux?
        if(self.getOS? == 'linux')
          return true
        end

        return false
      end

      def isUnix?
      	if(self.getOS? == 'mac' || self.getOS?() == 'linux')
          return true
        end

        return false
      end

  end
end
