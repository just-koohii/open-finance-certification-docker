openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost" \
        -out ./certification.pem \
        -keyout ./certification.key