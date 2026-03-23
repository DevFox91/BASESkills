---
name: base-backup-skills
description: Generar un backup de las skills disponibles en la ruta solicitada, distinguiendo si se quiere todo el catalogo o solo las skills base. Usar cuando el usuario pida exportar, copiar o respaldar skills.
---

# Base Backup Skills

## Proposito
Respaldar skills de forma controlada.

## Skills relacionadas
- Llamadas obligatorias: ninguna.
- Llamadas opcionales: ninguna.
- Esta skill es operativa y no forma parte del flujo normal de analisis/desarrollo.

## Alcances
- Solo base: skills con prefijo `base-`.
- Todo: todas las skills de usuario en `~/.codex/skills`.
- Seleccion: una lista concreta de skills.

## Flujo
1. Confirmar ruta destino.
2. Confirmar alcance:
- base
- todo
- seleccion
3. Copiar manteniendo estructura de carpetas.
4. Informar que skills se han incluido y cuales no.

## Regla de distincion
Las skills base de este sistema se distinguen por:
- nombre de carpeta con prefijo `base-`
- nombre visible `Base / ...` en `agents/openai.yaml`

## Reglas
- No sobreescribir backups existentes sin indicarlo.
- Si falta la ruta destino, detenerse y pedirla.
