USE LEAP
GO

CREATE TABLE td_circulocredito_cuentas (
	ccc_id INT NOT NULL IDENTITY(1,1)
	, ccc_cc_id INT NOT NULL CONSTRAINT const_ccc_cc_id DEFAULT 0
	, ccc_prodresponsabilidad VARCHAR(500) NOT NULL CONSTRAINT const_ccc_prodresponsabilidad DEFAULT ''
	, ccc_credito VARCHAR(100) NOT NULL CONSTRAINT const_ccc_credito DEFAULT ''
	, ccc_otorgante VARCHAR(500) NOT NULL CONSTRAINT const_ccc_otorgante DEFAULT ''
	, ccc_plazo INT NOT NULL CONSTRAINT const_ccc_plazo DEFAULT -1
	, ccc_limite INT NOT NULL CONSTRAINT const_ccc_limite DEFAULT -1
	, ccc_aprobado DECIMAL(18,4) NOT NULL CONSTRAINT const_ccc_aprobado DEFAULT -1
	, ccc_actual DECIMAL(18,4) NOT NULL CONSTRAINT const_ccc_actual DEFAULT -1
	, ccc_vencido DECIMAL(18,4) NOT NULL CONSTRAINT const_ccc_vencido DEFAULT -1
	, ccc_apagar DECIMAL(18,4) NOT NULL CONSTRAINT const_ccc_apagar DEFAULT -1
	, ccc_reporte DATETIME NOT NULL CONSTRAINT const_ccc_reporte DEFAULT ''
	, ccc_apertura DATETIME NOT NULL CONSTRAINT const_ccc_apertura DEFAULT ''
	, ccc_cierre DATETIME NOT NULL CONSTRAINT const_ccc_cierre DEFAULT ''
	, ccc_pago DATETIME NOT NULL CONSTRAINT const_ccc_pago DEFAULT ''
	, ccc_ultimos VARCHAR(500) NOT NULL CONSTRAINT const_ccc_ultimos DEFAULT ''
	, ccc_atraso VARCHAR(500) NOT NULL CONSTRAINT const_ccc_atraso DEFAULT ''
	, ccc_montoAtraso DECIMAL(18,4) NOT NULL CONSTRAINT const_ccc_montoAtraso DEFAULT -1
	, ccc_fechaAtraso DATETIME NOT NULL CONSTRAINT const_ccc_fechaAtraso DEFAULT ''
)