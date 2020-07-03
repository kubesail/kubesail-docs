FROM python:3

WORKDIR /usr/src/app
COPY requirements.txt /app/
WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt
COPY ./mkdocs.yml /app/
COPY ./docs /app/docs
RUN mkdocs build

# Start development server by default
FROM nginx
COPY --from=0 /app/site /usr/share/nginx/html
EXPOSE 80
