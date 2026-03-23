---
name: base-memory-protocol
description: Definir cuando consultar, guardar, actualizar y consolidar memoria operativa reusable del motor base. Usar cuando una tarea pueda beneficiarse de contexto previo o deje aprendizaje transversal para futuras sesiones.
---

# Base Memory Protocol

## Proposito
Dar al motor base un criterio comun para usar memoria operativa sin volver el flujo pesado, ruidoso o dependiente de un proyecto concreto.

## Cuando usarla
- Cuando exista memoria previa que pueda reducir exploracion o reanalisis.
- Cuando una tarea deje aprendizaje reusable mas alla de la conversacion actual.
- Cuando un mismo tema evolucione en varias tareas y convenga mantener una entrada viva.
- Cuando haya que decidir si algo debe quedar en memoria operativa, en reglas o solo en documentacion puntual.

## Skills relacionadas
- Llamadas obligatorias:
  - `base-project-bootstrap`
  - `base-document-project`
- Llamadas opcionales:
  - `base-golden-rules`
  - `base-plan-work`
  - `base-develop-task`
  - `base-test-strategy`
  - `base-error-registry`
  - `base-analyze-module`

## Flujo
1. Confirmar el alcance real con `base-project-bootstrap`.
2. Consultar solo la memoria minima necesaria:
- `Memory/BootstrapMemory.md` para arranque
- `Memory/PlanningMemory.md` para secuencias recurrentes
- `Memory/AnalysisMemory.md` para focos de auditoria
- `Memory/TaskMemory.md` para ejecuciones reutilizables
- `Memory/ValidationMemory.md` para validaciones minimas estables
- `Memory/ErrorMemory.md` para diagnosticos reutilizables
- `Memory/RulesMemory.md` para criterios recurrentes aun no formales
- `Memory/TopicMemory.md` para temas vivos
3. Contrastar siempre la memoria con el estado real del contexto.
4. Si la memoria ayuda, reutilizar solo lo que cambie el arranque, el plan, la validacion o el diagnostico.
5. Al cerrar la tarea, decidir si ha aparecido aprendizaje reusable.
6. Si el aprendizaje aplica a una fase concreta, guardarlo en la memoria de esa fase.
7. Si el aprendizaje pertenece a un tema que seguira evolucionando, actualizar `Memory/TopicMemory.md`.
8. Si el aprendizaje ya es estable y repetible, coordinar con `base-golden-rules` para proponer regla formal.

## Formato minimo de observacion reusable
- Fecha
- Contexto
- Tipo
- Tema o clave estable si aplica
- What
- Why
- Where
- Learned
- Criterio de reutilizacion

## Criterios de consulta
- Consultar memoria si reduce lecturas, evita reanalisis, evita redefinir una validacion o recupera un diagnostico ya hecho.
- No consultar memoria por rutina en tareas triviales o cuando el alcance no tiene historial util.
- Si una memoria no cambia la accion siguiente, no seguir abriendo memorias relacionadas.

## Criterios de persistencia
- Guardar solo aprendizaje que reduzca tiempo, riesgo o tokens en trabajos futuros.
- No guardar notas efimeras, resultados puntuales, comandos aislados ni conclusiones obvias.
- Si una entrada ya existe, actualizarla o referenciarla; no duplicarla.
- Si una memoria contradice el estado actual del proyecto o motor, prevalece el estado real y la memoria debe actualizarse.

## Consolidacion
- Memoria operativa: aprendizaje reusable pero aun no formal.
- Regla de oro: criterio estable, repetible y general.
- Documentacion puntual: contexto de una tarea, plan, error o analisis que no merece memoria propia.

## Reglas
- La memoria del motor debe seguir siendo ligera y selectiva.
- Ninguna entrada de memoria debe depender de un lenguaje, framework o proyecto concreto para tener sentido en el motor base.
- `TopicMemory.md` es el destino preferente para decisiones o patrones que evolucionan a lo largo del tiempo.
- La memoria nunca sustituye verificaciones reales; solo reduce trabajo futuro.
