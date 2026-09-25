#!/bin/bash

set -e

echo "Début du déploiement"

ACTIVE_COLOR_FILE="active_color"

if [ ! -f "$ACTIVE_COLOR_FILE" ]; then
    echo "blue" > "$ACTIVE_COLOR_FILE"
fi

ACTIVE=$(cat "$ACTIVE_COLOR_FILE")

if [ "$ACTIVE" = "blue" ]; then
    TARGET="green"
else
    TARGET="blue"
fi

echo "Active : $ACTIVE"
echo "Target : $TARGET"

docker compose --profile $TARGET up -d

echo "Attente du démarrage..."
sleep 15

if curl -f http://localhost:5000/health; then
    echo "$TARGET" > "$ACTIVE_COLOR_FILE"
    echo "Déploiement réussi"
else
    echo "Healthcheck KO"
    docker compose stop app-$TARGET
    echo "Rollback effectué"
    exit 1
