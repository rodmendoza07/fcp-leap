USE LEAP
GO

CREATE TABLE tp_circuloCredito (
	cc_id INT NOT NULL IDENTITY(1,1)
	, cc_nombre VARCHAR(50) NOT NULL, CONSTRAINT const_cc_nombre DEFAULT ('')
	, cc_paterno VARCHAR(50) NOT NULL, CONSTRAINT const_cc_paterno DEFAULT ('')
	, cc_materno VARCHAR(50) NOT NULL, CONSTRAINT const_cc_materno DEFAULT ('')
	, cc_birthdate DATETIME NOT NULL, CONSTRAINT const_cc_birthdate DEFAULT ''
	, cc_rfc VARCHAR(20) NOT NULL, CONSTRAINT const_cc_rfc DEFAULT('')
	, cc_curp VARCHAR(25) NOT NULL, CONSTRAINT const_cc_curp DEFAULT ''
	, cc_msg VARCHAR(MAX) NOT NULL, CONSTRAINT const_cc_msg DEFAULT ''
	, cc_score INT NOT NULL, CONSTRAINT const_cc_score DEFAULT 0
	, cc_tVigente INT NOT NULL, CONSTRAINT const_cc_tVigente DEFAULT 0
	, cc_montoAprobado INT NOT NULL, CONSTRAINT const_cc_montoAprobado DEFAULT 0
	, cc_saldoActual INT NOT NULL, CONSTRAINT const_cc_saldoActual DEFAULT 0
	, cc_credAbiertos INT NOT NULL, CONSTRAINT const_cc_credAbiertos DEFAULT 0
	, cc_credOld DATETIME NOT NULL, CONSTRAINT const_cc_credOld DEFAULT ''
	, cc_maAprobed DECIMAL(18,4) NOT NULL, CONSTRAINT const_cc_maAprobed DEFAULT 0
	, cc_querydate DATETIME NOT NULL, CONSTRAINT const_cc_querydate DEFAULT ''
	, cc_folioquery INT NOT NULL, CONSTRAINT const_cc_folioquery DEFAULT 0
	, cc_folioquerySic INT NOT NULL, CONSTRAINT const_cc_folioquerySic DEFAULT 0
)