#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Definition specific tests
check "version" bash -c "/opt/mssql-tools/bin/sqlcmd -? | grep -i version"

# Report result
reportResults