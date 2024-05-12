# Пробуем переназначить переменную из docker-compose.yml, при docker compose build --no-cache
ARG APP_VERSION=1.0.2

# Этап 1: Установка зависимостей. Создаем образ для установки зависимостей.
FROM node:alpine as dependencies
WORKDIR /app
COPY package.json package-lock.json ./
# Здесь переменная не будет отображаться, потому что она не определена через ARG
RUN echo "Value is: $APP_VERSION"
RUN npm install

# Этап 2: Сборка приложения. Создаем образ, в котором будет происходить сборка приложения.
FROM node:alpine as build

WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY . .
# Определение переменной.
# По умолчанию - пытается найти ранее определенную переменную.
# При docker compose build в приоритете - переменная из docker-compose.yml
# При docker build в приоритете - он игнорирует docker-compose.yml
ARG APP_VERSION
RUN echo "Value is: $APP_VERSION"

# Попробуем переназначить переменную, чтобы в следующем образе получить другую переменную.
ARG APP_VERSION=1.0.3

RUN echo "Value changed to: $APP_VERSION"

RUN npm run build

# Этап 3: Финальный образ, без использования node:alpine. Значительно облегчает образ.
FROM nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 8080
# Определяем переменную, в надежде, что увидим переназначенную переменную
ARG APP_VERSION

RUN echo "Value is: $APP_VERSION"

CMD ["nginx", "-g", "daemon off;"]
