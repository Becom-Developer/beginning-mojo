FROM perl:5.32.1
RUN cpanm Carton && mkdir -p /usr/src/app && \
apt-get update && \
apt-get install -y sqlite3
WORKDIR /usr/src/app
