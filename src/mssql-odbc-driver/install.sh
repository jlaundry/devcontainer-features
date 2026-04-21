#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Jed Laundry. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# Based on https://github.com/devcontainers/features/blob/main/src/azure-cli/install.sh


set -e

# Clean up
rm -rf /var/lib/apt/lists/*

ODBC_VERSION=${VERSION:-"18"}

OS_VERSION_ID="$(source /etc/os-release; echo "${ID}:${VERSION_ID}")"
case $OS_VERSION_ID in
    debian:10) MICROSOFT_GPG_KEYS_URI="https://packages.microsoft.com/keys/microsoft.asc" ;;
    debian:11) MICROSOFT_GPG_KEYS_URI="https://packages.microsoft.com/keys/microsoft.asc" ;;
    debian:12) MICROSOFT_GPG_KEYS_URI="https://packages.microsoft.com/keys/microsoft.asc" ;;
    debian:13) MICROSOFT_GPG_KEYS_URI="https://packages.microsoft.com/keys/microsoft-2025.asc" ;;
    ubuntu:20.04) MICROSOFT_GPG_KEYS_URI="https://packages.microsoft.com/keys/microsoft.asc" ;;
    ubuntu:22.04) MICROSOFT_GPG_KEYS_URI="https://packages.microsoft.com/keys/microsoft.asc" ;;
    ubuntu:24.04) MICROSOFT_GPG_KEYS_URI="https://packages.microsoft.com/keys/microsoft.asc" ;;
    ubuntu:26.04) MICROSOFT_GPG_KEYS_URI="https://packages.microsoft.com/keys/microsoft-2025.asc" ;;
    *) MICROSOFT_GPG_KEYS_URI="https://packages.microsoft.com/keys/microsoft-2025.asc" ;;
esac

echo "using Microsoft GPG key ${MICROSOFT_GPG_KEYS_URI} for ${OS_VERSION_ID}"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Get central common setting
get_common_setting() {
    if [ "${common_settings_file_loaded}" != "true" ]; then
        curl -sfL "https://aka.ms/vscode-dev-containers/script-library/settings.env" 2>/dev/null -o /tmp/vsdc-settings.env || echo "Could not download settings file. Skipping."
        common_settings_file_loaded=true
    fi
    if [ -f "/tmp/vsdc-settings.env" ]; then
        local multi_line=""
        if [ "$2" = "true" ]; then multi_line="-z"; fi
        local result="$(grep ${multi_line} -oP "$1=\"?\K[^\"]+" /tmp/vsdc-settings.env | tr -d '\0')"
        if [ ! -z "${result}" ]; then declare -g $1="${result}"; fi
    fi
    echo "$1=${!1}"
}

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            echo "Running apt-get update..."
            apt-get update -y
        fi
        apt-get -y install --no-install-recommends "$@"
    fi
}

export DEBIAN_FRONTEND=noninteractive


install_using_apt() {
    echo "installing msodbcsql withODBC_VERSION=${ODBC_VERSION} using MICROSOFT_GPG_KEYS_URI=${MICROSOFT_GPG_KEYS_URI} on ${architecture}"
    # Install dependencies
    check_packages apt-transport-https curl ca-certificates gnupg2 dirmngr

    # Import key safely (new 'signed-by' method rather than deprecated apt-key approach) and install
    curl -sSL ${MICROSOFT_GPG_KEYS_URI} | gpg --dearmor > /usr/share/keyrings/microsoft-prod.gpg

    echo "deb [arch=${architecture} signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/$ID/$VERSION_ID/prod ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/mssql-release.list
    apt-get update

    if [ $ODBC_VERSION -eq "18" ]; then
        MSSQL_PKG="msodbcsql${ODBC_VERSION} mssql-tools18"
    else
        MSSQL_PKG="msodbcsql${ODBC_VERSION} mssql-tools"
    fi

    if ! (ACCEPT_EULA=Y apt-get install -yq ${MSSQL_PKG} python3-dev gcc g++ unixodbc-dev); then
        rm -f /etc/apt/sources.list.d/mssql-release.list
        return 1
    fi
}

echo "(*) Installing SQL Server ODBC Driver..."
. /etc/os-release
architecture="$(dpkg --print-architecture)"

install_using_apt

# Clean up
rm -rf /var/lib/apt/lists/*

echo "Done!"
