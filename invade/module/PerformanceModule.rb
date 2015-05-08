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
  class Performance < Base

    MODULE = "PERFORMANCE"

    def initialize()
      if ($vagrant_performance_auto == true)
        # Give access to all cpu cores on the host
        if InvadeOs.isMac?
          $vagrant_performance_cores = `sysctl -n hw.ncpu`.to_i
          # sysctl returns Bytes and we need to convert to MB
          $vagrant_performance_ram = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
        elsif InvadeOs.isLinux?
          $vagrant_performance_cores = `nproc`.to_i
          $vagrant_performance_ram = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
        else
          self.warning("Auto calculation does not work with Windows. Skip.")
        end

        self.info("Using %s cores and %s ram (auto calculation)." % [$vagrant_performance_cores, $vagrant_performance_ram]) if InvadeArgument.valid?
      else
        self.info("Auto Calculation deactivated. Using values from config (Cores: %s, Ram: %s)" % [$vagrant_performance_cores, $vagrant_performance_ram]) if InvadeArgument.valid? if $vagrant_performance == false
      end
    end
  end
end
