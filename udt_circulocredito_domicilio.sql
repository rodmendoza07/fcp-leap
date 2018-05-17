USE [LEAP]
GO

CREATE TYPE [dbo].[udt_circulocredito_domicilio] AS TABLE(
	ccd_calleNumero VARCHAR(500) NOT NULL
	, ccd_numeroint VARCHAR(50) NOT NULL 
	, ccd_numeroext VARCHAR(50) NOT NULL 
	, ccd_colonia VARCHAR(500) NOT NULL
	, ccd_municipio VARCHAR(500) NOT NULL
	, ccd_estado VARCHAR(100) NOT NULL
)
GO