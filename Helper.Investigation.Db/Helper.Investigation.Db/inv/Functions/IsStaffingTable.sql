CREATE FUNCTION [inv].[IsStaffingTable]
(
	@schema_name VARCHAR(100),
	@table_name VARCHAR(100)
)
RETURNS BIT
AS
BEGIN	
	IF @schema_name = 'stm'
		RETURN 1

	IF CHARINDEX('Staffing', @table_name) > 0 AND @schema_name = 'dbo'
		RETURN 1

	IF CHARINDEX('ViewSM', @table_name) > 0 AND @schema_name = 'dbo'
		RETURN 1

	RETURN 0
END
