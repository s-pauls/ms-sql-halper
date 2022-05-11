CREATE FUNCTION [inv].[GetColumnType]
(
	@schema_name VARCHAR(100),
	@table_name VARCHAR(100),
	@column_name VARCHAR(100)
)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE
		@column_type VARCHAR(100)
	
	SELECT 
		@column_type=upper(tp.name) 		
	FROM 
		sys.columns c
	JOIN 
		sys.tables t ON c.object_id = t.object_id
	JOIN
		sys.schemas s ON s.schema_id = t.schema_id
	JOIN 
		sys.types tp ON tp.system_type_id = c.system_type_id
	WHERE 
		s.name = @schema_name
		AND t.name = @table_name
		AND c.name = @column_name

	RETURN @column_type
END
