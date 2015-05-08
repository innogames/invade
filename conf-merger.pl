#!/usr/bin/perl -w

#
# InVaDE - [In]nogames [Va]grant [D]evelopment [E]nvironment
#
# @author Lennart Stein
# @email  lennart.stein@innogames.com
# @web    http://github.com/innogames/invade
#

# Copyright (C) 2008-2014 TrinityCore <http://www.trinitycore.org/>
# Author: leak
# Date: 2010-12-06

use strict;

#if (@ARGV != 3)
#{
#    print("Usage:\nconf-merger.pl <path to new .conf.dist> <path to old .conf> <path to output .conf>\n");
#    exit(1);
#}

#if (! -e $ARGV[0])
#{
#    print("No file found at: ".$ARGV[0]);
#    exit(1);
#}
#elsif (! -e $ARGV[1])
#{
#    print("No file found at: ".$ARGV[1]);
#    exit(1);
#}

my $newConfigDist = 'VagrantfileConfig.dist';
my $oldConfig     = 'VagrantfileConfig';
my $newConfig     = 'VagrantfileConfig';
my $backupConfig  = 'VagrantfileConfig.old';

open CONFDIST, "<", $newConfigDist or die "Error: Could not open ".$newConfigDist."\n";
my $confdist = join "", <CONFDIST>;
close CONFDIST;

open CONFOLD, "<", $oldConfig or die "Error: Could not open ".$oldConfig."\n";
my $confold = join "", <CONFOLD>;
open CONFBACKUP, ">", $backupConfig or die "Error: Could not open ".$backupConfig."\n";
binmode(CONFBACKUP);
print CONFBACKUP $confold;
close CONFBACKUP;
close CONFOLD;

while ($confold =~ m/^(?!#)(.*?)\s+?=\s+?(.*?)$/mg) {
    my $key = $1, my $value = $2;
        $confdist =~ s/^(\Q$key\E)(\s+?=\s+?)(.*)/$1$2$value/mg;
}

open OUTPUT, ">", $newConfig or die "Error: Could not open ".$newConfig."\n";
binmode(OUTPUT);
print OUTPUT $confdist;
close OUTPUT;
