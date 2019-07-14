DROP SCHEMA IF EXISTS layers CASCADE;

CREATE SCHEMA IF NOT EXISTS layers;
COMMENT ON SCHEMA layers IS 'Layers for vector tiles';


CREATE OR REPLACE VIEW layers.switches AS
SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:local_operated' AS local_operated,
	tags->'railway:switch:resetting' AS resetting,
	tags->'railway:switch:electric' AS electric,
	tags->'railway:switch:heated' AS heated,
	CASE
		WHEN tags->'railway' = 'switch' THEN COALESCE(tags->'railway:switch', 'switch')
		WHEN tags->'railway' = 'railway_crossing' THEN 'railway_crossing'
		WHEN tags->'railway' = 'derail' THEN 'derail'
		WHEN tags->'railway' = 'buffer_stop' THEN 'buffer_stop'
	END AS type
FROM openrailwaymap_point
WHERE tags->'railway' = 'switch'
	OR tags->'railway' = 'railway_crossing'
	OR tags->'railway' = 'derail'
	OR tags->'railway' = 'buffer_stop';


CREATE OR REPLACE VIEW layers.milestones AS
SELECT way AS geom,
	tags->'railway:position' AS position,
	tags->'railway:position:exact' AS exact_position
FROM openrailwaymap_point
WHERE tags->'railway' = 'milestone';


CREATE OR REPLACE VIEW layers.platforms AS
SELECT way AS geom,
	tags->'surface' AS surface,
	tags->'operator' AS operator,
	tags->'operator:short' AS operator_short,
	tags->'name' AS name,
	COALESCE(tags->'height', tags->'platform_height', tags->'platform:height') AS height,
	COALESCE(tags->'length', tags->'platform_length', tags->'platform:length') AS length,
	tags->'local_ref' AS ref
FROM openrailwaymap_line
WHERE tags->'railway' = 'platform'

UNION ALL

SELECT way AS geom,
	tags->'surface' AS surface,
	tags->'operator' AS operator,
	tags->'operator:short' AS operator_short,
	tags->'name' AS name,
	COALESCE(tags->'height', tags->'platform_height', tags->'platform:height') AS height,
	COALESCE(tags->'length', tags->'platform_length', tags->'platform:length') AS length,
	tags->'local_ref' AS ref
FROM openrailwaymap_polygon
WHERE tags->'railway' = 'platform';


CREATE OR REPLACE VIEW layers.crossings AS
SELECT way AS geom,
	tags->'railway:position' AS position,
	tags->'railway:position:exact' AS exact_position,
	tags->'crossing:saltire' AS saltire,
	tags->'crossing:bell' AS bell,
	tags->'crossing:chicane' AS chicane,
	tags->'crossing:light' AS light,
	tags->'crossing:barrier' AS barrier,
	tags->'crossing:supervision' AS supervision,
	tags->'crossing:activation' AS activation,
	tags->'crossing:on_demand' AS on_demand,
	tags->'name' AS name,
	COALESCE(tags->'railway:ref', tags->'ref') AS ref
FROM openrailwaymap_point
WHERE tags->'railway' = 'level_crossing'
	OR tags->'railway' = 'crossing';


CREATE OR REPLACE VIEW layers.tracks AS
SELECT way AS geom,
	tags->'railway' AS type,
	tags->'disused:railway' AS disused_type,
	tags->'abandoned:railway' AS abandoned_type,
	tags->'razed:railway' AS razed_type,
	tags->'proposed:railway' AS proposed_type,
	tags->'construction:railway' AS construction_type,
	tags->'voltage' AS voltage,
	tags->'frequency' AS frequency,
	tags->'electrified' AS electrified,
	tags->'proposed:voltage' AS proposed_voltage,
	tags->'proposed:frequency' AS proposed_frequency,
	tags->'proposed:electrified' AS proposed_electrified,
	tags->'construction:voltage' AS construction_voltage,
	tags->'construction:frequency' AS construction_frequency,
	tags->'construction:electrified' AS construction_electrified,
	tags->'gauge' AS gauge,
	tags->'usage' AS usage,
	tags->'service' AS service,
	tags->'ref' AS line_ref,
	tags->'railway:track_ref' AS track_ref,
	tags->'name' AS name,
	tags->'rack' AS rack,
	tags->'railway:traffic_mode' AS traffic_mode,
	tags->'railway:preferred_direction' AS preferred_direction,
	tags->'highspeed' AS highspeed,
	tags->'railway:ballastless' AS ballastless,
	tags->'operator' AS operator,
	tags->'operator:short' AS operator_short,
	tags->'tunnel' AS tunnel,
	tags->'tunnel:name' AS tunnel_name,
	tags->'tunnel:length' AS tunnel_length,
	tags->'bridge' AS bridge,
	tags->'bridge:name' AS bridge_name,
	tags->'bridge:length' AS bridge_length,
	tags->'bridge:structure' AS bridge_structure,
	tags->'level' AS level,
	tags->'layer' AS layer,
	tags->'maxspeed' AS maxspeed,
	tags->'maxspeed:forward' AS maxspeed_forward,
	tags->'maxspeed:backward' AS maxspeed_backward,
	tags->'maxspeed:tilting' AS maxspeed_tilting,
	tags->'incline' AS incline,
	tags->'embankment' AS embankment,
	tags->'cutting' AS cutting,
	tags->'railway:pzb' AS pzb,
	tags->'railway:lzb' AS lzb,
	tags->'railway:etcs' AS etcs,
	tags->'railway:gnt' AS gnt
FROM openrailwaymap_line
WHERE tags->'railway' = 'rail'
	OR tags->'railway' = 'tram'
	OR tags->'railway' = 'light_rail'
	OR tags->'railway' = 'subway'
	OR tags->'railway' = 'narrow_gauge'
	OR tags->'railway' = 'miniature'
	OR tags->'railway' = 'preserved'
	OR tags->'railway' = 'proposed'
	OR tags->'railway' = 'construction'
	OR tags->'railway' = 'disused'
	OR tags->'railway' = 'abandoned'
	OR tags->'railway' = 'razed';


CREATE OR REPLACE VIEW layers.signal_boxes AS
SELECT way AS geom,
	tags->'name' AS name,
	tags->'railway:ref' AS ref,
	tags->'railway:signal_box' AS signal_box,
	tags->'operator' AS operator,
	tags->'operator:short' AS operator_short,
	tags->'railway:local_operated' AS local_operated
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal_box'

UNION ALL

SELECT way AS geom,
	tags->'name' AS name,
	tags->'railway:ref' AS ref,
	tags->'railway:signal_box' AS signal_box,
	tags->'operator' AS operator,
	tags->'operator:short' AS operator_short,
	tags->'railway:local_operated' AS local_operated
FROM openrailwaymap_polygon
WHERE tags->'railway' = 'signal_box';


CREATE OR REPLACE VIEW layers.signals AS
SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'main' AS category,
	tags->'railway:signal:main' AS signal,
	tags->'railway:signal:main:form' AS form,
	tags->'railway:signal:main:height' AS height,
	tags->'railway:signal:main:deactivated' AS deactivated,
	tags->'railway:signal:main:states' AS states,
	tags->'railway:signal:main:function' AS function,
	tags->'railway:signal:main:substitute_signal' AS substitute_signal,
	tags->'railway:signal:main:shortened' AS shortened,
	tags->'railway:signal:main:repeated' AS repeated,
	tags->'railway:signal:main:speed' AS speed,
	tags->'railway:signal:main:turn_direction' AS turn_direction,
	tags->'railway:signal:main:type' AS type,
	tags->'railway:signal:main:caption' AS caption,
	tags->'railway:signal:main:twice' AS twice,
	tags->'railway:signal:main:only_transit' AS only_transit,
	tags->'railway:signal:main:frequency' AS frequency,
	tags->'railway:signal:main:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:main'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'combined' AS category,
	tags->'railway:signal:combined' AS signal,
	tags->'railway:signal:combined:form' AS form,
	tags->'railway:signal:combined:height' AS height,
	tags->'railway:signal:combined:deactivated' AS deactivated,
	tags->'railway:signal:combined:states' AS states,
	tags->'railway:signal:combined:function' AS function,
	tags->'railway:signal:combined:substitute_signal' AS substitute_signal,
	tags->'railway:signal:combined:shortened' AS shortened,
	tags->'railway:signal:combined:repeated' AS repeated,
	tags->'railway:signal:combined:speed' AS speed,
	tags->'railway:signal:combined:turn_direction' AS turn_direction,
	tags->'railway:signal:combined:type' AS type,
	tags->'railway:signal:combined:caption' AS caption,
	tags->'railway:signal:combined:twice' AS twice,
	tags->'railway:signal:combined:only_transit' AS only_transit,
	tags->'railway:signal:combined:frequency' AS frequency,
	tags->'railway:signal:combined:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:combined'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'distant' AS category,
	tags->'railway:signal:distant' AS signal,
	tags->'railway:signal:distant:form' AS form,
	tags->'railway:signal:distant:height' AS height,
	tags->'railway:signal:distant:deactivated' AS deactivated,
	tags->'railway:signal:distant:states' AS states,
	tags->'railway:signal:distant:function' AS function,
	tags->'railway:signal:distant:substitute_signal' AS substitute_signal,
	tags->'railway:signal:distant:shortened' AS shortened,
	tags->'railway:signal:distant:repeated' AS repeated,
	tags->'railway:signal:distant:speed' AS speed,
	tags->'railway:signal:distant:turn_direction' AS turn_direction,
	tags->'railway:signal:distant:type' AS type,
	tags->'railway:signal:distant:caption' AS caption,
	tags->'railway:signal:distant:twice' AS twice,
	tags->'railway:signal:distant:only_transit' AS only_transit,
	tags->'railway:signal:distant:frequency' AS frequency,
	tags->'railway:signal:distant:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:distant'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'minor' AS category,
	tags->'railway:signal:minor' AS signal,
	tags->'railway:signal:minor:form' AS form,
	tags->'railway:signal:minor:height' AS height,
	tags->'railway:signal:minor:deactivated' AS deactivated,
	tags->'railway:signal:minor:states' AS states,
	tags->'railway:signal:minor:function' AS function,
	tags->'railway:signal:minor:substitute_signal' AS substitute_signal,
	tags->'railway:signal:minor:shortened' AS shortened,
	tags->'railway:signal:minor:repeated' AS repeated,
	tags->'railway:signal:minor:speed' AS speed,
	tags->'railway:signal:minor:turn_direction' AS turn_direction,
	tags->'railway:signal:minor:type' AS type,
	tags->'railway:signal:minor:caption' AS caption,
	tags->'railway:signal:minor:twice' AS twice,
	tags->'railway:signal:minor:only_transit' AS only_transit,
	tags->'railway:signal:minor:frequency' AS frequency,
	tags->'railway:signal:minor:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:minor'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'minor_distant' AS category,
	tags->'railway:signal:minor_distant' AS signal,
	tags->'railway:signal:minor_distant:form' AS form,
	tags->'railway:signal:minor_distant:height' AS height,
	tags->'railway:signal:minor_distant:deactivated' AS deactivated,
	tags->'railway:signal:minor_distant:states' AS states,
	tags->'railway:signal:minor_distant:function' AS function,
	tags->'railway:signal:minor_distant:substitute_signal' AS substitute_signal,
	tags->'railway:signal:minor_distant:shortened' AS shortened,
	tags->'railway:signal:minor_distant:repeated' AS repeated,
	tags->'railway:signal:minor_distant:speed' AS speed,
	tags->'railway:signal:minor_distant:turn_direction' AS turn_direction,
	tags->'railway:signal:minor_distant:type' AS type,
	tags->'railway:signal:minor_distant:caption' AS caption,
	tags->'railway:signal:minor_distant:twice' AS twice,
	tags->'railway:signal:minor_distant:only_transit' AS only_transit,
	tags->'railway:signal:minor_distant:frequency' AS frequency,
	tags->'railway:signal:minor_distant:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:minor_distant'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'speed_limit' AS category,
	tags->'railway:signal:speed_limit' AS signal,
	tags->'railway:signal:speed_limit:form' AS form,
	tags->'railway:signal:speed_limit:height' AS height,
	tags->'railway:signal:speed_limit:deactivated' AS deactivated,
	tags->'railway:signal:speed_limit:states' AS states,
	tags->'railway:signal:speed_limit:function' AS function,
	tags->'railway:signal:speed_limit:substitute_signal' AS substitute_signal,
	tags->'railway:signal:speed_limit:shortened' AS shortened,
	tags->'railway:signal:speed_limit:repeated' AS repeated,
	tags->'railway:signal:speed_limit:speed' AS speed,
	tags->'railway:signal:speed_limit:turn_direction' AS turn_direction,
	tags->'railway:signal:speed_limit:type' AS type,
	tags->'railway:signal:speed_limit:caption' AS caption,
	tags->'railway:signal:speed_limit:twice' AS twice,
	tags->'railway:signal:speed_limit:only_transit' AS only_transit,
	tags->'railway:signal:speed_limit:frequency' AS frequency,
	tags->'railway:signal:speed_limit:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:speed_limit'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'speed_limit_distant' AS category,
	tags->'railway:signal:speed_limit_distant' AS signal,
	tags->'railway:signal:speed_limit_distant:form' AS form,
	tags->'railway:signal:speed_limit_distant:height' AS height,
	tags->'railway:signal:speed_limit_distant:deactivated' AS deactivated,
	tags->'railway:signal:speed_limit_distant:states' AS states,
	tags->'railway:signal:speed_limit_distant:function' AS function,
	tags->'railway:signal:speed_limit_distant:substitute_signal' AS substitute_signal,
	tags->'railway:signal:speed_limit_distant:shortened' AS shortened,
	tags->'railway:signal:speed_limit_distant:repeated' AS repeated,
	tags->'railway:signal:speed_limit_distant:speed' AS speed,
	tags->'railway:signal:speed_limit_distant:turn_direction' AS turn_direction,
	tags->'railway:signal:speed_limit_distant:type' AS type,
	tags->'railway:signal:speed_limit_distant:caption' AS caption,
	tags->'railway:signal:speed_limit_distant:twice' AS twice,
	tags->'railway:signal:speed_limit_distant:only_transit' AS only_transit,
	tags->'railway:signal:speed_limit_distant:frequency' AS frequency,
	tags->'railway:signal:speed_limit_distant:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:speed_limit_distant'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'shunting' AS category,
	tags->'railway:signal:shunting' AS signal,
	tags->'railway:signal:shunting:form' AS form,
	tags->'railway:signal:shunting:height' AS height,
	tags->'railway:signal:shunting:deactivated' AS deactivated,
	tags->'railway:signal:shunting:states' AS states,
	tags->'railway:signal:shunting:function' AS function,
	tags->'railway:signal:shunting:substitue_signal' AS substitute_signal,
	tags->'railway:signal:shunting:shortened' AS shortened,
	tags->'railway:signal:shunting:repeated' AS repeated,
	tags->'railway:signal:shunting:speed' AS speed,
	tags->'railway:signal:shunting:turn_direction' AS turn_direction,
	tags->'railway:signal:shunting:type' AS type,
	tags->'railway:signal:shunting:caption' AS caption,
	tags->'railway:signal:shunting:twice' AS twice,
	tags->'railway:signal:shunting:only_transit' AS only_transit,
	tags->'railway:signal:shunting:frequency' AS frequency,
	tags->'railway:signal:shunting:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:shunting'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'resetting_switch' AS category,
	tags->'railway:signal:resetting_switch' AS signal,
	tags->'railway:signal:resetting_switch:form' AS form,
	tags->'railway:signal:resetting_switch:height' AS height,
	tags->'railway:signal:resetting_switch:deactivated' AS deactivated,
	tags->'railway:signal:resetting_switch:states' AS states,
	tags->'railway:signal:resetting_switch:function' AS function,
	tags->'railway:signal:resetting_switch:substitute_signal' AS substitute_signal,
	tags->'railway:signal:resetting_switch:shortened' AS shortened,
	tags->'railway:signal:resetting_switch:repeated' AS repeated,
	tags->'railway:signal:resetting_switch:speed' AS speed,
	tags->'railway:signal:resetting_switch:turn_direction' AS turn_direction,
	tags->'railway:signal:resetting_switch:type' AS type,
	tags->'railway:signal:resetting_switch:caption' AS caption,
	tags->'railway:signal:resetting_switch:twice' AS twice,
	tags->'railway:signal:resetting_switch:only_transit' AS only_transit,
	tags->'railway:signal:resetting_switch:frequency' AS frequency,
	tags->'railway:signal:resetting_switch:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:resetting_switch'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'resetting_switch_distant' AS category,
	tags->'railway:signal:resetting_switch_distant' AS signal,
	tags->'railway:signal:resetting_switch_distant:form' AS form,
	tags->'railway:signal:resetting_switch_distant:height' AS height,
	tags->'railway:signal:resetting_switch_distant:deactivated' AS deactivated,
	tags->'railway:signal:resetting_switch_distant:states' AS states,
	tags->'railway:signal:resetting_switch_distant:function' AS function,
	tags->'railway:signal:resetting_switch_distant:substitute_signal' AS substitute_signal,
	tags->'railway:signal:resetting_switch_distant:shortened' AS shortened,
	tags->'railway:signal:resetting_switch_distant:repeated' AS repeated,
	tags->'railway:signal:resetting_switch_distant:speed' AS speed,
	tags->'railway:signal:resetting_switch_distant:turn_direction' AS turn_direction,
	tags->'railway:signal:resetting_switch_distant:type' AS type,
	tags->'railway:signal:resetting_switch_distant:caption' AS caption,
	tags->'railway:signal:resetting_switch_distant:twice' AS twice,
	tags->'railway:signal:resetting_switch_distant:only_transit' AS only_transit,
	tags->'railway:signal:resetting_switch_distant:frequency' AS frequency,
	tags->'railway:signal:resetting_switch_distant:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:resetting_switch_distant'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'crossing' AS category,
	tags->'railway:signal:crossing' AS signal,
	tags->'railway:signal:crossing:form' AS form,
	tags->'railway:signal:crossing:height' AS height,
	tags->'railway:signal:crossing:deactivated' AS deactivated,
	tags->'railway:signal:crossing:states' AS states,
	tags->'railway:signal:crossing:function' AS function,
	tags->'railway:signal:crossing:substitute_signal' AS substitute_signal,
	tags->'railway:signal:crossing:shortened' AS shortened,
	tags->'railway:signal:crossing:repeated' AS repeated,
	tags->'railway:signal:crossing:speed' AS speed,
	tags->'railway:signal:crossing:turn_direction' AS turn_direction,
	tags->'railway:signal:crossing:type' AS type,
	tags->'railway:signal:crossing:caption' AS caption,
	tags->'railway:signal:crossing:twice' AS twice,
	tags->'railway:signal:crossing:only_transit' AS only_transit,
	tags->'railway:signal:crossing:frequency' AS frequency,
	tags->'railway:signal:crossing:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:crossing'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'crossing_distant' AS category,
	tags->'railway:signal:crossing_distant' AS signal,
	tags->'railway:signal:crossing_distant:form' AS form,
	tags->'railway:signal:crossing_distant:height' AS height,
	tags->'railway:signal:crossing_distant:deactivated' AS deactivated,
	tags->'railway:signal:crossing_distant:states' AS states,
	tags->'railway:signal:crossing_distant:function' AS function,
	tags->'railway:signal:crossing_distant:substitute_signal' AS substitute_signal,
	tags->'railway:signal:crossing_distant:shortened' AS shortened,
	tags->'railway:signal:crossing_distant:repeated' AS repeated,
	tags->'railway:signal:crossing_distant:speed' AS speed,
	tags->'railway:signal:crossing_distant:turn_direction' AS turn_direction,
	tags->'railway:signal:crossing_distant:type' AS type,
	tags->'railway:signal:crossing_distant:caption' AS caption,
	tags->'railway:signal:crossing_distant:twice' AS twice,
	tags->'railway:signal:crossing_distant:only_transit' AS only_transit,
	tags->'railway:signal:crossing_distant:frequency' AS frequency,
	tags->'railway:signal:crossing_distant:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:crossing_distant'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'route' AS category,
	tags->'railway:signal:route' AS signal,
	tags->'railway:signal:route:form' AS form,
	tags->'railway:signal:route:height' AS height,
	tags->'railway:signal:route:deactivated' AS deactivated,
	tags->'railway:signal:route:states' AS states,
	tags->'railway:signal:route:function' AS function,
	tags->'railway:signal:route:substitute_signal' AS substitute_signal,
	tags->'railway:signal:route:shortened' AS shortened,
	tags->'railway:signal:route:repeated' AS repeated,
	tags->'railway:signal:route:speed' AS speed,
	tags->'railway:signal:route:turn_direction' AS turn_direction,
	tags->'railway:signal:route:type' AS type,
	tags->'railway:signal:route:caption' AS caption,
	tags->'railway:signal:route:twice' AS twice,
	tags->'railway:signal:route:only_transit' AS only_transit,
	tags->'railway:signal:route:frequency' AS frequency,
	tags->'railway:signal:route:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:route'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'route_distant' AS category,
	tags->'railway:signal:route_distant' AS signal,
	tags->'railway:signal:route_distant:form' AS form,
	tags->'railway:signal:route_distant:height' AS height,
	tags->'railway:signal:route_distant:deactivated' AS deactivated,
	tags->'railway:signal:route_distant:states' AS states,
	tags->'railway:signal:route_distant:function' AS function,
	tags->'railway:signal:route_distant:substitute_signal' AS substitute_signal,
	tags->'railway:signal:route_distant:shortened' AS shortened,
	tags->'railway:signal:route_distant:repeated' AS repeated,
	tags->'railway:signal:route_distant:speed' AS speed,
	tags->'railway:signal:route_distant:turn_direction' AS turn_direction,
	tags->'railway:signal:route_distant:type' AS type,
	tags->'railway:signal:route_distant:caption' AS caption,
	tags->'railway:signal:route_distant:twice' AS twice,
	tags->'railway:signal:route_distant:only_transit' AS only_transit,
	tags->'railway:signal:route_distant:frequency' AS frequency,
	tags->'railway:signal:route_distant:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:route_distant'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'humping' AS category,
	tags->'railway:signal:humping' AS signal,
	tags->'railway:signal:humping:form' AS form,
	tags->'railway:signal:humping:height' AS height,
	tags->'railway:signal:humping:deactivated' AS deactivated,
	tags->'railway:signal:humping:states' AS states,
	tags->'railway:signal:humping:function' AS function,
	tags->'railway:signal:humping:substitute_signal' AS substitute_signal,
	tags->'railway:signal:humping:shortened' AS shortened,
	tags->'railway:signal:humping:repeated' AS repeated,
	tags->'railway:signal:humping:speed' AS speed,
	tags->'railway:signal:humping:turn_direction' AS turn_direction,
	tags->'railway:signal:humping:type' AS type,
	tags->'railway:signal:humping:caption' AS caption,
	tags->'railway:signal:humping:twice' AS twice,
	tags->'railway:signal:humping:only_transit' AS only_transit,
	tags->'railway:signal:humping:frequency' AS frequency,
	tags->'railway:signal:humping:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:humping'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'departure' AS category,
	tags->'railway:signal:departure' AS signal,
	tags->'railway:signal:departure:form' AS form,
	tags->'railway:signal:departure:height' AS height,
	tags->'railway:signal:departure:deactivated' AS deactivated,
	tags->'railway:signal:departure:states' AS states,
	tags->'railway:signal:departure:function' AS function,
	tags->'railway:signal:departure:substitute_signal' AS substitute_signal,
	tags->'railway:signal:departure:shortened' AS shortened,
	tags->'railway:signal:departure:repeated' AS repeated,
	tags->'railway:signal:departure:speed' AS speed,
	tags->'railway:signal:departure:turn_direction' AS turn_direction,
	tags->'railway:signal:departure:type' AS type,
	tags->'railway:signal:departure:caption' AS caption,
	tags->'railway:signal:departure:twice' AS twice,
	tags->'railway:signal:departure:only_transit' AS only_transit,
	tags->'railway:signal:departure:frequency' AS frequency,
	tags->'railway:signal:departure:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:departure'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'brake_test' AS category,
	tags->'railway:signal:brake_test' AS signal,
	tags->'railway:signal:brake_test:form' AS form,
	tags->'railway:signal:brake_test:height' AS height,
	tags->'railway:signal:brake_test:deactivated' AS deactivated,
	tags->'railway:signal:brake_test:states' AS states,
	tags->'railway:signal:brake_test:function' AS function,
	tags->'railway:signal:brake_test:substitute_signal' AS substitute_signal,
	tags->'railway:signal:brake_test:shortened' AS shortened,
	tags->'railway:signal:brake_test:repeated' AS repeated,
	tags->'railway:signal:brake_test:speed' AS speed,
	tags->'railway:signal:brake_test:turn_direction' AS turn_direction,
	tags->'railway:signal:brake_test:type' AS type,
	tags->'railway:signal:brake_test:caption' AS caption,
	tags->'railway:signal:brake_test:twice' AS twice,
	tags->'railway:signal:brake_test:only_transit' AS only_transit,
	tags->'railway:signal:brake_test:frequency' AS frequency,
	tags->'railway:signal:brake_test:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:brake_test'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'snowplow' AS category,
	tags->'railway:signal:snowplow' AS signal,
	tags->'railway:signal:snowplow:form' AS form,
	tags->'railway:signal:snowplow:height' AS height,
	tags->'railway:signal:snowplow:deactivated' AS deactivated,
	tags->'railway:signal:snowplow:states' AS states,
	tags->'railway:signal:snowplow:function' AS function,
	tags->'railway:signal:snowplow:substitute_signal' AS substitute_signal,
	tags->'railway:signal:snowplow:shortened' AS shortened,
	tags->'railway:signal:snowplow:repeated' AS repeated,
	tags->'railway:signal:snowplow:speed' AS speed,
	tags->'railway:signal:snowplow:turn_direction' AS turn_direction,
	tags->'railway:signal:snowplow:type' AS type,
	tags->'railway:signal:snowplow:caption' AS caption,
	tags->'railway:signal:snowplow:twice' AS twice,
	tags->'railway:signal:snowplow:only_transit' AS only_transit,
	tags->'railway:signal:snowplow:frequency' AS frequency,
	tags->'railway:signal:snowplow:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:snowplow'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'fouling_point' AS category,
	tags->'railway:signal:fouling_point' AS signal,
	tags->'railway:signal:fouling_point:form' AS form,
	tags->'railway:signal:fouling_point:height' AS height,
	tags->'railway:signal:fouling_point:deactivated' AS deactivated,
	tags->'railway:signal:fouling_point:states' AS states,
	tags->'railway:signal:fouling_point:function' AS function,
	tags->'railway:signal:fouling_point:substitute_signal' AS substitute_signal,
	tags->'railway:signal:fouling_point:shortened' AS shortened,
	tags->'railway:signal:fouling_point:repeated' AS repeated,
	tags->'railway:signal:fouling_point:speed' AS speed,
	tags->'railway:signal:fouling_point:turn_direction' AS turn_direction,
	tags->'railway:signal:fouling_point:type' AS type,
	tags->'railway:signal:fouling_point:caption' AS caption,
	tags->'railway:signal:fouling_point:twice' AS twice,
	tags->'railway:signal:fouling_point:only_transit' AS only_transit,
	tags->'railway:signal:fouling_point:frequency' AS frequency,
	tags->'railway:signal:fouling_point:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:fouling_point'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'switch' AS category,
	tags->'railway:signal:switch' AS signal,
	tags->'railway:signal:switch:form' AS form,
	tags->'railway:signal:switch:height' AS height,
	tags->'railway:signal:switch:deactivated' AS deactivated,
	tags->'railway:signal:switch:states' AS states,
	tags->'railway:signal:switch:function' AS function,
	tags->'railway:signal:switch:substitute_signal' AS substitute_signal,
	tags->'railway:signal:switch:shortened' AS shortened,
	tags->'railway:signal:switch:repeated' AS repeated,
	tags->'railway:signal:switch:speed' AS speed,
	tags->'railway:signal:switch:turn_direction' AS turn_direction,
	tags->'railway:signal:switch:type' AS type,
	tags->'railway:signal:switch:caption' AS caption,
	tags->'railway:signal:switch:twice' AS twice,
	tags->'railway:signal:switch:only_transit' AS only_transit,
	tags->'railway:signal:switch:frequency' AS frequency,
	tags->'railway:signal:switch:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:switch'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'helper_engine' AS category,
	tags->'railway:signal:helper_engine' AS signal,
	tags->'railway:signal:helper_engine:form' AS form,
	tags->'railway:signal:helper_engine:height' AS height,
	tags->'railway:signal:helper_engine:deactivated' AS deactivated,
	tags->'railway:signal:helper_engine:states' AS states,
	tags->'railway:signal:helper_engine:function' AS function,
	tags->'railway:signal:helper_engine:substitute_signal' AS substitute_signal,
	tags->'railway:signal:helper_engine:shortened' AS shortened,
	tags->'railway:signal:helper_engine:repeated' AS repeated,
	tags->'railway:signal:helper_engine:speed' AS speed,
	tags->'railway:signal:helper_engine:turn_direction' AS turn_direction,
	tags->'railway:signal:helper_engine:type' AS type,
	tags->'railway:signal:helper_engine:caption' AS caption,
	tags->'railway:signal:helper_engine:twice' AS twice,
	tags->'railway:signal:helper_engine:only_transit' AS only_transit,
	tags->'railway:signal:helper_engine:frequency' AS frequency,
	tags->'railway:signal:helper_engine:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:helper_engine'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'wrong_road' AS category,
	tags->'railway:signal:wrong_road' AS signal,
	tags->'railway:signal:wrong_road:form' AS form,
	tags->'railway:signal:wrong_road:height' AS height,
	tags->'railway:signal:wrong_road:deactivated' AS deactivated,
	tags->'railway:signal:wrong_road:states' AS states,
	tags->'railway:signal:wrong_road:function' AS function,
	tags->'railway:signal:wrong_road:substitute_signal' AS substitute_signal,
	tags->'railway:signal:wrong_road:shortened' AS shortened,
	tags->'railway:signal:wrong_road:repeated' AS repeated,
	tags->'railway:signal:wrong_road:speed' AS speed,
	tags->'railway:signal:wrong_road:turn_direction' AS turn_direction,
	tags->'railway:signal:wrong_road:type' AS type,
	tags->'railway:signal:wrong_road:caption' AS caption,
	tags->'railway:signal:wrong_road:twice' AS twice,
	tags->'railway:signal:wrong_road:only_transit' AS only_transit,
	tags->'railway:signal:wrong_road:frequency' AS frequency,
	tags->'railway:signal:wrong_road:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:wrong_road'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'short_route' AS category,
	tags->'railway:signal:short_route' AS signal,
	tags->'railway:signal:short_route:form' AS form,
	tags->'railway:signal:short_route:height' AS height,
	tags->'railway:signal:short_route:deactivated' AS deactivated,
	tags->'railway:signal:short_route:states' AS states,
	tags->'railway:signal:short_route:function' AS function,
	tags->'railway:signal:short_route:substitute_signal' AS substitute_signal,
	tags->'railway:signal:short_route:shortened' AS shortened,
	tags->'railway:signal:short_route:repeated' AS repeated,
	tags->'railway:signal:short_route:speed' AS speed,
	tags->'railway:signal:short_route:turn_direction' AS turn_direction,
	tags->'railway:signal:short_route:type' AS type,
	tags->'railway:signal:short_route:caption' AS caption,
	tags->'railway:signal:short_route:twice' AS twice,
	tags->'railway:signal:short_route:only_transit' AS only_transit,
	tags->'railway:signal:short_route:frequency' AS frequency,
	tags->'railway:signal:short_route:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:short_route'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'main_repeated' AS category,
	tags->'railway:signal:main_repeated' AS signal,
	tags->'railway:signal:main_repeated:form' AS form,
	tags->'railway:signal:main_repeated:height' AS height,
	tags->'railway:signal:main_repeated:deactivated' AS deactivated,
	tags->'railway:signal:main_repeated:states' AS states,
	tags->'railway:signal:main_repeated:function' AS function,
	tags->'railway:signal:main_repeated:substitute_signal' AS substitute_signal,
	tags->'railway:signal:main_repeated:shortened' AS shortened,
	tags->'railway:signal:main_repeated:repeated' AS repeated,
	tags->'railway:signal:main_repeated:speed' AS speed,
	tags->'railway:signal:main_repeated:turn_direction' AS turn_direction,
	tags->'railway:signal:main_repeated:type' AS type,
	tags->'railway:signal:main_repeated:caption' AS caption,
	tags->'railway:signal:main_repeated:twice' AS twice,
	tags->'railway:signal:main_repeated:only_transit' AS only_transit,
	tags->'railway:signal:main_repeated:frequency' AS frequency,
	tags->'railway:signal:main_repeated:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:main_repeated'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'loading_gauge' AS category,
	tags->'railway:signal:loading_gauge' AS signal,
	tags->'railway:signal:loading_gauge:form' AS form,
	tags->'railway:signal:loading_gauge:height' AS height,
	tags->'railway:signal:loading_gauge:deactivated' AS deactivated,
	tags->'railway:signal:loading_gauge:states' AS states,
	tags->'railway:signal:loading_gauge:function' AS function,
	tags->'railway:signal:loading_gauge:substitute_signal' AS substitute_signal,
	tags->'railway:signal:loading_gauge:shortened' AS shortened,
	tags->'railway:signal:loading_gauge:repeated' AS repeated,
	tags->'railway:signal:loading_gauge:speed' AS speed,
	tags->'railway:signal:loading_gauge:turn_direction' AS turn_direction,
	tags->'railway:signal:loading_gauge:type' AS type,
	tags->'railway:signal:loading_gauge:caption' AS caption,
	tags->'railway:signal:loading_gauge:twice' AS twice,
	tags->'railway:signal:loading_gauge:only_transit' AS only_transit,
	tags->'railway:signal:loading_gauge:frequency' AS frequency,
	tags->'railway:signal:loading_gauge:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:loading_gauge'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'station_distant' AS category,
	tags->'railway:signal:station_distant' AS signal,
	tags->'railway:signal:station_distant:form' AS form,
	tags->'railway:signal:station_distant:height' AS height,
	tags->'railway:signal:station_distant:deactivated' AS deactivated,
	tags->'railway:signal:station_distant:states' AS states,
	tags->'railway:signal:station_distant:function' AS function,
	tags->'railway:signal:station_distant:substitute_signal' AS substitute_signal,
	tags->'railway:signal:station_distant:shortened' AS shortened,
	tags->'railway:signal:station_distant:repeated' AS repeated,
	tags->'railway:signal:station_distant:speed' AS speed,
	tags->'railway:signal:station_distant:turn_direction' AS turn_direction,
	tags->'railway:signal:station_distant:type' AS type,
	tags->'railway:signal:station_distant:caption' AS caption,
	tags->'railway:signal:station_distant:twice' AS twice,
	tags->'railway:signal:station_distant:only_transit' AS only_transit,
	tags->'railway:signal:station_distant:frequency' AS frequency,
	tags->'railway:signal:station_distant:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:station_distant'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'train_protection' AS category,
	tags->'railway:signal:train_protection' AS signal,
	tags->'railway:signal:train_protection:form' AS form,
	tags->'railway:signal:train_protection:height' AS height,
	tags->'railway:signal:train_protection:deactivated' AS deactivated,
	tags->'railway:signal:train_protection:states' AS states,
	tags->'railway:signal:train_protection:function' AS function,
	tags->'railway:signal:train_protection:substitute_signal' AS substitute_signal,
	tags->'railway:signal:train_protection:shortened' AS shortened,
	tags->'railway:signal:train_protection:repeated' AS repeated,
	tags->'railway:signal:train_protection:speed' AS speed,
	tags->'railway:signal:train_protection:turn_direction' AS turn_direction,
	tags->'railway:signal:train_protection:type' AS type,
	tags->'railway:signal:train_protection:caption' AS caption,
	tags->'railway:signal:train_protection:twice' AS twice,
	tags->'railway:signal:train_protection:only_transit' AS only_transit,
	tags->'railway:signal:train_protection:frequency' AS frequency,
	tags->'railway:signal:train_protection:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:train_protection'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'stop' AS category,
	tags->'railway:signal:stop' AS signal,
	tags->'railway:signal:stop:form' AS form,
	tags->'railway:signal:stop:height' AS height,
	tags->'railway:signal:stop:deactivated' AS deactivated,
	tags->'railway:signal:stop:states' AS states,
	tags->'railway:signal:stop:function' AS function,
	tags->'railway:signal:stop:substitute_signal' AS substitute_signal,
	tags->'railway:signal:stop:shortened' AS shortened,
	tags->'railway:signal:stop:repeated' AS repeated,
	tags->'railway:signal:stop:speed' AS speed,
	tags->'railway:signal:stop:turn_direction' AS turn_direction,
	tags->'railway:signal:stop:type' AS type,
	tags->'railway:signal:stop:caption' AS caption,
	tags->'railway:signal:stop:twice' AS twice,
	tags->'railway:signal:stop:only_transit' AS only_transit,
	tags->'railway:signal:stop:frequency' AS frequency,
	tags->'railway:signal:stop:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:stop'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'stop_demand' AS category,
	tags->'railway:signal:stop_demand' AS signal,
	tags->'railway:signal:stop_demand:form' AS form,
	tags->'railway:signal:stop_demand:height' AS height,
	tags->'railway:signal:stop_demand:deactivated' AS deactivated,
	tags->'railway:signal:stop_demand:states' AS states,
	tags->'railway:signal:stop_demand:function' AS function,
	tags->'railway:signal:stop_demand:substitute_signal' AS substitute_signal,
	tags->'railway:signal:stop_demand:shortened' AS shortened,
	tags->'railway:signal:stop_demand:repeated' AS repeated,
	tags->'railway:signal:stop_demand:speed' AS speed,
	tags->'railway:signal:stop_demand:turn_direction' AS turn_direction,
	tags->'railway:signal:stop_demand:type' AS type,
	tags->'railway:signal:stop_demand:caption' AS caption,
	tags->'railway:signal:stop_demand:twice' AS twice,
	tags->'railway:signal:stop_demand:only_transit' AS only_transit,
	tags->'railway:signal:stop_demand:frequency' AS frequency,
	tags->'railway:signal:stop_demand:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:stop_demand'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'crossing_info' AS category,
	tags->'railway:signal:crossing_info' AS signal,
	tags->'railway:signal:crossing_info:form' AS form,
	tags->'railway:signal:crossing_info:height' AS height,
	tags->'railway:signal:crossing_info:deactivated' AS deactivated,
	tags->'railway:signal:crossing_info:states' AS states,
	tags->'railway:signal:crossing_info:function' AS function,
	tags->'railway:signal:crossing_info:substitute_signal' AS substitute_signal,
	tags->'railway:signal:crossing_info:shortened' AS shortened,
	tags->'railway:signal:crossing_info:repeated' AS repeated,
	tags->'railway:signal:crossing_info:speed' AS speed,
	tags->'railway:signal:crossing_info:turn_direction' AS turn_direction,
	tags->'railway:signal:crossing_info:type' AS type,
	tags->'railway:signal:crossing_info:caption' AS caption,
	tags->'railway:signal:crossing_info:twice' AS twice,
	tags->'railway:signal:crossing_info:only_transit' AS only_transit,
	tags->'railway:signal:crossing_info:frequency' AS frequency,
	tags->'railway:signal:crossing_info:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:crossing_info'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'crossing_hint' AS category,
	tags->'railway:signal:crossing_hint' AS signal,
	tags->'railway:signal:crossing_hint:form' AS form,
	tags->'railway:signal:crossing_hint:height' AS height,
	tags->'railway:signal:crossing_hint:deactivated' AS deactivated,
	tags->'railway:signal:crossing_hint:states' AS states,
	tags->'railway:signal:crossing_hint:function' AS function,
	tags->'railway:signal:crossing_hint:substitute_signal' AS substitute_signal,
	tags->'railway:signal:crossing_hint:shortened' AS shortened,
	tags->'railway:signal:crossing_hint:repeated' AS repeated,
	tags->'railway:signal:crossing_hint:speed' AS speed,
	tags->'railway:signal:crossing_hint:turn_direction' AS turn_direction,
	tags->'railway:signal:crossing_hint:type' AS type,
	tags->'railway:signal:crossing_hint:caption' AS caption,
	tags->'railway:signal:crossing_hint:twice' AS twice,
	tags->'railway:signal:crossing_hint:only_transit' AS only_transit,
	tags->'railway:signal:crossing_hint:frequency' AS frequency,
	tags->'railway:signal:crossing_hint:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:crossing_hint'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'request' AS category,
	tags->'railway:signal:request' AS signal,
	tags->'railway:signal:request:form' AS form,
	tags->'railway:signal:request:height' AS height,
	tags->'railway:signal:request:deactivated' AS deactivated,
	tags->'railway:signal:request:states' AS states,
	tags->'railway:signal:request:function' AS function,
	tags->'railway:signal:request:substitute_signal' AS substitute_signal,
	tags->'railway:signal:request:shortened' AS shortened,
	tags->'railway:signal:request:repeated' AS repeated,
	tags->'railway:signal:request:speed' AS speed,
	tags->'railway:signal:request:turn_direction' AS turn_direction,
	tags->'railway:signal:request:type' AS type,
	tags->'railway:signal:request:caption' AS caption,
	tags->'railway:signal:request:twice' AS twice,
	tags->'railway:signal:request:only_transit' AS only_transit,
	tags->'railway:signal:request:frequency' AS frequency,
	tags->'railway:signal:request:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:request'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'whistle' AS category,
	tags->'railway:signal:whistle' AS signal,
	tags->'railway:signal:whistle:form' AS form,
	tags->'railway:signal:whistle:height' AS height,
	tags->'railway:signal:whistle:deactivated' AS deactivated,
	tags->'railway:signal:whistle:states' AS states,
	tags->'railway:signal:whistle:function' AS function,
	tags->'railway:signal:whistle:substitute_signal' AS substitute_signal,
	tags->'railway:signal:whistle:shortened' AS shortened,
	tags->'railway:signal:whistle:repeated' AS repeated,
	tags->'railway:signal:whistle:speed' AS speed,
	tags->'railway:signal:whistle:turn_direction' AS turn_direction,
	tags->'railway:signal:whistle:type' AS type,
	tags->'railway:signal:whistle:caption' AS caption,
	tags->'railway:signal:whistle:twice' AS twice,
	tags->'railway:signal:whistle:only_transit' AS only_transit,
	tags->'railway:signal:whistle:frequency' AS frequency,
	tags->'railway:signal:whistle:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:whistle'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'ring' AS category,
	tags->'railway:signal:ring' AS signal,
	tags->'railway:signal:ring:form' AS form,
	tags->'railway:signal:ring:height' AS height,
	tags->'railway:signal:ring:deactivated' AS deactivated,
	tags->'railway:signal:ring:states' AS states,
	tags->'railway:signal:ring:function' AS function,
	tags->'railway:signal:ring:substitute_signal' AS substitute_signal,
	tags->'railway:signal:ring:shortened' AS shortened,
	tags->'railway:signal:ring:repeated' AS repeated,
	tags->'railway:signal:ring:speed' AS speed,
	tags->'railway:signal:ring:turn_direction' AS turn_direction,
	tags->'railway:signal:ring:type' AS type,
	tags->'railway:signal:ring:caption' AS caption,
	tags->'railway:signal:ring:twice' AS twice,
	tags->'railway:signal:ring:only_transit' AS only_transit,
	tags->'railway:signal:ring:frequency' AS frequency,
	tags->'railway:signal:ring:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:ring'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'passing' AS category,
	tags->'railway:signal:passing' AS signal,
	tags->'railway:signal:passing:form' AS form,
	tags->'railway:signal:passing:height' AS height,
	tags->'railway:signal:passing:deactivated' AS deactivated,
	tags->'railway:signal:passing:states' AS states,
	tags->'railway:signal:passing:function' AS function,
	tags->'railway:signal:passing:substitute_signal' AS substitute_signal,
	tags->'railway:signal:passing:shortened' AS shortened,
	tags->'railway:signal:passing:repeated' AS repeated,
	tags->'railway:signal:passing:speed' AS speed,
	tags->'railway:signal:passing:turn_direction' AS turn_direction,
	tags->'railway:signal:passing:type' AS type,
	tags->'railway:signal:passing:caption' AS caption,
	tags->'railway:signal:passing:twice' AS twice,
	tags->'railway:signal:passing:only_transit' AS only_transit,
	tags->'railway:signal:passing:frequency' AS frequency,
	tags->'railway:signal:passing:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:passing'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'expected_position' AS category,
	tags->'railway:signal:expected_position' AS signal,
	tags->'railway:signal:expected_position:form' AS form,
	tags->'railway:signal:expected_position:height' AS height,
	tags->'railway:signal:expected_position:deactivated' AS deactivated,
	tags->'railway:signal:expected_position:states' AS states,
	tags->'railway:signal:expected_position:function' AS function,
	tags->'railway:signal:expected_position:substitute_signal' AS substitute_signal,
	tags->'railway:signal:expected_position:shortened' AS shortened,
	tags->'railway:signal:expected_position:repeated' AS repeated,
	tags->'railway:signal:expected_position:speed' AS speed,
	tags->'railway:signal:expected_position:turn_direction' AS turn_direction,
	tags->'railway:signal:expected_position:type' AS type,
	tags->'railway:signal:expected_position:caption' AS caption,
	tags->'railway:signal:expected_position:twice' AS twice,
	tags->'railway:signal:expected_position:only_transit' AS only_transit,
	tags->'railway:signal:expected_position:frequency' AS frequency,
	tags->'railway:signal:expected_position:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:expected_position'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'electricity' AS category,
	tags->'railway:signal:electricity' AS signal,
	tags->'railway:signal:electricity:form' AS form,
	tags->'railway:signal:electricity:height' AS height,
	tags->'railway:signal:electricity:deactivated' AS deactivated,
	tags->'railway:signal:electricity:states' AS states,
	tags->'railway:signal:electricity:function' AS function,
	tags->'railway:signal:electricity:substitute_signal' AS substitute_signal,
	tags->'railway:signal:electricity:shortened' AS shortened,
	tags->'railway:signal:electricity:repeated' AS repeated,
	tags->'railway:signal:electricity:speed' AS speed,
	tags->'railway:signal:electricity:turn_direction' AS turn_direction,
	tags->'railway:signal:electricity:type' AS type,
	tags->'railway:signal:electricity:caption' AS caption,
	tags->'railway:signal:electricity:twice' AS twice,
	tags->'railway:signal:electricity:only_transit' AS only_transit,
	tags->'railway:signal:electricity:frequency' AS frequency,
	tags->'railway:signal:electricity:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:electricity'

UNION ALL

SELECT way AS geom,
	tags->'ref' AS ref,
	tags->'railway:signal:direction' AS direction,
	tags->'railway:signal:position' AS position,
	'radio' AS category,
	tags->'railway:signal:radio' AS signal,
	tags->'railway:signal:radio:form' AS form,
	tags->'railway:signal:radio:height' AS height,
	tags->'railway:signal:radio:deactivated' AS deactivated,
	tags->'railway:signal:radio:states' AS states,
	tags->'railway:signal:radio:function' AS function,
	tags->'railway:signal:radio:substitute_signal' AS substitute_signal,
	tags->'railway:signal:radio:shortened' AS shortened,
	tags->'railway:signal:radio:repeated' AS repeated,
	tags->'railway:signal:radio:speed' AS speed,
	tags->'railway:signal:radio:turn_direction' AS turn_direction,
	tags->'railway:signal:radio:type' AS type,
	tags->'railway:signal:radio:caption' AS caption,
	tags->'railway:signal:radio:twice' AS twice,
	tags->'railway:signal:radio:only_transit' AS only_transit,
	tags->'railway:signal:radio:frequency' AS frequency,
	tags->'railway:signal:radio:voltage' AS voltage
FROM openrailwaymap_point
WHERE tags->'railway' = 'signal'
	AND tags ? 'railway:signal:radio';


CREATE OR REPLACE VIEW layers.services AS
SELECT way AS geom,
	CASE
		WHEN tags->'railway' = 'radio' AND tags->'man_made' = 'mast' THEN 'radio_mast'
		WHEN tags->'railway' = 'radio' AND tags->'man_made' = 'tower' THEN 'radio_tower'
		WHEN tags->'railway' = 'radio' AND tags->'man_made' = 'antenna' THEN 'radio_antenna'
		ELSE tags->'railway'
	END AS type,
	tags->'operator' AS operator,
	tags->'operator:short' AS operator_short,
	tags->'name' AS name,
	tags->'ref' AS ref
FROM openrailwaymap_point
WHERE tags->'railway' = 'water_crane'
	OR tags->'railway' = 'pit'
	OR tags->'railway' = 'fuel'
	OR tags->'railway' = 'wash'
	OR tags->'railway' = 'coaling_facility'
	OR tags->'railway' = 'water_tower'
	OR tags->'railway' = 'engine_shed'
	OR tags->'railway' = 'workshop'
	OR tags->'railway' = 'carrier_truck_pit'
	OR tags->'railway' = 'track_scale'
	OR tags->'railway' = 'loading_gauge'
	OR tags->'railway' = 'turntable'
	OR tags->'railway' = 'traverser'
	OR tags->'railway' = 'hump_yard'
	OR tags->'railway' = 'rail_brake'
	OR tags->'railway' = 'gauge_conversion'
	OR tags->'railway' = 'car_shuttle'
	OR tags->'railway' = 'loading_ramp'
	OR tags->'railway' = 'rolling_highway'
	OR tags->'railway' = 'phone'
	OR tags->'railway' = 'radio'

UNION ALL

SELECT way AS geom,
	tags->'railway' AS type,
	tags->'operator' AS operator,
	tags->'operator:short' AS operator_short,
	tags->'name' AS name,
	tags->'ref' AS ref
FROM openrailwaymap_polygon
WHERE tags->'railway' = 'pit'
	OR tags->'railway' = 'fuel'
	OR tags->'railway' = 'wash'
	OR tags->'railway' = 'coaling_facility'
	OR tags->'railway' = 'water_tower'
	OR tags->'railway' = 'engine_shed'
	OR tags->'railway' = 'workshop'
	OR tags->'railway' = 'carrier_truck_pit'
	OR tags->'railway' = 'turntable'
	OR tags->'railway' = 'traverser'
	OR tags->'railway' = 'hump_yard'
	OR tags->'railway' = 'rail_brake'
	OR tags->'railway' = 'gauge_conversion'
	OR tags->'railway' = 'car_shuttle'
	OR tags->'railway' = 'loading_ramp'
	OR tags->'railway' = 'rolling_highway';


CREATE OR REPLACE VIEW layers.landuses AS
SELECT way AS geom
FROM openrailwaymap_polygon
WHERE tags->'landuse' = 'railway';


CREATE OR REPLACE VIEW layers.buildings AS
SELECT way AS geom,
	tags->'ele' AS ele,
	CASE
		WHEN tags->'building' = 'train_station' THEN 'station_building'
		WHEN tags->'railway' = 'signal_box' AND tags ? 'building' THEN 'signal_box'
		ELSE tags->'railway'
	END AS type
FROM openrailwaymap_polygon
WHERE tags->'building' = 'train_station'
	OR tags ? 'railway';


CREATE OR REPLACE VIEW layers.operating_points AS
SELECT way AS geom,
	'active' AS status,
	tags->'railway' AS type,
	tags->'station' AS station,
	tags->'name' AS name,
	tags->'ele' AS ele,
	tags->'operator' AS operator,
	tags->'operator:short' AS operator_short,
	tags->'uic_ref' AS uic_ref,
	tags->'uic_name' AS uic_name,
	tags->'railway:ref' AS code,
	tags->'ref:IFOPT' AS ifopt
FROM openrailwaymap_point
WHERE tags->'railway' IN ('station', 'halt', 'tram_stop', 'yard', 'service_station', 'junction', 'crossover', 'spur_junction', 'site', 'owner_change', 'border')

UNION ALL

SELECT way AS geom,
	'disused' AS status,
	tags->'disused:railway' AS type,
	tags->'disused:station' AS station,
	tags->'disused:name' AS name,
	tags->'ele' AS ele,
	tags->'disused:operator' AS operator,
	tags->'disused:operator:short' AS operator_short,
	tags->'disused:uic_ref' AS uic_ref,
	tags->'disused:uic_name' AS uic_name,
	tags->'disused:railway:ref' AS code,
	tags->'disused:ref:IFOPT' AS ifopt
FROM openrailwaymap_point
WHERE tags->'disused:railway' IN ('station', 'halt', 'tram_stop', 'yard', 'service_station', 'junction', 'crossover', 'spur_junction', 'site', 'owner_change', 'border')

UNION ALL

SELECT way AS geom,
	'abandoned' AS status,
	tags->'abandoned:railway' AS type,
	tags->'abandoned:station' AS station,
	tags->'abandoned:name' AS name,
	tags->'ele' AS ele,
	tags->'abandoned:operator' AS operator,
	tags->'abandoned:operator:short' AS operator_short,
	tags->'abandoned:uic_ref' AS uic_ref,
	tags->'abandoned:uic_name' AS uic_name,
	tags->'abandoned:railway:ref' AS code,
	tags->'abandoned:ref:IFOPT' AS ifopt
FROM openrailwaymap_point
WHERE tags->'abandoned:railway' IN ('station', 'halt', 'tram_stop', 'yard', 'service_station', 'junction', 'crossover', 'spur_junction', 'site', 'owner_change', 'border')

UNION ALL

SELECT way AS geom,
	'razed' AS status,
	tags->'razed:railway' AS type,
	tags->'razed:station' AS station,
	tags->'razed:name' AS name,
	tags->'ele' AS ele,
	tags->'razed:operator' AS operator,
	tags->'razed:operator:short' AS operator_short,
	tags->'razed:uic_ref' AS uic_ref,
	tags->'razed:uic_name' AS uic_name,
	tags->'razed:railway:ref' AS code,
	tags->'razed:ref:IFOPT' AS ifopt
FROM openrailwaymap_point
WHERE tags->'razed:railway' IN ('station', 'halt', 'tram_stop', 'yard', 'service_station', 'junction', 'crossover', 'spur_junction', 'site', 'owner_change', 'border')

UNION ALL

SELECT way AS geom,
	'construction' AS status,
	tags->'construction:railway' AS type,
	tags->'construction:station' AS station,
	tags->'construction:name' AS name,
	tags->'ele' AS ele,
	tags->'construction:operator' AS operator,
	tags->'construction:operator:short' AS operator_short,
	tags->'construction:uic_ref' AS uic_ref,
	tags->'construction:uic_name' AS uic_name,
	tags->'construction:railway:ref' AS code,
	tags->'construction:ref:IFOPT' AS ifopt
FROM openrailwaymap_point
WHERE tags->'construction:railway' IN ('station', 'halt', 'tram_stop', 'yard', 'service_station', 'junction', 'crossover', 'spur_junction', 'site', 'owner_change', 'border')

UNION ALL

SELECT way AS geom,
	'proposed' AS status,
	tags->'proposed:railway' AS type,
	tags->'proposed:station' AS station,
	tags->'proposed:name' AS name,
	tags->'ele' AS ele,
	tags->'proposed:operator' AS operator,
	tags->'proposed:operator:short' AS operator_short,
	tags->'proposed:uic_ref' AS uic_ref,
	tags->'proposed:uic_name' AS uic_name,
	tags->'proposed:railway:ref' AS code,
	tags->'proposed:ref:IFOPT' AS ifopt
FROM openrailwaymap_point
WHERE tags->'proposed:railway' IN ('station', 'halt', 'tram_stop', 'yard', 'service_station', 'junction', 'crossover', 'spur_junction', 'site', 'owner_change', 'border')
