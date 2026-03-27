---
name: base-data-map
description: Generar un mapa de datos por archivo y por metodo, indicando que datos recibe y envia, con tipos y origen/destino verificables. Usar cuando haya que documentar flujo de datos en cualquier stack o como soporte de un analisis tecnico.
---

# Base Data Map

## Proposito
Documentar el flujo de datos metodo a metodo sin depender de pantallas ni de un stack concreto.

## Skills relacionadas
- Llamadas obligatorias:
  - `base-project-bootstrap`
  - `base-document-project`
- Llamadas opcionales: ninguna.
- Esta skill suele ser llamada por:
  - `base-analyze-module`
  - `base-develop-task` cuando haga falta entender flujo antes de tocar codigo

## Salida base
```text
ARCHIVO
- METODO
--- DATOS QUE ENVIA -> metodo destino (dato, tipo, archivo)
--- DATOS QUE RECIBE <- metodo origen (dato, tipo, archivo)
```

## Flujo
1. Verificar que `base-project-bootstrap` fue ejecutado en este chat. Si ya se ejecutó en esta sesión, no repetirlo — usar el contexto existente. Solo volver a ejecutarlo si el alcance del proyecto cambió.
2. Consultar `Memory/DataMapMemory.md` si existe para reutilizar convenciones ya observadas.
3. Tomar uno o varios archivos objetivo.
4. Identificar metodos, handlers, funciones o equivalentes.
5. Para cada metodo documentar:
- datos que recibe
- datos que envia
- tipo de dato si es verificable
- archivo y metodo origen/destino si es verificable
- contratos difusos o dependencias implicitas si se detectan
6. Guardar con `base-document-project` en `DataMap.md`.
7. Si se detectan convenciones de flujo reutilizables del contexto, promoverlas a `Memory/DataMapMemory.md`.

## Reglas
- No usar descripciones vagas como "desde UI" o "a estado" si se puede identificar origen/destino real.
- Si el tipo o el origen no es verificable, marcarlo como `No verificable`.
- Adaptar "metodo" al lenguaje:
  - funcion
  - handler
  - metodo de clase
  - callback nombrado
  - efecto relevante
- Si un archivo no tiene metodos propios, documentar las llamadas principales visibles.
- No duplicar el `DataMap.md` entero en memoria; guardar solo convenciones o atajos reutilizables.
- Si una transformacion de datos esta repartida en demasiadas capas o puntos, dejarlo indicado como riesgo estructural.

## Relacion con otras skills
- `base-analyze-module` debe usar esta skill para la seccion de flujo de datos.
