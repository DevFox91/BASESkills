---
name: base-data-map
description: Generar un mapa de datos por archivo y por metodo, indicando que datos recibe y envia, con tipos y origen/destino verificables. Usar cuando haya que documentar flujo de datos en cualquier stack o como soporte de un analisis tecnico.
---

# Base Data Map

## Proposito
Documentar el flujo de datos metodo a metodo sin depender de pantallas ni de un stack concreto.
Mantener una salida textual verificable y una vista grafica derivada, estructurada en cajones por archivo y filas por metodo.

## Skills relacionadas
- Llamadas obligatorias:
  - `base-project-bootstrap`
  - `base-document-project`
- Llamadas opcionales: ninguna.
- Esta skill suele ser llamada por:
  - `base-analyze-module`
  - `base-develop-task` cuando haga falta entender flujo antes de tocar codigo

## Salida base
### 1) Salida textual canonica (obligatoria)
```text
ARCHIVO
- METODO
--- DATOS QUE ENVIA -> metodo destino (dato, tipo, archivo)
--- DATOS QUE RECIBE <- metodo origen (dato, tipo, archivo)
```

### 2) Salida visual derivada (obligatoria cuando exista al menos un bloque `ARCHIVO`)
- Archivo HTML autocontenido (`DataMap.visual.html` o equivalente) con CSS inline.
- Estructura obligatoria:
  - un cajon grande por cada bloque `ARCHIVO` del `DataMap.md`.
  - dentro de cada cajon, una fila por cada `METODO`.
  - en cada fila: izquierda `DATOS QUE RECIBE`, centro `METODO`, derecha `DATOS QUE ENVIA`.
- Si una linea de metodo viene agrupada (`m1 / m2 / m3`), la vista debe separar cada metodo en filas independientes.
- La salida visual nunca sustituye la salida textual canonica.

## Contrato visual obligatorio
```text
CAJON ARCHIVO
- titulo: ARCHIVO <ruta>
- filas: una por metodo

FILA METODO
- columna izquierda: DATOS QUE RECIBE <-
- columna centro: nombre del metodo
- columna derecha: DATOS QUE ENVIA ->
```

## Flujo
1. Verificar que `base-project-bootstrap` fue ejecutado en este chat. Si ya se ejecuto en esta sesion, no repetirlo; usar el contexto existente. Solo volver a ejecutarlo si el alcance del proyecto cambio.
2. Consultar `Memory/DataMapMemory.md` si existe para reutilizar convenciones ya observadas.
3. Tomar uno o varios archivos objetivo.
4. Identificar metodos, handlers, funciones o equivalentes.
5. Para cada metodo documentar:
- datos que recibe
- datos que envia
- tipo de dato si es verificable
- archivo y metodo origen/destino si es verificable
- contratos difusos o dependencias implicitas si se detectan
6. Guardar con `base-document-project` la salida textual en `DataMap.md`.
7. Derivar la salida visual desde `DataMap.md` usando `assets/datamap-template.html` como base.
8. En la vista visual, validar:
- mismo numero de bloques `ARCHIVO` que en `DataMap.md`
- cada bloque `ARCHIVO` del texto aparece en la vista
- una fila por cada `METODO`
- columnas fijas por fila: recibe/centro metodo/envia
- sin nodos, flechas ni relaciones que no aparezcan en el texto
9. Si se detectan convenciones de flujo reutilizables del contexto, promoverlas a `Memory/DataMapMemory.md`.

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
- La salida visual es derivada: no se permite inventar metodos ni relaciones no sustentadas por la salida textual.
- Si no existe ningun bloque `ARCHIVO`, la salida visual puede omitirse y debe justificarse en una nota breve.

## Relacion con otras skills
- `base-analyze-module` debe usar esta skill para la seccion de flujo de datos.
