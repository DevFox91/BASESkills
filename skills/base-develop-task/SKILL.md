---
name: base-develop-task
description: Ejecutar una tarea o un plan siguiendo fases, restricciones y documentacion comun. Usar cuando se pida implementar cambios, ya exista un plan o no, y haya que desarrollar de forma consistente entre proyectos.
---

# Base Develop Task

## Proposito
Desarrollar cambios reales con el mismo flujo de trabajo en cualquier proyecto.

## Skills relacionadas
- Llamadas obligatorias:
  - `base-project-bootstrap`
  - `base-architecture-guard`
  - `base-memory-protocol`
  - `base-golden-rules`
  - `base-error-registry`
  - `base-document-project`
- Llamadas opcionales:
  - `base-test-strategy`
  - `base-analyze-module`
  - `base-data-map`
  - `base-plan-work` si no existe plan y el cambio no es trivial

## Flujo
1. Verificar que `base-project-bootstrap` fue ejecutado en este chat. Si ya se ejecutó en esta sesión, no repetirlo — usar el contexto existente. Solo volver a ejecutarlo si el alcance del proyecto cambió.
2. Leer el plan si existe.
3. Ejecutar `base-architecture-guard` si el trabajo no es trivial o toca una zona sensible.
4. Si hay plan, seguir las fases en el orden definido.
5. Si no hay plan, agrupar mentalmente el trabajo en bloques pequenos antes de tocar codigo.
6. Antes del segundo parche sobre el mismo bug, hacer una pausa de diagnostico si el problema parece de UI runtime, render cliente, DOM, estilos aplicados en tiempo de ejecucion, eventos de ciclo de vida o visibilidad condicional.
7. En esa pausa de diagnostico, fijar explicitamente en cual de estas capas vive el fallo:
- servidor
- tema o CSS estatico
- cliente o DOM runtime
- integracion entre capas
8. Si el componente depende de JavaScript, overlays, `setVisible(false)`, render diferido, resize, attach/detach o mutacion del DOM, anadir una observacion verificable antes de seguir:
- inspeccion de existencia real de nodos clave
- estado visible/oculto real
- instrumentacion minima temporal en consola, objeto global o logs cliente
9. No encadenar mas cambios visuales mientras no exista al menos una evidencia verificable del estado real del componente en la capa afectada.
10. Aplicar cambios.
11. Ejecutar validacion minima relevante.
12. Cerrar la tarea con revision de aprendizaje reusable:
- si hubo una leccion que reduzca arranque futuro -> memoria de arranque
- si hubo una secuencia de ejecucion especialmente eficaz -> memoria de ejecucion
- si hubo una validacion minima valiosa -> memoria de validacion
- si hubo un error repetible -> registro de errores y memoria de errores
- si hubo una decision, patron o descubrimiento vivo -> actualizar memoria de temas en lugar de duplicar notas
13. Persistir tarea, changelog y memoria relevante con `base-document-project`.
14. Si durante la tarea se ha reutilizado memoria con impacto real, emitir una salida breve de ahorro:
- formato: `He ahorrado tiempo porque ...`
- solo cuando la memoria haya evitado exploracion, replanteos, validacion redefinida o rediagnostico
- si la memoria se consulto pero no aporto ahorro real, no emitir esta salida
15. Si durante la tarea se detecta una carencia recurrente del propio motor, sugerir ajuste de skill:
- solo si la mejora propuesta es generalizable a futuros trabajos
- nunca si la necesidad nace de un proyecto, lenguaje o framework concretos
- la sugerencia debe explicar que skill tocar y que problema de flujo resolveria

## Bloqueos
Detenerse y pedir informacion solo si ocurre una de estas situaciones:
- Falta una decision funcional real.
- Hay varias opciones validas con impacto importante.
- Hay riesgo de romper datos, permisos o integraciones.
- La opcion estructural y la tactica tienen consecuencias futuras muy distintas y no es razonable asumir una sin confirmar.
- El problema sigue bloqueado tras investigacion local razonable.

## Comentarios en codigo
- Anadir comentarios solo cuando aporten valor.
- Comentar:
  - workarounds
  - reglas de negocio no obvias
  - decisiones defensivas contra regresiones
  - codigo cuya intencion no sea evidente
- No comentar lineas triviales.

## Validacion
- Si existen tests o comandos de chequeo, usar `base-test-strategy`.
- Si no existen, hacer la mejor validacion local razonable y registrarla.
- En bugs de UI dinamica, considerar validacion minima razonable:
  - existencia real de nodos clave
  - estado visible/oculto efectivo
  - evidencia de ciclo de vida cliente si el comportamiento depende de runtime
- Antes de dar por bueno el cambio, revisar si la solucion ha mejorado, mantenido o empeorado la estructura.

## Aprendizaje del trabajo
- No registrar todo lo ocurrido en la tarea.
- Persistir solo aprendizaje reusable que reduzca tiempo, decisiones repetidas, errores o tokens en trabajos futuros.
- Si el aprendizaje no tiene reutilizacion clara, dejarlo solo en la tarea y no promocionarlo a `Memory/`.
- Cuando se persista aprendizaje reusable, usar el formato y los criterios definidos en `base-memory-protocol`.
- Si el aprendizaje pertenece a un tema ya vivo, actualizar la entrada existente en lugar de crear una nueva paralela.

## Criterio estructural obligatorio
- No introducir comportamiento nuevo en una pieza fragil sin evaluar antes si conviene saneamiento minimo.
- No mezclar innecesariamente UI, estado, layout, eventos, datos o integraciones en la misma pieza.
- Si el cambio pequeno obliga a tocar demasiadas cosas, priorizar una extraccion minima segura antes de ampliar comportamiento.
- No presentar una solucion tactica como si fuera la mejor opcion estructural.
- Si se elige una solucion `tactica-controlada` o `urgencia-documentada`, debe quedar explicito en la tarea y en el changelog.

## Salida de ahorro
- La frase `He ahorrado tiempo porque ...` es opcional y condicional.
- Solo debe aparecer si puede explicarse una accion evitada gracias a memoria ya existente.
- Motivos validos:
  - se evitaron lecturas o exploracion redundante
  - se evito rehacer un plan o replantear el enfoque
  - se reutilizo una validacion minima ya aprendida
  - se reutilizo el diagnostico o la solucion de un error conocido
- Motivos no validos:
  - simplemente se reviso memoria pero no sirvio
  - la memoria confirmo lo que ya era obvio
  - el ahorro es especulativo o no se puede explicar de forma concreta
- La salida debe ser breve y causal, por ejemplo:
  - `He ahorrado tiempo porque la memoria de arranque ya identificaba las rutas clave del proyecto.`
  - `He ahorrado tiempo porque la validacion minima ya estaba fijada y no ha hecho falta redefinirla.`
  - `He ahorrado tiempo porque el error ya estaba diagnosticado y se ha reutilizado la solucion previa.`

## Sugerencia de mejora del motor
- El motor puede sugerir modificar una skill base cuando detecte una friccion recurrente del flujo de trabajo.
- La sugerencia debe ser excepcional, no rutinaria.
- Solo es valida si cumple todas estas condiciones:
  - mejora varias tareas futuras, no solo la actual
  - aplica al trabajo en general y no a un proyecto concreto
  - no depende de un lenguaje, framework o arquitectura especificos
  - puede expresarse como mejora de una fase del motor o de su persistencia documental
- La salida debe ser breve y concreta:
  - `Sugiero ajustar la skill X para que ...`
- Motivos validos:
  - una skill carece de un paso general que se echa en falta de forma repetida
  - dos skills se solapan y generan trabajo redundante
  - falta un criterio claro para decidir, persistir o validar
  - la memoria actual no captura un aprendizaje transversal importante
- Motivos no validos:
  - preferencias de un proyecto concreto
  - necesidades de un stack concreto
  - mejoras que deberian resolverse en `AGENTS.md` o documentacion local del proyecto
- Si la mejora detectada es local al proyecto, proponerla en la documentacion del proyecto y no como cambio del motor.

## Documentacion
- Tarea -> `TAREAS/AAAA_MM_DD_slug.md`
- Cambio relevante -> `Changelog.md`
- Si aparecen reglas nuevas o errores repetibles, coordinar con `base-golden-rules` o `base-error-registry`.
- Si aparece aprendizaje operativo reutilizable, coordinar con `base-document-project` para actualizar `Memory/*.md`.
- Si el cambio mejora o evita deuda estructural, documentarlo explicitamente.

## Condicion de cierre obligatoria
- Un cambio de codigo NO esta terminado hasta que la documentacion este persistida.
- No presentar ningun cambio al usuario como "listo", "hecho" o equivalente sin haber ejecutado el paso 8.
- Si la sesion termina antes de documentar, indicar explicitamente que la documentacion queda pendiente y hacerlo en el siguiente turno antes de cualquier otro cambio.
