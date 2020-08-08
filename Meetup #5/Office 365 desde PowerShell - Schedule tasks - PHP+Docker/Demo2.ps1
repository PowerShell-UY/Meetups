Set-Location ~\Documents\Dev\Meetup\

#Build la imagen de PHP con el Dockerfile
docker build -t php-pwsh .

#Ejecutar un container a partir de la imagen creada
docker run -d --name pwsh php-pwsh:latest

#Conectarse al container para validar que la instalación esté correcta
docker exec -it pwsh bash

#Crear el container con compose (montando el volumen con los scripts)
docker-compose up -d
