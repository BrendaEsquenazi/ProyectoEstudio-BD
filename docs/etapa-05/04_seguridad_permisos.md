# Etapa V: Temas Técnicos — 4. Seguridad, usuarios y permisos

**Integrante:** Lucas Franco  
**Archivo SQL:** `sql/tecnico/04_seguridad_permisos.sql`  
**Base de datos:** `EcommerceInd`

---

## 1. Definición y objetivo

La seguridad de una base de datos controla quién puede autenticarse en el servidor y qué acciones puede realizar sobre sus objetos. En SQL Server, los **logins** permiten conectarse a la instancia, los **usuarios** representan esos logins dentro de una base de datos y los **roles** agrupan permisos para asignarlos de forma coherente.

### Objetivo

Aplicar una separación de responsabilidades en `EcommerceInd` mediante dos perfiles:
- **Administrador:** usuario con permisos amplios para administrar la base de datos.
- **Solo lectura:** usuario limitado a consultar el catálogo y ejecutar un procedimiento de consulta.

El ejercicio también verifica el modo de autenticación de la instancia y comprueba operaciones permitidas y denegadas.

---

## 2. Ventajas y consideraciones

### Ventajas
- **Mínimo privilegio:** el perfil de lectura recibe permisos específicos sobre `Producto`, sin acceso a las tablas con datos personales.
- **Administración centralizada:** el rol `rol_lectura` agrupa los permisos de consulta y puede asignarse a varios usuarios.
- **Control de operaciones:** se concede explícitamente `EXECUTE` sobre el procedimiento almacenado, además del permiso de lectura.
- **Separación de responsabilidades:** el perfil administrador y el perfil de consulta tienen alcances distintos.

### Consideraciones
- La creación de logins requiere permisos administrativos de servidor, como `sysadmin` o `securityadmin`.
- Los logins SQL necesitan que SQL Server esté configurado en modo mixto (autenticación de Windows y SQL Server). Si la instancia está configurada solo para Windows, debe cambiarse esa opción y reiniciarse el servicio para poder conectarse con los logins SQL.
- Las contraseñas se proporcionan mediante variables SQLCMD y no deben guardarse en el repositorio.
- `db_owner` concede control amplio sobre la base de datos. Se usa para representar al administrador en esta demostración; en producción conviene asignar permisos administrativos más acotados según las tareas requeridas.

---

## 3. Implementación en SQL Server

El script implementa las siguientes partes:

1. **Verificación de autenticación:** consulta `SERVERPROPERTY('IsIntegratedSecurityOnly')`. El valor `1` indica autenticación solo Windows y `0` indica modo mixto.
2. **Logins de servidor:** crea `login_ecommerce_admin` y `login_ecommerce_lectura` con directiva de contraseña habilitada. La creación se realiza solo si los logins no existen.
3. **Procedimiento almacenado:** define `dbo.usp_ConsultarProductos`, que devuelve los campos de consulta del catálogo desde `dbo.Producto`.
4. **Usuarios y roles:** crea los usuarios de base de datos asociados a sus logins. Asigna el usuario administrador a `db_owner` y el de lectura a `rol_lectura`.
5. **Permisos específicos:** concede `SELECT` sobre `dbo.Producto` y `EXECUTE` sobre `dbo.usp_ConsultarProductos` al rol de lectura.

Para mantener las credenciales fuera del archivo, se debe ejecutar en modo SQLCMD y definir las variables `AdminPassword` y `LecturaPassword` desde el cliente. La primera parte del script requiere permisos de servidor; las operaciones sobre `EcommerceInd` requieren permisos suficientes en esa base de datos.

---

## 4. Caso concreto aplicado al e-commerce

El equipo necesita que un usuario pueda consultar los productos disponibles sin recibir permisos para alterar el catálogo ni consultar datos personales de clientes. Para ello, el rol `rol_lectura` recibe acceso de lectura únicamente a `dbo.Producto` y permiso para ejecutar `dbo.usp_ConsultarProductos`.

El usuario `usr_ecommerce_admin`, en cambio, pertenece a `db_owner` y representa el perfil que administra la base de datos. Esta separación permite demostrar que los permisos se asignan según la función del usuario y no de forma indiscriminada.

---

## 5. Pruebas y resultados esperados

El script usa `EXECUTE AS USER` para probar permisos dentro de la base de datos sin conectarse con cada login por separado.

| Operación evaluada | Perfil | Comportamiento esperado |
| :--- | :--- | :--- |
| Consultar filas de `dbo.Producto` | Solo lectura | Permitido por el `GRANT SELECT` asignado al rol. |
| Ejecutar `dbo.usp_ConsultarProductos` | Solo lectura | Permitido por el `GRANT EXECUTE` asignado al rol. |
| Ejecutar `UPDATE` sobre `dbo.Producto` | Solo lectura | Denegado por falta de permiso de modificación. La sentencia filtra con `WHERE 1 = 0` para evitar cambios si la configuración fuera incorrecta. |
| Ejecutar `DELETE` sobre `dbo.Producto` | Solo lectura | Denegado por falta de permiso de eliminación. También utiliza `WHERE 1 = 0`. |
| Consultar y verificar permisos sobre `dbo.Producto` | Administrador | Debe pertenecer a `db_owner` y tener permisos de lectura y actualización. |

**Estado de validación:** estos son los comportamientos previstos por el script. No se ejecutó contra una instancia de SQL Server en esta revisión; los resultados reales deben confirmarse al correrlo en el entorno del equipo.

---

## 6. Conclusiones

1. Los logins, usuarios de base de datos y roles cumplen funciones distintas y deben configurarse en sus respectivos niveles.
2. Un rol de lectura con permisos explícitos sobre los objetos necesarios limita el acceso a la información y evita conceder capacidades de escritura.
3. El permiso `EXECUTE` permite exponer una operación almacenada sin otorgar permisos generales de modificación.
4. La verificación del modo de autenticación y el manejo externo de contraseñas son requisitos importantes para desplegar el esquema de seguridad.