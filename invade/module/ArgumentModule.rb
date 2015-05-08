# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# InVaDE - [In]nogames [Va]grant [D]evelopment [E]nvironment
#
# @author Lennart Stein
# @email  lennart.stein@innogames.com
#

module Invade
  class Argument < Base

    MODULE = "ARGUMENT"

    def valid?
      valid_arguments = ["up", "reload"]
      arg = ARGV[0].to_s

      valid_arguments.each { |x|
        if x === arg
          return true
        end
      }

      return false

    end
  end
end
