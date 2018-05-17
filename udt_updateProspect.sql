USE [LEAP]
GO

CREATE TYPE [dbo].[udt_conyuguereduced] AS TABLE(
	id_prospecto INT NOT NULL
	, nombre VARCHAR(100) NOT NULL
	, paterno  VARCHAR(100) NOT NULL
	, materno  VARCHAR(100) NOT NULL
	, rfc  VARCHAR(100) NOT NULL
	, curp  VARCHAR(100) NOT NULL
	, fecha_nacimiento DATE NOT NULL
	, edad INT NOT NULL
	, telefono  VARCHAR(100) NOT NULL
	, escolaridad INT NOT NULL
	, ocupacion INT NOT NULL
	, actividad_profesion INT NOT NULL
	, nacionalidad INT NOT NULL
	, pais_residencia INT NOT NULL
	, tipo_tiempo INT NOT NULL
	, anios_mat INT NOT NULL 
)
GO