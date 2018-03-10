USE LEAP
GO

CREATE TABLE td_circulocredito_producto (
	ccp_id INT NOT NULL IDENTITY(1,1)
	, ccp_cc_id INT NOT NULL CONSTRAINT const_ccp_cc_id DEFAULT 0
	, ccp_producto VARCHAR(500) NOT NULL CONSTRAINT const_ccp_desc DEFAULT ''
	, ccp_cuentas INT NOT NULL CONSTRAINT const_ccp_cuentas DEFAULT 0
	, ccp_limite INT NOT NULL CONSTRAINT const_ccp_limite DEFAULT -1
	, ccp_aprobado DECIMAL(18,4) CONSTRAINT const_ccp_aprobado DEFAULT -1
	, ccp_actual DECIMAL(18,4) CONSTRAINT const_ccp_actual DEFAULT -1
	, ccp_vencido DECIMAL(18,4) CONSTRAINT const_ccp_vencido DEFAULT -1
	, ccp_psemanal DECIMAL(18,4) CONSTRAINT const_ccp_psemanal DEFAULT -1
	, ccp_pquincenal DECIMAL(18,4) CONSTRAINT const_ccp_pquincenal DEFAULT -1
	, ccp_pmensual DECIMAL(18,4) CONSTRAINT const_ccp_pmensual	DEFAULT -1
)