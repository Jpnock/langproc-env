#!/bin/bash

# Author : James Nock (@Jpnock)
# Year   : 2023

#!/bin/bash

set -uo pipefail
shopt -s globstar

make bin/c_compiler

mkdir -p bin
mkdir -p bin/output

TOTAL=0
PASSING=0

for DRIVER in compiler_tests/**/*_driver.c; do
    let TOTAL++

    TO_ASSEMBLE="${DRIVER%_driver.c}.c"
    LOG_PATH="${TO_ASSEMBLE//\//_}"
    LOG_PATH="./bin/output/${LOG_PATH%.c}"

    echo "${TO_ASSEMBLE}"

    OUT="${LOG_PATH}"
    rm -f "${OUT}.s"
    rm -f "${OUT}.o"
    rm -f "${OUT}"
    ./bin/c_compiler -S "${TO_ASSEMBLE}" -o "${OUT}.s" 2> "${LOG_PATH}.compiler.stderr.log" > "${LOG_PATH}.compiler.stdout.log"
    if [ $? -ne 0 ]; then
        echo "\t> Fail: see ${LOG_PATH}.compiler.stderr.log and ${LOG_PATH}.compiler.stdout.log"
        continue
    fi

    riscv64-unknown-elf-gcc -march=rv32imfd -mabi=ilp32d -o "${OUT}.o" -c "${OUT}.s" 2> "${LOG_PATH}.assembler.stderr.log" > "${LOG_PATH}.assembler.stdout.log"
    if [ $? -ne 0 ]; then
        echo -e "\t> Fail: see ${LOG_PATH}.assembler.stderr.log and ${LOG_PATH}.assembler.stdout.log"
        continue
    fi

    riscv64-unknown-elf-gcc -march=rv32imfd -mabi=ilp32d -static -o "${OUT}" "${OUT}.o" "${DRIVER}" 2> "${LOG_PATH}.linker.stderr.log" > "${LOG_PATH}.linker.stdout.log"
    if [ $? -ne 0 ]; then
        echo -e "\t> Fail: see ${LOG_PATH}.linker.stderr.log and ${LOG_PATH}.linker.stdout.log"
        continue
    fi

    spike pk "${OUT}" > "${LOG_PATH}.simulation.log"
    if [ $? -eq 0 ]; then
        echo -e "\t> Pass"
        let PASSING++
    else
        echo -e "\t> Fail: simulation did not exit with exit code 0"
    fi
done

printf "\nPassing %d/%d tests\n" "${PASSING}" "${TOTAL}"
