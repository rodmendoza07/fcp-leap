USE [LEAP]
GO
/****** Object:  StoredProcedure [dbo].[sp_setProspectHist]    Script Date: 10/04/2018 04:51:42 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_setProspectHist](
	@udt_prospecto udt_prospectEXP READONLY
	, @udt_conyugue udt_conyuguereduced READONLY
	, @udt_obligado udt_obligadoreduced READONLY
	, @udt_ref udt_refreduced READONLY
	, @udt_job udt_jobreduced READONLY
	, @udt_prospast udt_prospectEXP READONLY
	, @leapuser VARCHAR(30) = ''
	, @typePerson VARCHAR(10) = ''
	, @isi_id_cte INT = 0
)
AS
BEGIN
	DECLARE
		@msg VARCHAR(300) = ''
		, @id_profile INT = 0
		, @countObligado INT = 0
		, @countConyugue INT = 0
		, @lastid INT = 0
		, @typecte INT = 0
		, @idExp INT = 0

	BEGIN TRY
		IF @typePerson = 'PRO' BEGIN 
			BEGIN TRAN
			UPDATE LEAP.dbo.tp_prospecto SET
				nombre  = udt_.nombre,paterno = udt_.paterno ,	materno =udt_.materno  ,
				CURP = udt_.CURP,		RFC =udt_.RFC ,
				sexo =udt_.sexo,		fechanacimiento = udt_.fechanacimiento  ,
				estadocivil = udt_.estadocivil  ,		direccion=udt_.direccion ,
				calle=udt_.calle  ,		numero=udt_.numero ,		numero_int=udt_.numero_int ,
				codigopostal=udt_.codigopostal ,		estado=udt_.estado  ,
				colonia=udt_.colonia  ,		municipiodelegacion =udt_.municipiodelegacion ,
				ladatel1 =udt_.ladatel1 ,		ladatel2 = udt_.ladatel2  ,
				telefono1=udt_.telefono1 ,		telefono2=udt_.telefono2 ,
				casa_propia=udt_.casa_propia ,		tiempo_recidencia =udt_.tiempo_recidencia ,
				pais_recidencia= udt_.pais_recidencia ,		pais_nacionalidad=udt_.pais_nacionalidad ,
				profesion_id=udt_.profesion_id  ,		profesion_label=udt_.profesion_label,  
				estado_nacimiento=udt_.estado_nacimiento,
				tipo_recidencia=udt_.tipo_recidencia, id_estudios = udt_.Id_estudios , 
				 referenciaDom =   udt_.referenciaDom , edad = udt_.edad , nacionalidad = udt_.nacionalidad
			FROM LEAP.dbo.tp_prospecto pro
			LEFT JOIN @udt_prospecto udt_ ON (udt_.IdProspect = pro.id_prospecto)
			WHERE udt_.IdProspect = pro.id_prospecto

			INSERT INTO LEAP.dbo.tp_prospectohist (
				nombre
				, paterno
				, materno
				, CURP
				, RFC
				, sexo
				, fechanacimiento
				, estadocivil
				, direccion
				, calle
				, numero
				, numero_int
				, codigopostal
				, estado
				, colonia
				, municipiodelegacion
				, ladatel1
				, ladatel2
				, telefono1
				, telefono2
				, casa_propia
				, tiempo_recidencia
				, pais_recidencia
				, pais_nacionalidad
				, profesion_id
				, profesion_label
				, estado_nacimiento
				, tipo_recidencia
				, id_estudios
				, referenciaDom
				, edad
				, nacionalidad
			) SELECT
				prosa.nombre
				, prosa.paterno
				, prosa.materno
				, prosa.CURP
				, prosa.RFC
				, prosa.sexo
				, prosa.fechanacimiento
				, prosa.estadocivil
				, prosa.direccion
				, prosa.calle
				, prosa.numero
				, prosa.numero_int
				, prosa.codigopostal
				, prosa.estado
				, prosa.colonia
				, prosa.municipiodelegacion
				, prosa.ladatel1
				, prosa.ladatel2
				, prosa.telefono1
				, prosa.telefono2
				, prosa.casa_propia
				, prosa.tiempo_recidencia
				, prosa.pais_recidencia
				, prosa.pais_nacionalidad
				, prosa.profesion_id
				, prosa.profesion_label
				, prosa.estado_nacimiento
				, prosa.tipo_recidencia
				, prosa.id_estudios
				, prosa.referenciaDom
				, prosa.edad
				, prosa.nacionalidad
			FROM @udt_prospast prosa

			SET @lastid = @@IDENTITY

			UPDATE LEAP.dbo.tp_prospectohist SET 
				usuario_actualiza = @leapuser
			WHERE id_prospectohist = @lastid

			SET @id_profile = isnull( (select top(1) idexpediente 
								from td_expediente
								where idprospecto = (select IdProspect FROM  @udt_prospecto)), 0 )

			IF (SELECT COUNT(*) FROM @udt_conyugue) > 0 BEGIN		
				INSERT INTO LEAP.dbo.td_persona_expediente(
					id_prospecto
					, nombre
					, apePaterno
					, apeMaterno
					, RFC
					, CURP
					, fecha_nacimiento
					, edad
					, telefono
					, escolaridad
					, ocupacion
					, actividad_profesion
					, nacionalidad
					, pais_residencia
					, tipo_tiempo
					, anos_matrimonio
				) SELECT
					*
				FROM @udt_conyugue
			END

			IF (SELECT COUNT(*) FROM @udt_obligado) > 0 BEGIN
				INSERT INTO LEAP.dbo.td_persona_expediente (
					id_prospecto
					, nombre
					, apePaterno
					, apeMaterno
					, RFC
					, CURP
					, fecha_nacimiento
					, edad
					, telefono
					, escolaridad
					, ocupacion
					, actividad_profesion
					, nacionalidad
					, pais_residencia
				) SELECT
					*
				FROM @udt_obligado
			END

			IF (SELECT COUNT(*) FROM @udt_ref ) > 0 BEGIN
				 INSERT INTO LEAP.dbo.tp_referencia (
					id_prospecto
					, nombreReferencia
					, paternoReferencia
					, maternoReferencia
					, relacionTitular
					, telReferencia
					, tipoTiempoConocer
					, tiempoConocer
					, tipoReferencia
				 ) SELECT
					*
				FROM @udt_ref		
			END
	
			IF (SELECT COUNT(*) FROM @udt_job) > 0 BEGIN
				INSERT INTO LEAP.dbo.td_expediente (
					idprospecto
					, empresa
					, id_giroempresa
					, antiguedadcantidad
					, telefonoTrabajo
					, extTelTrabajo
					, puesto
					, nombreJefeTrabajo
					, calletrabajo
					, numerotrabajo
					, coloniatrabajo
					, codigopostaltrabajo
					, antiguedadtipo
					, fechaAltaExpediente
				) SELECT 
					*
				FROM @udt_job
			END

			IF @@TRANCOUNT > 0 
				COMMIT TRAN
			ELSE
				ROLLBACK TRAN
				SET @msg = (SELECT SUBSTRING(ERROR_MESSAGE(), 1, 300))
		END
		ELSE IF @typePerson = 'CTE' BEGIN
			SELECT
				@typecte = id_prospecto
			FROM LEAP.dbo.tp_prospecto
			WHERE id_cte_isi = (SELECT id_prospecto FROM @udt_prospecto)

			IF @typecte = 0 BEGIN
				BEGIN TRAN
				INSERT INTO LEAP.dbo.tp_prospecto (
					nombre
					, paterno
					, materno
					, CURP
					, RFC
					, sexo
					, fechanacimiento
					, estadocivil
					, direccion
					, calle
					, numero
					, numero_int
					, codigopostal
					, estado
					, colonia
					, municipiodelegacion
					, ladatel1
					, ladatel2
					, telefono1
					, telefono2
					, casa_propia
					, tiempo_recidencia
					, pais_recidencia
					, pais_nacionalidad
					, profesion_id
					, profesion_label
					, estado_nacimiento
					, tipo_recidencia
					, id_estudios
					, referenciaDom
					, edad
					, nacionalidad
					, id_cte_isi
				) SELECT
					pros.nombre
					, pros.paterno
					, pros.materno
					, pros.CURP
					, pros.RFC
					, pros.sexo
					, pros.fechanacimiento
					, pros.estadocivil
					, pros.direccion
					, pros.calle
					, pros.numero
					, pros.numero_int
					, pros.codigopostal
					, pros.estado
					, pros.colonia
					, pros.municipiodelegacion
					, pros.ladatel1
					, pros.ladatel2
					, pros.telefono1
					, pros.telefono2
					, pros.casa_propia
					, pros.tiempo_recidencia
					, pros.pais_recidencia
					, pros.pais_nacionalidad
					, pros.profesion_id
					, pros.profesion_label
					, pros.estado_nacimiento
					, pros.tipo_recidencia
					, pros.id_estudios
					, pros.referenciaDom
					, pros.edad
					, pros.nacionalidad
					, @isi_id_cte
				FROM @udt_prospecto pros

				SET @id_profile = @@IDENTITY

				INSERT INTO LEAP.dbo.td_expediente (
					idprospecto
					, fechaAltaExpediente
				) VALUES (
					@id_profile
					, GETDATE()	
				)

				SET @idExp = @@IDENTITY

				UPDATE LEAP.dbo.td_expediente SET
					empresa = (SELECT empresa FROM @udt_job)
					, id_giroempresa  = (SELECT id_giroempresa FROM @udt_job)
					, antiguedadcantidad = (SELECT antiguedadcantidad FROM @udt_job)
					, telefonoTrabajo = (SELECT telefonoTrabajo FROM @udt_job)
					, extTelTrabajo = (SELECT extTelTrabajo FROM @udt_job)
					, puesto = (SELECT puesto FROM @udt_job)
					, nombreJefeTrabajo = (SELECT nombreJefeTrabajo FROM @udt_job)
					, calletrabajo = (SELECT calletrabajo FROM @udt_job)
					, numerotrabajo = (SELECT numerotrabajo FROM @udt_job)
					, coloniatrabajo = (SELECT coloniatrabajo FROM @udt_job)
					, codigopostaltrabajo = (SELECT codigopostaltrabajo FROM @udt_job)
					, antiguedadtipo = (SELECT antiguedadtipo FROM @udt_job)
				WHERE idexpediente = @idExp

				IF @@TRANCOUNT > 0 BEGIN
					COMMIT TRAN
					SELECT @id_profile AS prospect
				END
				ELSE
					ROLLBACK TRAN
					SET @msg = (SELECT SUBSTRING(ERROR_MESSAGE(), 1, 300))
			END

			--IF @typecte > 0 BEGIN
			
			--END

		END
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SET @msg = (SELECT SUBSTRING(ERROR_MESSAGE(), 1, 300))
		RAISERROR(@msg, 16, 1)
	END CATCH

END