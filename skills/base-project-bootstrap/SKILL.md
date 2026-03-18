---
name: base-project-bootstrap
description: Leer AGENTS.md, reglas de oro y contexto documental antes de trabajar en uno o varios proyectos. Usar al inicio de un chat o cuando cambie el alcance para alinear proyectos implicados, subproyectos, modulos, skills aplicables y restricciones.
---

# Base Project Bootstrap

## Proposito
Arrancar cualquier trabajo con el mismo contexto operativo, inspeccionando primero la estructura real del proyecto y sin asumir que todos los repos siguen la misma organizacion.

## Cuando usarla
- Al inicio de un chat de trabajo.
- Cuando la tarea cambie de proyecto, subproyecto o modulo.
- Cuando haya dudas sobre donde documentar o que reglas aplican.

## Skills relacionadas
- Llamadas obligatorias: ninguna.
- Llamadas opcionales:
  - `base-memory-protocol`
  - `base-golden-rules`
  - `base-analyze-module`
  - `base-plan-work`
  - `base-develop-task`
  - `base-test-strategy`
  - `base-error-registry`

## Flujo
1. Inspeccionar el proyecto real:
- Estructura de carpetas.
- Manifests y archivos clave.
- Posibles proyectos, subproyectos y modulos implicados.

2. Localizar `AGENTS.md` relevante si existe:
- Raiz superior si existe.
- Raiz del proyecto implicado.
- Subproyecto implicado si aplica.

3. Localizar `REGLAS_DE_ORO.md` relevante si existe:
- `REGLAS_DE_ORO.md` en la raiz del proyecto.
- `REGLAS_DE_ORO.md` en el subproyecto si existe.

4. Comprobar si existe estructura documental:
- `DOC/` global o equivalente si el proyecto ya usa otra convencion.
- Si no existe, no bloquear el trabajo: informar de la ausencia.
5. Comprobar si existe memoria operativa relevante:
- `Memory/BootstrapMemory.md` del contexto detectado.
- `Memory/TopicMemory.md` o memorias equivalentes si el alcance coincide con un tema ya trabajado.
- O equivalente en la convencion documental del proyecto.
- Si existe, aplicar `base-memory-protocol` y usar solo la minima memoria necesaria como ayuda de arranque sin sustituir la comprobacion del estado real del repo.

6. Determinar alcance:
- Proyecto o proyectos implicados.
- Subproyecto o subproyectos implicados.
- Modulo o modulos implicados.

7. Resumir antes de actuar:
- Que se va a tocar.
- Que skills base aplican.
- Que restricciones tecnicas y de negocio mandan.
- Que contexto formal existe y cual falta.
- Donde se guardara la documentacion si la estructura documental ya existe.
- Si hay memoria reusable de arranque y si faltaria crearla tras esta tarea.

## Reglas
- No modificar codigo ni documentacion hasta tener claro el alcance.
- Cualquier modificacion de codigo, aunque sea un fix puntual o una correccion de compilacion, debe pasar por `base-develop-task`. Si la conversacion deriva hacia cambios directos sin invocarla, detener y reconducir el flujo antes de tocar codigo.
- Un cambio no esta terminado hasta que su documentacion este persistida en `doc/`. Si se presenta un cambio como "listo" sin documentacion, el flujo esta roto.
- Si faltan `AGENTS.md`, `REGLAS_DE_ORO.md` o `DOC/`, seguir con la mejor inferencia local y señalar la ausencia de forma explicita.
- No asumir una estructura fija de proyecto: primero comprobar, luego inferir.
- Si una tarea toca varios proyectos, mantener un resumen separado por proyecto.
- La memoria de arranque nunca sustituye a la verificacion del estado real del repo; solo reduce exploracion redundante.
- La memoria debe consultarse de forma selectiva: primero arranque, despues tema vivo si realmente aplica; no abrir memorias por rutina.
- Si una memoria contradice el estado actual del repo, manda el estado real y la memoria debe quedar marcada para actualizacion posterior.
- Si durante el arranque se confirma una estructura estable reusable, dejar preparada su persistencia en `Memory/BootstrapMemory.md` mediante `base-document-project`.

## Salida minima
- Proyecto(s) implicado(s).
- Subproyecto(s) implicado(s) si aplica.
- Modulo(s) implicado(s).
- Archivos de contexto encontrados:
  - `AGENTS.md`
  - `REGLAS_DE_ORO.md`
  - `DOC/` u otra estructura documental detectada
  - `Memory/BootstrapMemory.md` o equivalente si existe
- Contexto faltante relevante.
- Skills base a usar en orden.
- Ruta documental objetivo si existe; si no existe, indicar que falta estructura documental formal.
