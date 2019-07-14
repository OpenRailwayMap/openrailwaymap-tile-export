SHELL = /bin/sh -e

DB_NAME := openrailwaymap
DB_HOST := localhost
DB_USER := openrailwaymap

DB := "host='${DB_HOST}' dbname='${DB_NAME}' user='${DB_USER}'"
SOURCE_SRS := EPSG:3857
TARGET_SRS := EPSG:4326
OGR2OGR_OPTIONS := -s_srs ${SOURCE_SRS} -t_srs ${TARGET_SRS}
TIPPECANOE_OPTIONS := --no-feature-limit --no-tile-size-limit --maximum-zoom=14 --force --drop-rate=0

.PHONY: all install export clean


all: clean install export

install:
	psql -h $(DB_HOST) -U $(DB_USER) -d $(DB_NAME) -f layers.sql

clean:
	rm -f *.geojson
	rm -f *.mbtiles

export:
	ogr2ogr -f GeoJSON switches.geojson PG:$(DB) layers.switches $(OGR2OGR_OPTIONS)
	ogr2ogr -f GeoJSON milestones.geojson PG:$(DB) layers.milestones $(OGR2OGR_OPTIONS)
	ogr2ogr -f GeoJSON platforms.geojson PG:$(DB) layers.platforms $(OGR2OGR_OPTIONS)
	ogr2ogr -f GeoJSON signals.geojson PG:$(DB) layers.signals $(OGR2OGR_OPTIONS)
	ogr2ogr -f GeoJSON signal_boxes.geojson PG:$(DB) layers.signal_boxes $(OGR2OGR_OPTIONS)
	ogr2ogr -f GeoJSON tracks.geojson PG:$(DB) layers.tracks $(OGR2OGR_OPTIONS)
	ogr2ogr -f GeoJSON crossings.geojson PG:$(DB) layers.crossings $(OGR2OGR_OPTIONS)
	ogr2ogr -f GeoJSON services.geojson PG:$(DB) layers.services $(OGR2OGR_OPTIONS)
	ogr2ogr -f GeoJSON landuses.geojson PG:$(DB) layers.landuses $(OGR2OGR_OPTIONS)
	ogr2ogr -f GeoJSON buildings.geojson PG:$(DB) layers.buildings $(OGR2OGR_OPTIONS)
	ogr2ogr -f GeoJSON operating_points.geojson PG:$(DB) layers.operating_points $(OGR2OGR_OPTIONS)

	tippecanoe $(TIPPECANOE_OPTIONS) --layer=switches --output=switches.mbtiles switches.geojson
	tippecanoe $(TIPPECANOE_OPTIONS) --layer=milestones --output=milestones.mbtiles milestones.geojson
	tippecanoe $(TIPPECANOE_OPTIONS) --layer=platforms --output=platforms.mbtiles platforms.geojson
	tippecanoe $(TIPPECANOE_OPTIONS) --layer=signals --output=signals.mbtiles signals.geojson
	tippecanoe $(TIPPECANOE_OPTIONS) --layer=signal_boxes --output=signal_boxes.mbtiles signal_boxes.geojson
	tippecanoe $(TIPPECANOE_OPTIONS) --layer=tracks --output=tracks.mbtiles tracks.geojson
	tippecanoe $(TIPPECANOE_OPTIONS) --layer=crossings --output=crossings.mbtiles crossings.geojson
	tippecanoe $(TIPPECANOE_OPTIONS) --layer=services --output=services.mbtiles services.geojson
	tippecanoe $(TIPPECANOE_OPTIONS) --layer=landuses --output=landuses.mbtiles landuses.geojson
	tippecanoe $(TIPPECANOE_OPTIONS) --layer=buildings --output=buildings.mbtiles buildings.geojson
	tippecanoe $(TIPPECANOE_OPTIONS) --layer=operating_points --output=operating_points.mbtiles operating_points.geojson

	tile-join --output=openrailwaymap.mbtiles --name=OpenRailwayMap --description="Worldwide railway data from OpenStreetMap" --attribution="Daten <a href=\"https://www.openstreetmap.org/copyright\">&copy; OpenStreetMap Contributors</a>, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA 2.0</a> <a href=\"https://www.openrailwaymap.org/\">OpenRailwayMap</a>" --force --no-tile-size-limit switches.mbtiles milestones.mbtiles platforms.mbtiles signals.mbtiles signal_boxes.mbtiles tracks.mbtiles crossings.mbtiles services.mbtiles landuses.mbtiles buildings.mbtiles operating_points.mbtiles
