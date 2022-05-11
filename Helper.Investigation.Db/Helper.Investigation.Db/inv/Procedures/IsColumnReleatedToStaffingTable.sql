CREATE PROCEDURE [inv].[IsColumnReleatedToStaffingTable]
	@schema_name VARCHAR(200),
	@table_name VARCHAR(200),
	@column_name VARCHAR(200),
	@level INT = 0,
	@result INT OUTPUT
AS
BEGIN

	DECLARE 
		@count INT,
		@own_schema_name VARCHAR(200),
		@own_table_name VARCHAR(200),
		@own_column_name VARCHAR(200),
		@own_level INT
	
	DECLARE
		@tables TABLE
		(
			SchemaName VARCHAR(200),
			TableName VARCHAR(200),
			ColumnName VARCHAR(200),
			TypemName VARCHAR(200)
		)

	DECLARE
		@PKs TABLE
		(
			PKName VARCHAR(200),
			ColumnName VARCHAR(200)
		)

	IF @schema_name IS NULL OR @table_name IS NULL OR @column_name IS NULL
	BEGIN
		SET @result = -1
		RETURN
	END

	-- TECH COLUMN
	IF @column_name in ('Id', 'Sequence')
	BEGIN
		SET @result = investigation.IsStaffingTable(@schema_name, @table_name)
		RETURN 
	END

	IF @column_name in ('CreatedBy', 'UpdatedBy', 'CreatorID', 'ModifierID', 'AuthorID')
	BEGIN
		SET @result = 0
		RETURN 
	END

	-- PK Own 
	-- Two colums can be in PK Individual

	INSERT @PKs (PKName, ColumnName)
	SELECT
		CONSTRAINT_NAME,
		COLUMN_NAME
	FROM 
		investigation.GetPrimmaryKeysForTable(@schema_name, @table_name)

	SELECT 
		@count = COUNT(*) 
	FROM 
		@PKs

	IF @count = 1 AND EXISTS (
		SELECT NULL
		FROM @PKs
		WHERE ColumnName = @column_name
	)
	BEGIN
		SET @result = investigation.IsStaffingTable(@schema_name, @table_name)
		
		RETURN 
	END

	-- FK

	EXEC investigation.GetForeinKeyInfo @schema_name, @table_name,  @column_name, 
		@own_schema_name OUTPUT, @own_table_name OUTPUT, @own_column_name OUTPUT

	IF @own_schema_name IS NOT NULL AND @own_table_name IS NOT NULL AND @own_column_name  IS NOT NULL
	BEGIN
		SET @result = investigation.IsStaffingTable(@own_schema_name, @own_table_name) 
		RETURN
	END

	-- ONE TIME MENTIONED COLUMN

	INSERT INTO @tables
	SELECT * FROM investigation.GetTablesByColumnName(@column_name)

	SELECT @count = COUNT(*)  from @tables

	IF @count = 1
	BEGIN
		SELECT 
			@own_schema_name = SchemaName,
			@own_table_name = TableName
		FROM @tables

		SET @result = investigation.IsStaffingTable(@own_schema_name, @own_table_name)

		RETURN 
	END

	-- IF WE HERE THIS IS FK-COLUMN 

	IF @count = 2 and 1 = 0
	BEGIN
		SELECT 
			@own_schema_name = SchemaName,
			@own_table_name = TableName
		FROM @tables
		WHERE NOT (
			SchemaName = @schema_name
			AND TableName = @table_name
			)
		SET @result = investigation.IsStaffingTable(@own_schema_name, @own_table_name)

		RETURN 
	END

	IF @count > 2 AND CHARINDEX('ID', @column_name) > 0 AND @level = 0
	BEGIN
		SET @own_table_name = SUBSTRING(@column_name, 1, LEN(@column_name) - 2 )
		SET @own_level =  @level + 1

		EXEC investigation.IsColumnReleatedToStaffingTable @schema_name, @own_table_name, @column_name, @own_level, @result OUTPUT
		
		IF @result = -1 AND @schema_name != 'dbo'
			 EXEC investigation.IsColumnReleatedToStaffingTable 'dbo', @own_table_name, @column_name, @own_level, @result OUTPUT
		
		RETURN
	END

	SET @result = -1
	RETURN
END
