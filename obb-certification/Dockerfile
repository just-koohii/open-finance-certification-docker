FROM maven:3.8.3-openjdk-17 AS builder

WORKDIR /usr/src/obb-certification

RUN git clone https://gitlab.com/obb1/certification.git .

RUN mvn --batch-mode --quiet -B -Dmaven.test.skip -Dpmd.skip clean package

FROM openjdk:21-jdk-slim-bullseye

WORKDIR /usr/src/obb-certification

RUN apt-get -qq update
RUN apt-get -qq install -y \
      redir \
      apache2 \
      ssl-cert \
      curl \
      wget
RUN apt-get -qq clean

COPY --from=builder /usr/src/obb-certification/target/fapi-test-suite.jar           /server/fapi-test-suite.jar
COPY ./suite-caller.sh                                              suite-caller.sh

RUN chmod u+x suite-caller.sh
ENV BASE_URL=https://localhost.emobix.co.uk:8443
ENV DIRECTORYROOTS_URL=https://data.sandbox.directory.openbankingbrasil.org.br/roots_directory.jwks
ENV DIRECTORY_PARTICIPANTS_URL=https://data.sandbox.directory.openbankingbrasil.org.br/participants

RUN echo 'Listen 8443' > /etc/apache2/ports.conf \
      && a2enmod headers proxy proxy_http rewrite ssl \
      && a2dissite 000-default.conf

COPY ./httpd-server.conf /etc/apache2/sites-enabled

CMD apachectl start && ./suite-caller.sh
