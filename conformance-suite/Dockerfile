FROM maven:3.9-amazoncorretto-21-al2023 AS builder

WORKDIR /usr/src/conformance-suite

RUN dnf -y update
RUN dnf -y install git

RUN git clone https://gitlab.com/openid/conformance-suite.git .

RUN mvn -q -B -DskipTests=true clean package

FROM amazoncorretto:21-al2023

WORKDIR /usr/src/conformance-suite

RUN dnf -y update
RUN dnf -y install httpd mod_ssl openssl
RUN dnf clean all && rm -rf /var/cache/dnf

COPY --from=builder /usr/src/conformance-suite/target/fapi-test-suite.jar           /server/fapi-test-suite.jar
COPY ./suite-caller.sh                                              suite-caller.sh

RUN chmod u+x suite-caller.sh
ENV ENABLE_HTTPD true
ENV BASE_URL https://certification.inic-of.com:8443
ENV DIRECTORYROOTS_URL https://data.sandbox.directory.openbankingbrasil.org.br/roots_directory.jwks
ENV DIRECTORY_PARTICIPANTS_URL https://data.sandbox.directory.openbankingbrasil.org.br/participants

RUN echo 'Listen 8443' > /etc/httpd/conf.d/ports.conf

COPY ./httpd-server.conf /etc/httpd/conf.d/

RUN rm -f /etc/httpd/conf.d/ssl.conf

RUN mkdir -p /etc/ssl/certification

COPY ./certification.pem /etc/ssl/certification/certification.pem
COPY ./certification.key /etc/ssl/certification/certification.key

# CMD httpd -D BACKGROUND && ./suite-caller.sh

CMD if [ "$ENABLE_HTTPD" = "true" ]; then httpd -D BACKGROUND; fi && ./suite-caller.sh
