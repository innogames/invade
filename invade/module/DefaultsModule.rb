# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# InVaDE - [In]nogames [Va]grant [D]evelopment [E]nvironment
#
# @author Lennart Stein
# @email  lennart.stein@innogames.com
# @web    http://github.com/innogames/invade
#

# VAGRANT - GENERAL CONFIGURATION
$vagrant_general_vm_name = "vagrant_invade_#{rand(500000).to_i}"
$vagrant_general_box_name = "puphpet/ubuntu1404-x64"
$vagrant_general_box_url = "puphpet/ubuntu1404-x64"
$vagrant_general_composer = true
$vagrant_general_package_state = 'latest'
$vagrant_general_apt_update = true
$vagrant_general_vbguest = false
$vagrant_general_vagrant_folder = 'etc/vagrant'

# VAGRANT - NETWORK CONFIGURATION
$vagrant_network_type = 'private_network'
$vagrant_network_ip = '24.24.24.24'
$vagrant_network_hostname = 'vagrant.vm'

# VAGRANT - SHARED FOLDER CONFIGURATION
$vagrant_shared_folder = true
$vagrant_shared_folder_source = '../..'
$vagrant_shared_folder_path = '/www'
$vagrant_shared_folder_type = 'vb'
$vagrant_shared_folder_owner = 'vagrant'
$vagrant_shared_folder_group = 'www-data'
$vagrant_shared_folder_dmode = 775
$vagrant_shared_folder_fmode = 664
$vagrant_shared_folder_nfs_mount_options = ['nolock']

# VAGRANT - PERFORMANCE CONFIGURATION
$vagrant_performance_auto = false
$vagrant_performance_cores = 4
$vagrant_performance_ram = 1024

# VAGRANT - SSH
$vagrant_ssh = true
$vagrant_ssh_use_agent = false
$vagrant_ssh_folder_path = '~/.ssh/'
$vagrant_ssh_private_key_filename = 'id_rsa'
$vagrant_ssh_public_key_filename = 'id_rsa.pub'
$vagrant_ssh_known_hosts = []

# VAGRANT - PUPPET CONFIGURATION
$vagrant_puppet = true
$vagrant_puppet_folder = '../puppet'
$vagrant_puppet_hiera_file_path = ''
$vagrant_puppet_modules_basic = [
  %w(github puppetlabs/puppetlabs-stdlib),
  %w(github puppetlabs/puppetlabs-apt 1.4.2)
]
$vagrant_puppet_modules  = []

# VAGRANT - PLUGINS CONFIGURATION
$vagrant_plugins_auto_update = false
$vagrant_plugins_basic = %w(vagrant-triggers vagrant-hostmanager vagrant-vbguest vagrant-cachier vagrant-bindfs vagrant-r10k)
$vagrant_plugins_basic_windows = ['vagrant-winnfsd']
$vagrant_plugins_basic_gems = []
$vagrant_plugins_winnfsd_logging = 'off'
$vagrant_plugins_hostmanager_enabled = true
$vagrant_plugins_hostmanager_manage_host = true
$vagrant_plugins_hostmanager_ignore_private_ip = false
$vagrant_plugins_hostmanager_include_offline = true
$vagrant_plugins_hostmanager_aliases = ''

# VAGRANT - PACKAGED BOX CONFIGURATION
$vagrant_provisioned_box = false
$vagrant_provisioned_box_branch = 'master'
$vagrant_provisioned_box_branch_base = 'develop'
$vagrant_provisioned_box_folder = ''
$vagrant_provisioned_box_force = false
