USE [LEAP]
GO

CREATE TYPE [dbo].[udt_circulocredito] AS TABLE(
	cc_idPros INT NOT NULL
	, cc_nombre VARCHAR(50) NOT NULL
	, cc_paterno VARCHAR(50) NOT NULL
	, cc_materno VARCHAR(50) NOT NULL
	, cc_birthdate DATETIME NOT NULL
	, cc_rfc VARCHAR(20) NOT NULL
	, cc_curp VARCHAR(25) NOT NULL
	, cc_folioquery VARCHAR(100) NOT NULL
	, cc_folioquerySic VARCHAR(100) NOT NULL
	, cc_querydate DATETIME NOT NULL
	, cc_totalAprobed INT NOT NULL
	, cc_montoAprobado DECIMAL(18,4) NOT NULL
	, cc_saldoActual DECIMAL(18,4) NOT NULL
	, cc_saldoVenc DECIMAL(18,4) NOT NULL
	, cc_paymentMonth DECIMAL(18,4) NOT NULL
)
GO