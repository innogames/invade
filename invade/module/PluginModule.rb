# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# InVaDE - [In]nogames [Va]grant [D]evelopment [E]nvironment
#
# @author Lennart Stein
# @email  lennart.stein@innogames.com
#

module Invade
  class Plugin < Base

    MODULE = "PLUGINS"

    def initialize()
      @plugins = Array.new

      self.autoUpdatePlugins()

      if(self.checkPlugins())
        self.info("Check Plugins...")
        self.installPlugins()
      end
    end

    def checkPlugins()

      if(InvadeOs.isWindows?)
        $vagrant_plugins_basic_windows.each { |plugin|
          unless Vagrant.has_plugin?(plugin)
            @plugins.push(plugin)
          end
        }
      end

      $vagrant_plugins_basic.each { |plugin|
        unless Vagrant.has_plugin?(plugin)
          @plugins.push(plugin)
        end
      }

      if(@plugins.count > 0)
        return true
      end

      return false
    end

    def installPlugins()
      self.info("Plugins needed to be installed:\n\t#{@plugins.join("\n\t")}")

      @plugins.each { |plugin|
        unless Vagrant.has_plugin?(plugin)
          system("vagrant plugin install #{plugin}")
        end
      }

      self.success("All plugins installed! Please run vagrant up again!")
      abort

    end

    def autoUpdatePlugins()
      if($vagrant_plugins_auto_update == true)
        system("vagrant plugin update")
      end
    end

  end
end
