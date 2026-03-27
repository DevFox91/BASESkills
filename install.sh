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
  # Marcador unico que indica que las skills estan embebidas en este archivo.
  # Si no existe, se anade el bloque completo de reglas + skills.
  EMBED_MARKER="<!-- BASE-SKILLS-EMBEDDED-v1 -->"

  # Funcion: escribe las reglas del motor y embebe todos los SKILL.md
  _embed_motor() {
    local dest="$1"
    cat >> "$dest" << 'EOF'

---

## Motor de skills — embebido en CLAUDE.md

Las 12 skills base estan definidas al final de este archivo y se cargan una sola
vez al inicio del chat como system prompt. No es necesario usar el Skill tool
para invocarlas: aplica su protocolo directamente desde el contexto.

Reglas de uso:
1. **base-project-bootstrap** al inicio de cada chat o cuando cambie el alcance.
   Una sola vez por chat — no repetirlo aunque otra skill lo mencione en su flujo.
2. **base-architecture-guard** cuando la tarea no sea trivial o toque estructura.
3. **base-develop-task** para cualquier cambio de codigo.
   Un cambio no esta terminado hasta que la documentacion este persistida en DOC/.
4. **La arquitectura importa tanto como la funcionalidad.**
   No des por buena una solucion solo porque funcione hoy si aumenta el acoplamiento o mezcla responsabilidades innecesariamente.
5. **Para tareas pequenas y obvias** (fix de una linea, cambio trivial),
   actuar directamente aplicando criterio del motor sin invocar la cadena completa.
6. Anuncia que skill estas aplicando antes de cada fase.

EOF
    echo "" >> "$dest"
    echo "$EMBED_MARKER" >> "$dest"
    echo "" >> "$dest"
    echo "---" >> "$dest"
    echo "" >> "$dest"
    echo "# Definicion de skills base" >> "$dest"
    local ORDER=(
      base-project-bootstrap
      base-architecture-guard
      base-memory-protocol
      base-golden-rules
      base-plan-work
      base-analyze-module
      base-data-map
      base-develop-task
      base-test-strategy
      base-error-registry
      base-document-project
      base-backup-skills
    )
    for SKILL_NAME in "${ORDER[@]}"; do
      SKILL_FILE="$SKILLS_SRC/$SKILL_NAME/SKILL.md"
      if [ -f "$SKILL_FILE" ]; then
        echo "" >> "$dest"
        echo "---" >> "$dest"
        echo "" >> "$dest"
        cat "$SKILL_FILE" >> "$dest"
      fi
    done
    echo ""
  }

  # 1. CLAUDE.md global
  if [ ! -f "$CLAUDE_MD" ]; then
    echo "# Reglas globales de Claude Code" > "$CLAUDE_MD"
    _embed_motor "$CLAUDE_MD"
    echo "  [OK] ~/.claude/CLAUDE.md creado con motor de skills embebido"
  elif ! grep -qF "$EMBED_MARKER" "$CLAUDE_MD"; then
    _embed_motor "$CLAUDE_MD"
    echo "  [OK] Motor de skills embebido en ~/.claude/CLAUDE.md existente"
  else
    echo "  [--] ~/.claude/CLAUDE.md ya contiene el motor de skills embebido"
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
            "command": "echo '{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"additionalContext\":\"⚠ MOTOR DE SKILLS: Recuerda aplicar base-develop-task y documentar el cambio en DOC/ antes de continuar.\"}}'"
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
        "command": "echo '{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"additionalContext\":\"⚠ MOTOR DE SKILLS: Recuerda aplicar base-develop-task y documentar el cambio en DOC/ antes de continuar.\"}}'",
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
