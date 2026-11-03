-- =========================================================================
-- ETAPA V - TEMA TECNICO 4: SEGURIDAD, USUARIOS Y PERMISOS
-- Base de datos: EcommerceInd
--
-- Ejecutar en modo SQLCMD y definir AdminPassword y LecturaPassword como
-- variables en el cliente. No guardar contrasenas reales en este archivo.
-- La creacion de logins requiere permisos de sysadmin o securityadmin.
-- =========================================================================

USE master;
GO

-- 1. Verificar el modo de autenticacion del servidor.
SELECT
    CASE CONVERT(INT, SERVERPROPERTY('IsIntegratedSecurityOnly'))
        WHEN 1 THEN 'Autenticacion solo Windows'
        WHEN 0 THEN 'Modo mixto: Windows y SQL Server'
        ELSE 'No se pudo determinar el modo de autenticacion'
    END AS modo_autenticacion,
    CONVERT(INT, SERVERPROPERTY('IsIntegratedSecurityOnly')) AS solo_windows;
GO

-- 2. Crear logins SQL de demostracion. Si el servidor esta en modo solo
-- Windows, los logins no podran autenticarse hasta habilitar modo mixto
-- desde las propiedades del servidor y reiniciar el servicio.
IF SUSER_ID(N'login_ecommerce_admin') IS NULL
BEGIN
    CREATE LOGIN [login_ecommerce_admin]
    WITH PASSWORD = '$(AdminPassword)', CHECK_POLICY = ON;
END;
GO

IF SUSER_ID(N'login_ecommerce_lectura') IS NULL
BEGIN
    CREATE LOGIN [login_ecommerce_lectura]
    WITH PASSWORD = '$(LecturaPassword)', CHECK_POLICY = ON;
END;
GO

USE EcommerceInd;
GO

-- 3. Crear el procedimiento de consulta del catalogo.
CREATE OR ALTER PROCEDURE dbo.usp_ConsultarProductos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT id_producto, nombre, descripcion, precio_unitario, precio_mayorista
    FROM dbo.Producto
    ORDER BY nombre;
END;
GO

-- 4. Crear el rol de lectura y los usuarios de base de datos.
IF DATABASE_PRINCIPAL_ID(N'rol_lectura') IS NULL
    CREATE ROLE [rol_lectura];
GO

IF DATABASE_PRINCIPAL_ID(N'usr_ecommerce_admin') IS NULL
    CREATE USER [usr_ecommerce_admin] FOR LOGIN [login_ecommerce_admin];
GO

IF DATABASE_PRINCIPAL_ID(N'usr_ecommerce_lectura') IS NULL
    CREATE USER [usr_ecommerce_lectura] FOR LOGIN [login_ecommerce_lectura];
GO

IF IS_ROLEMEMBER(N'db_owner', N'usr_ecommerce_admin') <> 1
    ALTER ROLE [db_owner] ADD MEMBER [usr_ecommerce_admin];
GO

IF IS_ROLEMEMBER(N'rol_lectura', N'usr_ecommerce_lectura') <> 1
    ALTER ROLE [rol_lectura] ADD MEMBER [usr_ecommerce_lectura];
GO

-- Se limita la lectura a Producto para no exponer datos sensibles de Usuario.
GRANT SELECT ON OBJECT::dbo.Producto TO [rol_lectura];
GRANT EXECUTE ON OBJECT::dbo.usp_ConsultarProductos TO [rol_lectura];
GO

-- 5. Probar accesos permitidos para el usuario de solo lectura.
EXECUTE AS USER = N'usr_ecommerce_lectura';

SELECT TOP (5) id_producto, nombre, precio_unitario
FROM dbo.Producto
ORDER BY id_producto;

EXEC dbo.usp_ConsultarProductos;
REVERT;
GO

-- 6. Probar accesos denegados. Las escrituras usan filtros que no modifican
-- filas, incluso si por error el permiso estuviera concedido.
EXECUTE AS USER = N'usr_ecommerce_lectura';

BEGIN TRY
    EXEC sys.sp_executesql
        N'UPDATE dbo.Producto SET precio_unitario = precio_unitario WHERE 1 = 0;';
    PRINT 'ERROR: el usuario de lectura pudo ejecutar UPDATE.';
END TRY
BEGIN CATCH
    PRINT 'UPDATE denegado como se esperaba: ' + ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    EXEC sys.sp_executesql
        N'DELETE FROM dbo.Producto WHERE 1 = 0;';
    PRINT 'ERROR: el usuario de lectura pudo ejecutar DELETE.';
END TRY
BEGIN CATCH
    PRINT 'DELETE denegado como se esperaba: ' + ERROR_MESSAGE();
END CATCH;

REVERT;
GO

-- 7. Comprobar que el usuario administrador tiene permisos amplios sin
-- realizar modificaciones sobre los datos del proyecto.
EXECUTE AS USER = N'usr_ecommerce_admin';

SELECT
    USER_NAME() AS usuario_actual,
    IS_ROLEMEMBER(N'db_owner') AS pertenece_a_db_owner,
    HAS_PERMS_BY_NAME(N'dbo.Producto', N'OBJECT', N'SELECT') AS puede_leer_producto,
    HAS_PERMS_BY_NAME(N'dbo.Producto', N'OBJECT', N'UPDATE') AS puede_actualizar_producto;

REVERT;
GO