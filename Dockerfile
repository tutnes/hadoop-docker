FROM ubuntu:16.04
#Forked from Naimdjon Takhirov <naimdjon@takhirov.name> https://github.com/naimdjon/hadoop-docker


ENV HADOOP_VERSION 2.7.3 
ENV PIG_VERSION 0.16.0
ENV MAVEN_VERSION 3.3.9 

RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends aptitude \
	curl \
	net-tools \
	openjdk-8-jdk \
	vim 

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/	
	
#RUN apt-get update  --fix-missing  \
    #&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openjdk-8-jdk --fix-missing  \

    #&& rm -rf /var/lib/apt/lists/*
   


#RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends net-tools curl


RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
    07617D4968B34D8F13D56E20BE5AAA0BA210C095 \
    2CAC83124870D88586166115220F69801F27E622 \
    4B96409A098DBD511DF2BC18DBAF69BEA7239D59 \
    9DD955653083EFED6171256408458C39E964B5FF \
    B6B3F7EDA5BA7D1E827DE5180DFF492D8EE2F25C \
    6A67379BEFC1AE4D5595770A34005598B8F47547 \
    47660BC98BC433F01E5C90581209E7F13D0C92B9 \
    CE83449FDC6DACF9D24174DCD1F99F6EE3CD2163 \
    A11DF05DEA40DA19CE4B43C01214CF3F852ADB85 \
    686E5EDF04A4830554160910DF0F5BBC30CD0996 \
    5BAE7CB144D05AD1BB1C47C75C6CC6EFABE49180 \
    AF7610D2E378B33AB026D7574FB955854318F669 \
    6AE70A2A38F466A5D683F939255ADF56C36C5F0F \
    70F7AB3B62257ABFBD0618D79FDB12767CC7352A \
    842AAB2D0BC5415B4E19D429A342433A56D8D31A \
    1B5D384B734F368052862EB55E43CAB9AEC77EAF \
    785436A782586B71829C67A04169AA27ECB31663 \
    5E49DA09E2EC9950733A4FF48F1895E97869A2FB \
    A13B3869454536F1852C17D0477E02D33DD51430 \
    A6220FFCC86FE81CE5AAC880E3814B59E4E11856 \
    EFE2E7C571309FE00BEBA78D5E314EEF7340E1CB \
    EB34498A9261F343F09F60E0A9510905F0B000F0 \
    3442A6594268AC7B88F5C1D25104A731B021B57F \
    6E83C32562C909D289E6C3D98B25B9B71EFF7770 \
    E9216532BF11728C86A11E3132CF4BF4E72E74D3 \
    E8966520DA24E9642E119A5F13971DA39475BD5D \
    1D369094D4CFAC140E0EF05E992230B1EB8C6EFA \
    A312CE6A1FA98892CB2C44EBA79AB712DE5868E6 \
    0445B7BFC4515847C157ECD16BA72FF1C99785DE \
    B74F188889D159F3D7E64A7F348C6D7A0DCED714 \
    4A6AC5C675B6155682729C9E08D51A0A7501105C \
    8B44A05C308955D191956559A5CEE20A90348D47


ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

RUN mkdir -p /opt/hadoop/ && mv /opt/hadoop-$HADOOP_VERSION /opt/hadoop/$HADOOP_VERSION
RUN ln -s /opt/hadoop/$HADOOP_VERSION /opt/hadoop/latest
RUN ln -s /opt/hadoop/latest/etc/hadoop /etc/hadoop
RUN ls -l /opt/hadoop/latest/
RUN cp /opt/hadoop/latest/etc/hadoop/mapred-site.xml.template /etc/hadoop/mapred-site.xml
RUN mkdir /opt/hadoop/latest/logs

RUN mkdir /opt/hadoop/data

ENV HADOOP_HOME=/opt/hadoop/$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1



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