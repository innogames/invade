# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# InVaDE - [In]nogames [Va]grant [D]evelopment [E]nvironment
#
# @author Lennart Stein
# @email  lennart.stein@innogames.com
# @web    http://github.com/innogames/invade
#

require 'uri'

module Invade
  class Puppet < Base

    MODULE = 'PUPPET'

    public

    def install
      merged_modules = concat_module_array($vagrant_puppet_modules_basic, $vagrant_puppet_modules)
      build_puppetfile(merged_modules)
    end

    def build_puppetfile(modules)

      puppetfile = "#{$vagrant_puppet_folder}/Puppetfile"

      begin
        if File.exist?(puppetfile)
            File.delete(puppetfile)
        end

        File.open(puppetfile, 'w+') {|f| f.write("
#Modules\n") }

        modules.each_with_index do |moduleScript, index|
          File.open(puppetfile, 'a+') do |f|
            f.puts generate_puppetfile_data(modules[index][0], modules[index][1], module_version: modules[index][2], module_name: modules[index][3], module_protocol: modules[index][4])
          end
        end
      rescue StandardError => error
        print "\nIO failed: #{error}"
        raise
      end
    end

    private

    # Concats an given Array with an other Array with data
    def concat_module_array(base_array, ext_array)
      unless ext_array.to_a.empty? || ext_array.to_a.nil?
        ext_array.each do |modules|
          base_array.push(modules.flatten)
        end
      end

      base_array
    end

    # noinspection RubyScope
    def generate_puppetfile_data(module_platform, module_path, module_version: nil, module_name: nil, module_protocol: nil)

      case module_platform
      when 'inno'
        hostname = 'gitlab.innogames.de'
        module_protocol = 'ssh' #ssh only
      when 'github'
        hostname = 'github.com'
      else
        self.exit_with_error(sprintf "Invalid platform: '%s' for module '%s'\n", module_platform, module_path)
      end

      # build name part
      if module_name.nil? || module_name.empty?
        module_name = get_module_name_from_repo_path(module_path)
      end

      definition = "mod '#{module_name}',"

      # build git url part
      if module_protocol.nil? || module_protocol.empty?
        module_protocol = 'https'
      end

      case module_protocol.downcase
      when 'https'
        url = "https://#{hostname}/#{module_path}.git"
      when 'ssh'
        url = "git@#{hostname}:#{module_path}.git"
      else
        self.warning(sprintf("Invalid protocol: '%s' for module '%s'. Try to use HTTPS protocol.\n"), module_protocol, module_name)
        url = "https://#{hostname}/#{module_path}.git"
      end
      definition.concat("\n  :git => '#{url}'")

      # build version part
      unless module_version.nil? || module_version.empty?
        definition.concat(",\n  :ref => '#{module_version}'")
      end

      definition.concat("\n")
    end

    def get_module_name_from_repo_path(repository_path)

      # Path must include '/'
      unless repository_path.include? '/'
        self.exit_with_error(sprintf "Invalid repository path: '%s'. Path must include username and repository name. Example: 'magneton/xmen-protocol'.")
      end

      repository_name = repository_path.partition('/').last

      dash_count = repository_name.count('-')
      lower_dash_count = repository_name.count('_')

      # Dashs in combination with lower dashs in a path are not allowed
      if dash_count > 0 && lower_dash_count > 0
        self.exit(sprintf "Invalid repository path: '%s'. It includes at least one dash and one lower dash. Can't generate a repository name. Please use the optional module_name paramater to manually define a name for this module.", repository_name)
      else
        if dash_count > 0
          cut_character = '-'
          i = 0
          while i < dash_count do
            repository_name = repository_name.partition(cut_character).last
            i +=1
          end
        else
          cut_character = '_'
          i = 0
          while i < lower_dash_count do
            repository_name = repository_name.partition(cut_character).last
            i +=1
          end
        end
      end

      if repository_path.include? 'innogames/invade-'
        repository_name = "invade-#{repository_name}"
      end

      repository_name
    end

  end
end
