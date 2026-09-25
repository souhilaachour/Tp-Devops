#!/bin/bash

STATE_FILE="active_color"

if [ ! -f "$STATE_FILE" ]; then
    echo "blue" > "$STATE_FILE"
fi

ACTIVE=$(cat "$STATE_FILE")

if [ "$ACTIVE" = "blue" ]; then
    TARGET="green"
else
    TARGET="blue"
fi

echo "Active color : $ACTIVE"
echo "Target color : $TARGET"

docker compose --profile $TARGET up -d

echo "Waiting for startup..."

HEALTH_OK=false

for i in {1..10}
do
    if docker exec starter-app2-app-$TARGET-1 python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')"
    then
        HEALTH_OK=true
        break
    fi

    echo "Tentative $i..."
    sleep 5
done

if [ "$HEALTH_OK" = true ]
then
    echo "Healthcheck OK"

    echo "$TARGET" > "$STATE_FILE"

    echo "Switching traffic to $TARGET"

    docker stop starter-app2-app-$ACTIVE-1

    echo "Deployment success"
else
    echo "Healthcheck failed"

    echo "Rollback"

    docker stop starter-app2-app-$TARGET-1
fi