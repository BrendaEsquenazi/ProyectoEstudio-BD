# ProyectoEstudio-BD: Plataforma E-commerce de Indumentaria

Base de datos relacional desarrollada para la materia **Bases de Datos I** (Licenciatura en Sistemas). El proyecto abarca el ciclo de vida completo del diseño e implementación de una base de datos relacional en **Microsoft SQL Server**, desde el relevamiento del caso de negocio hasta la implementación de mecanismos técnicos avanzados (DDL, DML, consultas analíticas, transacciones ACID, triggers de auditoría, seguridad RBAC y optimización de índices sobre grandes volúmenes).

---

## 📌 Descripción del Caso de Negocio

El sistema modela una **plataforma e-commerce de indumentaria femenina y masculina**, orientada a centralizar el catálogo comercial con sus variantes físicas (talle y color), el control de inventario en tiempo real, el flujo de ventas con múltiples medios de pago, el abastecimiento mediante órdenes de compra a proveedores y el resguardo de precios históricos sin alterar operaciones pasadas.

### Actores del Sistema
- **Clientes / Usuarios:** Navegan el catálogo, consultan variantes, registran órdenes de compra y realizan pagos.
- **Administradores:** Gestionan productos, fijan listas de precios mayoristas y minoristas, actualizan inventarios y auditan cambios.
- **Proveedores:** Abastecen el stock de variantes mediante órdenes de compra registradas en el sistema.

---

## 👥 Integrantes y Roles (Equipo 01)

| Integrante | Módulo / Especialidad Técnica |
| :--- | :--- |
| **Iara** | Procedimientos y Funciones Almacenadas |
| **Brenda** | Manejo de Transacciones (ACID & Control de Concurrencia) |
| **Paulina** | Triggers de Auditoría y Trazabilidad de Cambios |
| **Lucas** | Seguridad, Gestión de Usuarios, Logins y Roles (RBAC) |
| **Gonzalo** | Facturación, Análisis de Clientes y Optimización de Consultas e Índices |

---

## 🗂️ Estructura del Repositorio

El repositorio está estructurado por etapas evolutivas y áreas técnicas:

```plaintext
ProyectoEstudio-BD/
│
├── docs/                                # Documentación de entregas por etapa
│   ├── etapa-01/                        # Caso de negocio y reglas de dominio
│   ├── etapa-02/                        # Modelo Relacional, Normalización (3FN) y DER
│   ├── etapa-04/                        # Casos de Uso y especificación de consultas
│   └── etapa-05/                        # Informes y justificaciones de temas técnicos
│       ├── 02_transacciones.sql         # Demostración de atomicidad en transacciones
│       ├── 03_triggers_auditoria.md     # Documentación de auditoría y triggers
│       └── 05_optimizacion_consultas.md # Estudio de rendimiento, lecturas lógicas e índices
│
├── sql/
│   ├── ddl/                             # Definición de estructuras (tablas, constraints, FKs)
│   │   ├── 01_base.sql                  # Direcciones, roles y usuarios
│   │   ├── 02_catalogo.sql              # Categorías, talles y productos
│   │   ├── 03_variantes.sql             # Colores, variantes de producto y proveedores
│   │   ├── 04_ventas.sql                # Métodos de pago, ventas cabecera/detalle y pagos
│   │   └── 05_compras.sql               # Órdenes de compra y compras detalle
│   │
│   ├── dml/                             # Poblado de datos maestros e iniciales
│   │   ├── 01_base.sql
│   │   ├── 02_catalogo.sql
│   │   ├── 03_variantes.sql
│   │   ├── 04_ventas.sql
│   │   └── 05_compras.sql
│   │
│   ├── consultas/                       # Consultas operativas, analíticas y reportes
│   │   ├── 01_facturacion.sql           # Factura detallada, tickets de cambio y presupuestos
│   │   ├── 02_reporte_agregado.sql      # Métricas de ventas agrupadas por categoría
│   │   ├── 03_consulta_avanzada.sql     # Detección de productos de alto valor y bajo stock
│   │   ├── 05_analisis_de_clientes.sql  # Ranking de clientes VIP y distribución geográfica
│   │   ├── 06_analisis_compras_proveedores.sql # Reporte de compras y abastecimiento
│   │   └── validaciones_ventas_pagos.sql# Comprobaciones de consistencia relacional
│   │
│   └── tecnico/                         # Implementaciones avanzadas del motor (Etapa V)
│       ├── 03_triggers_auditoria.sql    # Triggers AFTER UPDATE/DELETE e integridad
│       ├── 04_seguridad_permisos.sql    # Usuarios, logins, roles y permisos mínimos
│       └── 05_optimizacion_indices.sql  # Banco de pruebas con 1.000.000 de filas e índices
│
└── manifiestos/                         # Aportes individuales por integrante y etapa
    ├── equipo01_etapa3_46245096.md
    ├── equipo01_etapaIV_46245096.md
    └── equipo01_etapaV_46245096.md
```

---

## ⚙️ Guía de Ejecución y Puesta en Marcha

Para desplegar la base de datos completa de forma consistente, se debe seguir el orden estricto de dependencias en SQL Server:

### 1. Creación de la Base de Datos
```sql
CREATE DATABASE EcommerceInd;
GO
USE EcommerceInd;
GO
```

### 2. Ejecución DDL (Estructuras y Constraints)
1. `sql/ddl/01_base.sql` (`direccion`, `rol`, `usuario`)
2. `sql/ddl/02_catalogo.sql` (`Categoria`, `Talle`, `Producto`)
3. `sql/ddl/03_variantes.sql` (`color`, `variante_producto`, `proveedor`)
4. `sql/ddl/04_ventas.sql` (`metodo_pago`, `Venta_Cabecera`, `Venta_Detalle`, `Pago`)
5. `sql/ddl/05_compras.sql` (`Compra`, `Detalle_Compra`)

### 3. Ejecución DML (Carga de Datos Iniciales)
Ejecutar los scripts correspondientes en `sql/dml/` respetando la misma secuencia (del `01` al `05`).

### 4. Consultas y Reportes
Los scripts analíticos en `sql/consultas/` pueden ejecutarse sobre la base activa para obtener métricas comerciales, facturación de clientes y seguimiento de inventarios.

### 5. Mecanismos Técnicos Avanzados (Etapa V)
- **Triggers y Auditoría:** `sql/tecnico/03_triggers_auditoria.sql`
- **Seguridad y Permisos:** `sql/tecnico/04_seguridad_permisos.sql`
- **Optimización e Índices (1M filas):** `sql/tecnico/05_optimizacion_indices.sql`
