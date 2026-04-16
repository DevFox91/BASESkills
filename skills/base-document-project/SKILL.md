---
name: base-document-project
description: Organizar y mantener la documentacion persistente del proyecto bajo DOC/PROYECTO/SUBPROYECTO/MODULO. Usar cuando otra skill necesite guardar o actualizar analysis, changelog, errores, planes, tareas o reuniones.
---

# Base Document Project

## Proposito
Mantener una estructura documental unica y consistente para cualquier proyecto.

## Skills relacionadas
- Llamadas obligatorias:
  - `base-project-bootstrap`
  - `base-memory-protocol` cuando se persista o lea memoria operativa
- Esta skill debe ser usada por:
  - `base-analyze-module`
  - `base-plan-work`
  - `base-develop-task`
  - `base-data-map`
  - `base-error-registry`
  - `base-test-strategy` cuando deje salida persistente
  - `base-golden-rules` si se registran reglas nuevas

## Estructura objetivo
```text
DOC/
  PROYECTO/
    SUBPROYECTO/ (si existe)
      MODULO/
        Analysis.md
        Changelog.md
        Errores.md
        DataMap.md
        Memory/
          BootstrapMemory.md
          RulesMemory.md
          PlanningMemory.md
          AnalysisMemory.md
          DataMapMemory.md
          TaskMemory.md
          ValidationMemory.md
          ErrorMemory.md
          TopicMemory.md
        PLANES/
        TAREAS/
        REUNIONES/
```

Si no hay subproyecto, `MODULO` cuelga directamente de `DOC/PROYECTO/`.

## Reglas
- `PROYECTO` puede ser un proyecto unico o un contenedor de subproyectos.
- `SUBPROYECTO` solo existe si el contexto del repo lo requiere.
- `MODULO` debe usar un nombre funcional y estable.
- `Changelog.md` va en orden cronologico descendente, lo mas nuevo arriba y con fecha.
- `Analysis.md`, `Errores.md` y `DataMap.md` se actualizan de forma acumulativa por modulo.
- `Memory/` guarda memoria operativa del motor por fase. No es obligatoria completa desde el inicio.
- `PLANES/`, `TAREAS/` y `REUNIONES/` usan nombre `AAAA_MM_DD_slug.md`.
- Los documentos del motor deben reflejar no solo que se hizo, sino por que la decision estructural importa si aplica.

## Flujo
1. Resolver `PROYECTO`, `SUBPROYECTO` y `MODULO` desde `AGENTS.md` y el alcance actual.
2. Crear carpetas faltantes si no existen.
3. Guardar o actualizar el documento correcto segun el tipo de salida:
- Analisis -> `Analysis.md`
- Mapa de datos -> `DataMap.md`
- Changelog -> `Changelog.md`
- Error -> `Errores.md`
- Memoria de arranque -> `Memory/BootstrapMemory.md`
- Memoria de reglas -> `Memory/RulesMemory.md`
- Memoria de planificacion -> `Memory/PlanningMemory.md`
- Memoria de analisis -> `Memory/AnalysisMemory.md`
- Memoria de flujo de datos -> `Memory/DataMapMemory.md`
- Memoria de ejecucion -> `Memory/TaskMemory.md`
- Memoria de validacion -> `Memory/ValidationMemory.md`
- Memoria de errores -> `Memory/ErrorMemory.md`
- Memoria de temas vivos -> `Memory/TopicMemory.md`
- Plan -> `PLANES/AAAA_MM_DD_slug.md`
- Tarea -> `TAREAS/AAAA_MM_DD_slug.md`
- Reunion -> `REUNIONES/AAAA_MM_DD_slug.md`
4. Si la tarea afecta varios proyectos, repetir la persistencia por proyecto implicado.

## Convenciones de contenido
- `Analysis.md`: secciones por modulo y fecha si crece.
- `Errores.md`: entradas con fecha, contexto, causa, solucion y estado.
- `Changelog.md`: fecha, resumen, referencias a plan/tarea/error si existen y motivo arquitectonico si aporta valor.
- `DataMap.md`: un bloque por archivo y sus metodos.
- `Memory/*.md`: entradas cortas, acumulativas, orientadas a reutilizacion futura. Cada entrada debe indicar fecha, contexto, aprendizaje y criterio de reutilizacion.
- `TAREAS/`: deben registrar tambien si la solucion fue estructural, tactica-controlada o urgencia-documentada cuando aplique.

## Formato minimo de observacion reusable
- Seguir el contrato definido en `base-memory-protocol`.

## Memoria operativa
- La memoria del motor se crea bajo demanda, nunca por preinstalacion completa.
- Solo crear un archivo de `Memory/` cuando una skill tenga aprendizaje reusable que guardar o necesite leer memoria ya existente.
- Si el proyecto usa una convencion documental distinta de `DOC/`, adaptar `Memory/` a esa convencion en lugar de forzar una ruta ajena al proyecto.
- Antes de anadir una entrada, revisar si ya existe una equivalente y actualizarla o referenciarla para evitar duplicados.
- Si un aprendizaje pertenece a un tema vivo que evolucionara, aplicar `base-memory-protocol` y actualizar `Memory/TopicMemory.md` o la entrada equivalente en lugar de crear observaciones paralelas.
- No persistir observaciones puntuales que no reduzcan tiempo, riesgo o tokens en trabajos futuros.

## Criterio
- No inventar rutas documentales.
- No mezclar modulos distintos en el mismo directorio.
- Si el modulo no es evidente, usar el nombre funcional mas pequeno que siga siendo claro.

## Documento estable de estrategia de tests
Cuando el proyecto tenga cambios de codigo recurrentes, mantener tambien:
- `TestStrategy.md` en el modulo correspondiente.

Contenido minimo de `TestStrategy.md`:
- ruta canonica de tests del proyecto
- convencion por tipo (unit/integration/e2e)
- convencion de nombrado
- comando global
- comando por modulo
- comando por archivo
- criterios de regresion y gate de cierre

## Convencion de persistencia de testing
- Cada `TAREA` con cambio de codigo debe incluir:
  - tests consultados antes del cambio
  - tests creados/actualizados
  - comandos ejecutados y resultado
- Si una validacion manual se repite y demuestra valor, promoverla a `Memory/ValidationMemory.md`.
