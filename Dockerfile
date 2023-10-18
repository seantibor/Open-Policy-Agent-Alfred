FROM python:3.11.5-alpine3.18

LABEL description="OPA Alfred"
LABEL github="https://github.com/dolevf/Open-Policy-Agent-Alfred"
LABEL maintainers="Dolev Farhi"

ARG TARGET_FOLDER=/app
ARG TARGETARCH

WORKDIR $TARGET_FOLDER/

RUN mkdir /app/bin
RUN apk add --update curl
RUN curl -L -o bin/opa https://github.com/open-policy-agent/opa/releases/download/v0.57.0/opa_linux_${TARGETARCH}_static
RUN chmod u+x bin/opa

COPY requirements.txt /app
RUN pip install -r requirements.txt

COPY core /app/core
COPY static /app/static
COPY templates /app/templates
COPY temp /app/temp
COPY config.py /app
COPY alfred.py /app
COPY version.py /app

RUN chown -R nobody. /app

USER nobody

EXPOSE 5000/tcp

CMD ["python3", "alfred.py"]