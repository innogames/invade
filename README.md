# InVaDE - The configuration injector for Vagrant
InVaDE is a configuration injector for Vagrant. It stands for [In]noGames [Va]grant [D]evelopment [E]nvironment.

Usually you configure Vagrant through a Vagrantfile. But while working in a team often different environments are used. So each person has to edit and extend its own Vagrantfile.
That's where InVaDE is getting place! With a basic and easy configuration file you are able to configure Vagrant. And that without complaining about various issues related to different operation systems, file systems or technologies.

A set of options are given to personalize your Vagrant Development Environment to your needs. The very same Vagrant with a personal configuration.
### Installation
With the first start InVaDE creates a configuration file called "InvadeConfig". You can configure InVaDE to your needs.
All available InVaDE configuration settings are listed in the wiki page [InVaDE Configuration Settings].

#### Standalone
```sh
$ cd ./yourworkspace
$ git clone git@innogames.de:invade/core.git invade

# Run InVaDE
$ cd invade
$ vagrant up
```
#### Into existing repository (as submodule)
```sh
$ cd ./yourworkspace/project
$ git submodule add git@github.com:innogames/invade.git invade

# Run InVaDE
$ cd invade
$ vagrant up
```

[invade]:https://github.com/innogames/invade
[virtualbox]:https://www.virtualbox.org
[vagrant]:https://www.vagrantup.com
[ruby]:https://www.ruby-lang.org
[InVaDE Configuration Settings]:https://github.com/innogames/invade/wiki
