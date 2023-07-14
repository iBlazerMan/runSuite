#!/bin/bash

# handle missing suite file/program
if [ $# -ne 2 ]; then
    echo "Usage: $0 [suite-file] [program]" 1>&2
    exit 4
fi

tests_passed=true

# handle missing expected output file
for test in $(cat $1); do
    if ! [ -r $test.expect ]; then
        echo "missing output(.expect) file" 1>&2
        exit 1
    fi

    TEMPFILE=$(mktemp)

    # run test with input and argument files supplied
    if [[ -r $test.args && -r $test.in ]]; then
        cat $test.in | ./$2 $(cat $test.args) > $TEMPFILE
        if ! [[ $(diff $test.expect $TEMPFILE) == "" ]]; then
            echo "Test failed: $test"
            echo "Args:"
            echo $(cat $test.args)
            echo "Input:"
            echo $(cat $test.in)
            echo "Expected:"
            echo $(cat $test.expect)
            echo "Actual:"
            echo $(cat $TEMPFILE)
            tests_passed=false
        fi

    # run test with only argument file supplied
    elif [[ -r $test.args ]]; then
        ./$2 $(cat $test.args) > $TEMPFILE
        if ! [[ $(diff $test.expect $TEMPFILE) == "" ]]; then
            echo "Test failed: $test"
            echo "Args:"
            echo $(cat $test.args)
            echo "No input provided"
            echo "Expected:"
            echo $(cat $test.expect)
            echo "Actual:"
            echo $(cat $TEMPFILE)
            tests_passed=false
        fi

    # run test with only input file supplied
    elif [[ -r $test.in ]]; then
        cat $test.in | ./$2 > $TEMPFILE
        if ! [[ $(diff $test.expect $TEMPFILE) == "" ]]; then
            echo "Test failed: $test"
            echo "No argument provided"
            echo "Input:"
            echo $(cat $test.in)
            echo "Expected:"
            echo $(cat $test.expect)
            echo "Actual:"
            echo $(cat $TEMPFILE)
            tests_passed=false
        fi

    # run test with no argument/input file supplied
    else
        ./$2 > $TEMPFILE
        if ! [[ $(diff $test.expect $TEMPFILE) == "" ]]; then
            echo "Test failed: $test"
            echo "No argument and input provided"
            echo "Expected:"
            echo $(cat $test.expect)
            echo "Actual:"
            echo $(cat $TEMPFILE)
            tests_passed=false
        fi
    fi
    
    rm $TEMPFILE
done

# print out confirmation if all tests passed
if [ "$tests_passed" = true ]; then
    echo "All tests passed!"
fi
