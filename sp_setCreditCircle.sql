USE LEAP
GO
ALTER PROCEDURE [dbo].[sp_setCreditCircle] (
	@udt_circulocredito udt_circulocredito READONLY
	, @udt_circulocredito_home udt_circulocredito_domicilio READONLY
)
AS
BEGIN
	DECLARE
		@msg VARCHAR(300)
		, @lastId INT

	BEGIN TRY
		BEGIN TRAN
		INSERT INTO LEAP.dbo.tp_circuloCredito (
			cc_idPros
			, cc_nombre
			, cc_paterno
			, cc_materno
			, cc_birthdate
			, cc_rfc
			, cc_curp
			, cc_folioquery
			, cc_folioquerySic
			, cc_querydate
			, cc_totalAprobed
			, cc_montoAprobado
			, cc_saldoActual
			, cc_saldoVenc
			, cc_paymentMonth
		)
		SELECT
			*
		FROM @udt_circulocredito

		SET @lastId = @@IDENTITY

		INSERT INTO LEAP.dbo.td_circulocredito_domicilios (
			ccd_cc_id
			, ccd_calleNumero
			, ccd_numeroint
			, ccd_numeroext
			, ccd_colonia
			, ccd_municipio
			, ccd_estado
		)
		SELECT
			@lastId
			, ccd_calleNumero
			, ccd_numeroint
			, ccd_numeroext
			, ccd_colonia
			, ccd_municipio
			, ccd_estado
		FROM @udt_circulocredito_home

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