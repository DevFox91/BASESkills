# Agent Install Guide — v1.1.1

## Objetivo
Instalar el motor base de skills en la configuracion **global** del agente IA, para que esten disponibles en todos los proyectos sin tener que reinstalar por proyecto.

---

## IMPORTANTE: Instalacion global, no en el proyecto

Las skills de este paquete son transversales a todos los proyectos.
Deben instalarse en el sistema de configuracion global del agente IA, **no dentro de ninguna carpeta de proyecto**.

El agente debe conocer donde gestiona sus propias skills, reglas o instrucciones globales
y usar esa ubicacion. No se prescribe una ruta fija: cada herramienta tiene la suya.

---

## Como usar este archivo

Proporciona al agente la ruta a este zip y dile:
> "Instala el motor de skills en tu configuracion global desde este zip: /ruta/al/zip"

El agente leera este archivo y seguira los pasos con la menor interaccion posible.
Si detecta varias herramientas, una ruta personalizada o una skill ya existente, debera
pedir confirmacion antes de continuar.

---

## Fase 0 — Identificar el mecanismo de skills globales del agente

El `manifest.json` incluye rutas de instalacion conocidas por herramienta en el campo `installPaths`.
Consultar primero esa tabla antes de explorar por cuenta propia.

### Rutas de instalacion por herramienta

| Herramienta   | Ruta global de skills        |
|---------------|------------------------------|
| Claude Code   | `~/.claude/skills/`          |
| Cursor        | `~/.cursor/skills/`          |
| Codex (OpenAI)| `~/.codex/skills/`           |

Si el agente no esta en ninguna de estas herramientas, debe determinar:

1. Si dispone de un sistema nativo de skills o reglas globales (directorio, ficheros de configuracion, etc.).
2. Cual es la ubicacion correcta segun su propia documentacion o configuracion.
3. Si no dispone de sistema nativo, usar el fallback de la seccion correspondiente.

El agente no debe preguntar al usuario por rutas conocidas.
Solo debe preguntar si hay ambiguedad que el usuario deba resolver (por ejemplo, multiples perfiles configurados).

---

## Fase 1 — Extraccion

1. Descomprimir el zip en una carpeta temporal.
2. Verificar que contiene carpeta `skills/` y este archivo `AGENT_INSTALL.md`.
3. Si no los contiene, detener e informar al usuario.

---

## Fase 2 — Instalacion global

### Si el agente tiene sistema nativo de skills o reglas globales

1. Localizar el directorio o mecanismo de skills/reglas globales del propio agente.
2. Por cada skill del zip:
   - Si la skill NO existe en el sistema global: instalarla.
   - Si YA existe: informar al usuario y preguntar si sobreescribir.
3. Verificar que las skills quedan disponibles globalmente para todos los proyectos.

Nota sobre automatizacion:
- El instalador `install.sh` no es completamente desatendido.
- Puede pedir confirmacion para elegir destino, usar ruta personalizada o sobrescribir una skill existente.
- Si se necesita ejecucion totalmente no interactiva, el agente debe resolver primero esas decisiones fuera del script o adaptar el flujo.

### Si el agente NO tiene sistema nativo de skills globales

1. Crear un directorio central accesible por el agente en cualquier proyecto.
2. Copiar cada skill del zip a ese directorio.
3. Informar al usuario de la ruta elegida.
4. Al invocar una skill por nombre, el agente debe:
   - Localizar el SKILL.md correspondiente en ese directorio central.
   - Leer su contenido y ejecutar el flujo descrito.
5. Indicar al usuario si necesita configurar algun permiso de lectura adicional en su herramienta.

---

## Fase 3 — Adaptacion de base-document-project

La skill `base-document-project` es la unica que debe adaptarse al contexto del proyecto.
Esta adaptacion se aplica sobre la copia instalada globalmente (no sobre el zip original).

1. Leer `AGENTS.md` o `CLAUDE.md` del proyecto actual para detectar:
   - Estructura documental (`doc/`, `DOC/`, otra convencion).
   - Nombre de carpeta de planes y tareas.
   - Proyectos del ecosistema si los hay.
2. Actualizar la copia global de `base-document-project` con esa informacion.
3. Si no hay `AGENTS.md`, usar la estructura por defecto del zip y anotarlo.

---

## Fase 4 — Registrar el motor en AGENTS.md o CLAUDE.md del proyecto

Aunque las skills esten en la configuracion global, cada proyecto necesita una referencia
al motor para que el agente sepa que usarlas y en que orden.

1. Detectar si existe `AGENTS.md` o `CLAUDE.md` en la raiz del proyecto actual.
2. Verificar si ya contiene una seccion "Motor de skills" o similar.
3. Si no existe, anadir al final la siguiente seccion:

```markdown
## Motor de Skills

Este proyecto usa el motor base de skills portables instalado en la configuracion global del agente.

### Arranque obligatorio
- Ejecutar siempre `base-project-bootstrap` al inicio de cada chat o cuando cambie el alcance.
- Leer `AGENTS.md` antes de tocar cualquier archivo.

### Flujo base

| Tarea                               | Skills a activar                                                         |
|-------------------------------------|--------------------------------------------------------------------------|
| Inicio de chat                      | `base-project-bootstrap` → `base-memory-protocol` → `base-golden-rules` |
| Planificar antes de implementar     | + `base-plan-work`                                                       |
| Entender un modulo antes de tocarlo | + `base-analyze-module` + `base-data-map`                                |
| Implementar cambios                 | + `base-develop-task`                                                    |
| Validar cambios                     | + `base-test-strategy`                                                   |
| Error o regresion                   | + `base-error-registry`                                                  |
| Guardar documentacion               | + `base-document-project`                                                |
| Exportar/respaldar skills           | `base-backup-skills`                                                     |

Nota:
- Cuando la tarea no es trivial o afecta estructura, planificacion o una zona fragil, el motor debe activar tambien `base-architecture-guard`.

### Comportamiento esperado
- Anunciar explicitamente que skill se esta ejecutando antes de cada fase.
- Usar `base-document-project` para persistir analisis, planes y tareas.
- Usar `base-memory-protocol` para leer y escribir memoria operativa reusable.
- No implementar cambios sin haber ejecutado `base-project-bootstrap` primero.
```

---

## Fase 5 — Memoria operativa (opcional)

1. Si el usuario proporciono ruta a memoria previa (`Memory/*.md`):
   - Detectar la ruta documental del proyecto.
   - Copiar los archivos `*.md` de `Memory/` a esa ruta.
2. Si no hay memoria previa, omitir esta fase sin bloquear.

---

## Fase 6 — Verificacion y resumen

1. Listar las skills instaladas con la ruta global donde quedaron.
2. Confirmar que `AGENTS.md` o `CLAUDE.md` del proyecto tiene la seccion del motor.
3. Indicar si `base-document-project` fue adaptado y como.
4. Indicar si se cargo memoria previa.
5. Indicar el siguiente paso: ejecutar `base-project-bootstrap`.

---

## Reglas de instalacion

- **NO instalar dentro de la carpeta del proyecto.** Las skills van en la configuracion global del agente.
- El agente resuelve la ruta de instalacion por si mismo; no debe pedirla al usuario salvo ambiguedad real.
- No compilar ni ejecutar el proyecto durante la instalacion.
- No modificar ninguna skill del zip excepto `base-document-project`.
- Si ya existen skills en el sistema global, preguntar antes de sobreescribir.
- Si ya existe la seccion del motor en `AGENTS.md`, no duplicarla; solo informar.
- Adaptar siempre al proyecto real; nunca forzar una estructura ajena.

---

## Skills incluidas

| Skill                    | Descripcion breve                                          |
|--------------------------|------------------------------------------------------------|
| `base-analyze-module`    | Analizar un modulo antes de tocarlo                        |
| `base-architecture-guard`| Evaluar si la solucion es sana para crecer                 |
| `base-backup-skills`     | Exportar o respaldar el motor de skills                    |
| `base-data-map`          | Mapear flujo de datos por archivo y metodo                 |
| `base-develop-task`      | Ejecutar una tarea o plan con consistencia                 |
| `base-document-project`  | Persistir analisis, planes y tareas en la doc del proyecto |
| `base-error-registry`    | Consultar y registrar errores por modulo                   |
| `base-golden-rules`      | Leer y aplicar reglas de oro del proyecto                  |
| `base-memory-protocol`   | Gestionar memoria operativa reusable entre sesiones        |
| `base-plan-work`         | Planificar una tarea por fases antes de implementar        |
| `base-project-bootstrap` | Arrancar cualquier chat con el contexto correcto           |
| `base-test-strategy`     | Definir y ejecutar la estrategia minima de tests           |
