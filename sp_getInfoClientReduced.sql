USE [LEAP]
GO
/****** Object:  StoredProcedure [dbo].[sp_getInfoClientReduced]    Script Date: 10/04/2018 04:41:37 p. m. ******/
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
		, @prosId INT = 0

	IF @cNumber = 0 AND @cPros > 0 BEGIN
		SET @goPros = 0
	END

	IF @cNumber > 0 AND @cPros = 0 BEGIN
		SELECT
			@cteNumber = COUNT(pros.id_prospecto)
		FROM LEAP.dbo.tp_prospecto pros
		WHERE pros.id_cte_isi = @cNumber
		SET @goPros = 1
	END

	

	IF @goPros <= 0 BEGIN
		/*Datos prospecto*/
		SELECT 
			pros.id_prospecto AS ID
			, CASE
				WHEN pros.id_cte_isi IS NULL THEN 0
				ELSE pros.id_cte_isi 
				END AS id_cte_isi
			, 'PRO' AS cliTIPO
			, pros.nombre 
			, pros.paterno
			, pros.materno 
			, CONVERT(VARCHAR, pros.fechanacimiento, 111) AS nacimiento
			, pros.edad
			, CASE
				WHEN pros.sexo = 'F' THEN 'Femenino'
				ELSE 'Masculino'
				END AS SEXO
			, pros.sexo AS idsexo
			--, pros.nombre + ' ' + pros.paterno + ' ' + pros.materno AS TITULAR
			, pros.RFC
			, pros.CURP
			--, pros.pais_nacionalidad
			, pros.estadocivil
			, pros.profesion_label
			, pros.ladatel1 AS lada1
			, pros.telefono1 AS TELE1
			, pros.ladatel2 AS lada2
			, pros.telefono2  AS TELE2
			, pros.calle
			, pros.numero
			, pros.numero_int
			, pros.referenciaDom
			, pros.codigopostal
			, pros.casa_propia
			, pros.colonia
			--, CAST(pros.tiempo_recidencia AS varchar) + ' ' + viv.type_label AS tiempo_recidencia
			, pros.tiempo_recidencia
			, pros.mesanio_recidencia
			--, CAST(pros.tiempo_recidencia_ante AS varchar) + ' ' + viva.type_label AS tiempo_recidencia_ante
			, pros.tiempo_recidencia_ante
			, pros.mesanio_recidencia_ante
			--CAMPOS JOINEADOS
			, est.descripcion AS nivelstudios
			, est.id_estudios
			, ex.ocupacion AS ocupacion
			, ex.numDependientes AS numDependientes
			, cest.id_estado AS estado_nacimiento
			, cest.nombre AS estadonacimiento
			, pais.nombre_pais AS pais_residencia
			, paisn.nombre_pais AS pais_nacionalidad
			, cp.d_estado AS estado
			, cp.c_mnpio AS municipiodelegacionID
			, cp.D_mnpio AS municipio
			, cp.c_mnpio AS municipiodelegacion
			, pros.id_estadodom
			, tv.nombre AS tipo_residencia
			, tc.descripcion AS estadocivil
			, ex.correo	as correo
			, ex.comentario
			--, pros.mesanio_recidencia_ante
			, ex.profesion AS id_profesion
			, pros.id_sucursal AS idSucursal
			, depto.descripcion AS nombreSucursal
			, ex.tienecargopublico AS Tienecargopublic
			, ex.desccargopublico AS cargopublico
			, pros.pais_recidencia
			, CONVERT(varchar, ex.fechaAltaExpediente, 112) AS fechaAltaExpediente
			, CASE
				WHEN ex.tipotiempovivienda_anterior = 1 THEN CAST('Años' AS varchar)
				WHEN ex.tipotiempovivienda_anterior = 0 THEN CAST('Meses' AS varchar)
				ELSE 'N/A' END tipotiempovivienda_anterior
		FROM LEAP.dbo.tp_prospecto pros
			LEFT JOIN CATALOGOS.dbo.tc_estudios est ON (est.id_estudios = pros.id_estudios)
			LEFT JOIN LEAP.dbo.td_expediente ex ON (ex.idprospecto = pros.id_prospecto AND ex.idexpediente = (SELECT TOP 1 idexpediente FROM LEAP.dbo.td_expediente WHERE idprospecto = @cPros ORDER BY idexpediente ASC))
			LEFT JOIN LEAP.dbo.tc_estado cest ON (cest.id_estado = pros.estado_nacimiento)
			LEFT JOIN LEAP.dbo.tc_pais pais ON (pais.id_catalogo = pros.pais_recidencia)
			LEFT JOIN LEAP.dbo.tc_pais paisn ON (paisn.id_catalogo = pros.pais_nacionalidad)
			LEFT JOIN LEAP.dbo.tc_codigopostal cp ON (cp.d_codigo = pros.codigopostal)
			LEFT JOIN LEAP.dbo.tc_tipovivienda tv ON (tv.estatus = 1 AND tv.id_tipovivienda = pros.casa_propia)
			LEFT JOIN LEAP.dbo.tc_estado_civil tc ON (tc.id_estado = pros.estadocivil)
			LEFT JOIN LEAP.dbo.tc_tipotiempovivienda viv ON (viv.type_label_isi = pros.mesanio_recidencia)
			LEFT JOIN LEAP.dbo.tc_tipotiempovivienda viva ON (viva.type_label_isi = pros.mesanio_recidencia_ante)
			LEFT JOIN CATALOGOS.dbo.tc_departamento depto ON (depto.id_departamento = pros.id_sucursal)
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
			, pex.escolaridad AS idescolaridad
			, pex.actividad_profesion AS idprofesion
			, pex.pais_residencia AS idresidencia
			, pex.nacionalidad AS idnacionalidad
			,  CASE
				WHEN pex.tipo_tiempo = 1 THEN CAST(pex.anos_matrimonio AS varchar) + ' ' + 'Años'
				WHEN pex.tipo_tiempo = 0 THEN CAST(pex.anos_matrimonio AS varchar) + ' ' + 'Meses'
			ELSE 'N/A' END AS tiempo_matrimonio
			, pex.anos_matrimonio AS matrimonio
			, pex.tipo_tiempo AS idtiempomat
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
			, pex.escolaridad AS idescolaridad
			, pex.actividad_profesion AS idprofesion
			, pex.pais_residencia AS idresidencia
			, pex.nacionalidad AS idnacionalidad
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
			ref.id_prospecto
			, ref.nombreReferencia
			, ref.paternoReferencia
			, ref.maternoReferencia
			, ref.relacionTitular
			, ref.telReferencia
			, tref.nombre AS tipo_referencia
			, CASE
				WHEN ref.tipoTiempoConocer = 1 THEN CAST(ref.tiempoConocer AS varchar) + ' ' + 'Años'
				WHEN ref.tipoTiempoConocer = 0 THEN CAST(ref.tiempoConocer AS varchar) + ' ' + 'Meses'
			ELSE CAST('N/A' AS varchar) END AS tiempo_conocer
			, ref.tipoTiempoConocer AS idtiempoconocer
			, ref.tiempoConocer AS totaltime
			, ref.tipoReferencia AS idtiporef
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
			, ex.antiguedadtipo AS idantiguedad
		FROM LEAP.dbo.td_expediente ex
			LEFT JOIN LEAP.dbo.tc_profesion prof ON (prof.id_profesion = ex.id_giroempresa)
		WHERE ex.idprospecto = @cPros

	END
	ELSE BEGIN

		SELECT
			@prosId = id_prospecto
		FROM LEAP.dbo.tp_prospecto
		WHERE id_cte_isi = @cNumber

		--SELECT @prosId

		IF @prosId = 0 BEGIN
			/*Generales de CTE */
			SELECT
				'' AS ID
				, @cNumber AS id_cte_isi
				, 'CTE' AS cliTIPO
				,
					REPLACE (SUBSTRING(  SUBSTRING(LTRIM(RTRIM(cte.titular)), CHARINDEX('*',LTRIM( RTRIM(cte.titular))),LEN(LTRIM( RTRIM(cte.titular)))) ,  
					CHARINDEX('*',SUBSTRING(LTRIM(RTRIM(cte.titular)), CHARINDEX('*',LTRIM( RTRIM(cte.titular))),LEN(LTRIM( RTRIM(cte.titular))))) , 
					CHARINDEX(' ',SUBSTRING(LTRIM(RTRIM(cte.titular)), CHARINDEX('*',LTRIM( RTRIM(cte.titular))),LEN(LTRIM( RTRIM(cte.titular))))) ) , '*', '')as [paterno], 
					SUBSTRING(  SUBSTRING(LTRIM( RTRIM(cte.titular)), CHARINDEX('*',LTRIM( RTRIM(cte.titular))),LEN(LTRIM( RTRIM(cte.titular)))) ,  
					CHARINDEX(' ',SUBSTRING(RTRIM(cte.titular), CHARINDEX('*',LTRIM( RTRIM(cte.titular))),LEN( LTRIM(RTRIM(cte.titular))))) , 
					LEN(SUBSTRING(LTRIM(RTRIM(cte.titular)), CHARINDEX('*',LTRIM( RTRIM(cte.titular))),LEN( LTRIM(RTRIM(cte.titular))))) ) as [materno], 
					SUBSTRING(rtrim(TITULAR),0,CHARINDEX('*',TITULAR))  as nombre
				, CONVERT(varchar, cte.FEC_NACIMIENTO, 111) AS nacimiento
				, '' AS edad
				, '' AS CURP
				, cte.RFC
				, '' AS ocupacion
				, 0 AS numDependientes
				, '' AS lada1
				, '' AS lada2
				, cte.TELEF AS TELE1
				, cte.TELEF_2 AS TELE2
				, cte.E_MAIL AS correo
				, cte.DIRECCION AS calle
				, cte.COLONIA AS colonia
				, '' AS numero
				, '' AS numero_int
				, '' AS referenciaDom
				, cte.CODPOST AS codigopostal
				, cte.ESTADO AS estado
				, 0 AS municipiodelegacionID
				, 0 AS municipiodelegacion
				, '' AS municipio
				, cte.NACIONALID AS pais_nacionalidad
				, 1 AS pais_recidencia
				, 1 AS pais_residencia
				, 1 AS id_estudios
				, 1 AS id_profesion
				, 0 AS casa_propia
				, cte.EDOCIVIL AS estadocivil
				, cte.FECH_ALTA
				, cte.TARJETA
				, cte.COD_SEXO AS idsexo
				, 0 AS tiempo_recidencia
				, 0 AS tiempo_recidencia_ante
				, 0 AS mesanio_recidencia
				, 0 AS mesanio_recidencia_ante
				, '' AS fechaAltaExpediente
				, 0 AS estado_nacimiento
				, 0 AS id_estadodom
				, '' AS referenciaDom
				, '' AS comentario
				, cte.SUCURSAL AS idSucursal
				, depto.descripcion AS nombreSucursal
				, '' AS Tienecargopublic
				, '' AS cargopublico
			FROM ISILOANSWEB.dbo.T_CTE cte
				INNER JOIN CATALOGOS.dbo.tc_departamento depto ON (cte.SUCURSAL = depto.id_departamento)
			WHERE cte.ACREDITADO = @cNumber
			/* DAtos conyugue */
			SELECT
				'' AS nombre
				, '' AS apePaterno
				, '' AS apeMaterno
				, '' AS fecha_nacimiento
				, '' AS edad
				, '' AS RFC
				, '' AS CURP
				, '' AS telefono
				, '' AS escolaridad
				, '' AS ocupacion
				, '' AS profesion
				, '' AS nacionalidad
				, '' AS pais_residencia
				, '' AS idescolaridad
				, '' AS idprofesion
				, '' AS idresidencia
				, '' AS idnacionalidad
				, '' AS tiempo_matrimonio
				, '' AS matrimonio
				, '' AS idtiempomat
			/* Economicos */
			set @idexpe = 0
			exec sp_getEconomicData  @prosId,  @idexpe , @usuario, @cIp
			/* Obligado solidario */
			SELECT
				'' AS nombre
				, '' AS apePaterno
				, '' AS apeMaterno
				, CONVERT(varchar, '1900-00-00 00:00:00.000', 103) AS fecha_nacimiento
				, '' AS edad
				, '' AS RFC
				, '' AS CURP
				, '' AS telefono
				, '' AS descripcion 
				, '' AS escolaridad
				, '' AS ocupacion
				, '' AS profesion
				, '' AS nacionalidad
				, '' AS pais_residencia
				, '' AS idescolaridad
				, '' AS idprofesion
				, '' AS idresidencia
				, '' AS idnacionalidad
			/* Referencias */
			SELECT
				'' AS id_prospecto
				, '' AS nombreReferencia
				, '' AS paternoReferencia
				, '' AS maternoReferencia
				, '' AS relacionTitular
				, '' AS telReferencia
				, '' AS tipo_referencia
				, '' AS tiempo_conocer
				, '' AS idtiempoconocer
				, '' AS totaltime
				, '' AS idtiporef

			/* Empleo solicitante */
			SELECT
				'' AS empresa
				, '' AS id_giroempresa
				, '' AS antiguedadcantidad
				, '' AS antiguedad
				, '' AS telefonoTrabajo
				, '' AS extTelTrabajo
				, '' AS puesto
				, '' AS nombreJefeTrabajo
				, '' AS calletrabajo
				, '' AS numerotrabajo
				, '' AS coloniatrabajo
				, '' AS codigopostaltrabajo
				, '' AS giroEmpresa
				, '' AS municipiotrabajo
				, '' AS idantiguedad
		END
		IF @prosId > 0 BEGIN
			/*Datos prospecto*/
			SELECT 
				pros.id_prospecto AS ID
				, CASE
					WHEN pros.id_cte_isi IS NULL THEN 0
					ELSE pros.id_cte_isi 
					END AS id_cte_isi
				, 'PRO' AS cliTIPO
				, pros.nombre 
				, pros.paterno
				, pros.materno 
				, CONVERT(VARCHAR, pros.fechanacimiento, 111) AS nacimiento
				, pros.edad
				, CASE
					WHEN pros.sexo = 'F' THEN 'Femenino'
					ELSE 'Masculino'
					END AS SEXO
				, pros.sexo AS idsexo
				--, pros.nombre + ' ' + pros.paterno + ' ' + pros.materno AS TITULAR
				, pros.RFC
				, pros.CURP
				--, pros.pais_nacionalidad
				, pros.estadocivil
				, pros.profesion_label
				, pros.ladatel1 AS lada1
				, pros.telefono1 AS TELE1
				, pros.ladatel2 AS lada2
				, pros.telefono2  AS TELE2
				, pros.calle
				, pros.numero
				, pros.numero_int
				, pros.referenciaDom
				, pros.codigopostal
				, pros.casa_propia
				, pros.colonia
				--, CAST(pros.tiempo_recidencia AS varchar) + ' ' + viv.type_label AS tiempo_recidencia
				, pros.tiempo_recidencia
				, pros.mesanio_recidencia
				--, CAST(pros.tiempo_recidencia_ante AS varchar) + ' ' + viva.type_label AS tiempo_recidencia_ante
				, pros.tiempo_recidencia_ante
				, pros.mesanio_recidencia_ante
				--CAMPOS JOINEADOS
				, est.descripcion AS nivelstudios
				, est.id_estudios
				, ex.ocupacion AS ocupacion
				, ex.numDependientes AS numDependientes
				, cest.id_estado AS estado_nacimiento
				, cest.nombre AS estadonacimiento
				, pais.nombre_pais AS pais_residencia
				, paisn.nombre_pais AS pais_nacionalidad
				, cp.d_estado AS estado
				, cp.c_mnpio AS municipiodelegacionID
				, cp.D_mnpio AS municipio
				, cp.c_mnpio AS municipiodelegacion
				, pros.id_estadodom
				, tv.nombre AS tipo_residencia
				, tc.descripcion AS estadocivil
				, ex.correo	as correo
				, ex.comentario
				--, pros.mesanio_recidencia_ante
				, ex.profesion AS id_profesion
				, pros.id_sucursal AS idSucursal
				, depto.descripcion AS nombreSucursal
				, ex.tienecargopublico AS Tienecargopublic
				, ex.desccargopublico AS cargopublico
				, pros.pais_recidencia
				, CONVERT(varchar, ex.fechaAltaExpediente, 112) AS fechaAltaExpediente
				, CASE
					WHEN ex.tipotiempovivienda_anterior = 1 THEN CAST('Años' AS varchar)
					WHEN ex.tipotiempovivienda_anterior = 0 THEN CAST('Meses' AS varchar)
					ELSE 'N/A' END tipotiempovivienda_anterior
			FROM LEAP.dbo.tp_prospecto pros
				LEFT JOIN CATALOGOS.dbo.tc_estudios est ON (est.id_estudios = pros.id_estudios)
				LEFT JOIN LEAP.dbo.td_expediente ex ON (ex.idprospecto = pros.id_prospecto AND ex.idexpediente = (SELECT TOP 1 idexpediente FROM LEAP.dbo.td_expediente WHERE idprospecto = @prosId ORDER BY idexpediente ASC))
				LEFT JOIN LEAP.dbo.tc_estado cest ON (cest.id_estado = pros.estado_nacimiento)
				LEFT JOIN LEAP.dbo.tc_pais pais ON (pais.id_catalogo = pros.pais_recidencia)
				LEFT JOIN LEAP.dbo.tc_pais paisn ON (paisn.id_catalogo = pros.pais_nacionalidad)
				LEFT JOIN LEAP.dbo.tc_codigopostal cp ON (cp.d_codigo = pros.codigopostal)
				LEFT JOIN LEAP.dbo.tc_tipovivienda tv ON (tv.estatus = 1 AND tv.id_tipovivienda = pros.casa_propia)
				LEFT JOIN LEAP.dbo.tc_estado_civil tc ON (tc.id_estado = pros.estadocivil)
				LEFT JOIN LEAP.dbo.tc_tipotiempovivienda viv ON (viv.type_label_isi = pros.mesanio_recidencia)
				LEFT JOIN LEAP.dbo.tc_tipotiempovivienda viva ON (viva.type_label_isi = pros.mesanio_recidencia_ante)
				LEFT JOIN CATALOGOS.dbo.tc_departamento depto ON (depto.id_departamento = pros.id_sucursal)
			WHERE pros.id_prospecto = @prosId

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
				, pex.escolaridad AS idescolaridad
				, pex.actividad_profesion AS idprofesion
				, pex.pais_residencia AS idresidencia
				, pex.nacionalidad AS idnacionalidad
				,  CASE
					WHEN pex.tipo_tiempo = 1 THEN CAST(pex.anos_matrimonio AS varchar) + ' ' + 'Años'
					WHEN pex.tipo_tiempo = 0 THEN CAST(pex.anos_matrimonio AS varchar) + ' ' + 'Meses'
				ELSE 'N/A' END AS tiempo_matrimonio
				, pex.anos_matrimonio AS matrimonio
				, pex.tipo_tiempo AS idtiempomat
			FROM LEAP.dbo.td_persona_expediente pex
				LEFT JOIN CATALOGOS.dbo.tc_estudios est ON (est.id_estudios = pex.escolaridad)
				LEFT JOIN LEAP.dbo.tc_pais pais ON (pais.id_catalogo = pex.pais_residencia)
				LEFT JOIN LEAP.dbo.tc_pais paisn ON (paisn.id_catalogo = pex.nacionalidad)
				LEFT JOIN LEAP.dbo.tc_profesion prof ON (prof.id_profesion = pex.actividad_profesion)
			WHERE pex.id_prospecto = @prosId
				AND pex.id_tipo_persona = 1
		
			/* Datos económicos */
			set @idexpe = (select top 1 idexpediente from td_expediente where idprospecto=@prosId)

			exec sp_getEconomicData  @prosId,  @idexpe , @usuario, @cIp

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
				, pex.escolaridad AS idescolaridad
				, pex.actividad_profesion AS idprofesion
				, pex.pais_residencia AS idresidencia
				, pex.nacionalidad AS idnacionalidad
			FROM LEAP.dbo.td_persona_expediente pex
				LEFT JOIN CATALOGOS.dbo.tc_estudios est ON (est.id_estudios = pex.escolaridad)
				LEFT JOIN LEAP.dbo.tc_pais pais ON (pais.id_catalogo = pex.pais_residencia)
				LEFT JOIN LEAP.dbo.tc_pais paisn ON (paisn.id_catalogo = pex.nacionalidad)
				LEFT JOIN LEAP.dbo.tc_profesion prof ON (prof.id_profesion = pex.actividad_profesion)
				--LEFT JOIN LEAP.dbo.tp_referencia ref  ON (ref.id_prospecto = pex.id_prospecto)
			WHERE pex.id_prospecto = @prosId
				AND pex.id_tipo_persona = 2

			/* Datos referencias */
			SELECT
				ref.id_prospecto
				, ref.nombreReferencia
				, ref.paternoReferencia
				, ref.maternoReferencia
				, ref.relacionTitular
				, ref.telReferencia
				, tref.nombre AS tipo_referencia
				, CASE
					WHEN ref.tipoTiempoConocer = 1 THEN CAST(ref.tiempoConocer AS varchar) + ' ' + 'Años'
					WHEN ref.tipoTiempoConocer = 0 THEN CAST(ref.tiempoConocer AS varchar) + ' ' + 'Meses'
				ELSE CAST('N/A' AS varchar) END AS tiempo_conocer
				, ref.tipoTiempoConocer AS idtiempoconocer
				, ref.tiempoConocer AS totaltime
				, ref.tipoReferencia AS idtiporef
			FROM LEAP.dbo.tp_referencia ref
				LEFT JOIN LEAP.dbo.tc_tipoRef tref ON (tref.id_tipoRef = ref.tipoReferencia)
			WHERE ref.id_prospecto = @prosId

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
				, ex.antiguedadtipo AS idantiguedad
			FROM LEAP.dbo.td_expediente ex
				LEFT JOIN LEAP.dbo.tc_profesion prof ON (prof.id_profesion = ex.id_giroempresa)
			WHERE ex.idprospecto = @prosId
		END 
	END

END