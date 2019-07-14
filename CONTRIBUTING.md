Contribution Guidelines
=======================

This document contains technical details and design guidelines for developers.

## Development

If you do any modifications on the [database views](layers.sql), apply your changes to the database with these simple steps:

* run `make install` to replace the old database views by the modified ones
* run `make export` again to generate a new MBTiles extract

You can also simply execute `make all` to execute both steps in a single command.

## Technical Deails

Generating a MBTiles vector tile extract consists of four steps:

1. Database Export Views
2. Export from database to GeoJSON with ogr2ogr
3. Conversion from GeoJSON to MBTiles with tippecanoe
4. Merging layers with tile-join

### Database Export Views

Each database view returns the data for one layer in the MBTiles vector tileset. Each export view must return a geometry column and a couple of optional columns. The column name will be the attribute name in the mbtiles layer.

The export views should contain the data for the highest zoom levels. Any simplification of geometries will be done with tippecanoe.
