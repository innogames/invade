#
# InVaDE - [In]nogames [Va]grant [D]evelopment [E]nvironment
#
# @author Lennart Stein
# @email  lennart.stein@innogames.com
#

require './invade/module/BaseModule'
require './invade/module/DefaultsModule'
require './invade/module/ArgumentModule'
require './invade/module/ConfigModule'
require './invade/module/SshModule'
require './invade/module/OsModule'
require './invade/module/PluginModule'
require './invade/module/SharedFolderModule'
require './invade/module/PuppetModule'
require './invade/module/PerformanceModule'
require './invade/module/BoxModule'

InvadeBase = Invade::Base.new()
InvadeArgument = Invade::Argument.new()
InvadeConfig = Invade::Configuration.new()
InvadeSSH = Invade::SSH.new()
InvadeOs = Invade::Os.new()
InvadePlugin = Invade::Plugin.new()
InvadeSharedFolder = Invade::SharedFolder.new()
InvadePuppet = Invade::Puppet.new()
InvadePerformance = Invade::Performance.new()
InvadeBox = Invade::Box.new()
