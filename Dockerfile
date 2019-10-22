FROM maven:3.6-jdk-8-slim AS build

WORKDIR /usr/src/app

COPY pom.xml .
RUN mvn -B -e -C -T 1C org.apache.maven.plugins:maven-dependency-plugin:3.1.1:go-offline

COPY . .
RUN mvn -B -e -o -T 1C verify

# - # - #

FROM tomcat:9.0-jre8-alpine AS deploy

WORKDIR $CATALINA_HOME/webapps/
COPY --from=build /usr/src/app/target/*.war ./

CMD ["catalina.sh", "run"]
