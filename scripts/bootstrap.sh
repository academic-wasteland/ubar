#!/bin/sh
# One-time setup of this city on a fresh checkout. Idempotent.
set -eu
here=$(cd "$(dirname "$0")/.." && pwd)
cd "$here"
[ -d rig/.git ] || git -C rig init -q -b main
git -C rig add -A && git -C rig -c user.name="townsfolk" -c user.email="townsfolk@localhost" commit -q -m "rig" 2>/dev/null || true
# Formula check scripts must live inside the rig (Gas City resolves check paths against the rig).
mkdir -p rig/scripts && cp ../pangenome-town/scripts/pt-reply-check.sh rig/scripts/ && chmod +x rig/scripts/pt-reply-check.sh
name=$(python3 -c 'import tomllib; print(tomllib.load(open("town.toml","rb"))["town"]["name"])')
prefix=$(grep -E '^prefix' city.toml | head -1 | sed 's/.*"\(.*\)"/\1/')
if ! gc rig list 2>/dev/null | grep -q "$name-rig"; then
  gc rig add rig --name "$name-rig" --prefix "$prefix" --adopt || gc rig add rig --name "$name-rig" --prefix "$prefix"
fi
grep -qs '^OPENROUTER_API_KEY=' "$HOME/.gc/secrets.env" || echo "warning: OPENROUTER_API_KEY missing from ~/.gc/secrets.env" >&2
[ -e ../data/jasapage/JaSaPaGe.gbz ] || echo "warning: graph not fetched yet; run ../pangenome-town/scripts/fetch-data.sh" >&2
gc doctor || true
