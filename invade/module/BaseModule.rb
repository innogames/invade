# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# InVaDE - [In]nogames [Va]grant [D]evelopment [E]nvironment
#
# @author Lennart Stein
# @email  lennart.stein@innogames.com
# @web    http://github.com/innogames/invade
#

require './invade/lib/Colorize'

module Invade
  class Base

    PREFIX = '[InVaDE]'
    MODULE = 'BASE'

    # Info/Debug Message
    def info(message)
      puts sprintf('%s%s', self.prefix, message).light_blue if InvadeArgument.valid?
    end

    # Success Message
    def success(message)
      puts sprintf('%s%s', self.prefix, message).green if InvadeArgument.valid?
    end

    # Warning Message
    def warning(message)
      puts sprintf('%s%s', self.prefix, message).yellow if InvadeArgument.valid?
    end

    # Error Message
    def error(message)
      puts sprintf('%s%s', self.prefix, message).red if InvadeArgument.valid?
    end

    def exit_with_error(message)
      puts sprintf('%s%s', self.prefix, message).red if InvadeArgument.valid?
      exit
    end

    def prefix
      module_name = self.class::MODULE
      if module_name == 'BASE'
        prefix = sprintf "%s:\t", self.class::PREFIX
      else
        prefix = sprintf "%s[%s]:\t", self.class::PREFIX, module_name
      end

      prefix
    end

  end
end
