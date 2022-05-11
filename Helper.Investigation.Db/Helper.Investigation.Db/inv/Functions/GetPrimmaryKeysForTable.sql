CREATE FUNCTION [inv].[GetPrimmaryKeysForTable]
(
	@shema_name VARCHAR(200),
	@table_name VARCHAR(200)
)
RETURNS @returntable TABLE
(
	CONSTRAINT_NAME VARCHAR(200),
	COLUMN_NAME VARCHAR(200)
)
AS
BEGIN
	INSERT @returntable (CONSTRAINT_NAME, COLUMN_NAME)

	SELECT 
		KCU.CONSTRAINT_NAME,
		KCU.COLUMN_NAME
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
		AND KCU.TABLE_SCHEMA = @shema_name
		AND KCU.TABLE_NAME = @table_name
	
	RETURN
END
