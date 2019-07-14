openrailwaymap-tile-export
==========================

Generate vector tiles in [MBTiles format](https://github.com/mapbox/mbtiles-spec) from an [osm2pgsql](https://github.com/openstreetmap/osm2pgsql) database.

This repository contains custom code for generating extracts with railway data for [OpenRailwayMap](https://www.openrailwaymap.org/), but you may use it as a basis for your own generation of custom MBTiles extracts.

## Installation

Follow the [installation instructions](INSTALL.md).

## Usage

Once you installed all dependencies like described in the [installation instructions](INSTALL.md), generating vector tiles is very easy:

To export the data from the database and generate a mbtiles vector tileset, simply run:

```shell
   $ make export
```

To remove all local `.mbtiles` and `.geojson` files, run:

```shell
   $ make export
```

You can also just execute `make all` to clean up local files, (re-)install the database export views and create the mbtiles:

```shell
   $ make all
```

## Contribute

Contributions to this project are welcome, read the [contribution guidelines](CONTRIBUTING.md) for further details and developer information.

If you would like to report an issue, please use the [issue tracker](https://github.com/openrailwaymap/openrailwaymap-tile-export/issues) on GitHub.

## Authors

This project is maintained by [Alexander Matheisen](http://github.com/rurseekatze/).
 
Github provides a [full list of contributors](https://github.com/openrailwaymap/openrailwaymap-tile-export/graphs/contributors).

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for further information.
