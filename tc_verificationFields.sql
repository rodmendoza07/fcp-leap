USE LEAP
GO

CREATE TABLE LEAP.dbo.tc_verificationFields (
	verf_id INT NOT NULL IDENTITY(1,1)
	, verf_fieldDes VARCHAR(100) NOT NULL CONSTRAINT const_verf_fieldDes DEFAULT('')
	, verf_status INT NOT NULL CONSTRAINT const_verf_status DEFAULT 1
	, verf_cDate DATETIME NOT NULL CONSTRAINT const_verf_cDate DEFAULT GETDATE()
)

INSERT INTO LEAP.dbo.tc_verificationFields (
	verf_fieldDes
) VALUES 
('Apellido paterno')
, ('Apellido materno')
, ('Nombre')
--, ('Segundo nombre')
, ('Fecha nacimiento')
, ('Lugar de nacimiento')
, ('RFC')
, ('Homoclave')
, ('CURP')
, ('Firma INE/IFE')
, ('Consulta INE/IFE')