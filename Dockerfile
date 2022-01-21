FROM adoptopenjdk/openjdk11:alpine-jre

RUN apk update && apk upgrade && \
    apk add --no-cache git openssh

RUN mkdir /app
WORKDIR /app

COPY *.jar /app/app.jar
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

RUN adduser -D whale --uid 1000
RUN chown -R whale /app

RUN mkdir -p /home/whale/.ssh
COPY ssh/spring_cloud_config_rsa /home/whale/.ssh
COPY ssh/config /home/whale/.ssh

RUN chmod 400 /home/whale/.ssh/spring_cloud_config_rsa
RUN chmod 400 /home/whale/.ssh/config
RUN chown -R whale /home/whale

USER 1000

EXPOSE 8888
ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8 -Duser.country=CA -Duser.language=en -Duser.timezone=UTC -Djava.net.preferIPv4Stack=true
ENTRYPOINT /app/entrypoint.sh
