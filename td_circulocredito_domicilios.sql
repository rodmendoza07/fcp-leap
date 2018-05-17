USE LEAP
GO

CREATE TABLE td_circulocredito_domicilios (
	ccd_id INT NOT NULL IDENTITY(1,1)
	, ccd_cc_id INT NOT NULL CONSTRAINT const_ccd_cc_id DEFAULT 0
	, ccd_calleNumero VARCHAR(500) NOT NULL CONSTRAINT const_ccd_calle DEFAULT ''
	, ccd_numeroint VARCHAR(50) NOT NULL CONSTRAINT const_ccd_numeroint DEFAULT ''
	, ccd_numeroext VARCHAR(50) NOT NULL CONSTRAINT const_ccd_numeroext DEFAULT ''
	, ccd_colonia VARCHAR(500) NOT NULL CONSTRAINT const_ccd_colonia DEFAULT ''
	, ccd_municipio VARCHAR(500) NOT NULL CONSTRAINT const_ccd_municipio DEFAULT ''
	, ccd_ciudad VARCHAR(100) NOT NULL CONSTRAINT const_ccd_ciudad DEFAULT ''
	, ccd_estado VARCHAR(100) NOT NULL CONSTRAINT const_ccd_estado DEFAULT ''
	, ccd_cp VARCHAR(10) NOT NULL CONSTRAINT const_ccd_cp DEFAULT ''
	, ccd_country VARCHAR(500) NOT NULL CONSTRAINT const_ccd_country DEFAULT ''
	, ccd_phone VARCHAR(20) NOT NULL CONSTRAINT const_ccd_phone DEFAULT ''
	, ccd_registerDate DATETIME NOT NULL CONSTRAINT const_ccd_registerDate DEFAULT ''
)