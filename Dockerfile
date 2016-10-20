FROM ubuntu:16.04
#Forked from Naimdjon Takhirov <naimdjon@takhirov.name> https://github.com/naimdjon/hadoop-docker

#ENV HADOOP_VERSION 2.7.3 
#ENV PIG_VERSION 0.16.0
#ENV MAVEN_VERSION 3.3.9 

#RUN apt-get update && apt-get install -y aptitude vim

#RUN apt-get update  --fix-missing  \
#    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openjdk-8-jdk --fix-missing  \
#    && rm -rf /var/lib/apt/lists/*
   
#ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

#RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends net-tools curl




ENV PIG_URL https://www.apache.org/dist/pig/pig-$PIG_VERSION/pig-$PIG_VERSION.tar.gz
RUN set -x \
    && curl -fSL "$PIG_URL" -o /tmp/pig.tar.gz \
    && curl -fSL "$PIG_URL.asc" -o /tmp/pig.tar.gz.asc \
    && tar -xvf /tmp/pig.tar.gz -C /opt/ \
    && cat /tmp/pig.tar.gz.asc \
    && rm /tmp/pig.tar.gz*

#    && gpg --verify /tmp/pig.tar.gz.asc \
RUN mkdir -p /opt/pig/ && mv /opt/pig-$PIG_VERSION /opt/pig/$PIG_VERSION
RUN ln -s /opt/pig/$PIG_VERSION /opt/pig/latest
ENV PIG_HOME=/opt/pig/$PIG_VERSION


ENV MAVEN_URL https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz
RUN set -x \
    && curl -fSL "$MAVEN_URL" -o /tmp/maven.tar.gz \
    && curl -fSL "$MAVEN_URL.asc" -o /tmp/maven.tar.gz.asc \
    && tar -xvf /tmp/maven.tar.gz -C /opt/ \
    && rm /tmp/maven.tar.gz*

#    && gpg --verify /tmp/maven.tar.gz.asc \
RUN mkdir -p /opt/maven/ && mv /opt/apache-maven-$MAVEN_VERSION /opt/maven/$MAVEN_VERSION
RUN ln -s /opt/maven/$MAVEN_VERSION /opt/maven/latest
ENV MAVEN_HOME=/opt/maven/$MAVEN_VERSION


ENV USER=root
ENV PATH $PIG_HOME/bin/:$HADOOP_HOME/bin/:$MAVEN_HOME/bin:$PATH
CMD ["/bin/bash"]
