CREATE FUNCTION [gen].[GenerateDropFkConstraint]
(
	@fkName NVARCHAR(128),
	@schemaName NVARCHAR(128),
	@tableName NVARCHAR(128)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	RETURN 'ALTER TABLE [' + @schemaName + '].[' + @tableName +'] DROP CONSTRAINT [' + @fkName + ']'
END
