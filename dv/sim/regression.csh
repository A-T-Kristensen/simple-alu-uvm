###################################################
# Author : Chris Le
# Email  : lehoangcuong1990@gmail.com
# Date   : July 08, 2018
###################################################
 
if ("$#" != 1) then
  echo "Please provide single list test file"
  echo "Use: run_regression.csh <list test file>"
  exit 1
endif
set pwd = `pwd`
set root = $pwd/regression
set passed_tests = ()
set failed_tests = ()
set tests = (`cat $1`)
set simvdb = ()
if(! -d $root) then
  mkdir $root
endif
foreach test ($tests)
  set seed = `bash -c 'echo $((RANDOM % 100000))'`
  if(! -d $root/${test}_${seed}) then
    mkdir $root/${test}_${seed}
  endif
  pushd $root/${test}_${seed}
  if(-e Makefile) then
    unlink Makefile
  endif 
  ln -s $pwd/Makefile 
  make ALU_HOME=$pwd/../.. TEST=$test SEED=$seed | tee run.log

  egrep "UVM_ERROR\s*:\s*0\s*" run.log >/dev/null && egrep "UVM_FATAL\s*:\s*0\s*" run.log  >/dev/null
  if(! $status) then
    set passed_tests = ($passed_tests "${test}_${seed}")
    set simvdb = ($simvdb "$root/${test}_${seed}/simv.vdb")
  else 
    set failed_tests = ($failed_tests "${test}_${seed}")
  endif
  popd
end
make COV_DB="$simvdb" coverage

echo
echo
echo "REGRESSION RESULTS"
echo "=================="
echo
echo "PASSED TESTS: $#passed_tests"
foreach test ($passed_tests)
  echo $test
end
echo "----------------"
echo "FAILED TESTS: $#failed_tests"
foreach test ($failed_tests)
  echo $test
end
