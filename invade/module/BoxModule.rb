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
  class Box < Base

    MODULE = 'BOX'

    #Defaults
    $box_path = $vagrant_general_box_url

    @do_update = false
    @box_folder = $vagrant_provisioned_box_folder
    @box_name = $vagrant_general_box_name.delete("\n")
    @box_file = '%s/%s.box' % [@box_folder, $vagrant_box_name]

    @local_version_file = './provisioned_version'
    @local_version_log_file = './provisioned_version.log'
    @remote_version_file = '%s.version' % @box_file

    def initialize
      if $vagrant_provisioned_box
        check_box if check_vagrant_argument and check_git_branch
      end
    end

    # Check the existence of a box, the version files and compare the versions
    def check_box

      unless File.directory?(@box_folder)
        self.error("InnoGames file server is not mounted! Can't create or use packaged box!\n")
        return
      end

      unless File.exist?(@box_file)
        self.warning("Box %s not yet provisioned! Create a provisioned box (see vagrant package) to speed up your development environment!\n") % @box_name
        return
      end

      unless File.exist?(@remote_version_file)
        self.error("Can't get version from remote!\nRemote: %s") % @remote_version_file
        return
      end

      unless File.exist?(@local_version_file)
        File.open(@local_version_file.delete("\n"), 'w+') do |f|
          f.write('0.0.0')
        end
      end

      unless File.exist?(@local_version_log_file)
        date = Time.now.to_s
        File.open(@local_version_log_file.delete("\n"), 'w+') { |f| f.write('%s - Created this log file.' % date) }
      end

      @box_path = @box_file
      @remote_box_version = File.open(@remote_version_file, &:readline).delete("\n")
      @local_box_version = File.open(@local_version_file, &:readline).delete("\n")

      # Compare versions
      if Gem::Version::new(@remote_box_version) > Gem::Version::new(@local_box_version)
        if @do_update
          self.ask_to_update
        else
          puts '[InVaDE][PACKAGED BOX]: New provisioned Box found! Please checkout %s branch and run [vagrant up] to update to version %s'.yellow % [$vagrant_provisioned_box_branch.upcase, @remote_box_version]
        end
      else
        self.success('Using packaged box (v%s).') % @remote_box_version
      end
    end

    private

    def ask_to_update
      prompt = '> '
      self.info('New provisioned Box found (v%s)! You want to update? Your current vagrant box (v%s) will be destroyed! [y/N] ') % [@remote_box_version.delete("\n"), @local_box_version.delete("\n")]
      print prompt

      while (user_input = STDIN.gets.chomp) # loop while getting user input
        case user_input
        when ('y' or 'Y')
          puts '[InVaDE][PACKAGED BOX]: Update to version %s. This will take a while...'.green % @remote_box_version
          self.update_version
          self.remove_and_start
          self.write_log
          break # make sure to break so you don't ask again
        when ('n' or 'N')
          self.error('Update abort') if InvadeArgument.valid
          break # and again
        else
          self.error('Wrong input. Please type [y/N].')
          print prompt # print the prompt, so the user knows to re-enter input
        end
      end
    end

    def remove_and_start
      system('vagrant destroy -f')
      system('vagrant box remove -f %s' % $vagrant_general_box_name.delete("\n"))
      system('vagrant up')
    end

    # Update the local version file
    def update_version
      File.open(@local_version_file.delete("\n"), 'w') {|f| f.write(@remote_box_version.delete("\n")) }
    end

    # Write log about version changes locally
    def write_log
      date = Time.now.to_s
      open(@local_version_log_file.delete("\n"), 'a') do |f|
          f.print "%s - Wrote version %s to file\n" % [date, @remote_box_version.delete("\n")]
      end
    end

    # Check whether argument UP was used or forced
    def check_vagrant_argument
      value = false

      if ARGV[0].to_s === 'up' || $vagrant_provisioned_box_force
        value = true
      end
    end

    # Check whether current branch is branch set in config
    def check_git_branch
      value = false

      current_branch = `git rev-parse --abbrev-ref HEAD`
      current_branch = current_branch.to_s.downcase.delete("\n")
      provisioned_box_branch = $vagrant_provisioned_box_branch.to_s.downcase.delete("\n")
      provisioned_box_branch_base = $vagrant_provisioned_box_branch_base.to_s.downcase.delete("\n")

      if current_branch == provisioned_box_branch
        @do_update = true
        value = true
      end

      if current_branch == provisioned_box_branch_base
        @do_update = false
        $vagrant_general_box_name = $vagrant_general_box_name + '-base'
        value = true
      end

      value
    end

  end
end
