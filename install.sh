#!/bin/bash
# install.sh — Motor Base de Skills
# Detecta el agente IA activo e instala las skills en la ruta global correcta.

set -e

# Cuando se ejecuta via curl | bash, stdin es el pipe y los 'read' no funcionan.
# Reconectar stdin a la terminal para permitir interaccion.
if [ ! -t 0 ]; then
  exec < /dev/tty
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Deteccion de modo: local vs curl | bash ---
REPO_URL="https://github.com/DevFox91/BASESkills.git"
REPO_LOCAL="$HOME/.devfox-base-skills"

if [ -d "$SCRIPT_DIR/skills" ]; then
  # Modo local: ejecutado desde el repo clonado
  SKILLS_SRC="$SCRIPT_DIR/skills"
else
  # Modo curl: clonar o actualizar el repo en ~/.devfox-base-skills/
  if [ -d "$REPO_LOCAL/.git" ]; then
    echo "Actualizando repo en $REPO_LOCAL..."
    git -C "$REPO_LOCAL" pull --ff-only
  else
    echo "Clonando repo en $REPO_LOCAL..."
    git clone "$REPO_URL" "$REPO_LOCAL"
  fi
  SKILLS_SRC="$REPO_LOCAL/skills"
fi

# --- Deteccion de agentes ---
CANDIDATES=()
[ -d "$HOME/.claude" ]  && CANDIDATES+=("claude-code:$HOME/.claude/skills")
[ -d "$HOME/.cursor" ]  && CANDIDATES+=("cursor:$HOME/.cursor/skills")
[ -d "$HOME/.codex" ]   && CANDIDATES+=("codex:$HOME/.codex/skills")

# --- Seleccion de destino ---
if [ ${#CANDIDATES[@]} -eq 0 ]; then
  echo "No se ha detectado ninguna herramienta compatible (Claude Code, Cursor, Codex)."
  printf "Introduce una ruta de instalacion personalizada (o Enter para abortar): "
  read -r CUSTOM_PATH
  CUSTOM_PATH="${CUSTOM_PATH/#\~/$HOME}"
  if [ -z "$CUSTOM_PATH" ]; then
    echo "Abortando. Consulta AGENT_INSTALL.md para instalacion manual."
    exit 1
  fi
  AGENT="custom"
  DEST="$CUSTOM_PATH"
fi

if [ ${#CANDIDATES[@]} -eq 1 ]; then
  echo "Herramienta detectada: ${CANDIDATES[0]%%:*} → ${CANDIDATES[0]##*:}"
  echo "  1) Instalar aqui"
  echo "  2) Ruta personalizada"
  printf "Elige una [1-2]: "
  read -r CHOICE
  if [ "$CHOICE" -eq 2 ] 2>/dev/null; then
    printf "Introduce la ruta de instalacion: "
    read -r CUSTOM_PATH
    CUSTOM_PATH="${CUSTOM_PATH/#\~/$HOME}"
    if [ -z "$CUSTOM_PATH" ]; then
      echo "Ruta vacia. Abortando."
      exit 1
    fi
    AGENT="custom"
    DEST="$CUSTOM_PATH"
  else
    AGENT="${CANDIDATES[0]%%:*}"
    DEST="${CANDIDATES[0]##*:}"
  fi
else
  echo "Se han detectado varias herramientas:"
  for i in "${!CANDIDATES[@]}"; do
    echo "  $((i+1))) ${CANDIDATES[$i]%%:*}"
  done
  CUSTOM_OPT=$(( ${#CANDIDATES[@]} + 1 ))
  echo "  $CUSTOM_OPT) Ruta personalizada"
  printf "Elige una [1-%d]: " "$CUSTOM_OPT"
  read -r CHOICE
  if [ "$CHOICE" -eq "$CUSTOM_OPT" ] 2>/dev/null; then
    printf "Introduce la ruta de instalacion: "
    read -r CUSTOM_PATH
    CUSTOM_PATH="${CUSTOM_PATH/#\~/$HOME}"
    if [ -z "$CUSTOM_PATH" ]; then
      echo "Ruta vacia. Abortando."
      exit 1
    fi
    AGENT="custom"
    DEST="$CUSTOM_PATH"
  else
    CHOICE=$((CHOICE - 1))
    if [ -z "${CANDIDATES[$CHOICE]}" ]; then
      echo "Opcion invalida. Abortando."
      exit 1
    fi
    AGENT="${CANDIDATES[$CHOICE]%%:*}"
    DEST="${CANDIDATES[$CHOICE]##*:}"
  fi
fi

echo "Agente detectado: $AGENT"
echo "Instalando en:    $DEST"
echo ""

# --- Instalacion ---
mkdir -p "$DEST"

for SKILL_DIR in "$SKILLS_SRC"/*/; do
  SKILL_NAME="$(basename "$SKILL_DIR")"
  SKILL_DEST="$DEST/$SKILL_NAME"

  if [ -d "$SKILL_DEST" ]; then
    printf "  [!] '%s' ya existe. Sobreescribir? [s/N]: " "$SKILL_NAME"
    read -r CONFIRM
    if [[ "$CONFIRM" != "s" && "$CONFIRM" != "S" ]]; then
      echo "      Omitida."
      continue
    fi
    rm -rf "$SKILL_DEST"
  fi

  cp -r "$SKILL_DIR" "$DEST/"
  echo "  [OK] $SKILL_NAME"
done

# --- Configuracion global Claude Code ---
if [ "$AGENT" = "claude-code" ]; then
  echo ""
  echo "Configurando entorno Claude Code..."

  CLAUDE_DIR="$HOME/.claude"
  CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"
  SETTINGS="$CLAUDE_DIR/settings.json"
  MOTOR_MARKER="Motor de skills — obligatorio en todos los proyectos"

  # 1. CLAUDE.md global
  if [ ! -f "$CLAUDE_MD" ]; then
    cat > "$CLAUDE_MD" << 'EOF'
# Reglas globales de Claude Code

## Motor de skills — obligatorio en todos los proyectos

Antes de tocar cualquier archivo de codigo o documentacion:

1. **DEBES invocar la skill correspondiente con el `Skill` tool**, no solo mencionarla en texto.
   - Cambios de codigo → `Skill: base-develop-task`
   - Planificacion previa → `Skill: base-plan-work`
   - Analisis de modulo → `Skill: base-analyze-module`

2. **Un cambio no esta terminado hasta que la documentacion este persistida.**
   Si no existe estructura `DOC/`, indicarlo explicitamente. No marcar una tarea como completa sin documentar.

3. **Anunciar una skill sin invocarla con el `Skill` tool cuenta como no haberla ejecutado.**
   Si detectas que vas a editar un archivo sin haber invocado `base-develop-task`, detente y hazlo antes.

4. **`base-project-bootstrap` se ejecuta una sola vez por chat**, al inicio o si el alcance cambia.
   Cuando una skill diga "paso 1: ejecutar bootstrap", significa verificar que ya se hizo, no repetirlo.
   Para tareas pequenas y obvias (fix puntual, cambio de una linea), actuar directamente sin invocar la cadena completa de skills.
EOF
    echo "  [OK] ~/.claude/CLAUDE.md creado con reglas del motor"
  elif ! grep -qF "$MOTOR_MARKER" "$CLAUDE_MD"; then
    cat >> "$CLAUDE_MD" << 'EOF'

---

## Motor de skills — obligatorio en todos los proyectos

Antes de tocar cualquier archivo de codigo o documentacion:

1. **DEBES invocar la skill correspondiente con el `Skill` tool**, no solo mencionarla en texto.
   - Cambios de codigo → `Skill: base-develop-task`
   - Planificacion previa → `Skill: base-plan-work`
   - Analisis de modulo → `Skill: base-analyze-module`

2. **Un cambio no esta terminado hasta que la documentacion este persistida.**
   Si no existe estructura `DOC/`, indicarlo explicitamente. No marcar una tarea como completa sin documentar.

3. **Anunciar una skill sin invocarla con el `Skill` tool cuenta como no haberla ejecutado.**
   Si detectas que vas a editar un archivo sin haber invocado `base-develop-task`, detente y hazlo antes.

4. **`base-project-bootstrap` se ejecuta una sola vez por chat**, al inicio o si el alcance cambia.
   Cuando una skill diga "paso 1: ejecutar bootstrap", significa verificar que ya se hizo, no repetirlo.
   Para tareas pequenas y obvias (fix puntual, cambio de una linea), actuar directamente sin invocar la cadena completa de skills.
EOF
    echo "  [OK] Reglas del motor anadidas a ~/.claude/CLAUDE.md existente"
  else
    echo "  [--] ~/.claude/CLAUDE.md ya contiene las reglas del motor"
  fi

  # 2. Hook PreToolUse en settings.json
  if [ ! -f "$SETTINGS" ]; then
    cat > "$SETTINGS" << 'EOF'
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "echo '{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"additionalContext\":\"⚠ MOTOR DE SKILLS: Antes de editar este archivo, ¿invocaste base-develop-task via Skill tool? Si no lo hiciste, detente y hazlo antes de continuar.\"}}'"
          }
        ]
      }
    ]
  }
}
EOF
    echo "  [OK] ~/.claude/settings.json creado con hook del motor"
  elif ! grep -qF "base-develop-task" "$SETTINGS"; then
    python3 - "$SETTINGS" << 'PYEOF'
import json, sys

path = sys.argv[1]
hook_entry = {
    "matcher": "Edit|Write",
    "hooks": [{
        "type": "command",
        "command": "echo '{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"additionalContext\":\"⚠ MOTOR DE SKILLS: Antes de editar este archivo, ¿invocaste base-develop-task via Skill tool? Si no lo hiciste, detente y hazlo antes de continuar.\"}}'",
        "statusMessage": "Verificando motor de skills..."
    }]
}

try:
    with open(path) as f:
        data = json.load(f)
except (json.JSONDecodeError, FileNotFoundError):
    data = {}

hooks = data.setdefault("hooks", {})
pre = hooks.setdefault("PreToolUse", [])
pre.append(hook_entry)

with open(path, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")

print("  [OK] Hook del motor anadido a ~/.claude/settings.json")
PYEOF
  else
    echo "  [--] ~/.claude/settings.json ya contiene el hook del motor"
  fi
fi

echo ""
echo "Instalacion completada en: $DEST"
echo "Reinicia el agente para que cargue las skills."
