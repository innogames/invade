# -*- mode: ruby -*-
# vi: set ft=ruby :
#
require 'uri'

module Invade
  class Puppet < Base

    MODULE = "PUPPET"

    def install()
      mergedModules = self.concatModuleArray($vagrant_puppet_modules_basic, $vagrant_puppet_modules)
      self.buildPuppetfile(mergedModules)
    end

    # Concats an given Array with an other Array with data
    def concatModuleArray(baseArray, extArray)
      unless extArray.to_a.empty? || extArray.to_a.nil?
        extArray.each do |modules|
          baseArray.push(modules.flatten())
        end
      end

      return baseArray
    end

    def getModuleNameFromGitUrl(moduleURL)
      uri = File.basename(moduleURL, ".*")
      return uri.gsub("/","-")
    end

    def generatePuppetfileData(moduleType, moduleName, moduleVersion)
      case moduleType
        when "puppetforge"
          definition = "mod '#{moduleName}'"

          unless moduleVersion.nil? || moduleVersion.empty?
            definition = definition.concat(",'#{moduleVersion}'")
          end

          definition = definition.concat("\n")
        when "git"
          url = moduleName
          moduleName = self.getModuleNameFromGitUrl(url)
          definition = "mod '#{moduleName}',"
          definition = definition.concat("\n  :git => '#{url}'")

          unless moduleVersion.nil? || moduleVersion.empty?
            definition = definition.concat(",\n  :ref => '#{moduleVersion}'")
          end

          definition = definition.concat("\n")
        else
          raise sprintf "Invalid Puppetfile module type: %s", moduleType
      end

      return definition
    end

    def buildPuppetfile(modules)

      puppetfile = "#{$vagrant_puppet_folder}/Puppetfile"

      begin
        if File.exist?(puppetfile)
            File.delete(puppetfile)
        end

        File.open(puppetfile, 'w+') {|f| f.write("
  #Forge url
  forge 'http://forge.puppetlabs.com'

  #Modules\n") }

        modules.each_with_index do |moduleScript, index|
          File.open(puppetfile, 'a+') do |f|
            f.puts self.generatePuppetfileData(modules[index][0], modules[index][1], modules[index][2])
          end
        end
      rescue StandardError => error
        print "\nIO failed: #{error}"
        raise
      end
    end
  end
end
