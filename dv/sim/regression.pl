#!/usr/bin/perl -w

###################################################
# Author : Chris Le
# Email  : lehoangcuong1990@gmail.com
# Date   : July 08, 2018
###################################################

use strict;
use Getopt::Long;
use FileHandle;
use Data::Dumper;
use Cwd qw(cwd);
use File::Path;
use List::Util qw(shuffle);

my $helpFlag  = 0;
my $compileFlag = 0;
my $simulateFlag  = 0;
my $coverageFlag = 0;
my $option = "";

GetOptions (                                                                                                                          
  "-option=s"   => \$option,
  "-compile"    => \$compileFlag,
  "-simulate"   => \$simulateFlag,
  "-coverage"   => \$coverageFlag,
  "-h"          => \$helpFlag,
);

if(@ARGV != 1 || $helpFlag) {                                                                                                                     
  print_error_message();
}

my $pwd = cwd;
my $regdir = "$pwd/regression";
my $iFile = $ARGV[0];
my @tests = ();
my @pass_tests = ();
my @fail_tests = ();

open(FILE, "<", $iFile) or die $!;
foreach my $line (shuffle <FILE>) {
  if($line =~/^\s*(\w+)\s+(\d+)\s*$/) {
    for(my $i = 0; $i < $2; $i++) {
      push @tests, $1;
    }
  } elsif($line =~/^\s*(\w+)\s*$/) {
    push @tests, $1;
  } else {
    print "*warning: ignored $line";
  }
}
close(FILE);

if(!$compileFlag && !$simulateFlag) {
  $compileFlag = 1;
  $simulateFlag = 1;
}

if($compileFlag || (!-e "$regdir/simv")) {
  compile_test();
}
foreach my $test (@tests) {
  if($simulateFlag) {
    simulate_test($test);
  }
}
if($coverageFlag) {
  coverage_test();
}
if($simulateFlag) {
  report_test();
}


#******************************************************************
# compile_test() - routine to comile the test
#******************************************************************
sub compile_test {
  my $pwd = cwd;
  my $dir = "${regdir}";
  mkpath($dir) unless (-d $dir);
  chdir($dir);
  system("ln -s $pwd/Makefile") unless (-f "Makefile");
  system("make ALU_HOME=$pwd/../.. OPT=\"$option\" compile | tee run.log");
  chdir($pwd);
}              

#******************************************************************
# simulate_test() - routine to simulate the test
#******************************************************************
sub simulate_test {
  my ($test) = @_;
  my $pass = 0;
  my $seed = sprintf("%05d", int(rand(100000)));
  my $simdir = "${regdir}/${test}_${seed}";
  my $covdir = "${regdir}/coverage";
  mkpath($simdir) unless (-d $simdir);
  mkpath($covdir) unless (-d $covdir);
  chdir($simdir);
  system("ln -s ../simv") unless (-f "simv");
  system("ln -s ../simv.daidir") unless (-d "simv.daidir");
  system("ln -s ../Makefile") unless (-f "Makefile");
  system("make ALU_HOME=$pwd/../.. TEST=$test SEED=$seed OPT=\"$option\" simulate");
  if(open(FILE, "<", "simulate.log")) {
    my $f = do {local $/;<FILE>};
    $pass = ($f =~ /UVM_ERROR\s*:\s*0\s*.*UVM_FATAL\s*:\s*0\s*/);
    close(FILE);
  } 
  if($pass) {
    push @pass_tests, "${test}_${seed}";
    system("cp -rf simv.vdb $covdir\/${test}_${seed}.vdb");
  } else {
    push @fail_tests, "${test}_${seed}";
  }
  chdir($pwd);
}              


#******************************************************************
# execute_test() - routine to execute the test
#******************************************************************
sub execute_test {
  my ($test) = @_;
  my $pass = 0;
  my $seed = sprintf("%05d", int(rand(100000)));
  my $simdir = "${regdir}/${test}_${seed}";
  my $covdir = "${regdir}/coverage";
  mkpath($simdir) unless (-d $simdir);
  mkpath($covdir) unless (-d $covdir);
  chdir($simdir);
  system("ln -s $pwd/Makefile") unless (-f "Makefile");
  system("make ALU_HOME=$pwd/../.. TEST=$test SEED=$seed OPT=\"$option\" | tee run.log");
  if(open(FILE, "<", "run.log")) {
    my $f = do {local $/;<FILE>};
    $pass = ($f =~ /UVM_ERROR\s*:\s*0\s*.*UVM_FATAL\s*:\s*0\s*/);
    close(FILE);
  } 
  if($pass) {
    push @pass_tests, "${test}_${seed}";
    system("cp -rf simv.vdb $covdir\/${test}_${seed}.vdb");
  } else {
    push @fail_tests, "${test}_${seed}";
  }
  chdir($pwd);
}              


#******************************************************************
# coverage_test() - routine to coverage the test
#******************************************************************
sub coverage_test {
  my $dir = "$regdir/coverage";
  if(-d $dir) {
    system("make COV_DB=\"$regdir\/coverage\/\*.vdb\" OPT=\"$option\" coverage");
  }
}              


#******************************************************************
# report_test() - routine to report the test
#******************************************************************
sub report_test {
  open(FILE, ">", "regression.log") or die $!;
  print FILE "REGRESSION RESULTS\n";
  print FILE "==================\n\n";
  print FILE "PASSED TESTS: " . scalar @pass_tests . "\n";
  foreach my $pass_test (@pass_tests) {
    print FILE "$pass_test\n";
  }
  print FILE "\n----------------\n";
  print FILE "FAILED TESTS: " . scalar @fail_tests . "\n";
  foreach my $fail_test (@fail_tests) {
    print FILE "$fail_test\n";
  }
  close(FILE);
  print "\n";
  system("cat regression.log");
}              

#******************************************************************
# print_error_message() - routine to print error message
#******************************************************************
sub print_error_message {
  print "Usage: perl regression.pl [-option -compile -simulate -h] <regression list file> \n";
  print "       -option <option> : add option to run string\n";
  print "       -compile          : compile the regression only\n";
  print "       -simulate         : simulate the regression only\n";
  print "       -coverage         : generate coverage report\n";
  print "       -h                : print help message\n";
  exit 0;           
}              
