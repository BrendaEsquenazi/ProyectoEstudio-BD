# Tema Técnico 3: Triggers de Auditoría y Control de Operaciones

**Responsable:** Paulina  
**Archivo SQL:** `sql/tecnico/03_triggers_auditoria.sql`  

---

### 1. Definición y Objetivo
Un *Trigger* (Disparador) es un objeto de programación almacenado que se ejecuta de manera automática e implícita en respuesta a un evento DML (`INSERT`, `UPDATE`, `DELETE`) sobre una tabla específica.

**Objetivo:** Garantizar la trazabilidad inmutable de los cambios de precios en los productos y proteger la integridad histórica de los comprobantes de ventas, impidiendo su eliminación física.

---

### 2. Ventajas y Aplicaciones
- **Trazabilidad Automática:** Permite responder quién, cuándo y qué valor exacto cambió sin depender del código fuente de la aplicación cliente.
- **Inviolabilidad de Datos:** Previene la pérdida accidentada o malintencionada de ventas registradas mediante triggers del tipo `INSTEAD OF`.
- **Transparencia:** Opera directamente en la capa del motor de base de datos SQL Server Express.

---

### 3. Implementación en SQL Server Express
Se utilizaron dos estrategias del motor:
1. **Trigger `AFTER UPDATE, DELETE`:** Utiliza las tablas del sistema `inserted` y `deleted` para capturar el estado previo y posterior a la modificación del precio en `Producto`.
2. **Trigger `INSTEAD OF DELETE`:** Intercepta la orden de borrado sobre `Venta_Cabecera`, frena la operación emitiendo un mensaje de error (`RAISERROR`) y ejecuta un `ROLLBACK`.

---

### 4. Caso Concreto Aplicado al Sistema de Ventas
- **Tabla Auditoría:** `Auditoria_Producto` (registra `id_producto`, `descripcion_anterior`, `precio_anterior`, `precio_nuevo`, `operacion`, `fecha_operacion`, `usuario_db`).
- **Tabla Controlada:** `Venta_Cabecera` (protege la facturación frente a borrados).

---

### 5. Resultados Obtenidos

| Operación Evaluada | Instrucción SQL | Comportamiento Esperado | Resultado en SQL Server |
| :--- | :--- | :--- | :--- |
| **Actualización de Precio** | `UPDATE Producto SET precio = precio + 1000 WHERE id_producto = 1;` | Registrar automáticamente el valor antiguo y nuevo en la auditoría. | **Exitoso.** Se inserta una fila en `Auditoria_Producto` con `operacion = 'UPDATE'`, usuario y fecha/hora exacta. |
| **Intento de Borrado de Venta** | `DELETE FROM Venta_Cabecera WHERE id_VentaCabecera = 1;` | Interceptar la acción, abortar la transacción y mostrar mensaje de error. | **Exitoso.** Operación denegada con mensaje `[SEGURIDAD / CONTROL]: No está permitido eliminar comprobantes...`. |