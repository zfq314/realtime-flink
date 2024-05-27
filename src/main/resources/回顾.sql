-- 阳明心学核心
	心即理


	知行合一


	致良知



-- 人生自悟 



	做一事成一事


	谋事在人、成事在天


	AIGC

	读书

	书法-练字


	拍照 

	视频剪辑


	今日事今日毕，做好手头的事情


-- sql优化
	     
	    mysql 索引 聚合索引不能中间不能断，带头大哥不能死，一般针对聚合索引  ，where 否则后面的索引失

	    	  索引列上少计算 不用 <> 
	    	  尽量不用函数，函数也会导致索引失效
	    	  not like 也会导致索引失效 
	    	  like 'xxx%' 这样索引有效 ，like '%xxx%' 前后都有 %% 会导致索引失效


	    	 1 联合索引不满足最左匹配原则
	    	  							第一种索引失效的场景就是：在联合索引的场景下，查询条件不满足最左匹配原则。 库存日报表 ，rq 联合索引 ，索引2  ，单独建索引，提升效率
	    	 2 使用了select *
	    	  	【强制】在表查询中，一律不要使用 * 作为查询的字段列表，需要哪些字段必须明确写明。 说明:1)增加查询分析器解析成本。
																							 2)增减字段容易与 resultMap 配置不一致。
																							 3)无用字段增加网络 消耗，尤其是 text 类型的字段。
										第二种索引失效场景：在联合索引下，尽量使用明确的查询列来趋向于走覆盖索引；

			 3 索引列参与运算
			  			 	 			第三种索引失效情况：索引列参与了运算，会导致全表扫描，索引失效。 select * from t_user where id+1=2

			 4 索引列参使用了函数
			  				 			第四种索引失效情况：索引列参与了函数处理，会导致全表扫描，索引失效。 date_format() 等

			 5 错误的Like使用	
			  					方式一：like ‘%abc’；
								方式二：like ‘abc%’；
								方式三：like ‘%abc%’；
								其中方式一和方式三，由于占位符出现在首部，导致无法走索引。这种情况不做索引的原因很容易理解，索引本身就相当于目录，从左到右逐个排序。而条件的左侧使用了占位符，导致无法按照正常的目录进行匹配，导致索引失效就很正常了。
			  						 	第五种索引失效情况：模糊查询时（like语句），模糊匹配的占位符位于条件的首部。
			 6 类型隐式转换
			  							第六种索引失效情况：参数类型与字段类型不匹配，导致类型发生了隐式转换，索引失效。
			  							这种情况还有一个特例，如果字段类型为int类型，而查询条件添加了单引号或双引号，则Mysql会参数转化为int类型，虽然使用了单引号或双引号：


			 7 使用OR操作
			  							第七种索引失效情况：查询条件使用or关键字，其中一个字段没有创建索引，则会导致整个查询语句索引失效； or两边为“>”和“<”范围查询时，索引失效。

			  							如果单独使用username字段作为条件很显然是全表扫描，既然已经进行了全表扫描了，前面id的条件再走一次索引反而是浪费了。所以，在使用or关键字时，切记两个条件都要添加索引，否则会导致索引失效。

										但如果or两边同时使用“>”和“<”，则索引也会失效：
             8 两列做比较
             							第八种索引失效情况：两列数据做比较，即便两列都创建了索引，索引也会失效。

             9 不等于比较
             							explain select * from t_user where create_time != '2022-02-27 09:56:42';
										上述SQL中，由于“2022-02-27 09:56:42”是存储过程在同一秒生成的，大量数据是这个时间。执行之后会发现，当查询结果集占比比较小时，会走索引，占比比较大时不会走索引。此处与结果集与总体的占比有关
										需要注意的是：上述语句如果是id进行不等操作，则正常走索引。

										第九种索引失效情况：查询条件使用不等进行比较时，需要慎重，普通索引会查询结果集占比较大时索引会失效。


			 10 is not null
			 							第十种索引失效情况：查询条件使用is null时正常走索引，使用is not null时，不走索引。

			 11 not in和not exists
										
										在日常中使用比较多的范围查询有in、exists、not in、not exists、between and等。

										explain select * from t_user where id in (2,3);
										explain select * from t_user where id_no in ('1001','1002');
										explain select * from t_user u1 where exists (select 1 from t_user u2 where u2.id  = 2 and u2.id = u1.id);
										explain select * from t_user where id_no between '1002' and '1003';		

										上述四种语句执行时都会正常走索引，具体的explain结果就不再展示。主要看不走索引的情况：


										第十一种索引失效情况：查询条件使用not in时，如果是主键则走索引，如果是普通索引，则索引失效。


										第十二种索引失效情况：查询条件使用not exists时，索引失效。


			 12 order by导致索引失效
			 							就是主键使用order by时，可以正常走索引
			 							也就是说覆盖索引的场景也是可以正常走索引的。
			 							第十三种索引失效情况：当查询条件涉及到order by、limit等条件时，是否走索引情况比较复杂，而且与Mysql版本有关，通常普通索引，如果未使用limit，则不会走索引。order by多个索引字段时，可能不会走索引。其他情况，建议在使用时进行expain验证。
			 13 参数不同导致索引失效

									   为什么同样的查询语句，只是查询的参数值不同，却会出现一个走索引，一个不走索引的情况呢？
									   答案很简单：上述索引失效是因为DBMS发现全表扫描比走索引效率更高，因此就放弃了走索引。
									   也就是说，当Mysql发现通过索引扫描的行记录数超过全表的10%-30%时，优化器可能会放弃走索引，自动变成全表扫描。某些场景下即便强制SQL语句走索引，也同样会失效。
									   类似的问题，在进行范围查询（比如>、< 、>=、<=、in等条件）时往往会出现上述情况，而上面提到的临界值根据场景不同也会有所不同。
									   第十四种索引失效情况：当查询条件为大于等于、in等范围查询时，根据查询结果占全表数据比例的不同，优化器有可能会放弃索引，进行全表扫描。							

			 这里要说的其他，可以总结为第十五种索引失效的情况：Mysql优化器的其他优化策略，比如优化器认为在某些情况下，全表扫描比走索引快，则它就会放弃索引。

	    存储过程 异常捕获，异常信息打印


	    hive 优化

	    		利用分区表优化
	    					  分区表 是在某一个或者几个维度上对数据进行分类存储，一个分区对应一个目录。如果筛选条件里有分区字段，那么 Hive 只需要遍历对应分区目录下的文件即可，不需要遍历全局数据，使得处理的数据量大大减少，从而提高查询效率 。
                              你也可以这样理解：当一个 Hive 表的查询大多数情况下，会根据某一个字段进行筛选时，那么非常适合创建为分区表，该字段即为分区字段。
                              1、当你意识到一个字段经常用来做where，建分区表，使用这个字段当做分区字段          
							  2、在查询的时候，使用分区字段来过滤，就可以避免全表扫描。只需要扫描这张表的一个分区的数据即可

				利用分桶表优化
			  				  分桶跟分区的概念很相似，都是把数据分成多个不同的类别，区别就是规则不一样！
							  1、分区：按照字段值来进行：一个分区，就只是包含这个这一个值的所有记录 不是当前分区的数据一定不在当前分区 当前分区也只会包含当前这个分区值的数据          
                              2、分桶：默认规则：Hash散列 一个分桶中会有多个不同的值 如果一个分桶中，包含了某个值，这个值的所有记录，必然都在这个分桶
                              Hive Bucket，分桶，是指将数据以指定列的值为 key 进行 hash，hash 到指定数目的桶中，这样做的目的和分区表类似，使得筛选时不用全局遍历所有的数据，只需要遍历所在桶就可以了。这样也可以支持高效采样 。

                选择合适的文件存储格式
							  在 HiveSQL 的 create table 语句中，可以使用 stored as ... 指定表的存储格式。Apache Hive 支持 Apache Hadoop 中使用的几种熟悉的文件格式，比如 TextFile、SequenceFile、RCFile、Avro、ORC、ParquetFile 等 
      						  存储格式一般需要根据业务进行选择，在我们的实操中，绝大多数表都采用TextFile与Parquet两种存储格式之一。TextFile是最简单的存储格式，它是纯文本记录，也是Hive的默认格式。虽然它的磁盘开销比较大，查询效率也低，但它更多的是作为跳板来使用。RCFile、ORC、Parquet等格式的表都不能由文件直接导入数据，必须由TextFile来做中转。Parquet和ORC都是 Apache旗下的开源列式存储格式。列式存储比起传统的行式存储更适合批量OLAP查询，并且也支持更好的压缩和编码。
      						  创建表时，特别是宽表，尽量使用 ORC、ParquetFile这些列式存储格式，因为列式存储的表，每一列的数据在物理上是存储在一起的，Hive查询时会只遍历需要列数据，大大减少处理的数据量。

      						  1、TextFile
										存储方式：行存储。默认格式，如果建表时不指定默认为此格式。
										每一行都是一条记录，每行都以换行符"\n"结尾。数据不做压缩时，磁盘会开销比较大，数据解析开销也 比较大。
										可结合Gzip、Bzip2等压缩方式一起使用（系统会自动检查，查询时会自动解压）, 推荐选用可切分的压缩算法。
							  2、Sequence File
										一种 Hadoop API提供的二进制文件，使用方便、可分割压缩的特点。
							  3、RC File
										存储方式：数据按行分块，每块按照列存储 。A、首先，将数据按行分块，保证同一个 record 在一个块上，避免读一个记录需要读取多个 block。B、其次，块数据列式存储，有利于数据压缩和快速的列存取。
										相对来说，RCFile对于提升任务执行性能提升不大，但是能节省一些存储空间。可以使用升级版的ORC格式。
							  4、ORC File
										存储方式：数据按行分块，每块按照列存储
										Hive提供的新格式，属于RCFile的升级版，性能有大幅度提升，而且数据可以压缩存储，压缩快，快速列存取。
										ORC File会基于列创建索引，当查询的时候会很快。
						      5、Parquet File
										存储方式：列式存储。
										Parquet 对于大型查询的类型是高效的。对于扫描特定表格中的特定列查询，Parquet 特别有用。Parquet 一般使用Snappy、Gzip压缩。默认Snappy。
										Parquet 支持 Impala 查询引擎。
										表的文件存储格式尽量采用Parquet或ORC，不仅降低存储量，还优化了查询，压缩，表关联等性能。 			支持三种压缩选择：NONE、RECORD、BLOCK。RECORD压缩率低，一般建议使用BLOCK压缩 

							  选择合适的压缩格式
										 Hive 语句最终是转化为 MapReduce 程序来执行的，而 MapReduce 的性能瓶颈在与网络IO 和 磁盘 IO，要解决性能瓶颈，最主要的是 减少数据量，对数据进行压缩是个好方式。压缩虽然是减少了数据量，但是压缩过程要消耗 CPU，但是在 Hadoop 中，往往性能瓶颈不在于 CPU，CPU 压力并不大，所以压缩充分利用了比较空闲的 CPU。	

				HQL语法和运行参数层面
							  			为了写出高效的SQL，我们有必要知道HQL的执行语法，以及通过一些控制参数来调整 HQL 的执行。

										1、查看Hive执行计划
										        Hive 的 SQL 语句在执行之前需要将 SQL 语句转换成 MapReduce 任务，因此需要了解具体的转换过程，可以在 SQL 语句中输入如下命令查看具体的执行计划 。	

							  			2、列裁剪
										 		列裁剪就是在查询时只读取需要的列，分区裁剪就是只读取需要的分区。当列很多或者数据量很大时，如果 select * 或者不指定分区，全列扫描和全表扫描效率都很低。
										        Hive 在读数据的时候，可以只读取查询中所需要用到的列，而忽略其他的列。这样做可以节省读取开销：中间表存储开销和数据整合开销。	
										        ## 列裁剪，取数只取查询中需要用到的列，默认是true
												set hive.optimize.cp = true; 	

										3、谓词下推
										        将 SQL 语句中的 where 谓词逻辑都尽可能提前执行，减少下游处理的数据量。对应逻辑优化器是 PredicatePushDown 。		
                                                ## 默认是true
												set hive.optimize.ppd=true;

										4、分区裁剪
										        列裁剪就是在查询时只读取需要的列，分区裁剪就是只读取需要的分区 。当列很多或者数据量很大时，如果 select * 或者不指定分区，全列扫描和全表扫描效率都很低 。
										        在查询的过程中只选择需要的分区，可以减少读入的分区数目，减少读入的数据量 。
										        Hive 中与分区裁剪优化相关的则是：		
										        ## 默认是true
 												set hive.optimize.pruner=true; 

 										5、合并小文件
 												Map 输入合并
										        在执行 MapReduce 程序的时候，一般情况是一个文件的一个数据分块需要一个 mapTask 来处理。但是如果数据源是大量的小文件，这样就会启动大量的 mapTask 任务，这样会浪费大量资源。可以将输入的小文件进行合并，从而减少 mapTask 任务数量 。		
										        ## Map端输入、合并文件之后按照block的大小分割（默认） 
												set hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat; 
												## Map端输入，不合并 
												set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

												Map/Reduce输出合并
                                                大量的小文件会给 HDFS 带来压力，影响处理效率。可以通过合并 Map 和 Reduce 的结果文件来消除影响 。
                                                ## 是否合并Map输出文件, 默认值为true 
												set hive.merge.mapfiles=true; 
												## 是否合并Reduce端输出文件,默认值为false 
												set hive.merge.mapredfiles=true; 
												## 合并文件的大小,默认值为256000000 
												set hive.merge.size.per.task=256000000; 
												## 每个Map 最大分割大小 
												set mapred.max.split.size=256000000; 
												## 一个节点上split的最少值 
												set mapred.min.split.size.per.node=1;  // 服务器节点 
												## 一个机架上split的最少值 
												set mapred.min.split.size.per.rack=1;  // 服务器机架

										6、合理设置MapTask并行度
												第一：MapReduce中的MapTask的并行度机制
												 Map数过大：当输入文件特别大，MapTask 特别多，每个计算节点分配执行的 MapTask 都很多，这时候可以考虑减少 MapTask 的数量 ，增大每个 MapTask 处理的数据量。如果 MapTask 过多，最终生成的结果文件数会太多 。

												原因:
												1、Map阶段输出文件太小，产生大量小文件 
												2、初始化和创建Map的开销很大

												 Map数太小：当输入文件都很大，任务逻辑复杂，MapTask 执行非常慢的时候，可以考虑增加 MapTask 数，来使得每个 MapTask 处理的数据量减少，从而提高任务的执行效率 。

												原因：
												1、文件处理或查询并发度小，Job执行时间过长 
												2、大量作业时，容易堵塞集群
												        在 MapReduce 的编程案例中，我们得知，一个 MapReduce Job 的 MapTask 数量是由输入分片 InputSplit 决定的。而输入分片是由 FileInputFormat.getSplit() 决定的。一个输入分片对应一个 MapTask，而输入分片是由三个参数决定的：		
												        long splitSize = Math.max(minSize, Math.min(maxSize, blockSize))

												默认情况下，输入分片大小和 HDFS 集群默认数据块大小一致，也就是默认一个数据块，启用一个 MapTask 进行处理，这样做的好处是避免了服务器节点之间的数据传输，提高 job 处理效率 。

										        两种经典的控制 MapTask 的个数方案：减少 MapTask 数 或者 增加 MapTask 数：

												1、减少 MapTask 数是通过合并小文件来实现，这一点主要是针对数据源
												2、增加 MapTask 数可以通过控制上一个 job 的 reduceTask 个数 重点注意：不推荐把这个值进行随意设置！推荐的方式：使用默认的切块大小即可。如果非要调整，最好是切块的N倍数        


												第二：合理控制 MapTask 数量
												减少 MapTask 数可以通过合并小文件来实现
												增加 MapTask 数可以通过控制上一个 ReduceTask 默认的 MapTask 个数
												计算方式
												输入文件总大小：total_size HDFS 设置的数据块大小：dfs_block_size default_mapper_num = total_size / dfs_block_size
										        MapReduce 中提供了如下参数来控制 map 任务个数，从字面上看，貌似是可以直接设置 MapTask 个数的样子，但是很遗憾不行，这个参数设置只有在大于 default_mapper_num 的时候，才会生效 。


										        总结一下控制 mapper 个数的方法：

												1、如果想增加 MapTask 个数，可以设置 mapred.map.tasks 为一个较大的值
												2、如果想减少 MapTask 个数，可以设置 maperd.min.split.size 为一个较大的值 
												3、如果输入是大量小文件，想减少 mapper 个数，可以通过设置 hive.input.format 合并小文件
												        如果想要调整 mapper 个数，在调整之前，需要确定处理的文件大概大小以及文件的存在形式（是大量小文件，还是单个大文件），然后再设置合适的参数。不能盲目进行暴力设置，不然适得其反。
												        MapTask 数量与输入文件的 split 数息息相关，在 Hadoop 源码org.apache.hadoop.mapreduce.lib.input.FileInputFormat 类中可以看到 split 划分的具体逻辑。可以直接通过参数 mapred.map.tasks （默认值2）来设定 MapTask 数的期望值，但它不一定会生效 。

										7、合理设置ReduceTask并行度

												如果 ReduceTask 数量过多，一个 ReduceTask 会产生一个结果文件，这样就会生成很多小文件，那么如果这些结果文件会作为下一个 Job 的输入，则会出现小文件需要进行合并的问题，而且启动和初始化ReduceTask 需要耗费资源 。

												如果 ReduceTask 数量过少，这样一个 ReduceTask 就需要处理大量的数据，容易拖慢运行时间或者造成 OOM，可能会出现数据倾斜的问题，使得整个查询耗时长。默认情况下，Hive 分配的 reducer 个数由下列参数决定：

												参数1：hive.exec.reducers.bytes.per.reducer (默认256M) 
												参数2：hive.exec.reducers.max (默认为1009) 
												参数3：mapreduce.job.reduces (默认值为-1，表示没有设置，那么就按照以上两个参数 进行设置)
												ReduceTask 的计算公式为：
												N = Math.min(参数2，总输入数据大小 / 参数1)
												可以通过改变上述两个参数的值来控制 ReduceTask 的数量。也可以通过
												set mapred.map.tasks=10; 
												set mapreduce.job.reduces=10;

									    8、 Join优化
									    
									    			Join优化整体原则：

														1、优先过滤后再进行Join操作，最大限度的减少参与join的数据量 
														2、小表join大表，最好启动mapjoin，hive自动启用mapjoin, 小表不能超过25M，可以更改 
														3、Join on的条件相同的话，最好放入同一个job，并且join表的排列顺序从小到大：select a., b., c.* from a join b on a.id = b.id join c on a.id = c.i 
														4、如果多张表做join, 如果多个链接条件都相同，会转换成一个JOb

													优先过滤数据

														尽量减少每个阶段的数据量，对于分区表能用上分区字段的尽量使用，同时只选择后面需要使用到的列，最大 限度的减少参与 Join 的数据量。

													小表 join 大表原则

														小表 join 大表的时应遵守小表 join 大表原则，原因是 join 操作的 reduce 阶段，位于 join 左边 的表内容会被加载进内存，将条目少的表放在左边，可以有效减少发生内存溢出的几率。join 中执行顺序是从左到右生成 Job，应该保证连续查询中的表的大小从左到右是依次增加的。

													使用相同的连接键

													在 hive 中，当对 3 个或更多张表进行 join 时，如果 on 条件使用相同字段，那么它们会合并为一个 MapReduce Job，利用这种特性，可以将相同的 join on 放入一个 job 来节省执行时间 。
													尽量原子操作
													尽量避免一个SQL包含复杂的逻辑，可以使用中间表来完成复杂的逻辑。
													大表Join大表
														1、空key过滤：有时join超时是因为某些key对应的数据太多，而相同key对应的数据都会发送到相同的 reducer上，从而导致内存不够。此时我们应该仔细分析这些异常的key，很多情况下，这些key对应的数据是异常数据，我们需要在SQL语句中进行过滤。         
														2、空key转换：有时虽然某个key为空对应的数据很多，但是相应的数据不是异常数据，必须要包含在join 的结果中，此时我们可以表a中key为空的字段赋一个随机的值，使得数据随机均匀地分到不同的reducer 上 。

										9、 启用 MapJoin
													这个优化措施，但凡能用就用！
													大表 join 小表 小表满足需求：小表数据小于控制条件时 。
													MapJoin 是将 join 双方比较小的表直接分发到各个 map 进程的内存中，在 map 进程中进行 join 操作，这样就不用进行 reduce 步骤，从而提高了速度。只有 join 操作才能启用 MapJoin 。		
													## 是否根据输入小表的大小，自动将reduce端的common join 转化为map join，将小表刷入内存中。 
													## 对应逻辑优化器是MapJoinProcessor 
													set hive.auto.convert.join = true; 

													## 刷入内存表的大小(字节) 
													set hive.mapjoin.smalltable.filesize = 25000000; 

													## hive会基于表的size自动的将普通join转换成mapjoin 
													set hive.auto.convert.join.noconditionaltask=true; 

													## 多大的表可以自动触发放到内层 LocalTask 中，默认大小10M 
													set hive.auto.convert.join.noconditionaltask.size=10000000;

													Hive 可以进行多表 Join。Join 操作尤其是 Join 大表的时候代价是非常大的。MapJoin 特别适合大小表 join 的情况。在Hive join场景中，一般总有一张相对小的表和一张相对大的表，小表叫 build table，大表叫 probe table。Hive 在解析带 join 的 SQL 语句时，会默认将最后一个表作为 probe table，将前面的表作为 build table 并试图将它们读进内存。如果表顺序写反，probe table 在前面，引发 OOM 的风险就高了。在维度建模数据仓库中，事实表就是 probe table，维度表就是 build table。这种 Join 方式在 map 端直接完成 join 过程，消灭了 reduce，效率很高。而且 MapJoin 还支持非等值连接 。

    											    当 Hive 执行 Join 时，需要选择哪个表被流式传输（stream），哪个表被缓存（cache）。Hive 将JOIN 语句中的最后一个表用于流式传输，因此我们需要确保这个流表在两者之间是最大的。如果要在不同的 key 上 join 更多的表，那么对于每个 join 集，只需在 ON 条件右侧指定较大的表 。

    									10、Join数据倾斜优化
													在编写 Join 查询语句时，如果确定是由于 join 出现的数据倾斜，那么请做如下设置：	    	
													# join的键对应的记录条数超过这个值则会进行分拆，值根据具体数据量设置 
													set hive.skewjoin.key=100000; 

													# 如果是join过程出现倾斜应该设置为true 
													set hive.optimize.skewjoin=false;
													如果开启了，在 Join 过程中 Hive 会将计数超过阈值 hive.skewjoin.key（默认100000）的倾斜 key 对应的行临时写进文件中，然后再启动另一个 job 做 map join 生成结果。
        											通过 hive.skewjoin.mapjoin.map.tasks 参数还可以控制第二个 job 的 mapper 数量，默认10000 。
													set hive.skewjoin.mapjoin.map.tasks=10000;

										11、CBO优化
        											join的时候表的顺序的关系：前面的表都会被加载到内存中。后面的表进行磁盘扫描 。

													select a., b., c.* from a join b on a.id = b.id join c on a.id = c.id ;
													Hive 自 0.14.0 开始，加入了一项 Cost based Optimizer 来对 HQL 执行计划进行优化，这个功能通过 hive.cbo.enable 来开启。在 Hive 1.1.0 之后，这个 feature 是默认开启的，它可以 自动优化 HQL 中多个 Join 的顺序，并选择合适的 Join 算法 。

													CBO，成本优化器，代价最小的执行计划就是最好的执行计划。传统的数据库，成本优化器做出最优化的执行计划是依据统计信息来计算的。Hive 的成本优化器也一样。

													Hive 在提供最终执行前，优化每个查询的执行逻辑和物理执行计划。这些优化工作是交给底层来完成的。根据查询成本执行进一步的优化，从而产生潜在的不同决策：如何排序连接，执行哪种类型的连接，并行度等等。要使用基于成本的优化（也称为CBO），请在查询开始设置以下参数：
													set hive.cbo.enable=true; 
													set hive.compute.query.using.stats=true; 
													set hive.stats.fetch.column.stats=true; 
													set hive.stats.fetch.partition.stats=true;	

									    12、怎样做笛卡尔积
											        当 Hive 设定为严格模式（hive.mapred.mode=strict）时，不允许在 HQL 语句中出现笛卡尔积，这实 际说明了 Hive 对笛卡尔积支持较弱。因为找不到 Join key，Hive 只能使用 1 个 reducer 来完成笛卡尔积 。
											        当然也可以使用 limit 的办法来减少某个表参与 join 的数据量，但对于需要笛卡尔积语义的需求来说，经常是一个大表和一个小表的 Join 操作，结果仍然很大（以至于无法用单机处理），这时 MapJoin 才是最好的解决办法。MapJoin，顾名思义，会在 Map 端完成 Join 操作。这需要将 Join 操作的一个或多个表完全读入内存。
											        PS：MapJoin 在子查询中可能出现未知 BUG。在大表和小表做笛卡尔积时，规避笛卡尔积的方法是， 给 Join 添加一个 Join key，原理很简单：将小表扩充一列 join key，并将小表的条目复制数倍，join key 各不相同；将大表扩充一列 join key 为随机数。
											 精髓就在于复制几倍，最后就有几个 reduce 来做，而且大表的数据是前面小表扩张 key 值范围里面随机出来的，所以复制了几倍 n，就相当于这个随机范围就有多大 n，那么相应的，大表的数据就被随机的分为了 n 份。并且最后处理所用的 reduce 数量也是 n，而且也不会出现数据倾斜 。				

										13、Group By 优化
													默认情况下，Map 阶段同一个 Key 的数据会分发到一个 Reduce 上，当一个 Key 的数据过大时会产生数据倾斜。进行 group by 操作时可以从以下两个方面进行优化：	

													1. Map端部分聚合 
																   事实上并不是所有的聚合操作都需要在 Reduce 部分进行，很多聚合操作都可以先在 Map 端进行部分聚合，然后在 Reduce 端的得出最终结果 。 	
																   ## 开启Map端聚合参数设置 
																   set hive.map.aggr=true; 
																   ## 设置map端预聚合的行数阈值，超过该值就会分拆job，默认值100000 
																   set hive.groupby.mapaggr.checkinterval=100000
													2. 有数据倾斜时进行负载均衡
																			 当 HQL 语句使用 group by 时数据出现倾斜时，如果该变量设置为 true，那么 Hive 会自动进行负载均衡。策略就是把 MapReduce 任务拆分成两个：第一个先做预汇总，第二个再做最终汇总 。	
																			 # 自动优化，有数据倾斜的时候进行负载均衡（默认是false）
																			 set hive.groupby.skewindata=false;		
																			 当选项设定为 true 时，生成的查询计划有两个 MapReduce 任务 。
																			1、在第一个 MapReduce 任务中，map 的输出结果会随机分布到 reduce 中，每个 reduce 做部分聚合操作，并输出结果，这样处理的结果是相同的group by key有可能分发到不同的 reduce 中，从而达到负载均衡的目的；         
																			2、第二个 MapReduce 任务再根据预处理的数据结果按照 group by key 分布到各个 reduce 中，最 后完成最终的聚合操作。
																			        Map 端部分聚合：并不是所有的聚合操作都需要在 Reduce 端完成，很多聚合操作都可以先在 Map 端进行部分聚合，最后在 Reduce 端得出最终结果，对应的优化器为 GroupByOptimizer 。   

										14、Order By优化
										
													order by 只能是在一个 reduce 进程中进行，所以如果对一个大数据集进行 order by ，会导致一个 reduce 进程中处理的数据相当大，造成查询执行缓慢 。
													1、在最终结果上进行order by，不要在中间的大数据集上进行排序。如果最终结果较少，可以在一个 reduce上进行排序时，那么就在最后的结果集上进行order by。
													2、如果是取排序后的前N条数据，可以使用distribute by和sort by在各个reduce上进行排序后前N 条，然后再对各个reduce的结果集合合并后在一个reduce中全局排序，再取前N条，因为参与全局排序的 order by的数据量最多是reduce个数 * N，所以执行效率会有很大提升。在Hive中，关于数据排序，提供了四种语法，一定要区分这四种排序的使用方式和适用场景。
													1、order by：全局排序，缺陷是只能使用一个reduce
													2、sort by：单机排序，单个reduce结果有序 
													3、cluster by：对同一字段分桶并排序，不能和sort by连用 
													4、distribute by+sort by：分桶，保证同一字段值只存在一个结果文件当中，结合sort by保证每 个reduceTask结果有序
													        Hive HQL 中的 order by 与其他 SQL 方言中的功能一样，就是将结果按某字段全局排序，这会导致所有 map 端数据都进入一个 reducer 中，在数据量大时可能会长时间计算不完 。
													        如果使用 sort by，那么还是会视情况启动多个 reducer 进行排序，并且保证每个 reducer 内局部有序。为了控制 map 端数据分配到 reducer 的 key，往往还要配合 distribute by 一同使用。如果不加 distribute by 的话，map 端数据就会随机分配到 reducer。									        

										15、Count Distinct优化
											    当要统计某一列去重数时，如果数据量很大，count(distinct) 就会非常慢，原因与 order by 类似，count(distinct) 逻辑只会有很少的 reducer 来处理。这时可以用 group by 来改写：

										16、怎样写in/exists语句
											     在Hive的早期版本中，in/exists语法是不被支持的，但是从 hive-0.8x 以后就开始支持这个语法。但是不推荐使用这个语法。虽然经过测验，Hive-2.3.6 也支持 in/exists 操作，但还是推荐使用 Hive 的一个高效替代方案：left semi join	        			        


										17、使用 vectorization 技术
											        在计算类似 scan, filter, aggregation 的时候， vectorization 技术以设置批处理的增量大小为 1024 行单次来达到比单条记录单次获得更高的效率。
													set hive.vectorized.execution.enabled=true ; 
													set hive.vectorized.execution.reduce.enabled=true;

										18、多重模式
        											如果你碰到一堆SQL，并且这一堆SQL的模式还一样。都是从同一个表进行扫描，做不同的逻辑。有可优化的地方：如果有n条SQL，每个SQL执行都会扫描一次这张表 。
											        如果一个 HQL 底层要执行 10 个 Job，那么能优化成 8 个一般来说，肯定能有所提高，多重插入就是一 个非常实用的技能。一次读取，多次插入，有些场景是从一张表读取数据后，要多次利用，这时可以使用 multi insert 语法：
											           需要的是，multi insert 语法有一些限制
													   1、一般情况下，单个SQL中最多可以写128路输出，超过128路，则报语法错误。
													   2、在一个multi insert中：对于分区表，同一个目标分区不允许出现多次。对于未分区表，该表不能出现多次。
													   3、对于同一张分区表的不同分区，不能同时有insert overwrite和insert into操作，否则报错返回	

										19、启动中间结果压缩
													map 输出压缩

													set mapreduce.map.output.compress=true; 
													set mapreduce.map.output.compress.codec=org.apache.hadoop.io.compress.SnappyCodec;

													中间数据压缩

													        中间数据压缩就是对 hive 查询的多个 Job 之间的数据进行压缩。最好是选择一个节省CPU耗时的压缩方式。可以采用 snappy 压缩算法，该算法的压缩和解压效率都非常高。

													set hive.exec.compress.intermediate=true; 
													set hive.intermediate.compression.codec=org.apache.hadoop.io.compress.SnappyCodec; 
													set hive.intermediate.compression.type=BLOCK;

													结果数据压缩

													        最终的结果数据（Reducer输出数据）也是可以进行压缩的，可以选择一个压缩效果比较好的，可以减少数据的大小和数据的磁盘读写时间 。

													        需要注意：常用的 gzip，snappy 压缩算法是不支持并行处理的，如果数据源是 gzip/snappy压缩文件大文件，这样只会有有个 mapper 来处理这个文件，会严重影响查询效率。所以如果结果数据需要作为其他查询任务的数据源，可以选择支持 splitable 的 LZO 算法，这样既能对结果文件进行压缩，还可以并行的处理，这样就可以大大的提高 job 执行的速度了。

													set hive.exec.compress.output=true; 
													set mapreduce.output.fileoutputformat.compress=true; 
													set mapreduce.output.fileoutputformat.compress.codec=org.apache.hadoop.io.compress.G zipCodec; 
													set mapreduce.output.fileoutputformat.compress.type=BLOCK;	

										20、Hive 架构层面

													1、启用本地抓取
													Hive 的某些 SQL 语句需要转换成 MapReduce 的操作，某些 SQL 语句就不需要转换成 MapReduce 操作，但是同学们需要注意，理论上来说，所有的 SQL 语句都需要转换成 MapReduce 操作，只不过 Hive 在转换 SQL 语句的过程中会做部分优化，使某些简单的操作不再需要转换成 MapReduce，例如：

														1、只是 select * 的时候 
														2、where 条件针对分区字段进行筛选过滤时 
														3、带有 limit 分支语句时
														        Hive 从 HDFS 中读取数据，有两种方式：启用MapReduce读取 和 直接抓取 。
														        直接抓取数据比 MapReduce 方式读取数据要快的多，但是只有少数操作可以使用直接抓取方式 。
														        可以通过 hive.fetch.task.conversion 参数来配置在什么情况下采用直接抓取方式：
														minimal：只有 select * 、在分区字段上 where 过滤、有 limit 这三种场景下才启用直接抓取方式。
														more：在 select、where 筛选、limit 时，都启用直接抓取方式 。

													2、本地执行优化
													        Hive在集群上查询时，默认是在集群上多台机器上运行，需要多个机器进行协调运行，这种方式很好地解决了大数据量的查询问题。但是在Hive查询处理的瓣量比较小的时候，其实没有必要启动分布 式模式去执行，因为以分布式方式执行设计到跨网络传输、多节点协调等，并且消耗资源。对于小数据 集，可以通过本地模式，在单台机器上处理所有任务，执行时间明显被缩短 。
													        启动本地模式涉及到三个参数：	
													        ##打开hive自动判断是否启动本地模式的开关
															set hive.exec.mode.local.auto=true;
															## map任务晝專大值,*启用本地模式的task最大皋数
															set hive.exec.mode.1ocal.auto.input.files.max=4;
															## map输入文件最大大小，不启动本地模式的最大输入文件大小
															set hive.exec.mode.1ocal.auto.inputbytes.max=134217728;

													3、JVM 重用
													        Hive语句最终会转换为一系的MapReduce任务，每一个MapReduce任务是由一系的MapTask 和ReduceTask组成的，默认情况下，MapReduce中一个MapTask或者ReduceTask就会启动一个 JVM进程，一个Task执行完毕后，JVM进程就会退出。这样如果任务花费时间很短，又要多次启动 JVM的情况下，JVM的启动时间会变成一个比较大的消耗，这时，可以通过重用JVM来解决 。
													            JVM也是有缺点的，开启JVM重用会一直占用使用到的task的插槽，以便进行重用，直到任务完成后才 会释放。如果某个不平衡的job中有几个reduce task执行的时间要比其他的reduce task消耗的时间 要多得多的话，那么保留的插槽就会一直空闲却无法被其他的job使用，直到所有的task都结束了才 会释放。
        															根据经验，一般来说可以使用一个cpu core启动一个JVM，假如服务器有16个cpu core，但是这个 节点，可能会启动32个 mapTask ,完全可以考虑：启动一个JVM,执行两个Task 。
													
        											4、并行执行
													        有的查询语句，Hive会将其转化为一个或多个阶段，包括：MapReduce阶段、抽样阶段、合并阶段、 limit阶段等。默认情况下，一次只执行一个阶段。但是，如果某些阶段不是互相依赖，是可以并行执行的。多阶段并行是比较耗系统资源的 。
													        一个 Hive SQL语句可能会转为多个MapReduce Job,每一个 job 就是一个 stage , 这些Job顺序执行，这个在 client 的运行日志中也可以看到。但是有时候这些任务之间并不是相互依赖的，如果集群资源允许的话，可以让多个并不相互依赖 stage 并发执行，这样就节约了时间，提高了执行速度，但是如 果集群资源匮乏时，启用并行化反倒是会导致各个 Job 相互抢占资源而导致整体执行性能的下降。启用 并行化：

													5、推测执行
													        在分布式集群环境下，因为程序Bug（包括Hadoop本身的bug），负载不均衡或者资源分布不均等原因，会造成同一个作业的多个任务之间运行速度不一致，有些任务的运行速度可能明显慢于其他任务（比如一个作业的某个任务进度只有50%，而其他所有任务已经运行完毕），则这些任务会拖慢作业的整体执行进度。为了避免这种情况发生，Hadoop采用了推测执行（Speculative Execution）机制，它根据一定的法则推测出“拖后腿”的任务，并为这样的任务启动一个备份任务，让该任务与原始任务同时处理同一份数据，并最终选用最先成功运行完成任务的计算结果作为最终结果 。

													6、Hive严格模式
													        所谓严格模式，就是强制不允许用户执行有风险的 HiveQL 语句，一旦执行会直接失败。但是Hive中为了提高SQL语句的执行效率，可以设置严格模式，充分利用 Hive 的某些特点 。  
													        ## 设置Hive的严格模式 
															set hive.mapred.mode=strict; 
															set hive.exec.dynamic.partition.mode=nostrict;      

					   		
-- 布局

	一、每天布局

	1、每天坚持早睡早起。坚持6:00起床，22:30分左右睡觉。坚持每天唤醒你的不是闹钟，而是梦想。
	2、每天坚持看书二小时，没有时间也要挤出时间去看，随身携带一本书、坐公交、地铁的时候也可以看几页。读书，要多读一流的好书，站在巨人的肩膀上去看世界。
	3、每天日程坚持守时。凡事提前10分钟，重要会议提前二十分钟。写好当日计划，知行合一。
	4、每天坚持运动，顶置健康能力。每天摄入8粒红枣10粒枸杞，再来2～3公里慢跑或快走，保持身体活力四射。
	5、每天坚持出门前，面对镜子微笑。头发要姿整，皮鞋要油亮，腰杠要挺直，胡子不要走中间路线，人要有精神气。每天走路，走的是虎步。



	二、每周布局

	1、每周去一次图书馆，博览群书，提高思想和技能，最充分地去适应时代。
	2、每星期去见一个你想见的人，可以请比你优秀的人单独吃饭，也可以和志趣相投的人在一起，提升能量。
	3、每星期登山一次，会当凌绝顶 ，一览众山小。登山感悟自然，与生命对话，与命运和解。
	4、每周花半天时间，写一篇有深度的文章；或观看一部一流的记录片，再写一篇读后感。保持思想输出。
	5、每周和父母见一次面，家人闲坐，灯火可亲，就是握着一份稳稳的幸福。如果路途遥远，那么至少每星期给父母打一次电话，维持亲情，靠近亲情，因为人到了一定的年纪后，你就会发现，除了家人，你已几乎一无所有。



	三、每月布局


	1、每月存一次钱，哪怕是少少的500～1000元，也要坚持每月固定存钱，顶置储蓄能力。银行卡里的余额，才是你生活的底气。
	2、每月去做一件“无用”但开心的事。如到陌生的地方旅行，或参加马拉松比赛，“无用”即大用。
	3、每月考察调研一次，研究趋势，捕捉机会，发现商机。
	4、每月做一次义工，向他人付出爱，积福积徳。做人施比受有福。
	5、每月断舍离一次。不需要的东西，扔掉；负能量的朋友，扔掉。



	四，每年布局


	1、每年做一次战略布局。选择比努力重要，不要用战术上的勤奋去掩饰战略上的懒惰。
	2、每年自己体检一次，带家人体检一次。关注健康，听从营养医生的建议，调整生活方式和饮食习惯，养成更好更合适的生活规律。
	3、学会藏富。每年做一次稳健的投资，让财富产生裂变，增加睡后收入。
	4、每年出国一次，去感受不同的文化，去见识世界不同的面。
	5、每年回老家一次，寻根祭祖，饮水思源，回到故土，审视自己的灵魂，注入生命新的能力，不忘初心，重新出发。

-- 费曼学习法

	诺贝尔物理学奖获得者温伯格说：“学会一样东西很简单，一，去学习，二，去教会别人，三，去把心得写成一本书。”


	这就是费曼学习法的最佳实践
	谁是费曼
	今年有一部电影《奥本海默》，这位原子弹之父曾说：“费曼是原子弹项目中最杰出的年轻物理学家。”他是诺贝尔奖获得者，也是一位伟大的教育家。
	什么是费曼学习法
	简而言之，就是把你学的东西讲给别人听，以教的方式来学，你能讲清楚就是学会了，如果讲不清楚回到源头再去理解，然后再讲给别人听。

	 

	为什么说教学相长？
	因为，教就是最好的学。

	 

	一个人脱胎换骨的蜕变，都源于知识体系的升级。对于构建一门知识的体系结构，最有效的方法是分享，而分享最有效的形式是讲一堂课、带一个徒弟、写一本书……
	我坚持每天发一个短视频，通过输出的形式，梳理自己的知识体系，同时不断的输入，逼着自己去大量阅读和思考，把对知识的理解提升到一个新层次。对费曼学习法的持续践行，提升了我的语言表达和写作能力，职场自媒体全网有了百万粉丝（明哥聊求职/职场）。
	一位尚硅谷的老学员，工作时经常写文章发博客，在技术社区热心解答问题，后来，我鼓励他录一套视频教程，反响不错，出版社的编辑找到他出了一本书，现在他做了付费课程，还做了咨询顾问……既升华了自己的知识体系，又成功变现副业搞得风生水起。

	 

	费曼学习法的核心就是：
	用输入帮助输出，用输出倒逼输入。
	领导让你带新人，带不带？有的人不愿意带徒弟，因为没有激励，怕教会徒弟饿死师傅。其实，教会了徒弟最大的受益人是你，不是徒弟，也不是公司。

	 

	第一，带徒弟的过程中，沉淀下来教的方法是最大的价值。这是一次你对自己知识体系的梳理和完善。
	第二，如果师傅被饿死了，只能证明徒弟会不是师傅教的好。你的危机意识源于你对自己可以变得更好没有信心。
	一个人刚被提拔，面临的最大问题是：如何管理之前的同事？原来大家是一样的职位，同事尤其是和你资历差不多的同事永远会问一句话：凭什么是你？这是一个管理者刚晋升时的最大挑战。
	所以，提拔之前，你的主管可能会安排两件事：一是把重要的事交给你做，二就是把新人交给你带。

	 

	一，能承担责任的人才能当领导

	提拔一个人最合适的理由是：他承担了责任，解决了问题，创造了价值，展现出了他的领导力。把重要的事交给你做，有了责任就有了权力，责权利是三位一体的，提拔就顺理成章。
	二，能培养新人的人才能当领导

	新员工交给你来带，一是培养你带人的能力，二是部门里的张三、李四、王二麻子都是你带出来的，你就有了自己的队伍，而群众的选择才是真正的选择。
	这两件事都干完了，把你提拔上来大家都服。带徒弟，是你一次绝佳的学习和成长的机会，通过教的形式，可以把自己的知识体系提升到一个新境界。

-- 离线数仓 
	数据建模

	hive
		优化
		原理
		基本语法
	
	数据迁移 
	      sqoop 
	      datax
	      canal
	      maxwell
	      dbsyncer 关系型数据库 mysql 可以基于binlog 增量读取，全量读取	

	调度工具
		   dolphinscheduler


-- 实时数仓 
	流计算
	存算分离
		   flink  计算 
           doris 存储
           clickhouse 
           seatunnel


--  hadoop 调度

              在 Yarn 中默认实现了三种调速器：FIFO Scheduler 、Capacity Scheduler、Fair Scheduler。

              FIFO
					最简单的一个策略，仅做测试用。
					用一个队列来存储提交等待的任务，先提交的任务就先分资源，有剩余的资源就给后续排队等待的任务，没有资源了后续任务就等着之前的任务释放资源。
					优点：
					简单，开箱即用，不需要额外的配置。早些版本的 Yarn 用 FIFO 作为默认调度策略，后续改为 CapacityScheduler 作为默认调度策略。
					缺点：
					除了简单外都是缺点，无法配置你各种想要的调度策略（限制资源量、限制用户、资源抢夺等）。


			Capacity Scheduler
			      （后以 CS 简写代替）以队列为单位划分资源。会给每个队列配置最小保证资源和最大可用资源。最小配置资源保证队列一定能拿到这么多资源，有空闲可共享给其他队列使用；
			       最大可用资源限制队列最多能使用的资源，防止过度消耗。		

			       优点：
						队列最低资源保障，防止小应用饿死；
						空闲容量共享，当队列配置资源有空闲时可共享给其他队列使用
				   缺点：
						队列配置繁琐，父队列、子队列都要单独配置优先级、最大资源、最小资源、用户最大资源、用户最小资源、用户权限配置等等。工程中会写个程序，自动生成该配置；

            FairScheduler
				    同 Capacity Seheduler 类似，Fair Scheduler 也是一个多用户调度器，它同样添加了多层级别的资源限制条件以更好地让多用户共享一个 Hadoop 集群，比如队列资源限制、用户应用程序数目限制等。
					在 Fair 调度器中，我们不需要预先占用一定的系统资源，Fair 调度器会为所有运行的 job 动态的调整系统资源。如下图所示，当第一个大 job 提交时，只有这一个 job 在运行，此时它获得了所有集群资源；当第二个小任务提交后，Fair 调度器会分配一半资源给这个小任务，让这两个任务公平的共享集群资源。			
					Fair 调度器的设计目标是为所有的应用分配公平的资源（对公平的定义可以通过参数来设置）。
					优点：

					分配给每个应用程序的资源取决于其优先级；
					它可以限制特定池或队列中的并发运行任务。