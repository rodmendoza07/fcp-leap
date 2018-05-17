USE LEAP
GO

CREATE TYPE [dbo].[udt_refreduced] AS TABLE(
	id_prospecto INT NOT NULL
	, nombre VARCHAR(100) NOT NULL
	, paterno  VARCHAR(100) NOT NULL
	, materno  VARCHAR(100) NOT NULL
	, relacion VARCHAR(300) NOT NULL
	, telefono VARCHAR(100) NOT NULL
	, tipoTiempoConocer INT NOT NULL
	, tiempoConocer INT NOT NULL
	, tiporef INT NOT NULL
)