# Skill System Package — v1.1.4

## En que consiste
Este paquete contiene un sistema portable de skills para un agente IA. El sistema esta pensado como un motor de trabajo generalista: organiza el flujo de arranque, analisis, planificacion, desarrollo, validacion, manejo de errores y persistencia documental sin acoplarse a un proyecto, lenguaje o framework concretos.

## Instalacion

**Instalacion rapida (una linea):**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/DevFox91/BASESkills/main/install.sh)
```

**Para actualizar**, vuelve a ejecutar el mismo comando.

Las skills se instalan en la **configuracion global** del agente IA, no dentro de ninguna carpeta de proyecto. Esto las hace disponibles en todos los proyectos sin reinstalar. Ver `AGENT_INSTALL.md` para instrucciones detalladas por agente (Claude Code, Cursor, Windsurf, otros).

## Alcance exportado
- Version: `1.1.4`
- Scope: `base`
- Instalacion: `global`
- Numero de skills incluidas: `12`

## Estructura del paquete
```text
README.md
AGENT_INSTALL.md
manifest.json
scripts/
  check_integrity.py
skills/
  <skill>/
    SKILL.md
    ...
```

## Verificacion de integridad
Antes de publicar o reinstalar el paquete desde el repo, conviene ejecutar:

```bash
python3 scripts/check_integrity.py
```

El chequeo valida la coherencia minima entre `manifest.json`, `skills/`, descriptores `agents/openai.yaml` y listados documentales clave.

## Skills incluidas
- `base-analyze-module`: Analizar un modulo desde perspectiva funcional, estructural y tecnica, generando documentacion por proyecto implicado. Usar cuando se pida entender un modulo, auditarlo, documentarlo o detectar riesgos antes de cambiarlo.
- `base-architecture-guard`: Evaluar si una solucion esta bien planteada para crecer, mantenerse y evolucionar sin acoplamiento innecesario. Usar antes de planificar o desarrollar cuando el cambio afecte estructura, responsabilidades, fronteras entre capas o una zona fragil.
- `base-backup-skills`: Generar un backup de las skills disponibles en la ruta solicitada, distinguiendo si se quiere todo el catalogo o solo las skills base. Usar cuando el usuario pida exportar, copiar o respaldar skills.
- `base-data-map`: Generar un mapa de datos por archivo y por metodo, indicando que datos recibe y envia, con tipos y origen/destino verificables. Usar cuando haya que documentar flujo de datos en cualquier stack o como soporte de un analisis tecnico.
- `base-develop-task`: Ejecutar una tarea o un plan siguiendo fases, restricciones y documentacion comun. Usar cuando se pida implementar cambios, ya exista un plan o no, y haya que desarrollar de forma consistente entre proyectos.
- `base-document-project`: Organizar y mantener la documentacion persistente del proyecto bajo DOC/PROYECTO/SUBPROYECTO/MODULO. Usar cuando otra skill necesite guardar o actualizar analysis, changelog, errores, planes, tareas o reuniones.
- `base-error-registry`: Consultar, resolver y registrar errores o comportamientos no deseados por modulo. Usar cuando aparezca un error, una excepcion o una regresion para comprobar si ya existe solucion documentada o registrarla si es nueva.
- `base-golden-rules`: Leer, aplicar y mantener reglas de oro globales y locales del proyecto. Usar cuando haya restricciones que no se deban romper y cuando se detecten patrones que convenga promover a regla permanente.
- `base-memory-protocol`: Definir cuando consultar, guardar, actualizar y consolidar memoria operativa reusable del motor base. Usar cuando una tarea pueda beneficiarse de contexto previo o deje aprendizaje transversal para futuras sesiones.
- `base-plan-work`: Generar un plan de trabajo por fases con archivos a tocar, cambios de codigo esperados, justificacion y estado. Usar cuando el usuario pida planificar una tarea antes de implementarla.
- `base-project-bootstrap`: Leer AGENTS.md, reglas de oro y contexto documental antes de trabajar en uno o varios proyectos. Usar al inicio de un chat o cuando cambie el alcance para alinear proyectos implicados, subproyectos, modulos, skills aplicables y restricciones.
- `base-test-strategy`: Proponer, crear y ejecutar la estrategia minima de tests antes y despues de cambios, detectando cobertura faltante y riesgos de regresion. Usar cuando se vaya a tocar codigo o cuando se quiera revisar que comprobar en un modulo.

## Como interactuan entre ellas
- Flujo base sugerido del motor:
  - `base-project-bootstrap` alinea alcance, reglas y contexto documental.
  - `base-architecture-guard` actua como puerta de calidad estructural antes de planificar o desarrollar cambios no triviales.
  - `base-memory-protocol` decide cuando consultar o persistir memoria reusable.
  - `base-golden-rules` protege restricciones estables y evita romper criterios del motor o del proyecto.
  - `base-plan-work` estructura el trabajo si la tarea necesita plan.
  - `base-analyze-module` y `base-data-map` profundizan en el modulo cuando hace falta entenderlo antes de tocarlo.
  - `base-develop-task` ejecuta el cambio real coordinando plan, memoria, validacion y documentacion.
  - `base-test-strategy` fija la validacion minima relevante y detecta huecos.
  - `base-error-registry` reutiliza o registra diagnosticos y soluciones repetibles.
  - `base-document-project` actua como capa de persistencia para planes, tareas, errores, analisis y memoria operativa.
- `base-backup-skills` queda fuera del flujo diario: sirve para exportar o respaldar el motor cuando se necesita moverlo o conservarlo.

## Politica de versionado del repositorio
- `main` contiene solo la version viva del sistema.
- Las versiones publicadas se marcan con tags Git: `vX.Y.Z`.
- Los artefactos descargables deben vivir en GitHub Releases o generarse externamente.
- No se guardan snapshots historicos (`v1.0.x/`, zips o copias completas) dentro del arbol principal del repo.
- Las ramas se usan para trabajo o mantenimiento paralelo real, no como sustituto de tags.

## Changelog

### v1.1.4
- **Sincronizacion de skills instaladas al repositorio.** Se reflejan en `main` los ajustes operativos que estaban en `~/.codex/skills` para mantener una unica fuente de verdad versionable.
- `base-project-bootstrap` incorpora contrato de testing del proyecto en la salida minima (rutas y comandos global/modulo/archivo).
- `base-plan-work` incorpora contrato obligatorio de plan de testing para cualquier cambio de codigo.
- `base-develop-task` eleva `base-test-strategy` a obligatoria cuando se toca codigo y anade condicion de cierre extendida por tests.
- `base-test-strategy` se amplia con clasificacion `bugfix|feature|refactor`, regla de regresion historica, gate de cierre y plantilla de salida estandar obligatoria.
- `base-analyze-module` y `base-document-project` refuerzan cobertura de variantes funcionales y persistencia estable de estrategia de pruebas.

### v1.1.3
- **Estandar visual estricto para `base-data-map`.** La vista `DataMap.visual.html` deja de ser un diagrama libre y pasa a ser una proyeccion 1:1 de `DataMap.md`.
- Formato obligatorio en la skill: cajon por `ARCHIVO`, fila por `METODO`, con columnas fijas `DATOS QUE RECIBE` (izquierda) / `METODO` (centro) / `DATOS QUE ENVIA` (derecha).
- Regla explicita para metodos agrupados (`m1 / m2 / m3`): deben desglosarse en filas independientes en la salida visual.
- Plantilla `skills/base-data-map/assets/datamap-template.html` alineada con este formato y con reglas de fidelidad para impedir elementos no presentes en `DataMap.md`.
- Prompt por defecto de `skills/base-data-map/agents/openai.yaml` actualizado para reforzar la salida estructurada por archivo y metodo.

### v1.1.2
- **Sincronizacion con las skills instaladas y endurecimiento del paquete.** Se traen al repo los ajustes operativos aplicados directamente sobre las skills instaladas para diagnostico y validacion de bugs de UI dinamica.
- `base-develop-task` incorpora una pausa de diagnostico antes de encadenar parches visuales cuando el fallo parece vivir en runtime cliente, DOM o visibilidad condicional.
- `base-test-strategy` anade una validacion minima especifica para UI dinamica basada en evidencia verificable del estado real del cliente.
- El paquete refuerza su autoproteccion con `scripts/check_integrity.py`, integrando chequeo previo en `install.sh` y documentandolo en el `README`.

### v1.1.1
- **Limpieza de estrategia Git del repositorio.** Se eliminan snapshots y versiones historicas del arbol principal para dejar `main` como linea viva del sistema.
- El versionado del proyecto pasa a apoyarse en tags y releases, no en carpetas `v1.0.x/` dentro del repo.
- `.gitignore` se simplifica para evitar volver a mezclar artefactos de release con el codigo fuente principal.

### v1.1.0
- **Nueva puerta arquitectonica del motor.** Se anade `base-architecture-guard` para convertir en obligatoria la evaluacion de escalabilidad, acoplamiento, responsabilidades mezcladas y necesidad de saneamiento estructural previo.
- `base-project-bootstrap`, `base-plan-work` y `base-develop-task` pasan a apoyarse en una lectura arquitectonica mas seria antes de actuar.
- `base-golden-rules` eleva a criterio formal del motor la separacion de responsabilidades, el bajo acoplamiento, los contratos claros y el diseno preparado para crecer.
- `base-test-strategy`, `base-analyze-module`, `base-error-registry`, `base-data-map`, `base-document-project` y `base-memory-protocol` se refuerzan para sostener la misma politica de escalabilidad y mantenibilidad.
- El sistema se orienta explicitamente a soluciones estructurales por defecto, dejando las soluciones tacticas como excepciones controladas.

### v1.0.6
- **Claude Code: skills embebidas en CLAUDE.md.** `install.sh` ahora escribe los 11 SKILL.md directamente en `~/.claude/CLAUDE.md`. Se cargan una sola vez al inicio del chat como system prompt (igual que Codex con `config.toml`). No se necesita el Skill tool para el motor base en Claude Code, eliminando el coste de re-inyeccion por invocacion.
- Reglas del motor actualizadas: eliminada la obligacion de invocar con el Skill tool; aplicacion directa desde contexto.
- Marcador `<!-- BASE-SKILLS-EMBEDDED-v1 -->` para evitar duplicados en reinstalaciones.
- Hook PreToolUse simplificado.

### v1.0.5
- **Fix: bootstrap no se repite por chat.** Las skills que tienen "paso 1: ejecutar bootstrap" ahora especifican que es una verificacion, no una re-ejecucion. Si bootstrap ya se ejecuto en el chat, no se vuelve a lanzar aunque otra skill lo mencione en su flujo.
- `install.sh`: regla 4 anadida al `CLAUDE.md` global — bootstrap una vez por chat; para tareas pequenas y obvias actuar directamente sin invocar la cadena completa de skills.
- Skills actualizadas: `base-develop-task`, `base-error-registry`, `base-plan-work`, `base-data-map`, `base-test-strategy`, `base-analyze-module`.

## Criterio del sistema
- Las skills base definen fases del trabajo, no detalles de stack.
- El contexto especifico de proyecto debe vivir fuera del motor base.
- La memoria operativa se usa de forma ligera y selectiva; no sustituye la verificacion del estado real del proyecto.
- La documentacion persistente y la memoria operativa se coordinan a traves de `base-document-project` y `base-memory-protocol`.
