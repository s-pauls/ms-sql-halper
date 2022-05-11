CREATE PROCEDURE [inv].[GetForeinKeyInfo]
(
	@schema_name VARCHAR(100),
	@table_name VARCHAR(200),
	@column_name VARCHAR(200),
	@referenced_schema_name VARCHAR(100) OUTPUT,
	@referenced_table_name VARCHAR(200) OUTPUT,
	@referenced_column_name VARCHAR(200) OUTPUT
) 
AS
BEGIN

	SELECT
		@referenced_schema_name = ReferencedSchemaName,
		@referenced_table_name= ReferencedTableName,  
		@referenced_column_name = ReferencedColumnName
	FROM 
		[inv].[ViewFKInfo]
	WHERE
		ParentSchemaName = @schema_name
		AND ParentTableName = @table_name
		AND ParentColumnName = @column_name
		

END
