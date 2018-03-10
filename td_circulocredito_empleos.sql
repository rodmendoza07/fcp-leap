USE LEAP
GO

CREATE TABLE td_circulocredito_empleo (
	cce_id INT NOT NULL IDENTITY(1,1)
	, cce_cc_id INT NOT NULL CONSTRAINT const_cce_cc_id DEFAULT 0
	, cce_company VARCHAR(500) NOT NULL CONSTRAINT const_cce_company DEFAULT ''
	, cce_puesto VARCHAR(500) NOT NULL CONSTRAINT const_cce_puesto DEFAULT ''
	, cce_salario DECIMAL(18,4) NOT NULL CONSTRAINT const_cce_salario DEFAULT 0
	, cce_calle VARCHAR(500) NOT NULL CONSTRAINT const_cce_calle DEFAULT ''
	, cce_colonia VARCHAR(500) NOT NULL CONSTRAINT const_cce_colonia DEFAULT ''
	, cce_municipio VARCHAR(100) NOT NULL CONSTRAINT const_cce_municipio DEFAULT ''
	, cce_ciudad VARCHAR(100) NOT NULL CONSTRAINT const_cce_ciudad DEFAULT ''
	, cce_estado VARCHAR(100) NOT NULL CONSTRAINT const_cce_estado DEFAULT ''
	, cce_cp VARCHAR(20) NOT NULL CONSTRAINT const_cce_cp DEFAULT ''
	, cce_phone VARCHAR(20) NOT NULL CONSTRAINT const_cce_phone DEFAULT ''
	, cce_registerdate DATETIME NOT NULL CONSTRAINT const_cce_registerdate DEFAULT ''
)