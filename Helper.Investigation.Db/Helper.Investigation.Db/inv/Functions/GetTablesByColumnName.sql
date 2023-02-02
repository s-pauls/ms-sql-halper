CREATE FUNCTION [inv].[GetTablesByColumnName]
(
	@column_name VARCHAR(100)
)
RETURNS @returntable TABLE
(
	SchemaName VARCHAR(100),
	TableName VARCHAR(100),
	ColumnName VARCHAR(100),
	TypemName VARCHAR(100)
)
AS
BEGIN
	
	INSERT @returntable
		(SchemaName, TableName, ColumnName, TypemName)
	SELECT 
		s.name AS 'SchemaName',
		t.name AS 'TableName',
		c.name AS 'ColumnName',
		upper(tp.name) As 'TypemName'
	FROM 
		sys.columns c
	JOIN 
		sys.tables t ON c.object_id = t.object_id
	JOIN
		sys.schemas s ON s.schema_id = t.schema_id
	JOIN 
		sys.types tp ON tp.user_type_id  = c.user_type_id
	WHERE 
		c.name = @column_name

	RETURN
END
