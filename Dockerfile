FROM stakater/java-centos:7-1.8

LABEL name="Stakater Maven Image on CentOS" \
      maintainer="bhanuprakashnr <bhanuprakashnr07@gmail.com>" \
      vendor="Stakater" \
      release="1" \
      summary="A Maven based image on CentOS"

# Setting Maven Version that needs to be installed
ARG MAVEN_VERSION=3.5.4

# Changing user to root to install maven
USER root

# Install required tools
# which: otherwise 'mvn version' prints '/usr/share/maven/bin/mvn: line 93: which: command not found'
RUN yum update -y && \
  yum install -y which && \
  yum clean all
RUN yum install git -y 

# Maven
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_VERSION=${MAVEN_VERSION}
ENV M2_HOME /usr/share/maven
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH

# Again using non-root user i.e. stakater as set in base image
#USER 10001

# Define default command, can be overriden by passing an argument when running the container
#CMD ["mvn","-version"]





#ENTRYPOINT ["tail","-f","/dev/null"]




RUN git clone https://github.com/jenkins-docs/simple-java-maven-app.git
WORKDIR simple-java-maven-app/
RUN mvn -B -DskipTests clean package
WORKDIR target/
CMD ["java","-jar","my-app-1.0-SNAPSHOT.jar"]
