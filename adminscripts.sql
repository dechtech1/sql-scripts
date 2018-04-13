-- Moving a DB
USE master;
GO

-- Return the logical file name.  
SELECT name, physical_name AS CurrentLocation, state_desc
FROM sys.master_files
WHERE database_id = DB_ID(N'[]')
GO

ALTER DATABASE [] SET OFFLINE WITH ROLLBACK IMMEDIATE;
GO

-- Physically move the file to a new location.  
-- In the following statement, modify the path specified in FILENAME to  
-- the new location of the file on your server.  
ALTER DATABASE []
    MODIFY FILE ( NAME = [],
                  FILENAME = 'E:\Data\[].mdf');
GO

ALTER DATABASE []
    MODIFY FILE ( NAME = []_log,
                  FILENAME = 'G:\Logs\[]_log.ldf');
GO

ALTER DATABASE [] SET ONLINE;
GO

--Verify the new location.  
SELECT name, physical_name AS CurrentLocation, state_desc
FROM sys.master_files
WHERE database_id = DB_ID(N'[]')
GO
-- End

/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1601)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO

/****** Object:  View [dbo].[vwExecQueries]    Script Date: 2018-04-13 16:39:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwExecQueries] AS
	SELECT
		execquery.last_execution_time AS [Date Time],
		execsql.text AS [Script]
	FROM
		sys.dm_exec_query_stats AS execquery
	CROSS APPLY
		sys.dm_exec_sql_text(execquery.sql_handle) AS execsql
GO

/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1601)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO

/****** Object:  View [dbo].[vwJobs]    Script Date: 2018-04-13 16:41:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwJobs] AS
SELECT
    [sJOB].[job_id] AS [JobID]
    , [sJOB].[name] AS [JobName]
    , [sJSTP].[step_uid] AS [StepID]
    , [sJSTP].[step_id] AS [StepNo]
    , [sJSTP].[step_name] AS [StepName]
    , CASE [sJSTP].[subsystem]
        WHEN 'ActiveScripting' THEN 'ActiveX Script'
        WHEN 'CmdExec' THEN 'Operating system (CmdExec)'
        WHEN 'PowerShell' THEN 'PowerShell'
        WHEN 'Distribution' THEN 'Replication Distributor'
        WHEN 'Merge' THEN 'Replication Merge'
        WHEN 'QueueReader' THEN 'Replication Queue Reader'
        WHEN 'Snapshot' THEN 'Replication Snapshot'
        WHEN 'LogReader' THEN 'Replication Transaction-Log Reader'
        WHEN 'ANALYSISCOMMAND' THEN 'SQL Server Analysis Services Command'
        WHEN 'ANALYSISQUERY' THEN 'SQL Server Analysis Services Query'
        WHEN 'SSIS' THEN 'SQL Server Integration Services Package'
        WHEN 'TSQL' THEN 'Transact-SQL script (T-SQL)'
        ELSE sJSTP.subsystem
      END AS [StepType]
    , [sPROX].[name] AS [RunAs]
    , [sJSTP].[database_name] AS [Database]
    , [sJSTP].[command] AS [ExecutableCommand]
    , CASE [sJSTP].[on_success_action]
        WHEN 1 THEN 'Quit the job reporting success'
        WHEN 2 THEN 'Quit the job reporting failure'
        WHEN 3 THEN 'Go to the next step'
        WHEN 4 THEN 'Go to Step: ' 
                    + QUOTENAME(CAST([sJSTP].[on_success_step_id] AS VARCHAR(3))) 
                    + ' ' 
                    + [sOSSTP].[step_name]
      END AS [OnSuccessAction]
    , [sJSTP].[retry_attempts] AS [RetryAttempts]
    , [sJSTP].[retry_interval] AS [RetryInterval (Minutes)]
    , CASE [sJSTP].[on_fail_action]
        WHEN 1 THEN 'Quit the job reporting success'
        WHEN 2 THEN 'Quit the job reporting failure'
        WHEN 3 THEN 'Go to the next step'
        WHEN 4 THEN 'Go to Step: ' 
                    + QUOTENAME(CAST([sJSTP].[on_fail_step_id] AS VARCHAR(3))) 
                    + ' ' 
                    + [sOFSTP].[step_name]
      END AS [OnFailureAction]
FROM
    [msdb].[dbo].[sysjobsteps] AS [sJSTP]
    INNER JOIN [msdb].[dbo].[sysjobs] AS [sJOB]
        ON [sJSTP].[job_id] = [sJOB].[job_id]
    LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sOSSTP]
        ON [sJSTP].[job_id] = [sOSSTP].[job_id]
        AND [sJSTP].[on_success_step_id] = [sOSSTP].[step_id]
    LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sOFSTP]
        ON [sJSTP].[job_id] = [sOFSTP].[job_id]
        AND [sJSTP].[on_fail_step_id] = [sOFSTP].[step_id]
    LEFT JOIN [msdb].[dbo].[sysproxies] AS [sPROX]
        ON [sJSTP].[proxy_id] = [sPROX].[proxy_id]

GO

/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1601)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO

/****** Object:  View [dbo].[vwProcedures]    Script Date: 2018-04-13 16:41:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwProcedures] AS
	SELECT
		object_id ProcedureId,
		'[' + OBJECT_SCHEMA_NAME(object_id) + '].[' + OBJECT_NAME(object_id) + ']' ProcedureName,
		OBJECT_DEFINITION(object_id) [ExecutableCommand]
	FROM
		sys.procedures
GO

/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1601)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO

/****** Object:  View [dbo].[vwTables]    Script Date: 2018-04-13 16:42:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTables] AS
	SELECT
		tb.object_id TableId,
		'[' + OBJECT_SCHEMA_NAME(tb.object_id) + '].[' + OBJECT_NAME(tb.object_id) + ']' TableName,
		cl.name ColumnName
	FROM
		sys.tables tb
	INNER JOIN
		sys.columns cl
	ON 
		tb.object_id = cl.object_id
GO

/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1601)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO

/****** Object:  View [dbo].[vwViews]    Script Date: 2018-04-13 16:42:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwViews] AS
	SELECT
		OBJECT_ID ViewId,
		OBJECT_NAME(OBJECT_ID) ViewName,
		OBJECT_DEFINITION(OBJECT_ID) [ExecutableCommand]
	FROM
		sys.views
GO

/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1601)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO

/****** Object:  StoredProcedure [dbo].[sp_lookup]    Script Date: 2018-04-13 16:48:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_lookup] @keyword varchar(max) AS
	SELECT * FROM vwJobs WHERE [ExecutableCommand] LIKE '%' + @keyword + '%' ORDER BY [JobName], [StepNo]
	SELECT * FROM vwProcedures WHERE [ExecutableCommand] LIKE '%' + @keyword + '%' ORDER BY [ProcedureName]
	SELECT * FROM vwTables WHERE [TableName] LIKE '%' + @keyword + '%' OR [ColumnName] LIKE '%' + @keyword + '%' ORDER BY [TableName], [ColumnName]
	SELECT * FROM vwViews WHERE [ExecutableCommand] LIKE '%' + @keyword + '%' ORDER BY [ViewName]
GO

/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1601)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO

/****** Object:  StoredProcedure [dbo].[spConcatSELECT]    Script Date: 2018-04-13 16:49:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spConcatSELECT] 
	(@@tblName nvarchar(max),--Table to query
	@@fldName nvarchar(max),--Column to query
	@@sep nvarchar(1) = ',',--separator; comma is the default
	@@strtype bit,--character to define the use of the string; 1 for single string, 0 for fieldName
	@strlist nvarchar(max) output --Output Parameter, string that will be created
	) AS

declare @@strselect nvarchar(max)
	set @@strselect = N'SELECT [' + @@fldName +'] FROM  [' + @@tblName  + ']'
declare @begField nvarchar(1)
	IF @@strtype = 1 SET @begField = '''' ELSE SET @begField = '[' 
declare @endField nvarchar(1)
	IF @@strtype = 1 SET @endField = '''' ELSE SET @endField = ']' 

IF OBJECT_ID('tempdb..#Items') IS NOT NULL DROP TABLE #Items
create table #Items([id] [int] IDENTITY(1,1) NOT NULL,[Items] nvarchar(max))
INSERT INTO #Items EXECUTE sp_executesql @@strselect

declare @countRows int
	set @countRows = (SELECT COUNT(*) FROM #Items)

set @strlist = @begField + (SELECT [Items] FROM #Items where [id] = @countRows) + @endField
	set @countRows = @countRows - 1

WHILE @countRows > 0
BEGIN
	set @strlist = @strlist + @@sep + @begField + (SELECT [Items] FROM #Items where [id] = @countRows)  + @endField
set @countRows = @countRows - 1
END
RETURN
GO

/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1601)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO

/****** Object:  StoredProcedure [dbo].[spUnZipFile]    Script Date: 2018-04-13 16:54:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spUnZipFile] (@Ruta VARCHAR(8000), @ZipFile VARCHAR(8000), @Ruta_d nvarchar(1000))
AS
declare @Result INT, @WinUnzip VARCHAR(8000), @Delete varchar(8000)

	SET @WinUnzip = 'C:\7-Zip\7z.exe e "' + @Ruta + @ZipFile + '" -o"' + @Ruta_d + '" -aou';
	PRINT @WinUnzip;

	EXEC @Result = master..xp_cmdShell @WinUnzip, no_output
	print @Result
	SET @Delete = 'del "' + @Ruta + @ZipFile+'"';
	IF @Result = 0
		BEGIN;
		PRINT @Delete;
		EXEC @Result = master.dbo.XP_CMDSHELL @Delete, no_output;
		END;
	ELSE
		PRINT 'Extraction failed, error code: ' + CAST(@Result AS nvarchar);
GO

/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1601)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO

/****** Object:  StoredProcedure [dbo].[spZipFile]    Script Date: 2018-04-13 16:54:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Diego Rivero
-- Create date: 2017-09-27
-- Description:	Compresses the specified file to a .zip folder
-- =============================================
CREATE PROCEDURE [dbo].[spZipFile] (@Ruta VARCHAR(8000), @Archivo VARCHAR(8000)) AS
	DECLARE @WinZip VARCHAR(8000),
			@ZipName VARCHAR(8000),
			@WinDel VARCHAR(8000),
			@Result INT
	SET @ZipName = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(16), GETDATE(), 120), '-', ''), ':', ''), ' ', '') --Adds the date and time in format yyyyMMddHHmm
				   + '_' + @Archivo + '.ZIP' --Adds the filename in .zip format
	SET @WINZIP = 'C:\7-Zip\7z.exe a "' + @Ruta + @ZipName + '" "' + @Ruta + @Archivo + '"' -- Adds the arguments for the 7z executable
	PRINT @winzip
	EXEC @Result = master.dbo.xp_cmdshell @Winzip, no_output
	SET @WinDel = 'del "' + @Ruta + @Archivo + '"'
	IF @Result = 0
	BEGIN
		PRINT @WinDel
		EXEC master.dbo.xp_cmdshell @WinDel, no_output
	END
	ELSE
		PRINT 'Compression failed, error code: ' + CAST(@Result AS VARCHAR)
GO

/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1601)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO

/****** Object:  UserDefinedFunction [dbo].[DATETIMETOUNIX]    Script Date: 2018-04-13 16:57:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Diego Rivero
-- Create date: 2017-11-30
-- Description:	Converts a sql datetime to a unix timestamp
-- =============================================
CREATE FUNCTION [dbo].[DATETIMETOUNIX] 
(
	-- Add the parameters for the function here
	@datetime datetime
)
RETURNS bigint
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result bigint

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = DATEDIFF(SECOND, '1970-01-01', @datetime)

	-- Return the result of the function
	RETURN @Result

END
GO

/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1601)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO

/****** Object:  UserDefinedFunction [dbo].[DIV0]    Script Date: 2018-04-13 16:58:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Diego Rivero
-- Create date: 2018-02-06
-- Description:	Returns a default value if the denominator of a fraction is 0
-- =============================================
CREATE FUNCTION [dbo].[DIV0] 
(
	-- Add the parameters for the function here
	@Numerator float,
	@Denonimator float,
	@Default float
)
RETURNS float
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result float

	-- Add the T-SQL statements to compute the return value here
	IF @Denonimator <> 0
		SELECT @Result = @Numerator/@Denonimator
	ELSE
		SELECT @Result = @Default

	-- Return the result of the function
	RETURN @Result

END
GO

/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1601)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO

/****** Object:  UserDefinedFunction [dbo].[EXCELTODATETIME]    Script Date: 2018-04-13 16:58:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Diego Rivero
-- Create date: 2017-10-05
-- Description:	Converts the Excel serial time format to the specified date/time format
-- =============================================
CREATE FUNCTION [dbo].[EXCELTODATETIME] 
(
	-- Add the parameters for the function here
	@serialdatetime float
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result datetime

	-- Add the T-SQL statements to compute the return value here
	SET @Result = DATEADD(MS, (ABS(@serialdatetime) - FLOOR(ABS(@serialdatetime))) * 86400000, DATEADD(DD, CAST(@serialdatetime AS int) - 2, '1900-01-01'))

	-- Return the result of the function
	RETURN @Result

END
GO

/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1601)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO

/****** Object:  UserDefinedFunction [dbo].[UNIXTODATETIME]    Script Date: 2018-04-13 16:58:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Diego Rivero
-- Create date: 2017-11-30
-- Description:	Converts a unix timestamp to a sql datetime
-- =============================================
CREATE FUNCTION [dbo].[UNIXTODATETIME] 
(
	-- Add the parameters for the function here
	@datetime bigint
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result datetime

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = DATEADD(SECOND, @Datetime, '1970-01-01 00:00:00')

	-- Return the result of the function
	RETURN @Result

END
GO

/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1601)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [master]
GO

/****** Object:  UserDefinedFunction [dbo].[Interval]    Script Date: 2018-04-13 16:59:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Javier Chacon
-- Create date: 2017-10-11
-- Description:	Trae el intervalo inferior definido en segundos (60 minutos, por defecto)
-- =============================================
CREATE FUNCTION [dbo].[Interval] 
(
	-- Add the parameters for the function here
	@datetime datetime,
	@type tinyint = 0,
	@minutes int = 60
)
RETURNS datetime
AS
BEGIN
	DECLARE @trSegs int = 60 * @minutes
	DECLARE @bDT datetime = cast(cast(@datetime as date) as datetime)
	DECLARE @segs bigint = DATEDIFF(SECOND,@bDT,@datetime)
	RETURN (SELECT DATEADD(second,(@type*@minutes*60)+@trSegs*FLOOR(@segs/@trSegs),@bDT))
END

GO

