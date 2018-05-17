USE LEAP
GO

ALTER PROCEDURE [dbo].[sp_getVerificationData](
	@idpros VARCHAR(20) = ''
)
AS
BEGIN
	SELECT
		ver.ver_status AS [status]
		, ver.ver_valDate AS fecha
		, ver.ver_idCampo AS campoId
		, verf.verf_fieldDes AS campos
	FROM LEAP.dbo.tc_verificationFields verf
		LEFT OUTER JOIN LEAP.dbo.tp_verificationData ver ON (ver.ver_idCampo = verf.verf_id AND verf.verf_status = 1)
	WHERE ver.ver_idPros = @idpros OR @idpros = ''
END