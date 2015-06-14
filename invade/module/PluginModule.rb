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
  class Plugin < Base

    MODULE = 'PLUGINS'

    def initialize
      @plugins = Array.new

      self.auto_update_plugins

      if self.check_plugins
        self.info('Check Plugins...')
        self.install_plugins
      end
    end

    def check_plugins

      if InvadeOs.is_windows
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

      $vagrant_plugins_basic_gems.each { |plugin|
        unless Vagrant.has_plugin?(plugin[0...-4])
          @plugins.push(plugin)
        end
      }

      if @plugins.count > 0
        return true
      end

      false
    end

    def install_plugins
      self.info("Plugins needed to be installed:\n\t#{@plugins.join("\n\t")}")

      @plugins.each { |plugin|
        unless Vagrant.has_plugin?(plugin)
          if plugin.end_with? '.gem'
            system("vagrant plugin install gems/#{plugin}")
          else
            system("vagrant plugin install #{plugin}")
          end
        end
      }

      self.success('All plugins installed! Please run vagrant up again!')
      exit
    end

    def auto_update_plugins
      if $vagrant_plugins_auto_update
        system('vagrant plugin update')
      end
    end

  end
end
