FROM ubuntu:20.04

# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive
ENV DB_URL="sqlite:///db.sqlite"

RUN set -xe \
    && apt-get update -y \
    && apt-get install -y python3 \
    && apt-get install -y python3-pip \
    && apt-get install -y python3-dev \
    && apt-get install -y build-essential \
    && apt-get install -y libmysqlclient-dev \
    && apt-get install -y libvirt-dev
    
WORKDIR /opt/python-todo
COPY . /opt/python-todo
RUN pip install -r requirements.txt
RUN python3 db_create.py

ENTRYPOINT gunicorn -b 0.0.0.0:5000 -w 2 server:app