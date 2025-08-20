ARG FRM='testdasi/ubuntu-base'
ARG TAG='latest'
ARG DEBIAN_FRONTEND='noninteractive'

FROM ${FRM}:${TAG}
ARG FRM
ARG TAG

## build note ##
RUN echo "$(date "+%d.%m.%Y %T") Built from ${FRM}:${TAG}" >> /build.info

## install static codes ##
RUN rm -Rf /testdasi \
    && mkdir -p /temp \
    && cd /temp \
    && curl -sL "https://github.com/visigoth/static-ubuntu/releases/latest/download/archive.zip" -o /temp/temp.zip \
    && unzip /temp/temp.zip -d /testdasi \
    && rm -Rf /testdasi/deprecated /temp/temp.zip

# add correct key to verify package repository signature
RUN apt -y update && apt -y install gnupg gnupg1 gnupg2
RUN curl -sOL "https://repos.influxdata.com/influxdata-archive.key"
RUN apt-key add influxdata-archive.key

## execute execute execute ##
RUN /bin/bash /testdasi/scripts-install/install-grafana-unraid-stack-base.sh

## debug mode (comment to disable) ##
#RUN /bin/bash /testdasi/scripts-install/install-debug-mode.sh
#ENTRYPOINT ["tini", "--", "/entrypoint.sh"]

## Final clean up ##
RUN rm -Rf /testdasi
