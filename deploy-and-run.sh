#!/bin/sh
appDir=${DEPLOY_DIR:-/app}
echo "Checking *.war in $appDir"
if [ -d ${appDir} ]; then
  target="/opt/apache-tomcat-${TOMCAT_VERSION}/webapps"
  for i in ${appDir}/*.war; do
     file=$(basename ${i})
     echo "Linking $i --> $target"
     if [ -f "${target}/${file}" ]; then
         rm "${target}/${file}"
     fi
     dir=$(basename ${i} .war)
     if [ x${dir} != x ] && [ -d "${target}/${dir}" ]; then
         rm -r "$target/${dir}"
     fi
     ln -s ${i} "${target}/${file}"
  done
fi

# Use faster (though more unsecure) random number generator
export CATALINA_OPTS="${CATALINA_OPTS} $(/opt/run-java-options --escape) -Djava.security.egd=file:/dev/./urandom"
/opt/apache-tomcat-${TOMCAT_VERSION}/bin/catalina.sh run
