USE LEAP
GO

CREATE TABLE LEAP.dbo.tc_verificationStatus (
	vs_id INT NOT NULL IDENTITY(1,1)
	, vs_statusDes VARCHAR(40) NOT NULL CONSTRAINT const_vs_statusDes DEFAULT('')
	, vs_status INT NOT NULL CONSTRAINT const_vs_status DEFAULT 1
	, vs_cDate DATETIME NOT NULL CONSTRAINT const_vs_cDate DEFAULT GETDATE()
)

INSERT INTO LEAP.dbo.tc_verificationStatus (
	vs_statusDes
) VALUES 
('Pendiente')
, ('Si coincide')
, ('No coincide')