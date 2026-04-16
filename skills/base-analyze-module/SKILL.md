---
name: base-analyze-module
description: Analizar un modulo desde perspectiva funcional, estructural y tecnica, generando documentacion por proyecto implicado. Usar cuando se pida entender un modulo, auditarlo, documentarlo o detectar riesgos antes de cambiarlo.
---

# Base Analyze Module

## Proposito
Entender un modulo con suficiente profundidad para poder mantenerlo, mejorarlo o coordinar trabajo entre proyectos.

## Cuando usarla
- Analisis de un modulo.
- Auditoria previa a cambios.
- Documentacion de arquitectura funcional.
- Revision de riesgos, validaciones, permisos o tests de un modulo.

## Skills relacionadas
- Llamadas obligatorias:
  - `base-project-bootstrap`
  - `base-architecture-guard`
  - `base-data-map`
  - `base-document-project`
- Llamadas opcionales:
  - `base-memory-protocol`
  - `base-golden-rules`
  - `base-test-strategy`
  - `base-error-registry`

## Estructura base del analisis
1. Descripcion general del modulo.
2. Analisis funcional:
- Perspectiva de usuario final.
- Casos de uso.
- Limitaciones y dependencias visibles.
3. Analisis estructural:
- Pantallas o vistas si aplica.
- Recursos, servicios, controladores, modelos o equivalentes segun stack.
4. Analisis por variantes funcionales si aplica:
- Tipos, subtipos, estados o modos operativos.
- Minimos requeridos por variante.
- Defaults exactos por variante.
- Dependencias condicionales entre campos o bloques.
- Campos visibles, ocultos o no aplicables por variante.
- Participantes o actores derivados automaticamente.
- Validaciones de guardado o cierre por variante.
- Pestañas, paneles o pasos que aplican por variante.
5. Analisis individual por archivo.
6. Flujo de datos.
7. Validaciones.
8. Manejo de errores.
9. Roles y permisos.
10. Tests existentes y faltantes.
11. Formatos especificos de datos.
12. Integraciones especiales.
13. Puntos a mejorar.
14. Barreras de escalabilidad y coste de cambio.

## Regla de profundidad
- Si el modulo es pequeno, fusionar secciones relacionadas para evitar relleno.
- Si una seccion no aplica, indicarlo brevemente y seguir.
- No convertir un analisis pequeno en una auditoria gigante por defecto.
- Si la pantalla analizada delega la operativa real en un detalle, formulario, wizard o panel hijo, el analisis no debe cerrarse solo en la pantalla contenedora.
- Si existen variantes funcionales relevantes por tipo, subtipo, estado o modo, el analisis debe bajar al nivel de reglas reales por variante y no quedarse en una descripcion global.

## Criterio especial para modulos con formularios complejos
- Cuando el modulo tenga una pantalla contenedora y otra pieza donde ocurre el guardado real, identificar explicitamente:
  - pantalla contenedora
  - pieza operativa real
  - frontera entre ambas
- Cuando el modulo tenga pestañas, paneles o pasos condicionales, documentar:
  - cuando aparece cada bloque
  - que campos gobierna
  - que bloquea
  - que datos produce o transforma
- Cuando el objetivo del analisis pueda alimentar agentes, prompts o automatizaciones, el analisis debe dejar verificable:
  - que puede decidir la capa conversacional
  - que debe validar la capa de dominio
  - que minima informacion requiere cada variante para ejecutarse con seguridad

## Checklist obligatorio para variantes funcionales
Si aplica alguna variante funcional relevante, el analisis debe responder explicitamente para cada una:
- que intenta crear o resolver el usuario
- que campos son minimos
- que valores por defecto existen
- que campos cambian de obligatoriedad
- que campos aparecen o desaparecen
- que participantes, responsables o actores se derivan automaticamente
- que validaciones bloquean guardado, cierre o confirmacion
- que bloques, pestañas o pasos entran en juego
- que pieza del codigo es la fuente de verdad de esa variante

## Flujo
1. Verificar que `base-project-bootstrap` fue ejecutado en este chat. Si ya se ejecutó en esta sesión, no repetirlo — usar el contexto existente. Solo volver a ejecutarlo si el alcance del proyecto cambió.
2. Consultar `Memory/AnalysisMemory.md` si existe para reutilizar focos de inspeccion ya valiosos.
3. Si el modulo tiene decisiones vivas, errores repetidos o hallazgos condensados, aplicar `base-memory-protocol` y consultar solo la memoria tematica necesaria antes de auditar.
4. Localizar archivos reales del modulo.
5. Identificar si existe una diferencia entre pantalla contenedora y pieza operativa real. Si existe, ampliar el alcance al menos hasta la pieza que valida o guarda de verdad.
6. Identificar variantes funcionales por tipo, subtipo, estado, modo o pestaña. Si existen, preparar una lectura especifica por variante.
7. Hacer lectura funcional y estructural.
8. Llamar a `base-data-map` para el flujo de datos.
9. Ejecutar `base-architecture-guard` si el modulo tiene una pieza sensible o un hotspot claro.
10. Sintetizar hallazgos tecnicos y de producto.
11. Persistir con `base-document-project` en `Analysis.md` y `DataMap.md`.
12. Si el analisis descubre criterios que aceleren futuras auditorias del mismo contexto, promoverlos a `Memory/AnalysisMemory.md`.

## Reglas
- Si el modulo toca varios proyectos, generar analisis separado por proyecto.
- No inventar roles, permisos o validaciones: solo usar evidencia de codigo o configuracion.
- Los puntos a mejorar deben centrarse en riesgos, deuda tecnica, huecos de test, duplicidad o acoplamiento.
- No convertir cada hallazgo del analisis en memoria; solo los que reduzcan analisis futuros de forma clara.
- La memoria previa orienta focos de inspeccion, pero nunca sustituye la lectura real del modulo.
- El analisis debe senalar explicitamente responsabilidades mezcladas, hotspots monoliticos, barreras de crecimiento y coste de cambio cuando existan.
- Si el modulo tiene formularios complejos, no dar por suficiente un analisis que solo documente listado, launcher o pantalla contenedora.
- Si una capacidad depende del tipo de entidad que se crea o edita, no resumirla como una sola funcionalidad; desglosarla por variante.
- Si el guardado real vive en otra clase, pantalla o panel, debe quedar documentado como fuente de verdad y sus reglas deben entrar en el analisis.
- Si el analisis se va a usar para construir agentes, debe dejar claro que parte es apta para interpretacion conversacional y que parte sigue siendo validacion dura de dominio.
