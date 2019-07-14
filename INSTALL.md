Installation Instructions
=========================

## Requirements

* [tippecanoe](https://github.com/mapbox/tippecanoe)
* tile-join (part of tippecanoe)
* [ogr2ogr](https://gdal.org/programs/ogr2ogr.html)
* PostgreSQL + PostGIS database with [osm2pgsql](https://github.com/openstreetmap/osm2pgsql) schema
* make (should be already be part of all major Linux distributions)

### tippecanoe

First install some dependencies by running

CentOS:

```shell
   $ sudo yum install libsqlite3x-devel zlib-dev
```

Debian/Ubuntu:

```shell
   $ sudo apt-get install build-essential libsqlite3-dev zlib1g-dev
```

Then check out the code from the Github repository and build it:

```shell
   $ git clone https://github.com/mapbox/tippecanoe.git
   $ cd tippecanoe
   $ make -j
   $ sudo make install
```

### ogr2ogr

ogr2ogr is part of GDAL and can be installed by running

CentOS:

```shell
   $ sudo yum install gdal
```

Debian/Ubuntu:

```shell
   $ sudo apt-get install gdal-bin
```

### Database

The installation of an osm2pgsql database is not documented here. Have a look at the following resources:

* https://github.com/openstreetmap/osm2pgsql/blob/master/README.md
* https://wiki.openstreetmap.org/wiki/Osm2pgsql
* https://github.com/OpenRailwayMap/OpenRailwayMap/blob/master/INSTALL.md#setting-up-the-database

## Installation

In the `Makefile`, set your database connection parameters. The password will be read from your `~/.pgpass` file.

```makefile
DB_NAME := openrailwaymap
DB_HOST := localhost
DB_USER := openrailwaymap
```

Run `make install` to create the export views in the database:

```shell
   $ make install
```

Note: The export views will be created in schema `layers`. Make sure that there is no existing schema with this name. The complete schema with all depending objects will be removed and overwritten when installing the database views with `make install`.
