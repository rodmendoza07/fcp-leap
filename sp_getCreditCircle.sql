USE LEAP
GO

ALTER PROCEDURE [dbo].[sp_getCreditCircle](
	@idPros INT = 0
	, @dStart VARCHAR(30) = ''
	, @dEnd VARCHAR(30) = ''
)
AS
BEGIN
	SELECT
		con.*
	FROM LEAP.dbo.tp_circuloCredito con
	WHERE con.cc_idPros = @idPros
		AND (con.cc_querydate BETWEEN @dStart AND @dEnd OR (@dStart = '' AND @dEnd =''))

	SELECT 
		dom.*
	FROM LEAP.dbo.td_circulocredito_domicilios dom
	WHERE dom.ccd_cc_id IN (SELECT cc_id FROM LEAP.dbo.tp_circuloCredito WHERE cc_idPros = @idPros AND (cc_querydate BETWEEN @dStart AND @dEnd OR (@dStart = '' AND @dEnd ='')))

	SELECT
		emp.*
	FROM LEAP.dbo.td_circulocredito_empleo emp
	WHERE emp.cce_cc_id IN (SELECT cc_id FROM LEAP.dbo.tp_circuloCredito WHERE cc_idPros = @idPros AND (cc_querydate BETWEEN @dStart AND @dEnd OR (@dStart = '' AND @dEnd ='')))

	SELECT
		cuenta.*
	FROM LEAP.dbo.td_circulocredito_cuentas cuenta
	where cuenta.ccc_cc_id IN (SELECT cc_id FROM LEAP.dbo.tp_circuloCredito WHERE cc_idPros = @idPros AND (cc_querydate BETWEEN @dStart AND @dEnd OR (@dStart = '' AND @dEnd ='')))

	SELECT
		prod.*
	FROM LEAP.dbo.td_circulocredito_producto prod
	WHERE prod.ccp_cc_id IN (SELECT cc_id FROM LEAP.dbo.tp_circuloCredito WHERE cc_idPros = @idPros AND (cc_querydate BETWEEN @dStart AND @dEnd OR (@dStart = '' AND @dEnd ='')))
END