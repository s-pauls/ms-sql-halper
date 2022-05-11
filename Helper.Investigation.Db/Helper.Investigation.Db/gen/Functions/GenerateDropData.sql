CREATE FUNCTION [gen].[GenerateDropData]
(
	@schemaName NVARCHAR(128),
	@tableName NVARCHAR(128)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	RETURN 'DELETE FROM [' + @schemaName + '].[' + @tableName + ']'
END
