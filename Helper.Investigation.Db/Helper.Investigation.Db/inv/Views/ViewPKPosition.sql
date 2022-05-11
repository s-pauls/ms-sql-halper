﻿CREATE VIEW [inv].[ViewPKPosition]
AS 
	SELECT 
		KCU.CONSTRAINT_NAME,
		KCU.TABLE_SCHEMA, 
		KCU.TABLE_NAME,
		STRING_AGG(KCU.COLUMN_NAME, ', ') COLUMN_NAMES,
		MIN(c.column_id) AS COLUMN_ORDER_POSITION
	FROM  
		INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU
	JOIN
		sys.schemas s ON s.name = kcu.TABLE_SCHEMA
	JOIN
		sys.tables t ON t.name = kcu.TABLE_NAME AND t.schema_id = s.schema_id
	JOIN 
		sys.columns c ON c.object_id = t.object_id AND c.name = KCU.COLUMN_NAME
	WHERE 
		KCU.CONSTRAINT_NAME like 'PK_%'
	GROUP BY 
		KCU.CONSTRAINT_NAME,
		KCU.TABLE_SCHEMA,
		KCU.TABLE_NAME
