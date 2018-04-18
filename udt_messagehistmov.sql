USE LEAP
GO

CREATE TYPE [dbo].[udt_messageHistMov] AS TABLE(
	id_prospecto INT NOT NULL
	, usermov VARCHAR(10)
	, comment VARCHAR(200)
	, id_expediente INT
	, id_etapa_prev INT 
)