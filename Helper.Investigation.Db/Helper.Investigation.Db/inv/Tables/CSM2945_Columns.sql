CREATE TABLE [inv].[CSM2945_Columns]
(
	oKey VARCHAR(200) NOT NULL, 
	oType VARCHAR(100) NOT NULL, 
	oSchema VARCHAR(100) NOT NULL, 
	oName VARCHAR(200) NOT NULL,
	oNewName VARCHAR(200),
	oNewTableName VARCHAR(200),
	ColumnName VARCHAR(200),
	ColumnType VARCHAR(200),
	ColumnID int,

	isSM int default 0 not null
)
