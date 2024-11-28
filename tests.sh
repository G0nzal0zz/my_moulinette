#!/bin/bash

EXECUTABLE="$1"

# Check if the correct number of arguments are passed
if [ "$#" -ne 1 ]; then
    echo -e "Usage: $0 <executable_path>"
    exit 1
fi

# Check if the file exists
if  ! test -f "${EXECUTABLE}"; then
    echo -e "File not found: ${EXECUTABLE}"
    exit 1
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
BOLDGREEN='\033[1;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
BOLDRED='\033[1;31m'
NC='\033[0m'  # No Color

divider="----------------------------------------------------"

declare -i failed_tests=0

should_return_84() {
    echo -e "$divider"
    echo -e "${YELLOW}Program should return 84\n${NC}"

    output=$("$EXECUTABLE" 2>&1)
    exit_status=$?

    # Run the test (check if the exit status is 84)
    if [ $exit_status -eq 1 ]; then
        echo -e "${BOLDGREEN}✔ Passed${NC}"
    else
        echo -e "${BOLDRED}✘ Failed${NC}"
        echo -e "${RED}Expected:${NC}"
        echo -e 84
        echo -e "${RED}Got:${NC}"
        echo -e "$exit_status"
        ((failed_tests++))  # Increment failed tests count
    fi
    echo -e "$divider\n"
}

should_show_help_message() {
    echo -e "$divider"
    echo -e "${YELLOW}Program should show help message\n${NC}"

    help_message="Usage: ./my_pgp CRYPTO_SYSTEM MODE [OPTIONS] [key]"
    output=$("$EXECUTABLE" 2>&1)

    # Run the test (check if the output is the help message)
    if [[ "$output" == "${help_message}" ]]; then
        echo -e "${BOLDGREEN}✔ Passed${NC}"
    else
        echo -e "${BOLDRED}✘ Failed${NC}"
        echo -e "${RED}Expected:${NC}"
        echo -e "${help_message}"
        echo -e "${RED}Got:${NC}"
        echo -e "$output"
        ((failed_tests++))  # Increment failed tests count
    fi
    echo -e "$divider\n"
}

log_test_result() {
    if [ $failed_tests -gt 0 ]; then
        echo -e "${RED}Failed Tests: $failed_tests${NC}"
        exit 1
    else
        echo -e "${GREEN}All Tests Passed!${NC}"
    fi
}

run_tests() {
    echo -e "${CYAN}Starting Tests...${NC}\n"
    # Add your test functions here
    should_return_84
    should_show_help_message
    # End of test functions
    echo -e "${CYAN}All Tests Completed.${NC}"
    log_test_result
}

run_tests
