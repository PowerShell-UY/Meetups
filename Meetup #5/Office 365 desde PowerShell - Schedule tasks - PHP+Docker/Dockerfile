FROM php:7.3-apache
COPY ./packages-microsoft-prod.deb /
RUN dpkg -i /packages-microsoft-prod.deb
RUN apt-get update
RUN apt-get install -y powershell