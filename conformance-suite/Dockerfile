FROM maven:3.8.3-openjdk-17 AS builder

WORKDIR /usr/src/conformance-suite

RUN git clone https://gitlab.com/openid/conformance-suite.git .

RUN mvn -q -B -DskipTests=true clean package

FROM amazoncorretto:17-al2023-jdk

WORKDIR /usr/src/conformance-suite

RUN dnf -y update
RUN dnf -y install httpd mod_ssl openssl
RUN dnf clean all && rm -rf /var/cache/dnf

COPY --from=builder /usr/src/conformance-suite/target/fapi-test-suite.jar           /server/fapi-test-suite.jar
COPY ./suite-caller.sh                                              suite-caller.sh

RUN chmod u+x suite-caller.sh
ENV BASE_URL https://localhost:8443
ENV DIRECTORYROOTS_URL https://data.sandbox.directory.openbankingbrasil.org.br/roots_directory.jwks
ENV DIRECTORY_PARTICIPANTS_URL https://data.sandbox.directory.openbankingbrasil.org.br/participants

RUN echo 'Listen 8443' > /etc/apache2/ports.conf

COPY ./httpd-server.conf /etc/httpd/conf.d/

RUN rm -f /etc/httpd/conf.d/ssl.conf

RUN mkdir -p /etc/ssl/certs /etc/ssl/private \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/ssl-cert-snakeoil.key \
        -out /etc/ssl/certs/ssl-cert-snakeoil.pem \
        -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"

CMD httpd -D BACKGROUND && ./suite-caller.sh
