#!/bin/bash

#
# Copyright (c) 2001-2018 Primeton Technologies, Ltd.
# All rights reserved.
#
# author: ZhongWen Li (mailto:lizw@primeton.com)
#

if [ -z "${JIRA_APP}" ]; then
  echo "[ERROR] Environment variable JIRA_APP not defined."
  exit 1
fi

if [ ! -d ${JIRA_APP} ]; then
  echo "[ERROR] ${JIRA_APP} not exists."
  exit 1
fi

if [ -z "${JIRA_HOME}" ]; then
  JIRA_HOME=/opt/jira_home
fi

if [ -z "${MYSQL_DATABASE}" ]; then
  echo "[`date`] [WARN ] Missing enviroment variable MYSQL_DATABASE, use default value: jira"
  MYSQL_DATABASE=jira
fi
if [ -z "${MYSQL_USER}" ]; then
  echo "[`date`] [WARN ] Missing enviroment variable MYSQL_USER, use default value: jira"
  MYSQL_USER=jira
fi
if [ -z "${MYSQL_PASSWORD}" ]; then
  echo "[`date`] [WARN ] Missing enviroment variable MYSQL_PASSWORD, use default value: jira"
  MYSQL_PASSWORD=jira
fi
if [ -z "${MYSQL_HOST}" ]; then
  echo "[`date`] [WARN ] Missing enviroment variable MYSQL_HOST, use default value: mysql"
  MYSQL_HOST=mysql
fi
if [ -z "${MYSQL_PORT}" ]; then
  echo "[`date`] [WARN ] Missing enviroment variable MYSQL_PORT, use default value: 3306"
  MYSQL_PORT=3306
fi

if [ -z "${JAVA_VM_MEM_MIN}" ]; then
  JVM_MIN_MEM=512
fi
if [ -z "${JAVA_VM_MEM_MAX}" ]; then
  JVM_MAX_MEM=1024
fi
if [ ${JAVA_VM_MEM_MIN} -gt ${JAVA_VM_MEM_MAX} ]; then
  echo "[`date`] [WARN ] JAVA_VM_MEM_MIN is bigger than JAVA_VM_MEM_MAX"
  JAVA_VM_MEM_MAX=${JAVA_VM_MEM_MIN}
fi

# Use setenv.sh
# JAVA_OPTS="${JAVA_OPTS} -Xms${JAVA_VM_MEM_MIN}m -Xmx${JAVA_VM_MEM_MAX}m"
JAVA_OPTS="${JAVA_OPTS} -Dfile.encoding=utf-8 -Duser.timezone=Asia/Shanghai"
export JAVA_OPTS

if [ -f ${JIRA_APP}/bin/setenv.sh ]; then
  sed -i -e "s/768m/${JAVA_VM_MEM_MAX}m/g"  ${JIRA_APP}/bin/setenv.sh
  sed -i -e "s/384m/${JAVA_VM_MEM_MIN}m/g"  ${JIRA_APP}/bin/setenv.sh
else
  JAVA_OPTS="${JAVA_OPTS} -Xms${JAVA_VM_MEM_MIN}m -Xmx${JAVA_VM_MEM_MAX}m"
fi

if [ -f ${JIRA_APP}/templates/dbconfig.xml ]; then
  if [ ! -d ${JIRA_HOME} ]; then
    mkdir -p ${JIRA_HOME}
  fi
  if [ "NO" == "${MANUAL_CONFIG_DATABASE}" ] || [ "no" == "${MANUAL_CONFIG_DATABASE}" ] || [ "n" == "${MANUAL_CONFIG_DATABASE}" ]; then
    \cp -f ${JIRA_APP}/templates/dbconfig.xml ${JIRA_HOME}/dbconfig.xml
    sed -i -e "s/MYSQL_HOST/${MYSQL_HOST}/g" ${JIRA_HOME}/dbconfig.xml
    sed -i -e "s/MYSQL_DATABASE/${MYSQL_DATABASE}/g" ${JIRA_HOME}/dbconfig.xml
    sed -i -e "s/MYSQL_USER/${MYSQL_USER}/g" ${JIRA_HOME}/dbconfig.xml
    sed -i -e "s/MYSQL_PASSWORD/${MYSQL_PASSWORD}/g" ${JIRA_HOME}/dbconfig.xml
    sed -i -e "s/MYSQL_PORT/${MYSQL_PORT}/g" ${JIRA_HOME}/dbconfig.xml
  fi
fi

JIRA_RUNNABLE=${JIRA_APP}/bin/start-jira.sh

if [ -x ${JIRA_RUNNABLE} ]; then
  ${JIRA_RUNNABLE} run
else
  chmod +x ${JIRA_RUNNABLE} && ${JIRA_RUNNABLE} run
fi
