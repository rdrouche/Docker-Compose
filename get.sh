#!/usr/bin/env bash
# ============================================================================
# get.sh – récupère UNE stack du dépôt Docker-Compose dans le dossier courant
#
#   bash <(wget -qO- https://forge.rdr-it.com/romain/Docker-Compose/raw/branch/main/get.sh) <app>
#   bash <(wget -qO- https://forge.rdr-it.com/romain/Docker-Compose/raw/branch/main/get.sh) <app>/<sous-stack>
#
# Options :
#   --dir <dossier>   destination (créée si besoin) ; défaut : dossier courant
#   --force           écrase les fichiers déjà présents (un .env n'est JAMAIS écrasé)
#   --tgz             télécharge l'archive publiée par rdr-it.com (sans git) : mêmes fichiers que
#                     la commande « Déployer en une commande » du site
#   --branch <nom>    branche du dépôt (défaut : main)
#   --nomove          ne copie rien, laisse le résultat dans un dossier temporaire (affiché)
#   -h, --help        aide
#
# Variables : GET_REPO_URL, GET_BRANCH, GET_API_URL, GET_SITE_URL
# ============================================================================
set -euo pipefail

REPO_URL="${GET_REPO_URL:-https://forge.rdr-it.com/romain/Docker-Compose.git}"
BRANCH="${GET_BRANCH:-main}"
API_URL="${GET_API_URL:-https://rdr-it.com/api/v1}"
SITE_URL="${GET_SITE_URL:-}"

die()   { echo "❌ $*" >&2; exit 1; }
usage() { sed -n '2,19p' "${BASH_SOURCE[0]:-$0}" 2>/dev/null | sed 's/^# \{0,1\}//' || true; }

TARGET=""; DEST="$(pwd)"; FORCE=false; KEEP=false; MODE=git
while [ $# -gt 0 ]; do
  case "$1" in
    --dir)      [ $# -ge 2 ] || die "--dir attend un dossier"; DEST="$2"; shift 2 ;;
    --branch)   [ $# -ge 2 ] || die "--branch attend un nom"; BRANCH="$2"; shift 2 ;;
    --force)    FORCE=true; shift ;;
    --tgz)      MODE=tgz; shift ;;
    --nomove)   KEEP=true; shift ;;
    -h|--help)  usage; exit 0 ;;
    -*)         die "option inconnue : $1 (voir --help)" ;;
    *)          [ -z "$TARGET" ] || die "un seul argument attendu : <app> ou <app>/<sous-stack>"; TARGET="${1%/}"; shift ;;
  esac
done

[ -n "$TARGET" ] || die "aucune stack indiquée. Usage : get.sh <app> | <app>/<sous-stack> [--dir d] [--force] [--tgz]"
[[ "$TARGET" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*(/[A-Za-z0-9][A-Za-z0-9._-]*)?$ ]] || die "nom invalide : « $TARGET » (attendu : app ou app/sous-stack)"
APP="${TARGET%%/*}"; SUB=""; [ "$APP" != "$TARGET" ] && SUB="${TARGET#*/}"

TMP="$(mktemp -d "${TMPDIR:-/tmp}/get-stack.XXXXXX")"
cleanup() { $KEEP || rm -rf "$TMP"; }
trap cleanup EXIT

has_compose() { local f; for f in compose.yaml compose.yml docker-compose.yaml docker-compose.yml; do [ -f "$1/$f" ] && return 0; done; return 1; }
download() { if command -v curl >/dev/null 2>&1; then curl -fsSL "$1"; elif command -v wget >/dev/null 2>&1; then wget -qO- "$1"; else die "curl ou wget requis"; fi; }

echo "📦 Récupération de « $TARGET »"
mkdir -p "$TMP/repo"
if [ "$MODE" = tgz ]; then
  command -v tar >/dev/null 2>&1 || die "tar requis"
  echo "🌐 Archive : $API_URL/stacks/$APP/${SUB:-default}/files.tgz"
  download "$API_URL/stacks/$APP/${SUB:-default}/files.tgz" | tar xz -C "$TMP/repo" || die "téléchargement impossible : stack inconnue ou non publiée ?"
  SRC="$TMP/repo"
else
  command -v git >/dev/null 2>&1 || die "git n'est pas installé"
  echo "🕓 Dépôt : $REPO_URL ($BRANCH)"
  # clone léger : seul le dossier de l'application est extrait (git ≥ 2.25) ; repli sur un clone superficiel complet
  if ! git clone --quiet --depth 1 --filter=blob:none --sparse --branch "$BRANCH" -- "$REPO_URL" "$TMP/repo" 2>"$TMP/err"; then
    rm -rf "$TMP/repo"
    git clone --quiet --depth 1 --branch "$BRANCH" -- "$REPO_URL" "$TMP/repo" 2>"$TMP/err" || { cat "$TMP/err" >&2; die "clone impossible"; }
  else
    git -C "$TMP/repo" sparse-checkout set -- "$APP" >/dev/null 2>&1 || true
  fi
  [ -d "$TMP/repo/$APP" ] || die "l'application « $APP » n'existe pas dans le dépôt"
  SRC="$TMP/repo/$TARGET"
  [ -d "$SRC" ] || die "« $TARGET » n'existe pas dans le dépôt"
fi

# Application à sous-stacks : le dossier de l'application ne contient que les sous-stacks (+ README) → on les liste
if ! has_compose "$SRC"; then
  subs=""
  for d in "$SRC"/*/; do [ -d "$d" ] && has_compose "$d" && subs="$subs ${APP}/$(basename "$d")"; done
  if [ "$MODE" = git ] && [ -z "$SUB" ] && [ -n "$subs" ]; then
    echo "ℹ️  « $APP » propose plusieurs variantes, précisez-en une :" >&2
    for s in $subs; do echo "     get.sh $s" >&2; done
    exit 1
  fi
  die "aucun fichier compose dans « $TARGET »"
fi

if $KEEP; then
  echo "📁 Résultat conservé dans : $SRC (option --nomove, rien n'a été copié)"
  exit 0
fi

# Copie : fichiers déjà présents conservés (sauf --force, et jamais un .env), dossiers vides recréés, droits conservés
SUDO=""
if ! mkdir -p "$DEST" 2>/dev/null || [ ! -w "$DEST" ]; then
  command -v sudo >/dev/null 2>&1 || die "écriture impossible dans $DEST (et sudo absent)"
  SUDO="sudo"; $SUDO mkdir -p "$DEST"
fi
( cd "$SRC" && find . -mindepth 1 \( -type f -o -type l -o \( -type d -empty \) \) -print | sed 's#^\./##' | sort ) > "$TMP/all"
: > "$TMP/copy"; copied=0; skipped=0
while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  if [ -e "$DEST/$rel" ] && [ ! -d "$SRC/$rel" ]; then
    if ! $FORCE || [ "${rel##*/}" = ".env" ]; then skipped=$((skipped + 1)); echo "   ↷ déjà présent, conservé : $rel"; continue; fi
  fi
  printf '%s\n' "$rel" >> "$TMP/copy"; copied=$((copied + 1))
done < "$TMP/all"
if [ -s "$TMP/copy" ]; then
  tar -C "$SRC" -cf - -T "$TMP/copy" | $SUDO tar -C "$DEST" -xf -
fi

echo "✅ « $TARGET » : $copied fichier(s) copié(s) dans $DEST, $skipped conservé(s)."
echo
echo "Étapes suivantes :"
n=1
for e in .env.example .env.sample env.example example.env .env.dist; do
  if [ -f "$DEST/$e" ] && [ ! -f "$DEST/.env" ]; then echo "  $n. cp $e .env"; n=$((n + 1)); break; fi
done
echo "  $n. renseigner .env${SITE_URL:+ (ou le générer : $SITE_URL#$APP)}"; n=$((n + 1))
echo "  $n. docker compose up -d"
