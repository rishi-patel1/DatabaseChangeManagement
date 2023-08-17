FROM alpine 


ENV FLYWAY_VERSION=4.2.0

ENV FLYWAY_HOME=/opt/flyway/$FLYWAY_VERSION  \
    FLYWAY_PKGS="https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz"


LABEL com.redhat.component="flyway" \
      io.k8s.description="Platform for upgrading database using flyway" \
      io.k8s.display-name="DB Migration with flyway	" \
      io.openshift.tags="builder,sql-upgrades,flyway,db,migration" 


RUN apk add --update \
       openjdk8-jre \
        wget \
        git \
        bash
         
ARG GIT_USERNAME
ARG GIT_TOKEN
#Download and flyway
RUN wget --no-check-certificate  $FLYWAY_PKGS &&\
   mkdir -p $FLYWAY_HOME && \
   mkdir -p /var/flyway/data  && \
   ls -a /var/flyway && \
   tar -xzf flyway-commandline-$FLYWAY_VERSION.tar.gz -C $FLYWAY_HOME  --strip-components=1 && \
   apk add --no-cache git && \
   git config --global credential.helper '!f() { sleep 1; echo "username=${GIT_USERNAME}"; echo "password=${GIT_TOKEN}"; }; f'
# COPY ./sql/*.sql  $FLYWAY_HOME/sql/
RUN ls -a $FLYWAY_HOME/sql

COPY entrypoint.sh /entrypoint.sh 
RUN chmod +x /entrypoint.sh
VOLUME /var/flyway/data


ENTRYPOINT  ["/entrypoint.sh"]
