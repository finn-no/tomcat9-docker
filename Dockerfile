FROM finntech/java8:8u112-2

ENV TOMCAT_MAJOR_VERSION 9
ENV TOMCAT_MINOR_VERSION 0
ENV TOMCAT_PATCH_VERSION 0.M15

ENV CATALINA_HOME /opt/tomcat${TOMCAT_MAJOR_VERSION}
ENV PATH $CATALINA_HOME/bin:$PATH

RUN curl -s http://apache.uib.no/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MAJOR_VERSION}.${TOMCAT_MINOR_VERSION}.${TOMCAT_PATCH_VERSION}/bin/apache-tomcat-${TOMCAT_MAJOR_VERSION}.${TOMCAT_MINOR_VERSION}.${TOMCAT_PATCH_VERSION}.tar.gz\
 | tar -xzf - -C /opt

RUN ln -s /opt/apache-tomcat-${TOMCAT_MAJOR_VERSION}.${TOMCAT_MINOR_VERSION}.${TOMCAT_PATCH_VERSION} /opt/tomcat${TOMCAT_MAJOR_VERSION} &&\
  rm -rf ${CATALINA_HOME}/webapps/ROOT \
         ${CATALINA_HOME}/webapps/docs \
         ${CATALINA_HOME}/webapps/examples \
         ${CATALINA_HOME}/webapps/host-manager \
         ${CATALINA_HOME}/webapps/manager \
         ${CATALINA_HOME}/bin/*.bat

ADD serverinfo.jar ${CATALINA_HOME}/lib/serverinfo.jar

ADD deploy-and-run.sh /opt/apache-tomcat-${TOMCAT_VERSION}/bin/

RUN chmod 755 /opt/apache-tomcat-${TOMCAT_VERSION}/bin/deploy-and-run.sh \
  && rm -rf /opt/apache-tomcat-${TOMCAT_VERSION}/webapps \
  && mkdir /opt/apache-tomcat-${TOMCAT_VERSION}/webapps

WORKDIR $CATALINA_HOME

EXPOSE 8080

CMD ["catalina.sh", "run"]
