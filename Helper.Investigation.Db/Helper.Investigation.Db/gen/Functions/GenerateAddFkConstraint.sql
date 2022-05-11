CREATE FUNCTION [gen].[GenerateAddFkConstraint]
(
	@fkName NVARCHAR(128),
	@schemaName NVARCHAR(128),
	@tableName NVARCHAR(128),
	@columnName NVARCHAR(128),
	@refSchemaName NVARCHAR(128),
	@refTableName NVARCHAR(128),
	@refColumnName NVARCHAR(128)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	RETURN 'ALTER TABLE [' + @schemaName + '].[' + @tableName + ']' + CHAR(149) + '    ' +
		   'ADD CONSTRAINT [' + @fkName + '] FOREIGN KEY ([' + @columnName + ']) REFERENCES [' + @refSchemaName + '].[' + @refTableName + '] ([' + @refColumnName + '])'
END
