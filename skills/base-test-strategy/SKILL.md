---
name: base-test-strategy
description: Proponer, crear y ejecutar la estrategia minima de tests antes y despues de cambios, detectando cobertura faltante y riesgos de regresion. Usar cuando se vaya a tocar codigo o cuando se quiera revisar que comprobar en un modulo.
---

# Base Test Strategy

## Proposito
Reducir regresiones con validacion ejecutable y trazable, decidiendo que comprobar antes y despues de tocar codigo.

## Modos
- Preventivo: que correr antes del cambio.
- Validacion: que correr despues del cambio.
- Gap analysis: que tests faltan y conviene crear.
- Regresion: que se rompe si falla un test historico.

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

## Clasificacion del cambio (obligatoria)
Antes de definir bateria de tests, clasificar el cambio como:
- `bugfix`: corrige comportamiento incorrecto existente.
- `feature`: introduce comportamiento nuevo.
- `refactor`: reestructura internamente sin cambiar contrato externo.

Regla minima por tipo:
- `bugfix`: crear o actualizar al menos 1 test de regresion del bug corregido.
- `feature`: crear o actualizar al menos 1 test del comportamiento nuevo (happy path) y evaluar bordes segun riesgo.
- `refactor`: crear o actualizar tests de contrato para asegurar que el comportamiento externo no cambia.

## Flujo
1. Verificar que `base-project-bootstrap` fue ejecutado en este chat. Si ya se ejecuto en esta sesion, no repetirlo; usar el contexto existente. Solo volver a ejecutarlo si el alcance del proyecto cambio.
2. Consultar `Memory/ValidationMemory.md` si existe para reutilizar validaciones minimas ya utiles.
3. Detectar que existe hoy:
- tests unitarios
- integracion
- e2e
- linters
- typecheck
- checks manuales
4. Clasificar el cambio (`bugfix|feature|refactor`) y fijar la bateria minima exigida por tipo.
5. Si el bug es de UI runtime, render cliente, overlay, DOM diferido o visibilidad condicional, definir tambien una validacion minima de UI dinamica antes de tocar nada mas.
6. Esa validacion minima de UI dinamica debe intentar responder, cuando aplique:
- existen los nodos clave en cliente
- estan visibles u ocultos por estado real o por CSS
- el problema nace en servidor, tema estatico o cliente runtime
- el componente depende de `setVisible(false)`, attach/detach o mutacion posterior
7. Proponer bateria minima previa al cambio.
8. Aplicar cambio y crear o actualizar tests reales del area tocada cuando exista infraestructura de test.
9. Tras el cambio, volver a correr la validacion relevante.
10. Verificar tambien si el cambio afecta responsabilidades vecinas o contratos cercanos.
11. Si faltan tests importantes, documentar huecos.
12. Si una validacion minima demuestra valor recurrente, promoverla a `Memory/ValidationMemory.md` mediante `base-document-project`.

## Regla de regresion historica
Si falla un test existente de semanas anteriores:
- tratarlo como posible regresion.
- no cerrar la tarea hasta corregir, o actualizar test con justificacion funcional explicita.
- documentar causa: regresion real vs cambio de requisito.

## Guion manual cuando falla un test (obligatorio)
Para cada test fallido, informar:
1. Que valida ese test en lenguaje funcional.
2. Como reproducir manualmente (pasos UI o API concretos).
3. Resultado esperado vs resultado actual.
4. Evidencia a observar (pantalla, log, archivo, endpoint).
5. Riesgo si se ignora.

## Gate de cierre
No marcar una tarea como cerrada si:
- no se ejecuto al menos la bateria minima acordada.
- hay test fallido sin resolucion o justificacion documentada.
- el tipo de cambio exigia test nuevo/actualizado y no se genero (salvo excepcion documentada).

## Excepciones permitidas (controladas)
Se permite cierre sin test automatico nuevo solo si:
- no existe infraestructura de test en el proyecto, o
- el cambio es estrictamente trivial y no aporta ruta estable de automatizacion.

En ese caso es obligatorio:
- validacion manual reproducible y detallada.
- riesgo residual declarado.
- tarea pendiente para habilitar test automatico cuando aplique.

## Persistencia
- Por defecto, registrar estrategia y resultado dentro de la tarea.
- Si el proyecto necesita una estrategia estable, crear o actualizar `TestStrategy.md` del modulo mediante `base-document-project`.
- Si una validacion resulta reusable y estable, registrarla tambien en `Memory/ValidationMemory.md`.

## Salida minima obligatoria
La salida de la skill debe incluir siempre:
- Tipo de cambio (`bugfix|feature|refactor`).
- Tests creados o actualizados (rutas).
- Comandos ejecutados.
- Resultado de ejecucion (pass/fail) por bloque.
- Validacion manual ejecutada (si aplica).
- Huecos de cobertura y riesgo residual.

## Reglas
- No exigir suites enormes para cambios pequenos.
- Priorizar tests que detecten regresiones del area tocada.
- Si la pieza tocada es sensible, priorizar checks que detecten regresion de contrato o de inicializacion, no solo del happy path.
- Si no hay infraestructura de test, dejar una validacion manual explicita.
- En UI dinamica, no quedarse solo en capturas o percepcion visual si el problema depende de runtime; pedir o generar una observacion verificable del DOM o del ciclo de vida.
- Evitar tests flaky: usar datos deterministas, aislar dependencias inestables y controlar tiempos de espera.
- No promocionar a memoria comandos o checks puntuales que no aporten reutilizacion futura.
- Solo subir a memoria validaciones minimas estables, no resultados efimeros ni comandos que dependan de un contexto irrepetible.
- La estrategia minima debe responder, cuando aplique, a esta pregunta: que seria lo primero en romperse si esta pieza creciera o se reutilizara.

## Plantilla de salida estandar (obligatoria)
Usar siempre este formato al reportar la estrategia y resultado:

```md
Tipo de cambio: <bugfix|feature|refactor>

Alcance validado:
- Modulo/archivo: <ruta o rutas>
- Riesgo principal: <breve>

Bateria previa (antes del cambio):
1. <comando o check manual>
2. <comando o check manual>

Tests creados o actualizados:
- <ruta_test_1>
- <ruta_test_2>

Ejecucion posterior (despues del cambio):
1. Comando: `<comando 1>`
Resultado: <pass|fail>
Detalle: <breve>
2. Comando: `<comando 2>`
Resultado: <pass|fail>
Detalle: <breve>

Si hubo fallos:
- Test fallido: <nombre/ruta>
- Que valida: <funcional>
- Reproduccion manual:
  1. <paso>
  2. <paso>
  3. <paso>
- Esperado vs actual: <breve>
- Evidencia: <log/pantalla/archivo>
- Riesgo si se ignora: <breve>

Cobertura y huecos:
- Hueco 1: <descripcion>
- Hueco 2: <descripcion>

Decision de cierre:
- Estado: <cerrada|pendiente>
- Motivo: <breve>
- Excepcion aplicada: <si/no + justificacion>
```

Regla:
- No omitir secciones; si una no aplica, indicar explicitamente `No aplica`.

## Politica de rutas de tests (obligatoria)
Definir y respetar una ruta fija por proyecto para que los tests sean encontrables y acumulativos.

Convencion recomendada por stack:
- JavaScript/TypeScript:
  - `tests/unit/`
  - `tests/integration/`
  - `tests/e2e/`
- Flutter/Dart:
  - `test/unit/`
  - `test/widget/`
  - `integration_test/`
- Python:
  - `tests/unit/`
  - `tests/integration/`

Regla:
- Si el proyecto ya tiene convencion propia, respetarla.
- Si no la tiene, proponer y fijar una en `TestStrategy.md` antes de escalar cambios.

## Consulta previa de tests relacionados (obligatoria)
Antes de tocar codigo:
1. localizar tests del modulo/archivo afectado
2. listar rutas consultadas
3. identificar contratos esperados que no deben romperse

Si no existen tests relacionados, registrar el gap y crear al menos el test minimo requerido por tipo de cambio.

## Matriz de ejecucion de pruebas (obligatoria)
Toda ejecucion de validacion debe incluir comandos para:
- alcance global (todos los tests)
- alcance por modulo/carpeta
- alcance por archivo

Si el proyecto no ofrece alguno de esos niveles, documentar la limitacion y proponer comando equivalente.

## Herramienta de ejecucion
La skill debe dejar siempre una propuesta clara de comando reusable para:
- correr regresion completa manualmente
- correr bateria rapida por modulo durante desarrollo
- correr test puntual durante depuracion
