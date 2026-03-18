#!/bin/bash
# install.sh — Motor Base de Skills
# Detecta el agente IA activo e instala las skills en la ruta global correcta.

set -e

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
  fi

  cp -r "$SKILL_DIR" "$SKILL_DEST"
  echo "  [OK] $SKILL_NAME"
done

echo ""
echo "Instalacion completada en: $DEST"
echo "Reinicia el agente para que cargue las skills."
