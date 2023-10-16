FROM python:3.9-alpine3.13
LABEL maintainer="lestermercado.com"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user

# make sure to down the docker first
### >>> docker-compose down
# then start building
### >>>  docker-compose build

# # ==========================
# # ========================== code from git
# # https://github.com/LondonAppDeveloper/c2-recipe-app-api-2/compare/s-05-project-setup-04-create-python-requirements-file...s-05-project-setup-05-create-project-dockerfile
