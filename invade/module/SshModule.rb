# -*- mode: ruby -*-
# vi: set ft=ruby :

module Invade
  class SSH < Base

    MODULE = "SSH"

    def initialize()

      $ssh = false

      if $vagrant_ssh == true
        $ssh = true
        self.info("Use host machines SSH folder \"#{$vagrant_ssh_folder_path}\"")
      end
    end

    # if ($vagrant_ssh_user_agent == true)
    #   $ssh_folder_copy_disabled = true
    # end

    # # Basic known hosts needed by the most projects
    # known_hosts = [
    #   'gitlab.innogames.de'
    # ]

    # # Merge basic known_hosts with known_hosts from configuration file
    # unless $vagrant_ssh_known_hosts.to_a.empty? || $vagrant_ssh_known_hosts.to_a.nil?
    #   $vagrant_ssh_known_hosts.each do |config_known_hosts|
    #     known_hosts.push(config_known_hosts)
    #   end
    # end

    # script_known_hosts_part = ""
    # known_hosts.each do |known_host|
    #   script_known_hosts_part.concat("
    #     echo 'Add #{known_host} to known_hosts';ip=$(dig +short #{known_host}); ssh-keygen -R #{known_host}; ssh-keygen -R $ip; ssh-keyscan -H #{known_host} >> /home/vagrant/.ssh/known_hosts && chmod 600 /home/vagrant/.ssh/known_hosts; ssh-keyscan -H $ip >> /home/vagrant/.ssh/known_hosts && chmod 600 /home/vagrant/.ssh/known_hosts;
    #   ")
    # end

    # ssh_known_hosts = <<SCRIPT
    #   #{script_known_hosts_part}
    # SCRIPT

    # $ssh_inline_script = ssh_known_hosts

  end
end
