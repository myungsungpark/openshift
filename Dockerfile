# Use EAP 7 Beta as a base image
FROM jboss-eap-7-beta/eap70-openshift

ENV KEYCLOAK_VERSION 1.9.4.Final

# add maven mirror
RUN sed -i -e 's/<mirrors>/&\n    <mirror>\n      <id>sti-mirror<\/id>\n      <url>${env.MAVEN_MIRROR_URL}<\/url>\n      <mirrorOf>external:*<\/mirrorOf>\n    <\/mirror>/' ${HOME}/.m2/settings.xml

# install adapter
WORKDIR ${JBOSS_HOME}
RUN curl -L https://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/adapters/keycloak-oidc/keycloak-wildfly-adapter-dist-$KEYCLOAK_VERSION.tar.gz | tar zx

# Standalone.xml modifications.
RUN sed -i -e 's/<extensions>/&\n        <extension module="org.keycloak.keycloak-adapter-subsystem"\/>/' $JBOSS_HOME/standalone/configuration/standalone-openshift.xml && \
    sed -i -e 's/<profile>/&\n        <subsystem xmlns="urn:jboss:domain:keycloak:1.1"\/>/' $JBOSS_HOME/standalone/configuration/standalone-openshift.xml && \
    sed -i -e 's/<security-domains>/&\n                <security-domain name="keycloak">\n                    <authentication>\n                        <login-module code="org.keycloak.adapters.jboss.KeycloakLoginModule" flag="required"\/>\n                    <\/authentication>\n                <\/security-domain>/' $JBOSS_HOME/standalone/configuration/standalone-openshift.xml

# perform the build

RUN mvn package

# after build, copy artifacts (e.g. .war files from target/) to deploy directory (e.g. $JBOSS_HOME/standalone/deployments)
