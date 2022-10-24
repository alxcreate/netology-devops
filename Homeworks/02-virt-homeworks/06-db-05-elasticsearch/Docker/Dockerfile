FROM arm64v8/centos:latest

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*

RUN dnf install centos-release-stream -y
RUN dnf swap centos-{linux,stream}-repos -y
RUN dnf distro-sync -y
RUN yum -y install sudo wget perl-Digest-SHA
RUN yum -y install sudo java
ENV ES_JAVA_HOME=/lib/jvm/jre-openjdk

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.4.3-darwin-aarch64.tar.gz && \
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.4.3-darwin-aarch64.tar.gz.sha512 && \
shasum -a 512 -c elasticsearch-8.4.3-darwin-aarch64.tar.gz.sha512 && \
tar -xzf elasticsearch-8.4.3-darwin-aarch64.tar.gz && \
rm -f elasticsearch-8.4.3-darwin-aarch64.tar.gz elasticsearch-8.4.3-darwin-aarch64.tar.gz.sha512

RUN echo "cluster.name: my-application" >> /elasticsearch-8.4.3/config/elasticsearch.yml && \
echo "node.name: netology_test" >> /elasticsearch-8.4.3/config/elasticsearch.yml && \
echo "path.data: /var/lib" >> /elasticsearch-8.4.3/config/elasticsearch.yml && \
echo "path.logs: /tmp" >> /elasticsearch-8.4.3/config/elasticsearch.yml && \
echo "discovery.type: single-node" >> /elasticsearch-8.4.3/config/elasticsearch.yml && \
useradd -MU elastic && \
chown -R elastic:elastic elasticsearch-8.4.3

EXPOSE 9200
EXPOSE 9300
CMD ["sudo", "-u", "elastic", "elasticsearch-8.4.3/bin/elasticsearch"]
