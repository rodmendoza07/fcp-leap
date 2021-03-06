USE LEAP
GO

CREATE TABLE [dbo].[tp_prospectohist] (
	[id_prospectohist][int] IDENTITY(1,1) NOT NULL, 
	[id_prospecto] [int] NOT NULL CONSTRAINT tp_proshist_idProspecto DEFAULT 0,
	[nombre] [varchar](100) NOT NULL CONSTRAINT tp_proshist_nombre DEFAULT '',
	[paterno] [varchar](100) NOT NULL CONSTRAINT tp_proshist_paterno DEFAULT '',
	[materno] [varchar](100) NOT NULL CONSTRAINT tp_proshist_materno DEFAULT '',
	[CURP] [varchar](100) NOT NULL CONSTRAINT tp_proshist_curp DEFAULT '',
	[RFC] [varchar](100) NOT NULL CONSTRAINT tp_proshist_rfc DEFAULT '',
	[sexo] [char](1) NOT NULL CONSTRAINT tp_proshist_sex DEFAULT '',
	[fechanacimiento] [datetime] NOT NULL CONSTRAINT tp_proshist_fechanac DEFAULT GETDATE(),
	[estadocivil] [int] NOT NULL CONSTRAINT tp_proshist_edocivil DEFAULT 0,
	[direccion] [varchar](100) NOT NULL CONSTRAINT tp_proshist_direccion DEFAULT '',
	[calle] [varchar](100) NOT NULL CONSTRAINT tp_proshist_calle DEFAULT '',
	[numero] [varchar](100) NOT NULL CONSTRAINT tp_proshist_numero DEFAULT '',
	[numero_int] [varchar](100) NOT NULL CONSTRAINT tp_proshist_numeroint DEFAULT '',
	[codigopostal] [varchar](20) NOT NULL CONSTRAINT tp_proshist_cp DEFAULT '',
	[estado] [varchar](300) NOT NULL CONSTRAINT tp_proshist_estado DEFAULT '',
	[colonia] [varchar](300) NOT NULL CONSTRAINT tp_proshist_colonia DEFAULT '',
	[municipiodelegacion] [varchar](300) NOT NULL CONSTRAINT tp_proshist_municipio DEFAULT '',
	[ladatel1] [varchar](300) NOT NULL CONSTRAINT tp_proshist_lada1 DEFAULT '',
	[ladatel2] [varchar](300) NOT NULL CONSTRAINT tp_proshist_lada2 DEFAULT '',
	[telefono1] [varchar](300) NOT NULL CONSTRAINT tp_proshist_tel1 DEFAULT '',
	[telefono2] [varchar](300) NOT NULL CONSTRAINT tp_proshist_tel2 DEFAULT '',
	[casa_propia] [int] NOT NULL CONSTRAINT tp_proshist_casapropia DEFAULT 0,
	[tiempo_recidencia] [varchar](20) NOT NULL CONSTRAINT tp_proshist_tiempores DEFAULT '',
	[mesanio_recidencia] [varchar](20) NOT NULL CONSTRAINT tp_proshist_mesaniores DEFAULT '',
	[pais_recidencia] [varchar](200) NOT NULL CONSTRAINT tp_proshist_paisresi DEFAULT '',
	[pais_nacionalidad] [varchar](200) NOT NULL CONSTRAINT tp_proshist_paisnac DEFAULT '',
	[profesion_id] [varchar](10) NOT NULL CONSTRAINT tp_proshist_profesionid DEFAULT '',
	[profesion_label] [varchar](200) NOT NULL CONSTRAINT tp_proshist_profesionlabel DEFAULT '',
	[fecha_alta] [datetime] NOT NULL CONSTRAINT tp_proshist_fecalta DEFAULT GETDATE(),
	[usuario] [varchar](20) NOT NULL CONSTRAINT tp_proshist_usuario DEFAULT '',
	[estado_nacimiento] [varchar](200) NOT NULL CONSTRAINT tp_proshist_estadonac DEFAULT '',
	[tipo_recidencia] [int] NOT NULL CONSTRAINT tp_proshist_tiporesidencia DEFAULT 0,
	[id_estudios] [int] NOT NULL CONSTRAINT tp_proshist_estudios DEFAULT 0,
	[id_estadodom] [int] NOT NULL CONSTRAINT tp_proshist_estadodom DEFAULT 0,
	[estadodom_label] [varchar](200) NOT NULL CONSTRAINT tp_proshist_estadolab DEFAULT '',
	[referenciaDom] [varchar](200) NOT NULL CONSTRAINT tp_proshist_referenciadom DEFAULT '',
	[id_sucursal] [int] NOT NULL CONSTRAINT tp_proshist_sucursal DEFAULT 0,
	[edad] [int] NOT NULL CONSTRAINT tp_proshist_edad DEFAULT 0,
	[nacionalidad] [int] NOT NULL CONSTRAINT tp_proshist_nacionalidadid DEFAULT 0,
	[id_cte_isi] [int] NOT NULL CONSTRAINT tp_proshist_cteisi DEFAULT 0,
	[tiempo_recidencia_ante] [varchar](20) NOT NULL CONSTRAINT tp_proshist_tresant DEFAULT '',
	[mesanio_recidencia_ante] [varchar](20) NOT NULL CONSTRAINT tp_proshist_mresant DEFAULT '',
	[ip_useradd] [varchar](50) NOT NULL CONSTRAINT tp_proshist_useradd DEFAULT '',
	[id_clasificado_profesion] [int] NOT NULL CONSTRAINT tp_proshist_clasprof DEFAULT 0,
	[id_pais_nacionalidad] [int] NOT NULL CONSTRAINT tp_proshist_paisnacid DEFAULT 0,
	[id_pais_recidencia] [int] NOT NULL CONSTRAINT tp_proshist_paisresid DEFAULT 0,
	[c_pais] [int] NOT NULL CONSTRAINT tp_proshist_pais DEFAULT 0,
	[c_localidad] [varchar](13) NOT NULL CONSTRAINT tp_proshist_localidad DEFAULT '',
	[user_valida_prospecto] [varchar](15) NOT NULL CONSTRAINT tp_proshist_uservalpros DEFAULT '',
	[fecha_valida_prospecto] [datetime] NOT NULL CONSTRAINT tp_proshist_fechavalpros DEFAULT GETDATE(),
	[fecha_actualizacion][datetime] NOT NULL CONSTRAINT tp_proshist_actulizacion DEFAULT GETDATE(),
	[usuario_actualiza][varchar](100) NOT NULL CONSTRAINT tp_proshist_userupdate DEFAULT ''
)