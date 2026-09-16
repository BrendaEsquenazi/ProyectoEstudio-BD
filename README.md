# ProyectoEstudio-BD

Integrantes:
Azula, Iara Elizabeth DNI: 42.753.256

//Esquenazi, Brenda DNI: 43.822.753

Fernandez Gomez, Gonzalo DNI: 46.245.096

Franco, Lucas DNI: 46.243.358

Galeano, Paulina. DNI: 45.097.063

Título del tema: Diseño e implementación de una base de datos para una plataforma e-commerce de venta y gestión de indumentaria


Descripción completa del caso

El proyecto se centra en un e-commerce de indumentaria femenina y masculina. El negocio busca digitalizar y optimizar sus canales de comercialización a través de una plataforma web que permita a los clientes consultar un catálogo clasificado por categorías y talles, registrarse como usuarios, gestionar un carrito de compras y concretar pedidos con diversos medios de pago. Paralelamente, el sistema proporciona al equipo de administración herramientas para controlar el inventario en tiempo real, actualizar precios de catálogo sin alterar órdenes históricas y auditar transacciones.

Alcance del sistema

Módulo de Clientes: Registro de usuarios, autenticación, gestión de datos personales y direcciones de envío.
Módulo de Catálogo y Productos: Consulta de prendas por categoría/talle y disponibilidad.
Módulo de Pedidos y Ventas: Gestión del carrito, confirmación de compra y emisión de órdenes de pedido detalladas.
Módulo de Stock: Descuento automático de unidades tras la confirmación del pago y alertas por bajo stock.
Módulo de Pagos: Registro de transacciones con múltiples medios de pago (tarjeta de crédito/débito, transferencia bancaria, pasarelas de pago virtuales).
Módulo de consultas: Asesoramiento respecto a talles y/o cualquier otra consulta.

Fuera del alcance:
Seguimiento en tiempo real por GPS de envíos logísticos (se gestiona mediante enlaces externos provistos por correos terceros).
Facturación fiscal integrada con webservices gubernamentales (AFIP u homólogos), limitándose al registro interno de comprobantes de venta.
Reglas de Negocio
RN.01 - Registro Único de Clientes: Todo cliente debe registrarse proporcionando obligatoriamente nombre, apellido, documento de identidad (DNI/CUIT), dirección física y una casilla de correo electrónico válida, la cual actúa como identificador único para evitar cuentas duplicadas.
RN.02 - Congelamiento del precio histórico: Cada ítem incluido en el detalle de una venta debe registrar el precio unitario vigente al momento de confirmar el pedido. Las modificaciones posteriores del precio del producto no deben alterar el precio registrado en ventas ya realizadas.
RN.03 - Validación y Reserva de Stock: No se permite confirmar una compra si la cantidad solicitada supera el stock disponible en almacén. Al momento de iniciar el proceso de checkout, los productos quedan reservados temporalmente por un lapso máximo de 15 minutos; si no se registra el pago en dicho lapso, las unidades retornan automáticamente al inventario disponible.
RN.04 - Medios y Confirmación de Pago: Una orden de compra sólo pasará al estado "En preparación" una vez que el pago haya sido acreditado y registrado con éxito. Si el método seleccionado es transferencia bancaria, el cliente dispone de 24 horas hábiles para adjuntar el comprobante; caso contrario, el pedido se cancela automáticamente.
RN.05 - Gestión de variantes de productos: Cada prenda debe estar asociada a una categoría y debe registrar sus variantes de talle y color. Cada variante debe mantener su propio stock disponible.
RN.06 - Cancelaciones y Reversión de Inventario: Si un pedido es cancelado por el cliente antes de su despacho, o rechazado por la pasarela de pagos, el sistema debe reintegrar de manera automática e inmediata las unidades retenidas al stock disponible del producto correspondiente.
RN.07 – Estado del pedido: Todo pedido debe poseer un estado que permita identificar su situación, por ejemplo: pendiente, pagado, en preparación, despachado o cancelado. Un pedido sólo podrá avanzar a un nuevo estado cuando se cumplan las condiciones correspondientes.
