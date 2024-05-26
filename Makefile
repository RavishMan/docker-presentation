# Makefile

# Переменная для задания версии приложения
# (вопросительный знак дает возможность условно присвоить. Если ее к примеру не прокинули)
APP_VERSION?=1.0.2

IMAGE_NAME=docker-presentation-app

build:
	docker build --build-arg APP_VERSION=$(APP_VERSION) -t $(IMAGE_NAME) .

run:
	docker run -d -p 8080:80 --name app_container $(IMAGE_NAME)

compose-build:
	docker-compose build --no-cache

compose-up:
	docker-compose up -d
