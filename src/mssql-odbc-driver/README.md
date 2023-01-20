
# SQL Server ODBC Driver (mssql-odbc-driver)

Installs the SQL Server ODBC Driver along with needed dependencies. Useful for developing apps inside codespaces that connect to a SQL Server instance.

## Example Usage

```json
"features": {
    "ghcr.io/jlaundry/devcontainer-features/mssql-odbc-driver:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select or enter an ODBC driver version. Defaults to 17. (available versions may vary by Linux distribution.) | string | 17 |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/jlaundry/devcontainer-features/blob/main/src/mssql-odbc-driver/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
