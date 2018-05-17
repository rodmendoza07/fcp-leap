USE LEAP
GO

ALTER PROCEDURE [dbo].[sp_setValidDocumentMatrix](
	@idPros INT = 0
	, @idDoc INT = 0
	, @opt INT = 0
)
AS
BEGIN
	DECLARE
		@msg VARCHAR(300) = ''
		, @idExp INT = ''

	BEGIN TRY
		SELECT
			@idExp = ex.idexpediente
		FROM LEAP.dbo.td_expediente ex
		WHERE ex.idprospecto = @idPros
			AND ex.estatus = 1
			AND ex.vigente = 1

		IF @opt = 1 BEGIN
			INSERT INTO LEAP.dbo.tp_documentMatrix (
				dm_exp_id
				, dm_pros_id
				, dm_doc_id
			) SELECT
				@idExp
				, @idPros
				, doc.id_documento
			FROM LEAP.dbo.tc_documento doc
		END
		ELSE IF @opt = 2 BEGIN
			UPDATE LEAP.dbo.tp_documentMatrix SET 
				dm_status = 1
			WHERE dm_pros_id = @idPros 
				AND dm_doc_id = @idDoc
				AND dm_exp_id = @idExp
		END
		ELSE BEGIN
			SET @msg = 'Opción inválida'
			RAISERROR(@msg, 16, 1)
		END
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @msg = (SELECT SUBSTRING(ERROR_MESSAGE(), 1, 300))
		RAISERROR(@msg, 16, 1)
	END CATCH
END