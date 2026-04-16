---
name: base-plan-work
description: Generar un plan de trabajo por fases con archivos a tocar, cambios de codigo esperados, justificacion y estado. Usar cuando el usuario pida planificar una tarea antes de implementarla.
---

# Base Plan Work

## Proposito
Planificar trabajo de forma ejecutable y documentable, sin depender de lenguaje o framework.

## Salida minima obligatoria
1. Descripcion general del desarrollo.
2. Fases logicas.
3. Archivos o rutas a tocar por fase.
4. Modificaciones de codigo esperadas por fase.
5. Justificacion tecnica o funcional de cada cambio.
6. Fecha de solicitud.
7. Estado del plan.

## Estado permitido
- Planificado
- En desarrollo
- Completado

## Skills relacionadas
- Llamadas obligatorias:
  - `base-project-bootstrap`
  - `base-architecture-guard`
  - `base-golden-rules`
  - `base-document-project`
  - `base-memory-protocol` cuando la memoria afecte la secuencia del plan
- Llamadas opcionales:
  - `base-analyze-module`
  - `base-test-strategy`

## Flujo
1. Verificar que `base-project-bootstrap` fue ejecutado en este chat. Si ya se ejecutó en esta sesión, no repetirlo — usar el contexto existente. Solo volver a ejecutarlo si el alcance del proyecto cambió.
2. Consultar `Memory/PlanningMemory.md` si existe para reutilizar fases o secuencias ya probadas.
3. Si hace falta mas memoria que la de planificacion, aplicar `base-memory-protocol` y consultar solo la memoria estrictamente relevante.
4. Confirmar objetivo y alcance.
5. Ejecutar `base-architecture-guard` si el plan toca estructura, responsabilidades o una pieza con riesgo de crecer.
6. Dividir en fases logicas.
7. Para cada fase, detallar:
- objetivo
- archivos/rutas a tocar
- cambios esperados
- motivo del cambio
- impacto sobre escalabilidad, desacoplamiento o mantenibilidad si aplica
8. Incluir cuando sea relevante:
- responsabilidades que deben quedar separadas
- deuda estructural que conviene evitar
- por que la estructura propuesta localiza mejor cambios futuros
9. Añadir riesgos y dependencias solo si cambian la ejecucion.
10. Guardar con `base-document-project` en `PLANES/AAAA_MM_DD_slug.md`.
11. Si una estructura de fases demuestra valor recurrente, promoverla a `Memory/PlanningMemory.md`.

## Reglas
- No crear fases artificiales para rellenar.
- Cada fase debe ser implementable y verificable.
- Si no es posible identificar archivos exactos, indicar rutas candidatas y decir que requieren confirmacion o investigacion.
- No promocionar a memoria planes puntuales que no generalicen a futuras tareas del mismo contexto.
- No consultar memoria adicional si no cambia el plan de forma real.
- Un plan no esta bien hecho si solo dice que se toca; tambien debe explicar por que esa estructura favorece cambios futuros seguros.
- Si el cambio es pequeno pero cae sobre una pieza fragil, el plan debe contemplar saneamiento minimo previo o justificar por que no compensa hacerlo.

## Contrato de plan de testing (obligatorio)
Todo plan que incluya cambio de codigo debe contener una fase de testing con:
1. Tests relacionados existentes a consultar antes de cambiar codigo.
2. Tests nuevos o actualizados a crear en la ruta canonica del proyecto.
3. Matriz de ejecucion:
- run global
- run por modulo
- run por archivo
4. Gate de cierre del plan:
- no cerrar sin resultados de ejecucion reportados.

## Salida minima extendida (testing)
Anadir siempre al plan:
- "Ruta de tests": <ruta fija del proyecto>
- "Consulta previa de tests relacionados": <rutas>
- "Tests a crear/actualizar por fase": <rutas esperadas>
- "Comandos de ejecucion": global/modulo/archivo
