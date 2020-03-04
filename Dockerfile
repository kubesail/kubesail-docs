FROM python:3.8.1-alpine3.11

WORKDIR /usr/src/app

COPY ./docs /app/docs
COPY ./mkdocs.yml requirements.txt /app/

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt && \
    mkdocs build

# Start development server by default
FROM nginx
COPY --from=0 /app/site /usr/share/nginx/html
EXPOSE 80
