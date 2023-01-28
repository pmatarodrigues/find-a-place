FROM openjdk:8-jdk-alpine
COPY . /app
WORKDIR /app
RUN apk update && apk add --no-cache curl && apk add --no-cache bash
RUN apk add --no-cache gradle
RUN gradle build
CMD ["java","-jar","build/libs/script.jar"]
