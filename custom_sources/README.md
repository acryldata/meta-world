# custom_sources

This is a collection of example custom sources to extend Datahub without the need of forking the Datahub project.
The core pieces for building your own source is a python package containing the code for your source (follow [adding-source guide](https://datahubproject.io/docs/metadata-ingestion/adding-source) for more details) and then you can just reference it in the recipe by using the package path.

## my-source
`my-source` is an example custom source which always returns the content of `example_mce/single_mce.json` as an MCE. It can work as a base for custom sources you may need in your project and are not available in the offical project yet.
