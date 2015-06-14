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
  class Argument < Base

    MODULE = 'ARGUMENT'

    def valid?
      valid_arguments = %w(up reload)
      arg = ARGV[0].to_s

      valid_arguments.each { |x|
        return true if x === arg
      }

      false
    end
  end
end
