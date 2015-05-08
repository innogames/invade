 # -*- mode: ruby -*-
# vi: set ft=ruby :

# Include InVaDE (InnoGames Vagrant Development Environment)
require './invade/Invade'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # General Vagrant Configuration
  config.vm.box       = $vagrant_general_box_name
  config.vm.box_url   = $vagrant_general_box_url
  config.vm.hostname  = $vagrant_network_hostname
  config.vm.network $vagrant_network_type, ip: $vagrant_network_ip

  # VirtualBox specific configuration
  config.vbguest.auto_update = $vagrant_general_vbguest

  # Hostmanager
  if Vagrant.has_plugin?("vagrant-hostmanager")
    if Vagrant.has_plugin?("vagrant-triggers")
      config.trigger.after [:reload], :stderr => false, :stdout => false, :force => true do
        info "Updating hostmanager..."
        run "vagrant hostmanager"
      end
    end
    config.hostmanager.enabled            = $vagrant_plugins_hostmanager_enabled
    config.hostmanager.manage_host        = $vagrant_plugins_hostmanager_manage_host
    config.hostmanager.ignore_private_ip  = $vagrant_plugins_hostmanager_ignore_private_ip
    config.hostmanager.include_offline    = $vagrant_plugins_hostmanager_include_offline
    config.hostmanager.aliases            = $vagrant_plugins_hostmanager_aliases
  end

  # Performance Configuration
  config.vm.provider :virtualbox do |v|
    v.name    = $vagrant_general_vm_name
    v.cpus    = $vagrant_performance_cores
    v.memory  = $vagrant_performance_ram
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--nicspeed1", "10485760"]
  end

  config.vm.provider :vmware_fusion do |v|
    v.name              = $vagrant_general_vm_name
    v.vmx["memsize"]    = $vagrant_performance_ram
    v.vmx["numvcpus"]   = $vagrant_performance_cores
  end

  config.vm.provider :vmware_workstation do |v|
    v.vmx["displayName"]    = $vagrant_general_vm_name
    v.vmx["memsize"]        = $vagrant_performance_ram
    v.vmx["numvcpus"]       = $vagrant_performance_cores
  end

  # Handle Shared Folders
  if ($vagrant_shared_folder == true)
    # NFS
    if ($vagrant_shared_folder_type == 'nfs')
      # NFS - Unix
      if(InvadeOs.isUnix? && Vagrant.has_plugin?("vagrant-bindfs"))
        $used_shared_folder_type = "NFS"
        config.nfs.map_uid = Process.uid
        config.nfs.map_gid = Process.gid
        config.vm.synced_folder $vagrant_shared_folder_source, $vagrant_shared_folder_path, type: "nfs", mount_options: $vagrant_shared_folder_nfs_mount_options, disabled: !$app

        # Use vagrant-bindfs to re-mount folder
        # if $app
        #   $used_shared_folder_type.concat(" + bindfs")
        #   config.bindfs.bind_folder $vagrant_shared_folder_source, $vagrant_shared_folder_path,
        #     perms: "u=rw:g=r:o=r",
        #     create_as_user: true
        # end

      # NFS - Windows
      elsif(InvadeOs.isWindows? && Vagrant.has_plugin?("vagrant-winnfsd"))
        $used_shared_folder_type = "NFS (Windows)"
        config.winnfsd.uid    = Process.uid
        config.winnfsd.gid    = Process.gid
        config.winnfsd.logging  = $vagrant_plugins_winnfsd_logging
        config.vm.synced_folder $vagrant_shared_folder_source, $vagrant_shared_folder_path, type: "nfs", disabled: !$app
      else
        InvadeSharedFolder.error("Error while configure NFS. All plugins are installed?")
        abort
      end

    # SMB - Windows only
    elsif ($vagrant_shared_folder_type == 'smb' && InvadeOs.isWindows?)
      $used_shared_folder_type = "SMB (Windows)"
      $absolute_shared_folder_source = File.expand_path($vagrant_shared_folder_source)

      if Vagrant.has_plugin?("vagrant-triggers")
        config.trigger.before [:up, :reload, :destroy], :stderr => false, :stdout => false, :force => true do
          info "Deleting old smb share folders..."
          run "net share %s /delete" % $absolute_shared_folder_source.gsub(%r{"/"}) {"\\"}
        end
      end

      config.vm.synced_folder $vagrant_shared_folder_source,
      $vagrant_shared_folder_path,
      type: "smb",
      mount_options: ["dmode=0#{$vagrant_shared_folder_dmode},fmode=0#{$vagrant_shared_folder_fmode}"],
      disabled: !$app

    # VB
    else
      $used_shared_folder_type = "VB"
      config.vm.synced_folder $vagrant_shared_folder_source,
      $vagrant_shared_folder_path, id: "vagrant-root", owner: $vagrant_shared_folder_owner, group: $vagrant_shared_folder_group, mount_options: ["dmode=#{$vagrant_shared_folder_dmode},fmode=#{$vagrant_shared_folder_fmode}"], disabled: !$app
    end

    host_path = File.expand_path($vagrant_shared_folder_source)
    guest_path = File.expand_path($vagrant_shared_folder_path)
    InvadeSharedFolder.info("Mounting #{$used_shared_folder_type.upcase} share:\n\t\"#{host_path}\" <=> \"#{guest_path}\"")
  else
    InvadeSharedFolder.warning("Shared folders are disabled.")
  end

  # # SSH configuration
  # if ($vagrant_ssh_use_agent)

  #   config.vm.provision :shell do |known_hosts|
  #     known_hosts.inline = $ssh_inline_script
  #   end

  #   $absolute_ssh_folder_path = File.expand_path($vagrant_ssh_folder_path)
  #   config.trigger.after [:up, :reload], :stderr => false, :stdout=> false do
  #     run "ssh-copy-id -i %s/%s vagrant@%s" % [$absolute_ssh_folder_path, $vagrant_ssh_public_key_filename, $vagrant_hostname]
  #   end

  #   config.ssh.forward_agent = true
  #   config.ssh.private_key_path = "%s%s" % [$vagrant_ssh_folder_path, $vagrant_ssh_private_key_filename]

  #   puts "[InVaDE][SSH]: Use private key %s%s.".green % [$vagrant_ssh_folder_path, $vagrant_ssh_private_key_filename] if validArg
  #   puts "[InVaDE][SSH]: Please get sure ssh-copy-id is installed and ssh-agent is running!".yellow if validArg

  # else
  #   puts "[InVaDE][SSH]: Copying %s folder to guest machine".yellow % $vagrant_ssh_folder_path if validArg
  #   config.vm.synced_folder $vagrant_ssh_folder_path, "/tmp/.ssh/", id: "ssh"
  # end
  config.vm.synced_folder $vagrant_ssh_folder_path, "/tmp/.ssh/", id: "ssh", disabled: !$ssh

  # Vagrant folder sync
  config.vm.synced_folder "../", "/vagrant", id: "vagrant"

  # Vagrant cachier to cache apt packages to speed up vagrant
  if (Vagrant.has_plugin?("vagrant-cachier") && InvadeOs.isUnix?())
    config.cache.scope = :machine
    config.cache.synced_folder_opts = {
      type: :nfs,
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
  end

  # Use puppet to setup and configure dependencies, packages and the project itself
  if ($vagrant_puppet == true)

    InvadePuppet.install()

    # Libarian Puppet configuration
    if Vagrant.has_plugin?("vagrant-librarian-puppet")
      config.librarian_puppet.puppetfile_dir = $vagrant_puppet_folder
      config.librarian_puppet.placeholder_filename = ".PLACEHOLDER"
      config.librarian_puppet.destructive = false
    end

    config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "#{$vagrant_puppet_folder}/manifests"
      puppet.module_path    = "#{$vagrant_puppet_folder}/modules"
      puppet.manifest_file  = "init.pp"

      # Using puppet with hiera
      if $hiera == true
        puppet.hiera_config_path = $vagrant_puppet_hiera_file_path
      end

      # Variables to use in puppet pushed from vagrant config file and extensions
      puppet.facter = {
        "app"                 => $app, # App folder is exists or not
        "ssh"                 => $ssh, # SSH folder exists or not
        "host_os"             => InvadeOs.getOS?(), # host os
        "shared_folder_type"  => $vagrant_shared_folder_type, # Shared folder type (VB, NFS, SMB)
        "shared_folder_path"  => $vagrant_shared_folder_path, # Shared folder path on the guest machine
        "composer"            => $vagrant_general_composer, # Composer true/false
        "package_state"       => $vagrant_general_package_state, # Install packages on the guest machine (latest/present)
        "apt_update"          => $vagrant_general_apt_update # Always APT Update
      }
    end
  else
    InvadeBase.warning("Puppet provisioning is disabled.")
  end
end
