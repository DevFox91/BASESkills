---
name: base-architecture-guard
description: Evaluar si una solucion esta bien planteada para crecer, mantenerse y evolucionar sin acoplamiento innecesario. Usar antes de planificar o desarrollar cuando el cambio afecte estructura, responsabilidades, fronteras entre capas o una zona fragil.
---

# Base Architecture Guard

## Proposito
Actuar como puerta obligatoria de calidad estructural del motor base para evitar soluciones que funcionen hoy pero escalen mal manana.

## Cuando usarla
- Antes de planificar cambios no triviales.
- Antes de desarrollar en zonas fragiles o acopladas.
- Cuando un cambio pequeno obliga a tocar una pieza grande.
- Cuando hay dudas sobre si hace falta saneamiento estructural previo.

## Skills relacionadas
- Llamadas obligatorias:
  - `base-project-bootstrap`
- Esta skill debe ser llamada por:
  - `base-plan-work`
  - `base-develop-task`
- Llamadas opcionales:
  - `base-golden-rules`
  - `base-analyze-module`
  - `base-test-strategy`

## Preguntas obligatorias
1. Que responsabilidades tiene esta pieza hoy.
2. Si mezcla responsabilidades que deberian vivir separadas.
3. Donde debe vivir realmente cada parte del cambio.
4. Si el cambio localiza la modificacion o expande el acoplamiento.
5. Si la solucion sigue siendo mantenible si la funcionalidad crece x2 o x3.
6. Si existe una frontera clara entre UI, estado, layout, eventos, datos, integraciones o persistencia.
7. Si la pieza ya es un hotspot fragil y conviene sanearla antes.

## Clasificacion obligatoria
- `estructural`: la solucion separa responsabilidades, localiza el cambio y mejora o conserva una base sana.
- `tactica-controlada`: la solucion resuelve algo acotado sin empeorar de forma relevante la estructura, pero no es la mejor base a futuro.
- `urgencia-documentada`: se acepta una solucion menos sana por urgencia real y debe quedar la deuda explicitamente registrada.

## Flujo
1. Confirmar alcance con `base-project-bootstrap`.
2. Identificar la pieza o piezas afectadas.
3. Responder las preguntas obligatorias.
4. Clasificar la solucion propuesta.
5. Si la clasificacion es `estructural`, permitir continuar.
6. Si la clasificacion es `tactica-controlada`, exigir explicacion breve de por que no compensa saneamiento previo.
7. Si la clasificacion es `urgencia-documentada`, exigir:
- motivo real de urgencia
- riesgo asumido
- deuda que queda abierta
8. Si la pieza mezcla demasiadas responsabilidades y el cambio no es urgente, recomendar saneamiento estructural minimo antes de ampliar comportamiento.

## Reglas
- El motor no debe presentar una solucion como profesional solo porque funcione.
- Si un cambio pequeno exige tocar una zona demasiado grande o fragil, el problema real puede ser estructural.
- No mezclar sin justificacion explicita varias de estas responsabilidades en una misma pieza:
  - UI
  - estado
  - layout
  - eventos
  - acceso a datos
  - integraciones
  - persistencia
- Si hay una opcion razonable mas limpia, debe preferirse frente al workaround fragil.
- `tactica-controlada` y `urgencia-documentada` son excepciones, no el estandar del motor.

## Salida minima
- Clasificacion elegida.
- Riesgo estructural detectado.
- Si hace falta saneamiento previo o no.
- Motivo breve de la decision.
