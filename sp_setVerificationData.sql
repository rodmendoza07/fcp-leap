USE LEAP
GO

ALTER PROCEDURE [dbo].[sp_setVerificationData] (
	@idpros VARCHAR(20) = ''
	, @verification INT = 1
	, @idVerification INT = 0
)
AS
BEGIN
	DECLARE
		@msg VARCHAR(300) = ''

	BEGIN TRY
		BEGIN TRAN
		UPDATE LEAP.dbo.tp_verificationData SET
			ver_status = @verification
			, ver_valDate = GETDATE()
		WHERE ver_idPros = @idpros
			AND ver_idCampo = @idVerification

		IF @@TRANCOUNT > 0 
			COMMIT TRAN
		ELSE
			ROLLBACK TRAN
			SET @msg = (SELECT SUBSTRING(ERROR_MESSAGE(), 1, 300))
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @msg = (SELECT SUBSTRING(ERROR_MESSAGE(), 1, 300))
		RAISERROR(@msg, 16, 1)
	END CATCH
END