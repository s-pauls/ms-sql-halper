CREATE FUNCTION [gen].[GenerateInsertIntoSelect]
(
	@schemaName NVARCHAR(128),
	@tableName NVARCHAR(128),
	@columns NVARCHAR(MAX),
	@selectDatabaseName NVARCHAR(128),
	@selectSchema NVARCHAR(128),
	@selectTable NVARCHAR(128),
	@selectColumns NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
DECLARE @s NVARCHAR(MAX)

	SET @s = 'INSERT INTO [' + @schemaName + '].[' + @tableName + '] (' + @columns + ') SELECT ' + @selectColumns + ' FROM [' + @selectDatabaseName + '].[' + @selectSchema + '].[' + @selectTable + ']'

	IF EXISTS(
		SELECT NULL
		FROM sys.objects O
		INNER JOIN sys.schemas S ON S.schema_id = O.schema_id
		INNER JOIN sys.identity_columns IC ON O.[object_id] = IC.[object_id]
		WHERE 
			O.[type]='U'
			AND IC.is_identity = 1
			AND S.[name] = @schemaName
			AND O.[name] = @tableName
		)
	BEGIN
	  SET @s = 'SET IDENTITY_INSERT [' + @schemaName + '].[' + @tableName + '] ON' + CHAR(149) +
			   @s + CHAR(149) +
			   'SET IDENTITY_INSERT [' + @schemaName + '].[' + @tableName + '] OFF'
	END

	RETURN @s + CHAR(149) + 'GO'
	
END
