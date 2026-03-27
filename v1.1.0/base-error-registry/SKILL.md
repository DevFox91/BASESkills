---
name: base-error-registry
description: Consultar, resolver y registrar errores o comportamientos no deseados por modulo. Usar cuando aparezca un error, una excepcion o una regresion para comprobar si ya existe solucion documentada o registrarla si es nueva.
---

# Base Error Registry

## Proposito
Evitar resolver varias veces el mismo error sin memoria del proyecto.

## Fuente principal
- `Errores.md` del modulo afectado.
- `Memory/ErrorMemory.md` si existe para reutilizar diagnosticos ya condensados.

## Skills relacionadas
- Llamadas obligatorias:
  - `base-project-bootstrap`
  - `base-memory-protocol`
  - `base-document-project`
- Llamadas opcionales:
  - `base-golden-rules`
  - `base-test-strategy`
- Esta skill suele ser llamada por:
  - `base-develop-task`

## Flujo
1. Verificar que `base-project-bootstrap` fue ejecutado en este chat. Si ya se ejecutó en esta sesión, no repetirlo — usar el contexto existente. Solo volver a ejecutarlo si el alcance del proyecto cambió.
2. Buscar el error en `Errores.md` del modulo.
3. Buscar tambien en `Memory/ErrorMemory.md` si existe.
4. Si ya existe:
- reutilizar diagnostico y solucion previa si siguen siendo validos
5. Si no existe:
- diagnosticar
- resolver
- registrar nueva entrada
6. Si el error afecta varios modulos, documentar en el modulo principal y referenciar los secundarios.
7. Si el error deja una leccion reusable mas alla del caso puntual, condensarla tambien en `Memory/ErrorMemory.md`.
8. Si el error pertenece a un patron o tema repetido, actualizar la memoria tematica correspondiente en vez de duplicar diagnosticos.

## Estructura recomendada por entrada
- Fecha
- Sintoma
- Contexto
- Causa raiz
- Causa raiz arquitectonica si aplica
- Solucion aplicada
- Prevencion futura
- Estado

## Reglas
- No registrar como error una simple duda de implementacion.
- Registrar solo errores repetibles, excepciones reales o comportamientos no deseados confirmados.
- Si la causa raiz no es segura, marcarla como hipotesis.
- No duplicar en memoria un error ya suficientemente cubierto salvo para resumir su diagnostico reusable.
- La memoria de errores debe condensar sintomas, causa y prevencion reutilizable; el detalle puntual sigue viviendo en `Errores.md`.
- Si el error nace de mezcla de responsabilidades, acoplamiento excesivo o frontera difusa, debe dejarse indicado.
