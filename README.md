# Development Container Features

'Features' are self-contained units of installation code and development container configuration. Features are designed
to install atop a wide-range of base container images (**this repo focuses on `debian` based images**).

This repo contains features used by Jed in his projects. You may find these useful as well.

Issues and PR's are welcome, but no guarantees are made.

You may learn about Features at [containers.dev](https://containers.dev/implementors/features/), which is the website for the dev container specification.

## Known Issues

  * `azure-function-core-tools`
  	* Upstream does not (yet) support AArch64 / arm64 architectures. https://github.com/Azure/azure-functions-core-tools/issues/3112
  * `mssql-odbc-driver`
	* Upstream does not (yet) support Ubuntu 24.04. https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server

## Usage

Azure Functions Core Tools are used when developing Function apps, to create a local development server.

The Microsoft SQL Server ODBC Driver is used to connect to SQL Server instances, including Azure SQL.

For example, if you develop Python-based Azure Functions that use SQL Server, your `.devcontainer.json` should look like:

```jsonc
{
	"name": "Python 3",
	"image": "mcr.microsoft.com/devcontainers/python:3.12-bookworm",
	"features": {
		"ghcr.io/jlaundry/devcontainer-features/azure-functions-core-tools:1": {
			"version": "latest"
		},
		"ghcr.io/jlaundry/devcontainer-features/mssql-odbc-driver:1": {
			"version": "17"
		}
	}
}
```
