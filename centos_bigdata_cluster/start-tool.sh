#!/bin/bash

CUR=$(cd `dirname 0`;pwd)
. $CUR/include/common.sh
zk(){
    usage="Usage: $0 (start|stop|status)"
 
    if [ $# -lt 1 ]; then
        echo $usage
        exit 1
    fi
    case $1 in
        start)
            for i in {"hdp-node-01","hdp-node-02","hdp-node-03"};
            do
                echo "-----$1 $i zookeeper-------"
                ssh $i "source /etc/profile;$INSTALL_PATH/zookeeper/bin/zkServer.sh start"
            done
            ;;
        stop)
            for i in {"hdp-node-01","hdp-node-02","hdp-node-03"};
            do
                echo "------$1 $i zookeeper-------"
                ssh $i "source /etc/profile;$INSTALL_PATH/zookeeper/bin/zkServer.sh stop"
            done
            ;;
        status)
            for i in {"hdp-node-01","hdp-node-02","hdp-node-03"};
            do
                echo "------$i status-------"
                ssh $i "source /etc/profile;$INSTALL_PATH/zookeeper/bin/zkServer.sh status"
            done
            ;;
        *)
            echo $usage
            ;;
    esac
}
#一键启动集群
kafka(){
    usage="Usage: $0 (start|stop)"
 
    if [ $# -lt 1 ]; then
        echo $usage
        exit 1
    fi
    case $1 in
        start)
            SIGNAL=${SIGNAL:-TERM}
            PIDS=$(ps ax | grep java | grep -i QuorumPeerMain | grep -v grep | awk '{print $1}')

            if [ -z "$PIDS" ]; then
                echo "Success to start zookeeper."
                zk start 
                echo "-----$1 $i start-------"
            else
                echo "Zookeeper has been started"
            fi
            for i in {"hdp-node-01","hdp-node-02","hdp-node-03"};
            do
                echo "-----$1 $i kafka-------"
                ssh $i "source /etc/profile;$INSTALL_PATH/kafka/bin/kafka-server-start.sh -daemon $INSTALL_PATH/kafka/config/server.properties"
            done
            ;;
        stop)
            for j in {"hdp-node-01","hdp-node-02","hdp-node-03"};
            do
                echo "-----$1 $j kafka-------"
                ssh $j  "kill -9 \$(ps ax |grep -i 'Kafka'| grep java| grep -v grep| awk '{print \$1}')"
            done
            ;;
        *)
            echo $usage
            ;;
    esac
}
dfs(){
    usage="Usage: $0 (start|stop)"
 
    if [ $# -lt 1 ]; then
        echo $usage
        exit 1
    fi
    case $1 in
        start)
            sh $INSTALL_PATH/hadoop/sbin/start-dfs.sh
            ;;
        stop)
            sh $INSTALL_PATH/hadoop/sbin/stop-dfs.sh
            ;;
        *)
            echo $usage
            ;;
    esac
}
yarn(){
    usage="Usage: $0 (start|stop)"
 
    if [ $# -lt 1 ]; then
        echo $usage
        exit 1
    fi
    case $1 in
        start)
            sh $INSTALL_PATH/hadoop/sbin/start-yarn.sh
            ;;
        stop)
            sh $INSTALL_PATH/hadoop/sbin/stop-yarn.sh
            ;;
        *)
            echo $usage
            ;;
    esac
}
spark(){
    usage="Usage(spark): $0 (start|stop)"
 
    if [ $# -lt 1 ]; then
        echo $usage
        exit 1
    fi
    case $1 in
        start)
            sh $INSTALL_PATH/spark/sbin/start-all.sh
            ;;
        stop)
            sh $INSTALL_PATH/spark/sbin/stop-all.sh
            ;;
        *)
            echo $usage
            ;;
    esac
}
flink(){
    usage="Usage(flink): $0 (start|stop)"
 
    if [ $# -lt 1 ]; then
        echo $usage
        exit 1
    fi
    case $1 in
        start)
            $INSTALL_PATH/flink/bin/start-cluster.sh
            ;;
        stop)
            $INSTALL_PATH/flink/bin/stop-cluster.sh
            ;;
        *)
            echo $usage
            ;;
    esac
}
hbase(){
    usage="Usage(hbase): $0 (start|stop)"
 
    if [ $# -lt 1 ]; then
        echo $usage
        exit 1
    fi
    case $1 in
        start)
            $INSTALL_PATH/hbase/bin/start-hbase.sh
            ;;
        stop)
            $INSTALL_PATH/hbase/bin/stop-hbase.sh
            ;;
        *)
            echo $usage
            ;;
    esac
}

args()
{
    usage="Usage: $0 (dfs|yarn.. start|stop)"
 
    if [ $# -lt 2 ]; then
        echo $usage
        exit 1
    fi

    case $1 in
	  dfs)
		dfs $2
		;;
	  yarn)
		yarn $2
		;;
	  spark)
		spark $2
		;;
	  zk)
		zk $2
		;;
	  flink)
		flink $2
		;;
	  hbase)
		hbase $2
		;;
	  kafka)
		kafka $2
		;;
          *)
                echo $usage
                ;;
    esac
}
args $@

