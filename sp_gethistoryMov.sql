USE [LEAP]
GO
/****** Object:  StoredProcedure [dbo].[sp_gethistoryMov]    Script Date: 13/04/2018 11:51:04 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[sp_gethistoryMov] (
	@idpro int =0
)
AS 
BEGIN
	SELECT 
		mov.id_mov_expe AS idm
		, mov.datemove AS datem
		, mov.usermove AS userm
		, mov.commentmove AS com
		, mov.id_etapa_prev AS fasem
		, CASE WHEN DATEDIFF(DAY, mov.datemove, GETDATE()) = 0 THEN 
			CAST(DATEDIFF(hh, mov.datemove, GETDATE()) as varchar) + ' Hrs'
		ELSE 
			CAST(DATEDIFF(DAY, mov.datemove, GETDATE()) as varchar) + ' Día'
		END as timeago
		, et.nombre AS [description]
	FROM LEAP.dbo.td_mov_expe mov
		INNER JOIN LEAP.dbo.tc_etapa et ON (mov.id_etapa_prev = et.id_etapa) 
	WHERE id_prospecto = @idpro
	ORDER BY mov.id_mov_expe ASC
END