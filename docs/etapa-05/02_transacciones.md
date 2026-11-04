# Etapa V: Temas Tecnicos — 2. Manejo de Transacciones

**Integrante:** Brenda Esquenazi  
**Archivo SQL:** `sql/tecnico/02_transacciones_ventas.sql`  


---

## 1. Definicion y objetivo

Una **transaccion** es una unidad logica de trabajo dentro de un motor de bases de datos relacional que agrupa un conjunto coordinado de sentencias de modificacion de datos (`INSERT`, `UPDATE`, `DELETE`)[cite: 5, 8]. Su funcionamiento se rige bajo el principio de indivisibilidad ("todo o nada"), garantizando el cumplimiento irrestricto de las propiedades **ACID** (Atomicidad, Consistencia, Aislamiento y Durabilidad):
- **Atomicidad:** Todas las operaciones contenidas en el bloque transaccional se confirman de forma conjunta (`COMMIT`) o, ante cualquier interrupcion o fallo imprevisto, se revierten en su totalidad (`ROLLBACK`), evitando modificaciones a medio camino.
- **Consistencia:** Asegura que la base de datos pase exclusivamente de un estado valido a otro estado valido, preservando todas las restricciones de integridad declaradas (`PRIMARY KEY`, `FOREIGN KEY`, `CHECK`).
- **Aislamiento:** Las operaciones intermedias ejecutadas por una transaccion permanecen invisibles para otras conexiones concurrentes hasta que se consolide la operacion, previniendo lecturas sucias y bloqueos anómalos.
- **Durabilidad:** Una vez confirmados los cambios mediante un `COMMIT`, el impacto queda asentado de manera permanente en el registro de transacciones (*transaction log*) y archivos de datos, resistiendo cortes de energia o caidas del servicio.

### Objetivo
El objetivo primordial de implementar transacciones en el modulo de ventas es **garantizar la atomicidad absoluta durante el circuito critico de facturacion y afectacion de inventario**. Se busca coordinar la creacion de la cabecera de orden, la insercion de sus items de compra y el correspondiente descuento de existencias fisicas en una unica operacion atómica[cite: 8], impidiendo que queden registradas ventas incompletas o que se descuente stock de mercaderia sin una venta legalmente respaldada[cite: 8, 9].

---

## 2. Ventajas, aplicaciones y consideraciones

### Ventajas
- **Garantia de consistencia operativa:** Previene la generacion de registros huerfanos en tablas dependientes (por ejemplo, registrar una cabecera de venta sin sus detalles correspondientes o viceversa)[cite: 8].
- **Sincronizacion de balances de stock:** Descuenta existencias en el catalogo exclusivamente cuando el comprobante de venta se ha guardado sin excepciones[cite: 8, 9].
- **Control estructurado de excepciones:** El empleo de bloques `BEGIN TRY ... BEGIN CATCH` permite interceptar cualquier violacion de reglas de negocio o fallos del motor, forzando la liberacion limpia de recursos mediante `ROLLBACK`[cite: 9].
- **Recuperacion automatica ante fallos:** En caso de fallas de conectividad durante la tramitacion de un carrito de compras, el motor restituye el estado previo de los datos sin intervencion manual[cite: 8, 9].

### Aplicaciones en el sistema de e-commerce
- Registracion integral de ordenes de pedido con impacto sincronizado en cabecera, detalle y stock de indumentaria[cite: 8].
- Procesamiento y conciliacion de cobros monetarios vinculados a facturas de venta.
- Anulacion y devolucion de ordenes comerciales con reposicion inmediata de unidades al inventario.

### Consideraciones y costo de mantenimiento
- Las transacciones abiertas retienen bloqueos (*locks*) sobre filas o tablas completas para mantener el aislamiento. Por ende, deben ser lo mas breves y directas posible para no generar contencion o bloqueos prolongados (*blocking/deadlocks*) en la plataforma web.
- Cada cambio genera registros en el log de transacciones (`LDF`), por lo que un volumen elevado de operaciones concurrentes requiere un monitoreo continuo de la persistencia y de la politica de backups.

---

## 3. Implementacion en SQL Server Express

En SQL Server Express, el manejo de transacciones explicitas se estructura a traves de las siguientes directivas de Transact-SQL[cite: 5, 9]:

1. **`BEGIN TRANSACTION`:**  
   Marca formalmente el punto de inicio de la unidad logica de trabajo y le indica al motor que comience a registrar los estados transitorios en el log de transacciones[cite: 9].

2. **`COMMIT TRANSACTION`:**  
   Consolida y persiste de forma definitiva todas las operaciones realizadas desde el inicio de la transaccion, liberando los bloqueos adquiridos[cite: 9].

3. **`ROLLBACK TRANSACTION`:**  
   Deshace la totalidad de las modificaciones efectuadas dentro del bloque, devolviendo la base de datos exactamente al estado en el que se encontraba antes de ejecutar el `BEGIN TRANSACTION`[cite: 8, 9].

4. **Bloques `TRY...CATCH` y la funcion `@@TRANCOUNT`:**  
   Permite estructurar una arquitectura robusta ante errores. Dentro del bloque `CATCH`, se evalua `IF @@TRANCOUNT > 0` para comprobar si existe una transaccion pendiente y forzar su reversion inmediata[cite: 9]:
   ```sql
   BEGIN TRY
       BEGIN TRANSACTION;
       -- Operaciones DML
       COMMIT TRANSACTION;
   END TRY
   BEGIN CATCH
       IF @@TRANCOUNT > 0
           ROLLBACK TRANSACTION;
       -- Notificacion del error
   END CATCH;
