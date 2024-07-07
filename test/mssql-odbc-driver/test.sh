#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Definition specific tests
if test -f /opt/mssql-tools18/bin/sqlcmd; then
  check "version" bash -c "/opt/mssql-tools18/bin/sqlcmd -? | grep -i version"
else
  check "version" bash -c "/opt/mssql-tools/bin/sqlcmd -? | grep -i version"
fi

# Report result
reportResults