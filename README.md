# runSuite

runSuite.sh is an input/output test automation tool implemented using Bash Script. 
It runs the executable with command line args and input provided and compares the expected output provided to the actual output of the program.

To use: provide the input in a .in file, arguments in .args, and expected output in .expect; one set of test must have the same stem(file name).
Then, create a suite file and provide the stems of all tests with no file extension with each test separated by a new line character.
Make sure all tests files and runSuite are in the directory of the executable and run the following under the directory:
./runSuite.sh suitefile ./executable


For example:

test files:
test.in
test.args
test.expect
test2.in
test2.expect

in suite file (suite.txt):
test
test2

executable:
program.exe

then run the following under the directory:
./runSuite.sh suite.txt ./program.exe
