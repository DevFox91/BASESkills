---
name: base-test-strategy
description: Proponer y ejecutar la estrategia minima de tests antes y despues de cambios, detectando cobertura faltante y riesgos de regresion. Usar cuando se vaya a tocar codigo o cuando se quiera revisar que comprobar en un modulo.
---

# Base Test Strategy

## Proposito
Reducir regresiones y decidir que comprobar antes y despues de tocar codigo.

## Modos
- Preventivo: que correr antes del cambio.
- Validacion: que correr despues del cambio.
- Gap analysis: que tests faltan y conviene crear.

## Skills relacionadas
- Llamadas obligatorias:
  - `base-project-bootstrap`
- Llamadas opcionales:
  - `base-architecture-guard`
  - `base-memory-protocol`
  - `base-document-project` si deja estrategia o resultado persistente
- Esta skill suele ser llamada por:
  - `base-develop-task`
  - `base-plan-work`
  - `base-analyze-module`
  - `base-error-registry`

## Flujo
1. Verificar que `base-project-bootstrap` fue ejecutado en este chat. Si ya se ejecutó en esta sesión, no repetirlo — usar el contexto existente. Solo volver a ejecutarlo si el alcance del proyecto cambió.
2. Consultar `Memory/ValidationMemory.md` si existe para reutilizar validaciones minimas ya utiles.
3. Detectar que existe hoy:
- tests unitarios
- integracion
- e2e
- linters
- typecheck
- checks manuales
4. Si el bug es de UI runtime, render cliente, overlay, DOM diferido o visibilidad condicional, definir tambien una validacion minima de UI dinamica antes de tocar nada mas.
5. Esa validacion minima de UI dinamica debe intentar responder, cuando aplique:
- existen los nodos clave en cliente
- estan visibles u ocultos por estado real o por CSS
- el problema nace en servidor, tema estatico o cliente runtime
- el componente depende de `setVisible(false)`, attach/detach o mutacion posterior
6. Proponer bateria minima previa al cambio.
7. Tras el cambio, volver a correr la validacion relevante.
8. Verificar tambien si el cambio afecta responsabilidades vecinas o contratos cercanos.
9. Si faltan tests importantes, documentar huecos.
10. Si una validacion minima demuestra valor recurrente, promoverla a `Memory/ValidationMemory.md` mediante `base-document-project`.

## Persistencia
- Por defecto, registrar estrategia y resultado dentro de la tarea.
- Si el proyecto necesita una estrategia estable, crear o actualizar `TestStrategy.md` del modulo mediante `base-document-project`.
- Si una validacion resulta reusable y estable, registrarla tambien en `Memory/ValidationMemory.md`.

## Reglas
- No exigir suites enormes para cambios pequenos.
- Priorizar tests que detecten regresiones del area tocada.
- Si la pieza tocada es sensible, priorizar checks que detecten regresion de contrato o de inicializacion, no solo del happy path.
- Si no hay infraestructura de test, dejar una validacion manual explicita.
- En UI dinamica, no quedarse solo en capturas o percepcion visual si el problema depende de runtime; pedir o generar una observacion verificable del DOM o del ciclo de vida.
- No promocionar a memoria comandos o checks puntuales que no aporten reutilizacion futura.
- Solo subir a memoria validaciones minimas estables, no resultados efimeros ni comandos que dependan de un contexto irrepetible.
- La estrategia minima debe responder, cuando aplique, a esta pregunta: que seria lo primero en romperse si esta pieza creciera o se reutilizara.
