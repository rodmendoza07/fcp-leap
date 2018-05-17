USE LEAP
GO

CREATE TABLE tp_documentMatrix(
	dm_id INT NOT NULL IDENTITY(1,1)
	, dm_exp_id VARCHAR(15) NOT NULL CONSTRAINT const_dm_exp_id DEFAULT ''
	, dm_pros_id INT NOT NULL CONSTRAINT const_dm_pros_id DEFAULT 0
	, dm_doc_id INT NOT NULL CONSTRAINT const_dm_doc_id DEFAULT 0
	, dm_create_date DATETIME NOT NULL CONSTRAINT const_dm_create_date DEFAULT GETDATE()
	, dm_usr_id INT NOT NULL CONSTRAINT const_dm_usr_id DEFAULT 0
	, dm_status INT NOT NULL CONSTRAINT const_dm_estatus DEFAULT 0
)