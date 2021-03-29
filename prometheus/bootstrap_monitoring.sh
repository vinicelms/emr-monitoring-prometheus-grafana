#!/bin/bash -xe

REPO_URL="https://raw.githubusercontent.com/vinicelms/emr-monitoring-prometheus-grafana/master"
NODE_EXPORTER_VERSION="1.0.1"
JMX_EXPORTER_VERSION="0.14.0"

#set up node_exporter for pushing OS level metrics
sudo useradd --no-create-home --shell /bin/false node_exporter
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
tar -xvzf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
cd node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64
sudo cp node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

cd /tmp
wget ${REPO_URL}/prometheus/config_files/node_exporter.service
sudo cp node_exporter.service /etc/systemd/system/node_exporter.service
sudo chown node_exporter:node_exporter /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload && \
sudo systemctl start node_exporter && \
sudo systemctl status node_exporter && \
sudo systemctl enable node_exporter

#set up jmx_exporter for pushing application metrics
wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_EXPORTER_VERSION}/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar
sudo mkdir -p /etc/prometheus/textfiles
sudo cp jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar /etc/prometheus

wget ${REPO_URL}/prometheus/config_files/hdfs_jmx_config_namenode.yaml
wget ${REPO_URL}/prometheus/config_files/hdfs_jmx_config_datanode.yaml
wget ${REPO_URL}/prometheus/config_files/yarn_jmx_config_resource_manager.yaml
wget ${REPO_URL}/prometheus/config_files/yarn_jmx_config_node_manager.yaml
wget ${REPO_URL}/prometheus/textfiles/emr_node_info.sh

HADOOP_CONF='/etc/hadoop/conf'
sudo mkdir -p ${HADOOP_CONF}
sudo cp hdfs_jmx_config_namenode.yaml ${HADOOP_CONF}
sudo cp hdfs_jmx_config_datanode.yaml ${HADOOP_CONF}
sudo cp yarn_jmx_config_resource_manager.yaml ${HADOOP_CONF}
sudo cp yarn_jmx_config_node_manager.yaml ${HADOOP_CONF}
sudo cp emr_node_info.sh /etc/prometheus/textfiles
sudo /etc/prometheus/textfiles/emr_node_info.sh


# Yarn configuration setup
wget ${REPO_URL}/prometheus/config_files/yarn_jmx_env_setup.txt
sed -i "s/__JMX_EXPORTER_VERSION__/${JMX_EXPORTER_VERSION}/g" /tmp/yarn_jmx_env_setup.txt
cat /tmp/yarn_jmx_env_setup.txt | sudo tee -a /etc/hadoop/conf/yarn-env.sh > /dev/null

exit 0