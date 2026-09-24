# Stage 1 : Builder
FROM python:3.12 AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --prefix=/install -r requirements.txt

# Stage 2 : Runtime
FROM python:3.12-slim

WORKDIR /app

RUN useradd -m appuser

COPY --from=builder /install /usr/local
COPY . .

USER appuser

EXPOSE 5000
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')"

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]