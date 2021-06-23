FROM python:3 as mkdocs

WORKDIR /usr/src/app
COPY requirements.txt /app/
WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt
COPY ./mkdocs.yml /app/
COPY ./docs /app/docs
RUN mkdocs build
ENTRYPOINT [ "mkdocs", "serve", "-a", "0.0.0.0:80" ]

# Start development server by default
FROM nginx
COPY --from=mkdocs /app/site /usr/share/nginx/html
EXPOSE 80
