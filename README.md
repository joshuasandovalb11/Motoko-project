# `Mi_Proyecto - Finanzas Personales`

Bienvenido a `Mi_Proyecto`, una aplicación de finanzas personales desarrollada en Motoko para el Internet Computer. Esta aplicación permite a los usuarios agregar, eliminar, actualizar y ver sus transacciones financieras de manera segura. El sistema utiliza autenticación para asegurar que solo el propietario de cada transacción pueda acceder y modificar sus datos.

## Tabla de Contenidos

1. [Requisitos](#requisitos)
2. [Estructura del Proyecto](#estructura-del-proyecto)
3. [Configuración y Ejecución del Proyecto](#configuración-y-ejecución-del-proyecto)
4. [Uso de la Aplicación](#uso-de-la-aplicación)
   - [Autenticación y Principales](#autenticación-y-principales)
   - [Funciones Disponibles](#funciones-disponibles)

## Requisitos

Para ejecutar este proyecto, asegúrate de tener instalados:

- [DFX SDK](https://internetcomputer.org/docs/current/developer-docs/setup/install) (para el desarrollo en Internet Computer)
- Node.js y npm (opcional, para trabajar con el frontend)

## Estructura del Proyecto

El proyecto incluye las siguientes funcionalidades clave:

- **Agregar Transacción**: Permite registrar una nueva transacción con una cantidad, tipo, fecha y usuario autenticado.
- **Eliminar Transacción**: Permite a un usuario eliminar sus propias transacciones.
- **Actualizar Transacción**: Permite a un usuario actualizar los detalles de una transacción existente.
- **Obtener Transacciones por Usuario**: Muestra todas las transacciones asociadas al usuario autenticado.
- **Obtener Transacción por ID**: Permite a un usuario obtener los detalles de una transacción específica, siempre que sea el propietario.

## Configuración y Ejecución del Proyecto

Para ejecutar el proyecto localmente, sigue estos pasos:

1. **Inicia el replica de IC localmente**:

   dfx start --background

2. **Despliega el canister:**:

    dfx deploy

3. **Autenticación del Usuario:**:
  Este proyecto requiere autenticación para funcionar correctamente. El sistema utiliza Principal, una identidad única asignada a cada usuario en Internet Computer. Para probarlo, asegúrate de que estés autenticado. Puedes utilizar el comando:

      dfx identity use <tu_identidad>

      O por otro lado utilizar una de las urls proporcionadas al ejecutar: dfx deploy. Luego agregando dicha url al directorio del Canister proporcionado despues de haber agregado: &ii= .

      *Por ejemplo:*
      `http://127.0.0.1:4943/?canisterId=aax3a-h4aaa-aaaaa-qaahq-cai&id=ajuq4-ruaaa-aaaaa-qaaga-cai&ii=http://ahw5u-keaaa-aaaaa-qaaha-cai.localhost:4943/`

## Uso de la Aplicación

### Autenticación y Principales

Cada transacción en esta aplicación está asociada a un usuario único identificado por su `Principal`. Este `Principal` permite que solo el usuario que creó la transacción pueda acceder, modificar o eliminarla.

**Importante**: Si intentas interactuar con el sistema sin autenticación (`Principal.isAnonymous`), recibirás un error. Asegúrate de que tu identidad está configurada y autenticada correctamente antes de realizar cualquier operación.


### Funciones Disponibles

#### 1. `agregarTransaccion`

  Esta función permite agregar una nueva transacción. La estructura de la transacción incluye:

  - `id`: Identificador único de la transacción.
  - `tipo`: Tipo de transacción (por ejemplo, "ingreso" o "gasto").
  - `cantidad`: Monto de la transacción (debe ser mayor que 0).
  - `fecha`: Fecha de la transacción.
  - `usuario`: Principal del usuario autenticado (en este apartado es importante recalcar que para fines de prueba sera necesario usar el usuario proporcionado dentro del canister. Por ejemplo: "aaaa-aa"). En un ambiente de produccion este usuario sera diferente para cada individuo.

  **Ejemplo de uso**:

  dfx canister call <nombre_del_canister> agregarTransaccion "(record { id = "trans001"; tipo = "ingreso"; cantidad = 1500.0; fecha = "2024-01-20"; usuario = principal "<tu_principal>" })"

  Si el `Principal` es anónimo o si el ID de transacción ya existe, la función devolverá un error.

#### 2. `eliminarTransaccion`

  Permite al usuario autenticado eliminar una transacción, siempre y cuando sea el propietario.

  **Ejemplo de uso**:

  dfx canister call <nombre_del_canister> eliminarTransaccion '("trans001")'

  Si intentas eliminar una transacción que no te pertenece, recibirás un mensaje de error.

#### 3. `obtenerTransaccionesPorUsuario`

  Devuelve todas las transacciones asociadas al usuario autenticado.

  **Ejemplo de uso**:

  dfx canister call <nombre_del_canister> obtenerTransaccionesPorUsuario '()'


#### 4. `obtenerTransaccion`
  Permite obtener los detalles de una transacción específica por su ID, siempre y cuando pertenezca al usuario autenticado.

  **Ejemplo de uso**:

  dfx canister call <nombre_del_canister> obtenerTransaccion '("trans001")'

#### 5. `actualizarTransaccion`
  Permite actualizar los detalles de una transacción existente. Los campos tipo, cantidad, y fecha son requeridos, y la cantidad debe ser mayor que 0.

  **Ejemplo de uso**:

  dfx canister call <nombre_del_canister> actualizarTransaccion '(record { id = "trans001"; tipo = "gasto"; cantidad = 1200.0; fecha = "2024-02-15"; usuario = principal "<tu_principal>" })'


