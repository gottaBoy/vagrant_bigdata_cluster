# vagrant_bigdata_cluster (maxwell环境)

## 一、基本介绍

本集群创建的组件如下表所示。

|   组件    | hdp101         | hdp102         | hdp103         |
| :-------: | -------------- | -------------- | -------------- |
|    OS     | centos7.6      | centos7.6      | centos7.6      |
|    JDK    | jdk1.8         | jdk1.8         | jdk1.8         |
| Zookeeper | QuorumPeerMain | QuorumPeerMain | QuorumPeerMain |
|   Kafka   | kafka          | Kafka          | Kafka          |
|   MySQL   | NA             | NA             | MySQL Server   |
|  Maxwell  | Maxwell        | NA             | NA             |

## 二、基本硬件准备

1. 集群默认启动三个节点，每个节点的默认内存是2G，所以你的机器至少需要6G
2. 我的测试环境：Vagrant 2.2.14， Virtualbox 6.0.14

## 三、安装集群环境

1. [下载和安装VirtualBOX](https://www.virtualbox.org/wiki/Downloads)

2. [下载和安装Vagrant](http://www.vagrantup.com/downloads.html)

3. 克隆本项目到本地，并cd到项目所在目录

   ```
   git clone https://github.com/yiluohan1234/vagrant_bigdata_cluster
   cd vagrant_bigdata_cluster
   git checkout env_maxwell
   ```

4. 执行`vagrant up` 创建虚拟机

5. 可以通过执行 `vagrant ssh` 登录到你创建的虚拟机，或通过SecureCRT等工具进行登录

6. 如果你想要删除虚拟机，可以通过执行`vagrant destroy` 来实现

## 四、自定义集群环境配置

基本目录结构

```
resources
scripts
.gitignore
README.md
VagrantFile
```

你可以通过修改`VagrantFile`、`scripts/common.sh`文件和`resources/组件名称`目录下各个组件的配置文件文件来实现自定义集群。

1. `VagrantFile`
   这个文件可以设置虚拟机的的版本、个数、名称、主机名、IP、内存、CPU等，根据自己需要更改即可。

2. `scripts/common.sh`
   这个文件可以设置各个组件的版本。

   > 注意：部分组件需要同步更改`XXX_VERSION`和`XXX_MIRROR_DOWNLOAD`，保证能下载到组件版本。


## 五、集群安装完毕后相关组件初始化及启动

### 1、ssh免登陆

在每台机器上执行以下

```
setssh
```

### 2、启动zookeeper和kafka

```
bigstart zookeeper start
bigstart kafka start
```

### 3、启动maxwell

```
bigstart maxwell start
```

