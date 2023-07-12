# docker run -d -p 8000:8000 alseambusher/crontab-ui
FROM python:3.9-alpine3.15

ENV   CRON_PATH /etc/crontabs

RUN   mkdir /crontab-ui; touch $CRON_PATH/root; chmod +x $CRON_PATH/root

WORKDIR /crontab-ui

LABEL maintainer "@alseambusher"
LABEL description "Crontab-UI docker"

RUN   apk --no-cache add \
      wget \
      curl \
      nodejs \
      npm \
      tzdata

COPY supervisord.conf /etc/supervisord.conf
COPY . /crontab-ui

RUN   npm install

RUN pip install --upgrade pip==20.2.4
RUN pip install supervisor requests dnspython

RUN wget -qO - https://raw.githubusercontent.com/cupcakearmy/autorestic/master/install.sh | bash

ENV   HOST 0.0.0.0

ENV   PORT 8000

ENV   CRON_IN_DOCKER true

EXPOSE $PORT

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
