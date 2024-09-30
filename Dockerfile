FROM public.ecr.aws/lambda/nodejs:18

RUN yum update -y && \
    yum install -y tar gzip && \
    yum clean all && \
    rm -rf /var/cache/yum


# Set up layer directory
RUN mkdir -p /opt/nodejs

WORKDIR /opt/nodejs
COPY package.json .
RUN npm install

ARG MAXMIND_USER_ID
ARG MAXMIND_LICENSE_KEY

ENV MAXMIND_USER_ID=$MAXMIND_USER_ID
ENV MAXMIND_LICENSE_KEY=$MAXMIND_LICENSE_KEY

WORKDIR /opt/maxminddb
RUN echo "Downloading GeoLite2-City database..." && \
    curl -o GeoLite2-City.tar.gz -L -u "${MAXMIND_USER_ID}":"${MAXMIND_LICENSE_KEY}" \
    "https://download.maxmind.com/geoip/databases/GeoLite2-City/download?suffix=tar.gz" && \
    tar -xzvf GeoLite2-City.tar.gz && \
    find . -name '*.mmdb' -exec mv {} . \; && \
    rm -rf GeoLite2-City_* *.tar.gz

WORKDIR /var/task
