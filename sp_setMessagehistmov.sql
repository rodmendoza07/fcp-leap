USE LEAP
GO

CREATE PROCEDURE [dbo].[sp_setMessagehistMov] (
	@message udt_messageHistMov READONLY
)
AS
BEGIN
	DECLARE
		@msg VARCHAR(300) = ''
		, @idex INT = 0

	BEGIN TRY
		
		SET @idex = (SELECT TOP 1 idexpediente FROM LEAP.dbo.td_expediente WHERE idprospecto = (SELECT id_prospecto FROM @message) ORDER BY idexpediente DESC)

		BEGIN TRAN
		INSERT INTO LEAP.dbo.td_mov_expe(
			datemove
			, usermove
			, commentmove
			, id_expediente
			, id_prospecto
			, id_etapa_prev	
		) SELECT 
				GETDATE()
				, mes.usermov
				, mes.comment
				, @idex
				, mes.id_prospecto
				, mes.id_etapa_prev
			FROM @message mes
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