USE LEAP
GO

CREATE TYPE [dbo].[udt_jobreduced] AS TABLE (
	id_prospecto INT NOT NULL
	, empresa VARCHAR(100) NOT NULL
	, id_giro INT NOT NULL
	, antiguedad INT NOT NULL
	, telefono VARCHAR(100) NOT NULL
	, exttel VARCHAR(100) NOT NULL
	, puesto VARCHAR(100) NOT NULL
	, nombreJefeTrabajo VARCHAR(100) NOT NULL
	, calletrabajo VARCHAR(100) NOT NULL
	, numerotrabajo VARCHAR(100) NOT NULL
	, coloniatrabajo VARCHAR(100) NOT NULL
	, codigopostaltrabajo VARCHAR(100) NOT NULL
	, idantiguedad INT NOT NULL
	, fechaAltaExpediente VARCHAR(100) NOT NULL 
)