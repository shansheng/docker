#
# author: sheng (mailto:shanshengsheng@gmail.com)
#

FROM centos:7

LABEL maintainer="shanshengsheng@gmail.com" \
    provider="SSS, Ltd."

ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

ENV JAVA_VERSION="1.6.0_45"

ENV JAVA_HOME="/usr/local/jdk${JAVA_VERSION}"

ENV PATH="${PATH}:${JAVA_HOME}/bin"

# Do not use alias cp
RUN \cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && yum update -y \
    && yum install -y zip unzip tar curl wget \
    && echo "alias l='ls -al'" >> /root/.bashrc

ADD resources/jdk*.tar.gz /usr/local/
