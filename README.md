# Development Container Features

'Features' are self-contained units of installation code and development container configuration. Features are designed
to install atop a wide-range of base container images (**this repo focuses on `debian` based images**).

This repo contains features used by Jed in his projects. You may find these useful as well.

Issues and PR's are welcome, but no guarantees are made.

You may learn about Features at [containers.dev](https://containers.dev/implementors/features/), which is the website for the dev container specification.

## Usage

### `azure-function-core-tools`

Azure Functions Core Tools are used when developing Function apps, to create a local development server.

To install, add `ghcr.io/jlaundry/devcontainer-features/azure-functions-core-tools:1` to the `.devcontainer.json` features list. For example, if you develop Python-based Azure Functions, your `.devcontainer.json` should look like:

```jsonc
{
	"name": "Python 3",
	"image": "mcr.microsoft.com/devcontainers/python:3.9",
	"features": {
		"ghcr.io/devcontainers/features/node:1": {
			"version": "lts"
		},
		"ghcr.io/jlaundry/devcontainer-features/azure-functions-core-tools:1": {
			"version": "latest"
		} 
	}

	// Use 'forwardPorts' to make a list of ports inside the container available locally.
	// "forwardPorts": [],

	// Use 'postCreateCommand' to run commands after the container is created.
	// "postCreateCommand": "pip3 install --user -r requirements.txt",

	// Configure tool-specific properties.
	// "customizations": {},

	// Uncomment to connect as root instead. More info: https://aka.ms/dev-containers-non-root.
	// "remoteUser": "root"
}
```
