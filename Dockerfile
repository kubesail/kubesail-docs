FROM python:3.8.1-alpine3.11

WORKDIR /usr/src/app

COPY ./docs /app/docs
COPY ./css /app/css
COPY ./mkdocs.yml requirements.txt /app/

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

# Start development server by default
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
