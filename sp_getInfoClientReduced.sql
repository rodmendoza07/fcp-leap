USE [LEAP]
GO
/****** Object:  StoredProcedure [dbo].[sp_getInfoClientReduced]    Script Date: 06/03/2018 05:20:42 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_getInfoClientReduced] (
	@cName VARCHAR(20) = ''
	, @cfirstName VARCHAR(20) = ''
	, @cLastName VARCHAR(20) = ''
	, @cNumber INT = 0
	, @cCredit INT = 0
	, @cCardNumber VARCHAR(18) = ''
	, @cPros INT = 0
	, @cIp VARCHAR(35) = ''
	, @usuario VARCHAR(15) = ''
)
AS
BEGIN
	DECLARE
		@cteNumber INT = 0
		, @goPros INT = 0
		, @idexpe INT = 0

	SELECT
		@goPros = COUNT(*)
		, @cteNumber = CAST(cte.ACREDITADO AS int)
	FROM ISILOANSWEB.dbo.T_CTE cte
	WHERE ((cte.TITULAR LIKE @cName + ' *' + @cfirstName + ' ' + @cLastName) OR (@cName = '' AND @cfirstName = '' AND @cLastName = ''))
		AND (cte.ACREDITADO = @cNumber OR @cNumber = 0)
		AND ((cte.ACREDITADO = (SELECT cliente FROM ISILOANSWEB.dbo.T_CRED WHERE NUMERO = @cCredit)) OR @cCredit = 0)
		AND (cte.TARJETA = @cCardNumber OR @cCardNumber = '')
		AND @cPros = 0
	GROUP BY cte.ACREDITADO

	IF @goPros <= 0 BEGIN
		/*Datos prospecto*/
		SELECT 
			pros.id_prospecto AS ID
			, pros.nombre 
			, pros.paterno
			, pros.materno 
			, CONVERT(VARCHAR, pros.fechanacimiento, 103) AS nacimiento
			, pros.edad
			, CASE
				WHEN pros.sexo = 'F' THEN 'Femenino'
				ELSE 'Masculino'
				END AS SEXO
			--, pros.nombre + ' ' + pros.paterno + ' ' + pros.materno AS TITULAR
			, pros.RFC
			, pros.CURP
			--, pros.pais_nacionalidad
			, pros.estadocivil
			, pros.profesion_label
			, pros.telefono1
			, pros.telefono2
			, pros.calle
			, pros.numero
			, pros.numero_int
			, pros.referenciaDom
			, pros.codigopostal
			, CASE
				WHEN pros.casa_propia = 1 THEN 'SI'
				ELSE 'NO' END AS casa_propia
			, pros.colonia
			, CAST(pros.tiempo_recidencia AS varchar) + ' ' + viv.type_label AS tiempo_recidencia
			, CAST(pros.tiempo_recidencia_ante AS varchar) + ' ' + viva.type_label AS tiempo_recidencia_ante 
			--CAMPOS JOINEADOS
			, est.descripcion AS nivelstudios
			, ex.ocupacion AS ocupacion
			, ex.numDependientes AS numDependientes
			, cest.nombre AS estadonacimiento
			, pais.nombre_pais AS pais_residencia
			, paisn.nombre_pais AS pais_nacionalidad
			, cp.d_estado AS estado
			, cp.D_mnpio AS municipio
			, tv.nombre AS tipo_residencia
			, tc.descripcion AS estadocivil
			, ex.correo	as correo
			, CASE
				WHEN ex.tipotiempovivienda_anterior = 1 THEN CAST('Años' AS varchar)
				WHEN ex.tipotiempovivienda_anterior = 0 THEN CAST('Meses' AS varchar)
				ELSE 'N/A' END tipotiempovivienda_anterior
		FROM LEAP.dbo.tp_prospecto pros
			LEFT JOIN CATALOGOS.dbo.tc_estudios est ON (est.id_estudios = pros.id_estudios)
			LEFT JOIN LEAP.dbo.td_expediente ex ON (ex.idprospecto = pros.id_prospecto)
			LEFT JOIN LEAP.dbo.tc_estado cest ON (cest.id_estado = pros.estado_nacimiento)
			LEFT JOIN LEAP.dbo.tc_pais pais ON (pais.id_catalogo = pros.pais_recidencia)
			LEFT JOIN LEAP.dbo.tc_pais paisn ON (paisn.id_catalogo = pros.pais_nacionalidad)
			LEFT JOIN LEAP.dbo.tc_codigopostal cp ON (cp.id_codigopostal = pros.codigopostal)
			LEFT JOIN LEAP.dbo.tc_tipovivienda tv ON (tv.estatus = 1 AND tv.id_tipovivienda = pros.casa_propia)
			LEFT JOIN LEAP.dbo.tc_estado_civil tc ON (tc.id_estado = pros.estadocivil)
			LEFT JOIN LEAP.dbo.tc_tipotiempovivienda viv ON (viv.type_label_isi = pros.mesanio_recidencia)
			LEFT JOIN LEAP.dbo.tc_tipotiempovivienda viva ON (viva.type_label_isi = pros.mesanio_recidencia_ante)
		WHERE pros.id_prospecto = @cPros

		/*Datos conyugue*/
		SELECT
			pex.nombre
			, pex.apePaterno
			, pex.apeMaterno
			, CONVERT(varchar, pex.fecha_nacimiento, 103) AS fecha_nacimiento
			, pex.edad
			, pex.RFC
			, pex.CURP
			, pex.telefono
			, est.descripcion AS escolaridad
			, pex.ocupacion
			, prof.label AS profesion
			, paisn.nombre_pais AS nacionalidad
			, pais.nombre_pais AS pais_residencia
			,  CASE
				WHEN pex.tipo_tiempo = 1 THEN CAST(pex.anos_matrimonio AS varchar) + ' ' + 'Años'
				WHEN pex.tipo_tiempo = 0 THEN CAST(pex.anos_matrimonio AS varchar) + ' ' + 'Meses'
			ELSE 'N/A' END AS tiempo_matrimonio
			, pex.anos_matrimonio AS matrimonio
		FROM LEAP.dbo.td_persona_expediente pex
			LEFT JOIN CATALOGOS.dbo.tc_estudios est ON (est.id_estudios = pex.escolaridad)
			LEFT JOIN LEAP.dbo.tc_pais pais ON (pais.id_catalogo = pex.pais_residencia)
			LEFT JOIN LEAP.dbo.tc_pais paisn ON (paisn.id_catalogo = pex.nacionalidad)
			LEFT JOIN LEAP.dbo.tc_profesion prof ON (prof.id_profesion = pex.actividad_profesion)
		WHERE pex.id_prospecto = @cPros
			AND pex.id_tipo_persona = 1
		
		/* Datos económicos */
		set @idexpe = (select top 1 idexpediente from td_expediente where idprospecto=@cPros)

		exec sp_getEconomicData  @cPros,  @idexpe , @usuario, @cIp

		/*Datos Obligado solidario*/
		SELECT
		pex.nombre
			, pex.apePaterno
			, pex.apeMaterno
			, CONVERT(varchar, pex.fecha_nacimiento, 103) AS fecha_nacimiento
			, pex.edad
			, pex.RFC
			, pex.CURP
			, pex.telefono
			, est.descripcion AS escolaridad
			, pex.ocupacion
			, prof.label AS profesion
			, paisn.nombre_pais AS nacionalidad
			, pais.nombre_pais AS pais_residencia
			/*, CASE
				WHEN ref.tipoTiempoConocer = 1 THEN ref.tiempoConocer + ' ' + 'Años1'
				WHEN ref.tipoTiempoConocer = 0 THEN ref.tiempoConocer + ' ' + 'Meses'
				ELSE 'N/A' END AS tiempo_conocer*/
		FROM LEAP.dbo.td_persona_expediente pex
			LEFT JOIN CATALOGOS.dbo.tc_estudios est ON (est.id_estudios = pex.escolaridad)
			LEFT JOIN LEAP.dbo.tc_pais pais ON (pais.id_catalogo = pex.pais_residencia)
			LEFT JOIN LEAP.dbo.tc_pais paisn ON (paisn.id_catalogo = pex.nacionalidad)
			LEFT JOIN LEAP.dbo.tc_profesion prof ON (prof.id_profesion = pex.actividad_profesion)
			--LEFT JOIN LEAP.dbo.tp_referencia ref  ON (ref.id_prospecto = pex.id_prospecto)
		WHERE pex.id_prospecto = @cPros
			AND pex.id_tipo_persona = 2

		/* Datos referencias */
		SELECT
			ref.nombreReferencia
			, ref.paternoReferencia
			, ref.maternoReferencia
			, ref.relacionTitular
			, ref.telReferencia
			, tref.nombre AS tipo_referencia
			, CASE
				WHEN ref.tipoTiempoConocer = 1 THEN CAST(ref.tiempoConocer AS varchar) + ' ' + 'Años'
				WHEN ref.tipoTiempoConocer = 0 THEN CAST(ref.tiempoConocer AS varchar) + ' ' + 'Meses'
			ELSE CAST('N/A' AS varchar) END AS tiempo_conocer
		FROM LEAP.dbo.tp_referencia ref
			LEFT JOIN LEAP.dbo.tc_tipoRef tref ON (tref.id_tipoRef = ref.tipoReferencia)
		WHERE ref.id_prospecto = @cPros

		/* Empleo solicitante */
		SELECT
			ex.empresa
			, ex.id_giroempresa
			, ex.antiguedadcantidad
			, CASE
				WHEN ex.antiguedadtipo = 1 THEN CAST(ex.antiguedadcantidad AS varchar) + ' ' + 'Años'
				WHEN ex.antiguedadtipo = 0 THEN CAST(ex.antiguedadcantidad AS varchar) + ' ' + 'Meses'
			ELSE 'N/A' END AS antiguedad
			, ex.telefonoTrabajo
			, ex.extTelTrabajo
			, ex.puesto
			, ex.nombreJefeTrabajo
			, ex.calletrabajo
			, ex.numerotrabajo
			, ex.coloniatrabajo
			, ex.codigopostaltrabajo
			, prof.label AS giroEmpresa
			, ex.municipiotrabajo
		FROM LEAP.dbo.td_expediente ex
			LEFT JOIN LEAP.dbo.tc_profesion prof ON (prof.id_profesion = ex.id_giroempresa)
		WHERE ex.idprospecto = @cPros

	END
	ELSE BEGIN
		SELECT
			REPLACE(cte.TITULAR,'*','')
			, cte.FECH_ALTA
			, cte.TARJETA
			, cte.FEC_NACIMIENTO
			, cte.COD_SEXO
			, cte.RFC
			, cte.NACIONALID
			, cte.DIRECCION
		FROM ISILOANSWEB.dbo.T_CTE cte
		WHERE cte.ACREDITADO = @cteNumber
	END

END