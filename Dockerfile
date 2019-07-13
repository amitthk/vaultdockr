FROM centos:centos7

ARG GROUP_ID=org.mywire.amitthk
ARG ARTIFACT_ID=vault
ARG ARTIFACT_VERSION=1.1.3
ARG ARTIFACT_TYPE=zip
ARG REPO_BASE_URL=https://jvcdp-repo.s3-ap-southeast-1.amazonaws.com
ARG ADMIN_USER=vaultadm
ARG ADMIN_UUID=1000
ARG PIP_INDEX=https://pypi.org/simple
ARG APP_HOME_DIR=/root

ENV GROUP_ID=${GROUP_ID} \
    ARTIFACT_ID=${ARTIFACT_ID} \
    ARTIFACT_VERSION=${ARTIFACT_VERSION} \
    ARTIFACT_TYPE=${ARTIFACT_TYPE} \
    REPO_BASE_URL=${REPO_BASE_URL} \
    ADMIN_UUID=${ADMIN_UUID} \
    PIP_INDEX=${PIP_INDEX} \
    APP_HOME_DIR=${APP_HOME_DIR} \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    PWD=/ \
    SHLVL=1 \
    HOME=/root \
    _=/usr/bin/env


EXPOSE 8200 8201 80

USER root


RUN mkdir -p ${APP_HOME_DIR} \
    && useradd --home-dir ${APP_HOME_DIR} -u ${ADMIN_UUID} -g 0 ${ADMIN_USER} 

RUN yum install -y wget unzip tar
    #&& yum install -y glibc glibc-common gcc gcc++  python-setuptools python-ldap java-1.8.0-openjdk java-1.8.0-openjdk-devel


RUN cd ${APP_HOME_DIR}/ \
    && export GROUP_URL=`echo "${GROUP_ID}" | tr "." "/"` \
    && wget ${REPO_BASE_URL}/${GROUP_URL}/${ARTIFACT_ID}/${ARTIFACT_VERSION}/${ARTIFACT_ID}-${ARTIFACT_VERSION}.${ARTIFACT_TYPE} \
    && unzip "${APP_HOME_DIR}/${ARTIFACT_ID}-${ARTIFACT_VERSION}.${ARTIFACT_TYPE}" -d "${APP_HOME_DIR}" \
    && rm "${APP_HOME_DIR}/${ARTIFACT_ID}-${ARTIFACT_VERSION}.${ARTIFACT_TYPE}" \
    && chmod -R 0755 ${APP_HOME_DIR} \
    && mkdir -p ${APP_HOME_DIR}/vault-data \
    && chown -R ${ADMIN_USER}:root ${APP_HOME_DIR} \
    && chmod g=u /etc/passwd

    # && if [ "${ARTIFACT_TYPE}"="tgz" ];  then tar -xzvf "${APP_HOME_DIR}/${ARTIFACT_ID}-${ARTIFACT_VERSION}.${ARTIFACT_TYPE}" -C "${APP_HOME_DIR}"; fi \
    # && if [ "${ARTIFACT_TYPE}"="tar" ];  then tar -xvf "${APP_HOME_DIR}/${ARTIFACT_ID}-${ARTIFACT_VERSION}.${ARTIFACT_TYPE}" -C "${APP_HOME_DIR}"; fi \


WORKDIR ${APP_HOME_DIR}

USER ${ADMIN_USER}

CMD ["/root/vault"]
