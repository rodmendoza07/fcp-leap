USE LEAP
GO

ALTER PROCEDURE [dbo].[sp_getValidDocumentMatrix] (
	@idPros INT = 0
)
AS
BEGIN
	DECLARE
		@msg VARCHAR(300) = ''
		, @idExp INT = 0

	BEGIN TRY
		SELECT
			@idExp = ex.idexpediente
		FROM LEAP.dbo.td_expediente ex
		WHERE ex.idprospecto = @idPros
			AND ex.estatus = 1
			AND ex.vigente = 1

		SELECT
			dm.dm_doc_id AS docId
			, doc.descripcion AS documento
			, dm.dm_status AS statusId
			, CASE
				WHEN dm.dm_status = 0 THEN '<i class="fa fa-times text-danger"></i>'
				WHEN dm.dm_status = 1 THEN '<i class="fa fa-check text-success"></i>'
			END AS estatus
		FROM LEAP.dbo.tc_documento doc
			INNER JOIN LEAP.dbo.tp_documentMatrix dm ON (doc.id_documento = dm.dm_doc_id)
		WHERE dm.dm_pros_id = @idPros
			AND dm.dm_exp_id = @idExp

	END TRY
	BEGIN CATCH
		SET @msg = (SELECT SUBSTRING(ERROR_MESSAGE(), 1, 300))
			RAISERROR(@msg, 16, 1)
	END CATCH
END