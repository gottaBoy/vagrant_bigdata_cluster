#!/bin/bash
#set -x

setup_hadoop() {
    local app_name=$1
    log info "creating $app_name directories"
    mkdir -p ${INSTALL_PATH}/hadoop/tmp
    mkdir -p ${INSTALL_PATH}/hadoop/tmp/dfs/name
    mkdir -p ${INSTALL_PATH}/hadoop/tmp/dfs/data
	
    log info "copying over $app_name configuration files"
    cp -f $HADOOP_RES_DIR/* $HADOOP_CONF_DIR
}

download_hadoop() {
    local app_name=$1
    log info "install $app_name"
    if resourceExists $HADOOP_ARCHIVE; then
        installFromLocal $HADOOP_ARCHIVE
    else
        installFromRemote $HADOOP_ARCHIVE $HADOOP_MIRROR_DOWNLOAD
    fi
    mv ${INSTALL_PATH}/$HADOOP_VERSION ${INSTALL_PATH}/hadoop
}

format_hdfs() {
    log info "formatting HDFS"
    hdfs namenode -format
}

start_daemons() {
    log info "starting Hadoop daemons"
    $HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
    $HADOOP_PREFIX/sbin/hadoop-daemons.sh --config $HADOOP_CONF_DIR --script hdfs start datanode
    $HADOOP_PREFIX/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager
    $HADOOP_PREFIX/sbin/yarn-daemons.sh --config $HADOOP_CONF_DIR start nodemanager
    $HADOOP_PREFIX/sbin/yarn-daemon.sh start proxyserver --config $HADOOP_CONF_DIR
    $HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF_DIR

    log info "waiting for HDFS to come up"
    # loop until at least HDFS is up
    cmd="hdfs dfs -ls /"
    NEXT_WAIT_TIME=0
    up=0
    while [  $NEXT_WAIT_TIME -ne 4 ] ; do
        $cmd
        rc=$?
        if [[ $rc == 0 ]]; then
            up=1
            break
        fi
       sleep $(( NEXT_WAIT_TIME++ ))
    done

    if [[ $up != 1 ]]; then
        log info "HDFS doesn't seem to be up; exiting"
        exit $rc
    fi

    log info "listing all Java processes"
    jps
}

setup_hdfs() {
    log info "creating user home directory in hdfs"
    hdfs dfs -mkdir -p /user/root
    hdfs dfs -mkdir -p /user/vagrant
    hdfs dfs -chown vagrant /user/vagrant

    log info "creating temp directories in hdfs"
    hdfs dfs -mkdir -p /tmp
    hdfs dfs -chmod -R 777 /tmp

    hdfs dfs -mkdir -p /var
    hdfs dfs -chmod -R 777 /var
}
install_hadoop() {
    local app_name=$1
    log info "setup $app_name"

    download_hadoop $app_name
    setup_hadoop $app_name
    setupEnv_app $app_name sbin
    dispatch_app $app_name
    source $PROFILE
    #format_hdfs
    #start_daemons
    #setupHdfs
}

