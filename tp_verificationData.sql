USE LEAP
GO

CREATE TABLE LEAP.dbo.tp_verificationData (
	ver_id INT NOT NULL IDENTITY(1,1)
	, ver_idPros VARCHAR(20) NOT NULL CONSTRAINT const_ver_idPros DEFAULT('')
	, ver_idCampo INT NOT NULL CONSTRAINT const_ver_idCampo DEFAULT 0
	, ver_status INT NOT NULL CONSTRAINT const_ver_status DEFAULT('')
	, ver_valDate DATETIME NOT NULL CONSTRAINT const_ver_valDate DEFAULT('')
	, ver_usrVal VARCHAR(15) NOT NULL CONSTRAINT const_ver_usrVal DEFAULT('')
)