FROM adoptopenjdk/openjdk11:alpine-jre

RUN apk update && apk upgrade && \
    apk add --no-cache git openssh

RUN mkdir /app
WORKDIR /app

COPY entrypoint.sh /app/entrypoint.sh
COPY app.jar /app/app.jar
RUN chmod +x /app/entrypoint.sh

RUN adduser -D whale --uid 1000
RUN chown -R whale /app

USER 1000

EXPOSE 8888
ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8 -Duser.country=CA -Duser.language=en -Duser.timezone=UTC -Djava.net.preferIPv4Stack=true
ENTRYPOINT /app/entrypoint.sh
