**实时项目**

```
截至时间2024-04-18，flink最稳定的版本，1.19.0
```

##### flink概述

###### 应用场景

```
电商和市场营销
			实时数据报表，广告投放，实时推荐
物联网
	传感器实时数据采集和显示，实时报警，交通运输业
物流配送和服务业
			 订单状态实时更新，通知消息推送
银行和金融业
		  实时结算和通知推送，实时检测异常行为
```

###### 分层api

```
sql
table  api
datastream/datasetapi
有状态流处理
```

##### 快速上手

###### 项目创建

```
批处理
流处理
socket数据接收
```

##### flink部署

###### 集群角色

```
FlinkClient
			提交Job给JobManager(协调调度中心)
										 JobManager下发给TaskManager
										 						  TaskManager才是干活的人，负责数据的处理						 
```

###### 打包插件

```
 <build>
        <plugins>
            <!-- 组装 assembly-->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-assembly-plugin</artifactId>
                <version>3.0.0</version>
                <configuration>
                    <descriptorRefs>
                        <descriptorRef>jar-with-dependencies</descriptorRef>
                    </descriptorRefs>
                </configuration>
                <executions>
                    <execution>
                        <id>make-assembly</id>
                        <phase>package</phase>
                        <goals>
                            <goal>single</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
```

###### 任务提交

```
页面提交，独立运行 ， 启动集群，用不带依赖的jar，上传jar,编辑参数任务运行

命令行提交任务，启动集群，提交任务
./bin/flink run -m hadoop31:8081 -c com.zfq.fo.flink.DataGetSocket  ./realtime-flink-1.0-SNAPSHOT.jar -host hadoop31 -port 8989
这里的参数 -m指定了提交到的JobManager，-c指定了入口类。 后面2个参数是程序运行时必需参数
```

###### 部署模式

```
在一些应用场景中，对于集群资源分配和占用的方式，可能会有特定的需求。Flink为各种场景提供了不同的部署模式，主要有以下三种：
会话模式（Session Mode）、单作业模式（Per-Job Mode）、应用模式（Application Mode）。
它们的区别主要在于：集群的生命周期以及资源的分配方式；以及应用的main方法到底在哪里执行——客户端（Client）还是JobManager。

会话模式其实最符合常规思维。我们需要先启动一个集群，保持一个会话，在这个会话中通过客户端提交作业。集群启动时所有资源就都已经确定，所以所有提交的作业会竞争集群中的资源，规模小执行时间短的作业

会话模式因为资源共享会导致很多问题，所以为了更好地隔离资源，我们可以考虑为每个提交的作业启动一个集群，这就是所谓的单作业(Per-Job)模式。
作业完成后，集群就会关闭，所有资源也会释放。这些特性使得单作业模式在生产环境运行更加稳定，所以是实际应用的首选模式。需要注意的是，Flink本身无法直接这样运行，所以单作业模式一般需要借助一些资源管理框架来启动集群，比如YARN、Kubernetes(K8s)

前面提到的两种模式下，应用代码都是在客户端上执行，然后由客户端提交给JobManager的。但是这种方式客户端需要占用大量网络带宽，去下载依赖和把二进制数据发送给JobMamager;加上很多情况下我们提交作业用的是同一个客户端，就会加重客户端所在节点的资源消耗。
所以解决办法就是，我们不要客户端了，直接把应用提交到JobManger上运行。而这也就代表着，我们需要为每一个提交的应用单独启动一个JobManager，也就是创建一个集群。这个JobManager只为执行这一个应用而存在，执行结束之后JobManager也就关闭了，这就是所谓的应用模式。
```

###### **Standalone运行模式**（了解）

```
独立模式是独立运行的，不依赖任何外部的资源管理平台；当然独立也是有代价的：如果资源不足，或者出现故障，没有自动扩展或重分配资源的保证，必须手动处理。所以独立模式一般只用在开发测试或作业非常少的场景下。
```

######  **会话模式部署**

```
Standalone集群的会话模式部署。
提前启动集群，并通过Web页面客户端提交任务（可以多个任务，但是集群资源固定）。
```

######  **单作业模式部署**

```
Flink的Standalone集群并不支持单作业模式部署。因为单作业模式需要借助一些资源管理平台
```

###### **应用模式部署**

```
应用模式下不会提前创建集群，所以不能调用start-cluster.sh脚本。我们可以使用同样在bin目录下的standalone-job.sh来创建一个JobManager。
用例
（1）进入到Flink的安装路径下，将应用程序的jar包放到lib/目录下。
mv  realtime-flink-1.0-SNAPSHOT.jar lib/ 
（2）执行以下命令，启动JobManager
bin/standalone-job.sh start --job-classname com.zfq.fo.flink.DataGetSocket
这里我们直接指定作业入口类，脚本会到lib目录扫描所有的jar包。
（3）同样是使用bin目录下的脚本，启动TaskManager。
bin/taskmanager.sh start


bin/taskmanager.sh stop
bin/standalone-job.sh stop

```

######  **YARN运行模式（重点）**

```
YARN上部署的过程是：客户端把Flink应用提交给Yarn的ResourceManager，Yarn的ResourceManager会向Yarn的NodeManager申请容器。在这些容器上，Flink会部署JobManager和TaskManager的实例，从而启动集群。Flink会根据运行在JobManger上的作业所需要的Slot数量动态分配TaskManager资源。

1）启动集群
（1）启动Hadoop集群（HDFS、YARN）。
（2）执行脚本命令向YARN集群申请资源，开启一个YARN会话，启动Flink集群。
 
[root@hadoop31 flink-1.17.2-yarn]# ./bin/yarn-session.sh -nm test

 可用参数解读：
-d：分离模式，如果你不想让Flink YARN客户端一直前台运行，可以使用这个参数，即使关掉当前对话窗口，YARN session也可以后台运行。
-jm（--jobManagerMemory）：配置JobManager所需内存，默认单位MB。
-nm（--name）：配置在YARN UI界面上显示的任务名。
-qu（--queue）：指定YARN队列名。
-tm（--taskManager）：配置每个TaskManager所使用内存。
注意：Flink1.11.0版本不再使用-n参数和-s参数分别指定TaskManager数量和slot数量，YARN会按照需求动态分配TaskManager和slot。所以从这个意义上讲，YARN的会话模式也不会把集群资源固定，同样是动态分配的。
YARN Session启动之后会给出一个Web UI地址以及一个YARN application ID
 
 任务提交 flink webUi提交
 
 命令行提交
 ./bin/flink run -c com.zfq.fo.flink.DataGetSocket ./realtime-flink-1.0-SNAPSHOT.jar -host hadoop31 -port 8989
 
 Yarn-Session实际上是一个Yarn的Application，并且有唯一的Application ID。
 
 单作业模式部署
在YARN环境中，由于有了外部平台做资源调度，所以我们也可以直接向YARN提交一个单独的作业，从而启动一个Flink集群。

（1）执行命令提交作业。
./bin/flink run -c com.zfq.fo.flink.DataGetSocket ./realtime-flink-1.0-SNAPSHOT.jar -host hadoop31 -port 8989
（2）可以使用命令行查看或取消作业，命令如下。
查看
 ./bin/flink list -t yarn-per-job -Dyarn.application.id=application_1714147315824_0004
 取消  bin/flink cancel -t yarn-per-job -Dyarn.application.id=application_XXXX_YY <jobId>
 ./bin/flink cancel -t yarn-per-job -Dyarn.application.id=application_1714147315824_0004 cb11930515f58f665ceb84366a74c90d
这里的application_XXXX_YY是当前应用的ID，<jobId>是作业的ID。注意如果取消作业，整个Flink集群也会停掉。

应用模式部署
应用模式同样非常简单，与单作业模式类似，直接执行flink run-application命令即可。

1）命令行提交
（1）执行命令提交作业。
 ./bin/flink run-application -t yarn-application -c com.zfq.fo.flink.DataGetSocket realtime-flink-1.0-SNAPSHOT.jar -host hadoop31 -port 8989

（2）在命令行中查看或取消作业。
./bin/flink list -t yarn-application -Dyarn.application.id=application_1714147315824_0005 ->jobid 6bb2399342284c807d26eaa8729f1f06
-- 取消任务
./bin/flink cancel -t yarn-application -Dyarn.application.id=application_1714147315824_0005 6bb2399342284c807d26eaa8729f1f06

上传HDFS提交
hadoop fs -mkdir /flink-dist

-- 任务执行
./bin/flink run-application -yqu hive -t  yarn-application -Dyarn.provided.lib.dirs="hdfs://mycluster/flink-dist" -c com.zfq.fo.flink.DataGetSocket  hdfs://mycluster/flink-dist/realtime-flink-1.0-SNAPSHOT.jar -host hadoop31 -port 8989

```

##### tar 解压到指定目录 -C 

```
tar -zxvf xxx.tar.gz -C /data/program/
```

