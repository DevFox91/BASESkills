---
name: base-golden-rules
description: Leer, aplicar y mantener reglas de oro globales y locales del proyecto. Usar cuando haya restricciones que no se deban romper y cuando se detecten patrones que convenga promover a regla permanente.
---

# Base Golden Rules

## Proposito
Evitar que se rompan reglas persistentes de trabajo, arquitectura o producto.
Tambien proteger que las skills base sigan siendo un motor de trabajo generalista y no deriven hacia reglas acopladas a proyectos, stacks o lenguajes concretos.

## Ubicacion
- Regla general de proyecto: `REGLAS_DE_ORO.md` en la raiz del proyecto.
- Regla local de subproyecto: `REGLAS_DE_ORO.md` en la raiz del subproyecto.

## Skills relacionadas
- Llamadas obligatorias:
  - `base-project-bootstrap`
- Llamadas opcionales:
  - `base-document-project` si se actualizan reglas persistentes

## Flujo
1. Leer reglas globales y locales al arrancar el trabajo.
2. Consultar `Memory/RulesMemory.md` si existe para revisar criterios recurrentes aun no promovidos.
3. Aplicarlas antes de planificar, analizar o desarrollar.
4. Si durante el trabajo aparece una regla recurrente valiosa:
- proponerla al usuario
- o anadirla si el usuario lo ha pedido explicitamente
5. Si una observacion es util pero todavia no merece `REGLAS_DE_ORO.md`, registrarla en `Memory/RulesMemory.md`.
6. Mantener separadas reglas generales y locales.

## Reglas
- Nunca contradecir una regla local con una global; la local manda en su ambito.
- No convertir observaciones puntuales en reglas de oro sin justificacion.
- Una regla de oro debe ser:
  - estable
  - repetible
  - util para evitar errores o incoherencias
- Distinguir siempre entre:
  - regla formal: estable y merecedora de `REGLAS_DE_ORO.md`
  - criterio recurrente: aun no consolidado, va a `Memory/RulesMemory.md`
  - aprendizaje operativo: util para una fase concreta, debe quedarse en la memoria de esa fase y no subir a reglas
- `Memory/RulesMemory.md` puede guardar criterios recurrentes, pero no sustituye una regla formal ni debe llenarse de notas puntuales.
- Ninguna skill base debe basarse en un proyecto concreto, un lenguaje concreto o un framework concreto.
- Las skills base describen fases, decisiones y criterios del trabajo; los detalles de stack deben vivir en contexto de proyecto, no en el motor.
- El motor base debe favorecer siempre:
  - separacion de responsabilidades
  - bajo acoplamiento
  - contratos claros entre piezas
  - localizacion del cambio
  - soluciones preparadas para crecer
- Que una solucion funcione hoy no basta para considerarla buena.
- El estandar por defecto del motor es la solucion estructural y sostenible.
- Una solucion tactica solo es aceptable si:
  - no existe una opcion limpia razonable para el contexto
  - o hay urgencia real
  - y el riesgo queda explicitado
- Si un cambio pequeno obliga a tocar una pieza grande o fragil, debe tratarse como senal de deuda estructural.

## Salida esperada
- Lista breve de reglas activas que afectan a la tarea actual.
- Propuesta de nueva regla solo cuando haya evidencia clara.
