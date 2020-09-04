# EMR Monitoring - Prometheus + Grafana
Project to concentrate files and settings for AWS EMR monitoring. Source: https://aws.amazon.com/blogs/big-data/monitor-and-optimize-analytic-workloads-on-amazon-emr-with-prometheus-and-grafana/

## Important

This project was entirely based on the project contained in this URL: https://aws.amazon.com/blogs/big-data/monitor-and-optimize-analytic-workloads-on-amazon-emr-with-prometheus-and-grafana/

I just dismembered the scripts contained in the CloudFormation stack so that it was possible to customize some things I wanted. There is no intention to plagiarize any knowledge!

All merit and credits must be given to the AWS EMR team engineers who created a complete solution to easily provision resources.


## How to use this project

Build your cluster the way you want, either via the control panel, AWS-CLI or Terraform. You will need to add a configuration snippet for Hadoop to use JMX Exporter. You will also need to apply a script to bootstrap the cluster.

### Configuring the JMX Exporter on Hadoop
```
{
    "Classification": "hadoop-env",
    "Configurations": [{
        "Classification": "export",
        "ConfigurationProperties": {
            "HADOOP_NAMENODE_OPTS": "\"-javaagent:/etc/prometheus/jmx_prometheus_javaagent-0.14.0.jar=7001:/etc/hadoop/conf/hdfs_jmx_config_namenode.yaml -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=50103\"",
            "HADOOP_DATANODE_OPTS": "\"-javaagent:/etc/prometheus/jmx_prometheus_javaagent-0.14.0.jar=7001:/etc/hadoop/conf/hdfs_jmx_config_datanode.yaml -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=50103\""
        }
    }]
}
```
> Stay tuned in the defined version of the JMX Exporter, because if you change, you will need to change this section.

### Bootstrap

Enter the URL of your script ![bootstrap_monitoring.sh](prometheus/bootstrap_monitoring.sh)

Example: `https://raw.githubusercontent.com/vinicelms/emr-monitoring-prometheus-grafana/master/prometheus/bootstrap_monitoring.sh`