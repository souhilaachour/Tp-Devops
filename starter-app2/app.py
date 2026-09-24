from flask import Flask, jsonify
# Test Pull Request
import os
import redis
app = Flask(__name__)

ALERT_THRESHOLD = 25


def get_redis_client():
    return redis.Redis(
        host=os.getenv("REDIS_HOST", "redis"),
        port=6379,
        decode_responses=True
    )

def alert_threshold():
    """Seuil d'alerte au-dessus duquel une notification est declenchee."""
    return ALERT_THRESHOLD


def sanitize_input(value):
    """Echappe les caracteres dangereux d'une entree utilisateur."""
    return value.replace("<", "&lt;").replace(">", "&gt;")


@app.route("/health")
def health():
    try:
        r = get_redis_client()
        r.ping()

        return jsonify(
            status="ok",
            redis="reachable"
        ), 200

    except Exception:
        return jsonify(
            status="error",
            redis="unreachable"
        ), 503

@app.route("/status")
def status():
    return jsonify(service="projet-devops-groupe-demo", version="1.0"), 200
@app.route("/visits")
def visits():
    r = get_redis_client()
    count = r.incr("visits")
    return jsonify(visits=count), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
