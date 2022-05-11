CREATE VIEW [inv].[ViewFKInfo]
AS 

	SELECT
		fc.name 'FkName', 
		ps.name 'ParentSchemaName',
		pt.name 'ParentTableName', 
		pc.name 'ParentColumnName', 
		rs.name 'ReferencedSchemaName',
		rt.name 'ReferencedTableName',  
		rc.name 'ReferencedColumnName'
	FROM 
		sys.foreign_key_columns fkc
	INNER JOIN 
		sys.foreign_keys fc ON fc.object_id = fkc.constraint_object_id
	INNER JOIN 
		sys.tables pt ON pt.object_id = fkc.parent_object_id
	INNER JOIN 
		sys.schemas ps ON ps.schema_id = pt.schema_id
	INNER JOIN 
		sys.columns pc ON pc.object_id = fkc.parent_object_id AND pc.column_id = fkc.parent_column_id
	INNER JOIN 
		sys.tables rt ON rt.object_id = fkc.referenced_object_id
	INNER JOIN 
		sys.schemas rs ON rs.schema_id = rt.schema_id
	INNER JOIN 
		sys.columns rc ON rc.object_id = fkc.referenced_object_id AND rc.column_id = fkc.referenced_column_id
