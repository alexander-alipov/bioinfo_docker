# Bioinfo Docker Image

Docker-образ с биоинформатическими инструментами:
- **samtools** (v1.17)
- **htsfile**  (v1.17)
- **bcftools** (v1.17)
- **vcftools** (v0.1.16)
- **Python**   (v3.10.12)

## Клонируйте репозиторий

git clone https://github.com/alexander-alipov/bioinfo_docker.git

## Перейдите в каталог 

cd bioinfo_docker

## Выполните сборку Docker-образа

docker build --no-cache -t bioinfo_docker .

## Запустите в интерактивном режиме

docker run -it bioinfo_docker /bin/bash

## Проверьте установку

samtools --version

htsfile --version

bcftools --version

vcftools --version

