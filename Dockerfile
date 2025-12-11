FROM python:3.9-alpine AS builder

RUN apk add --no-cache gcc musl-dev libffi-dev

WORKDIR /app

FROM python:3.9-alpine AS production

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

COPY app.py /app/

RUN adduser -D -s /bin/bash appuser

RUN chown -R appuser:appuser /app

EXPOSE 5000

USER appuser

ENV ENV=production

CMD ["python", "app.py"]
