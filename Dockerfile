FROM python:3.9-alpine AS builder

RUN apk add --no-cache gcc=12.2.1_git20220924-r10 musl-dev=1.2.3_git20220926-r8 libffi-dev=3.4.4-r0

WORKDIR /app

FROM python:3.9-alpine AS production

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

COPY app.py /app/

RUN adduser -D -s /bin/bash appuser && \
    chown -R appuser:appuser /app

EXPOSE 5000

USER appuser

ENV ENV=production

CMD ["python", "app.py"]
