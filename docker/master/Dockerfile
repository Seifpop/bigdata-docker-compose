# Image du noeud master : l'image du cluster + Apache Pig 0.17.0.
#
# Pig n'existe pas dans lisacumt/hadoop-hive-hbase-spark-docker. Il est ajoute
# ici pour etre disponible des le premier "docker-compose up -d" apres un
# clone ou un pull : docker-compose construit cette image automatiquement.
#
# Seul le master en a besoin : Pig est un client qui soumet des jobs
# MapReduce a YARN, les workers n'executent que du MapReduce standard.
FROM lisacumt/hadoop-hive-hbase-spark-docker:1.1.6

ARG PIG_VERSION=0.17.0
ARG PIG_MD5=da76998409fe88717b970b45678e00d4

# Telechargement depuis le CDN Apache, repli sur les archives si besoin.
# docs/src/test/tutorial (~130 Mo) ne servent pas a l'execution.
RUN set -e; \
    cd /tmp; \
    f=pig-${PIG_VERSION}.tar.gz; \
    curl -fsSL -o $f https://dlcdn.apache.org/pig/pig-${PIG_VERSION}/$f \
      || curl -fsSL -o $f https://archive.apache.org/dist/pig/pig-${PIG_VERSION}/$f; \
    echo "${PIG_MD5}  $f" | md5sum -c -; \
    tar -xzf $f -C /usr/program; \
    mv /usr/program/pig-${PIG_VERSION} /usr/program/pig; \
    rm -rf $f /usr/program/pig/docs /usr/program/pig/src \
           /usr/program/pig/test /usr/program/pig/tutorial

ENV PIG_HOME=/usr/program/pig
ENV PATH=${PATH}:/usr/program/pig/bin
