# Tarea: Limpiar versionado git y snapshots del repo

**Fecha**: 2026-03-27
**Repositorio**: `BASE Skills`
**Estado**: Completada

## Descripcion

Se adapta el repositorio para seguir una estrategia git mas profesional: `main` como linea viva, versionado mediante tags y releases, y sin carpetas historicas de versiones o zips dentro del arbol principal.

## Cambios realizados

- Limpieza de snapshots historicos del repo.
- Simplificacion de `.gitignore` para no mezclar artefactos de release con codigo fuente.
- Actualizacion de `README.md` con politica explicita de versionado:
  - `main` para la version viva
  - tags para releases
  - artefactos fuera del arbol principal
- Bump de version del paquete a `1.1.1`.

## Motivo tecnico

Guardar versiones completas dentro de la rama principal degrada la higiene del repositorio, mezcla codigo fuente con distribuciones historicas y dificulta que Git haga su trabajo natural de versionado.

## Resultado

El repo queda alineado con una estrategia mas seria:
- fuente viva en `main`
- releases por tag
- artefactos fuera del arbol principal
