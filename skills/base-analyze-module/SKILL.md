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
4. Analisis individual por archivo.
5. Flujo de datos.
6. Validaciones.
7. Manejo de errores.
8. Roles y permisos.
9. Tests existentes y faltantes.
10. Formatos especificos de datos.
11. Integraciones especiales.
12. Puntos a mejorar.

## Regla de profundidad
- Si el modulo es pequeno, fusionar secciones relacionadas para evitar relleno.
- Si una seccion no aplica, indicarlo brevemente y seguir.
- No convertir un analisis pequeno en una auditoria gigante por defecto.

## Flujo
1. Ejecutar `base-project-bootstrap`.
2. Consultar `Memory/AnalysisMemory.md` si existe para reutilizar focos de inspeccion ya valiosos.
3. Si el modulo tiene decisiones vivas, errores repetidos o hallazgos condensados, aplicar `base-memory-protocol` y consultar solo la memoria tematica necesaria antes de auditar.
4. Localizar archivos reales del modulo.
5. Hacer lectura funcional y estructural.
6. Llamar a `base-data-map` para el flujo de datos.
7. Sintetizar hallazgos tecnicos y de producto.
8. Persistir con `base-document-project` en `Analysis.md` y `DataMap.md`.
9. Si el analisis descubre criterios que aceleren futuras auditorias del mismo contexto, promoverlos a `Memory/AnalysisMemory.md`.

## Reglas
- Si el modulo toca varios proyectos, generar analisis separado por proyecto.
- No inventar roles, permisos o validaciones: solo usar evidencia de codigo o configuracion.
- Los puntos a mejorar deben centrarse en riesgos, deuda tecnica, huecos de test, duplicidad o acoplamiento.
- No convertir cada hallazgo del analisis en memoria; solo los que reduzcan analisis futuros de forma clara.
- La memoria previa orienta focos de inspeccion, pero nunca sustituye la lectura real del modulo.
