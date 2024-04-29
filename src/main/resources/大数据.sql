-- --------------------------------------------------------------------------------------------------------------
ClickHouse  
			join 不好 
			适合建宽表
			通过拼宽表避免聚合操作

-- --------------------------------------------------------------------------------------------------------------



-- --------------------------------------------------------------------------------------------------------------

StarRocks
			
			StarRocks 对于 join 的能力更强，可以建立星型或者雪花模型应对维度数据的变更。

			在 StarRocks 中提供了三种不同类型的 join：			当小表与大表关联时，可以使用 boardcast join，小表会以广播的形式加载到不同节点的内存中
			当大表与大表关联式，可以使用 shuffle join，两张表值相同的数据会 shuffle 到相同的机器上
			为了避免 shuffle 带来的网络与 I/O 的开销，也可以在创建表示就将需要关联的数据存储在同一个 colocation group 中，使用 colocation join
-- --------------------------------------------------------------------------------------------------------------





-- 批量任务删除  yarn  
-- --------------------------------------------------------------------------------------------------------------
			for i in `yarn application -list | grep -i accepted | awk 'NR == 1 {next} {print $1}' | grep application_`; do yarn application -kill $i; done
-- --------------------------------------------------------------------------------------------------------------


-- --------------------------------------------------------------------------------------------------------------

-- tez 指定执行任务的队列

set tez.job.queuename=hive;
<property>
  <name>tez.queue.name</name>
  <value>hive</value>
</property>



set tez.queue.name=default;

-- --------------------------------------------------------------------------------------------------------------

dataworks


dts

数据传输服务DTS（Data Transmission Service）是阿里云提供的实时数据流服务，支持关系型数据库（RDBMS）、非关系型的数据库（NoSQL）、数据多维分析（OLAP）等数据源间的数据交互，集数据同步、迁移、订阅、集成、加工于一体，助您构建安全、可扩展、高可用的数据架构。



第一，确立你要学习的目标。找到和列出自己想要了解的知识，可以是一本书，也可以是一门技术，甚至是你能想象到的任意领域和事物。
第二，理解你要学习的对象.针对这个目标，准备好和筛选相关的资料，选择可靠和多个角度的信息来源，把这些内容系统化地归纳整理出来。
第三，以教代学，用输出代替输入。模拟一个传授的场景，用自己的语言把这些知识讲给别人，用以检查自己是否已经掌握了这些知识。
第四，进行回顾和反思。对其中遇到阻碍、模糊不清和有疑义的知识重新学习、回顾和反思。如有必要，可以重整旗鼓，进行再一次输出。
第五，实现知识的简化和吸收。最后，通过针对性的简化和整合，实现这些知识的内化和有效的应用。





-- --------------------------------------------------------------------------------------------------------------

-- 梦享会调拨数据，异常工费问题排查

-- 北京异常单据 DBRK202403280199
select * from t_ka_splsz where chf like '梦享会%' GROUP BY id HAVING SUM(ifnull(jcgfje,0) + ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0))=0

-- 特艺城异常单据 DBRK202404070447 DBRK202404070448 
select *    from t_ka_splsz where chf like '梦享会%' GROUP BY id HAVING SUM(ifnull(jcgfje,0) + ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0))=0 order by rq  desc 

-- 海南展厅无异常
-- 合肥展厅无异常
-- 厚德金展厅无异常
-- 南京展厅无异常

-- 江西异常单据 DBRK202404030416
select *    from t_ka_splsz where chf like '梦享会%' GROUP BY id HAVING SUM(ifnull(jcgfje,0) + ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0))=0 order by rq  desc 

-- --------------------------------------------------------------------------------------------------------------



cx_zt_kcrbb2_rbv2_settlement_to_decision 同步存储过程



-- --------------------------------------------------------------------------------------------------------------
-- 全国版展厅库存相关的2个报表去掉冗余的成色
and ckmc='镶嵌Q柜' and jsmc='金9999'
and (ckmc='镶嵌柜（德钰东方）' or ckmc='德钰东方柜' ) and jsmc='金9999'
and (ckmc='镶嵌柜（德钰东方）' or ckmc='德钰东方柜' ) and jsmc='AU750'
and (ckmc='镶嵌柜（德钰东方）' or ckmc='德钰东方柜' ) and jsmc='足金'
and (ckmc='镶嵌打标') and jsmc='千足金'
and (ckmc='镶嵌Q柜') and jsmc='足金' 
and jsmc='喜9999' 
and jsmc='喜99999'
and jsmc='金9999'and  ckmc = '金德尚万足柜'
and jsmc='金9999'and  ckmc = '万足柜'

-- --------------------------------------------------------------------------------------------------------------


cx_zt_kcrbb2_rbv2_settlement
cx_zt_ztkcsfc_rb
func_sale_from_report
cx_gtkcdzcx
cx_zt_kcrbb2_rbv2_settlement_to_decision
cx_zt_kcrbb2_rbv2
showroom_inventory_collection_summary_table
customer_withdrawal_details
p_tbl_sales_detail
p_kc_detail
p_product_enroute





-- --------------------------------------------------------------------------------------------------------------

深圳结算-东方斓 上线 

决策报表
收发存
柜台对账汇总
库存日报表财务
库存日报表财务1 -涉及中间表-和调用的存储过程 
客户日销售报表



RpQuerySalesStorageData_Modify
cx_zt_ztkcsfc_sz_new_5G
cx_szzt_hz_gtkcdzcx
cx_szzt_kcrbb_cw2_5g
GenSzztxsrb
cx_zt_xsrbb_sz_cw2
cx_zt_xsrbb_sz_kh4

-- --------------------------------------------------------------------------------------------------------------
ssh hadoop33 登录慢问题处理

-- 排查
ssh -v root@hadoop33 
 
-- 处理 
重启相关服务
 
systemctl restart dbus
systemctl restart systemd-logind


-- --------------------------------------------------------------------------------------------------------------

-- 4月3号梦享会调入特艺城数据工费和流水不一致的情况
 
select  * from t_ka_splsz where djh='DBRK202404020395' and jz in (
36.77,
7.32,
6.54,
6.79
)

select * from t_from_allocation_in_warehouse_detail where allocation_identity='18E9D97E-2310-174F-9FD5-5959C55193A1'  and gold_weight in (
36.77,
7.32,
6.54,
6.79
)
 
-- --------------------------------------------------------------------------------------------------------------


select   djh,SUM(ifnull(jcgfje,0) + ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0) ) from t_ka_splsz where jsmc='金9999' and chf like '梦享会%' and rq='2024-04-03' GROUP BY djh 


select * from t_from_allocation_in_warehouse where allocation_code in (select   djh  from t_ka_splsz where jsmc='金9999' and chf like '梦享会%' and rq='2024-04-03' GROUP BY djh 
)

select gold_weight,total_amount from t_from_allocation_in_warehouse_detail where allocation_identity='18E9D97E-2310-174F-9FD5-5959C55193A1'   





-- -------------------------------------------------------------------------------------------------------------- 
处理ssh登录特别慢的问题 



-- --------------------------------------------------------------------------------------------------------------




-- --------------------------------------------------------------------------------------------------------------
scp同步
scp -r /home/space/music/ root@www.runoob.com:/home/root/others/ 






scp -r /data/program/canal/ hadoop32:/data/program/canal/





-- --------------------------------------------------------------------------------------------------------------
kafka-console-consumer.sh --bootstrap-server hadoop31:9092 --topic sync_sz_decent_cloud

kafka-console-consumer.sh --bootstrap-server hadoop31:9092 --topic sync_jx_decent_cloud



-- --------------------------------------------------------------------------------------------------------------



#! /bin/bash

case $1 in
"start"){
                echo " ============================ ★ 启动 hadoop32 采集flume ============================ "
                nohup /data/program/flume/bin/flume-ng agent --conf-file /data/program/flume/conf/kafka-flume-hdfs-topic-decent_cloud.conf --name a2 -Dflume.root.logger=INFO,LOGFILE >/data/program/flume/kafka-flume-hdfs-topic-decent_cloud.log 2>&1  &
};;
"stop"){
                echo " ============================ ★ 停止 hadoop32 采集flume ============================ "
                ps -ef | grep kafka-flume-hdfs-topic-decent_cloud | grep -v grep |awk  '{print $2}' | xargs kill -9
};;
esac

-- --------------------------------------------------------------------------------------------------------------


-- hIve 复制表机构


CREATE TABLE bigdata17_new like bigdata17_old;

CREATE TABLE sync_sz_decent_cloud.origin_table like origin_data.origin_table;


-- --------------------------------------------------------------------------------------------------------------

-- 查看hadoop 健康状态信息


hdfs dfsadmin -report

-- --------------------------------------------------------------------------------------------------------------

-- 定时任务 ，数据装载脚本

*/5 * * * *  source ~/.bash_profile;/bin/sh /root/origin_data_load.sh



-- --------------------------------------------------------------------------------------------------------------



-- --------------------------------------------------------------------------------------------------------------

进入hive之后的解析饿的sql

select
       translate( translate(get_json_object(data,'$.data'),'[','') ,']','') as data,
       get_json_object(data,'$.ts') as ts,
       get_json_object(data,'$.type') as type,
       dt
    from origin_table where  get_json_object(data,'$.table')='t_ka_splsz' and dt='2024-04-17';



select

* from (
    select
       translate( translate(get_json_object(data,'$.data'),'[','') ,']','') as data,
       get_json_object(data,'$.ts') as ts,
       get_json_object(data,'$.type') as type,
       dt
    from origin_table where  get_json_object(data,'$.table')='t_ka_splsz' and dt='2024-04-17'
           )t where get_json_object(data,'$.djh')='DBRK202404160921';



-- --------------------------------------------------------------------------------------------------------------
-- ai处理工具


https://ai-bot.cn/favorites/ai-image-object-removers/



-- --------------------------------------------------------------------------------------------------------------

kafka 消费flume 内存溢出问题排查
校验程序数据核对









-- --------------------------------------------------------------------------------------------------------------




-- --------------------------------------------------------------------------------------------------------------
-- 离线数仓
-- 数据仓库架构
-- 主题建模
-- 数据治理
-- 数据管理
-- etl 开发经验






-- --------------------------------------------------------------------------------------------------------------





-- --------------------------------------------------------------------------------------------------------------
-- 实时数仓



-- --------------------------------------------------------------------------------------------------------------
-- 梦享会异常数据
-- 北京展厅
DBRK202404020348
								-- select jz,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)  from t_ka_splsz where djh='DBRK202404020348'   and jz in (3.38, 3.89, 4.2, 4.3, 4.66, 5.01, 5.08, 5.59, 5.96, 6.13, 6.13, 6.34) order by jz  
								-- select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EB1015-FEC0-030C-952E-D500ED78CA95'  and gold_weight in (3.38, 3.89, 4.2, 4.3, 4.66, 5.01, 5.08, 5.59, 5.96, 6.13, 6.13, 6.34)  order by gold_weight
								-- 处理方案， 金重一致，工费本应该不一致，调成一致的， 结合sql调整

DBRK202404020362
							--  select jz,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)  from t_ka_splsz where djh='DBRK202404020362'   and jz in (25.32, 25.66, 27.78) order by jz 
							--  select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EB108B-18A0-042C-95F5-18C0E1779CBC'  and gold_weight in (25.32, 25.66, 27.78)  order by gold_weight
							-- 处理方案， 金重一致，工费本应该不一致，调成一致的， 结合sql调整

DBRK202404020365
							 --  select jz,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)  from t_ka_splsz where djh='DBRK202404020365'   and jz in (4.75, 4.78, 5.02, 5.18, 5.18, 5.2, 5.46) order by jz 
							 -- select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EB1015-FE30-0233-9C5E-B03838315CD2'  and gold_weight in (4.75, 4.78, 5.02, 5.18, 5.18, 5.2, 5.46)  order by gold_weight
							 -- 处理方案， 金重一致，工费本应该不一致，调成一致的， 结合sql调整
DBRK202404020367
                --  select  jz  ,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0) from t_ka_splsz where djh='DBRK202404020367'  order by jz
								--  select gold_weight , total_amount   from t_from_allocation_in_warehouse_detail where allocation_identity='18EB108B-1890-0419-BF51-CB028F31B8D4'   order by gold_weight
					      -- 处理方案， 流水和明细工费都不一致， 请调整 应该是jgfje导致的 调拨工费dbgfje需要减去件工费 

DBRK202404020370
								--  select jz,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)  from t_ka_splsz where djh='DBRK202404020370'   and jz in (9.09) order by jz 
								-- select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EB0FA0-C4B0-00D4-B2F0-B53DB64407BE'  and gold_weight in (9.09)  order by gold_weight
								-- 处理方案， 金重一致，工费本应该不一致，调成一致的， 结合sql调整
DBRK202404020372
							--  select jz,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)  from t_ka_splsz where djh='DBRK202404020372'   and jz in (5.66) order by jz 
              --  select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EB1015-FDB0-0152-A871-B76ED5EB25D0'  and gold_weight in (5.66)  order by gold_weight
             	-- 处理方案， 金重一致，工费本应该不一致，调成一致的， 结合sql调整

DBRK202404020373
						--  select  jz  ,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0) from t_ka_splsz where djh='DBRK202404020373'  order by jz
						--  select gold_weight , total_amount   from t_from_allocation_in_warehouse_detail where allocation_identity='18EB0FA0-C4B0-00C9-87B6-0AEE868B0F0E'   order by gold_weight
						-- -- 处理方案， 流水和明细工费都不一致， 请调整 应该是jgfje导致的 调拨工费dbgfje需要减去件工费
DBRK202404020374
							--  select jz,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)  from t_ka_splsz where djh='DBRK202404020374'   and jz in (29.02) order by jz 
              -- select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EB0FA0-C4C0-0119-9396-78138687B343'  and gold_weight in (29.02)  order by gold_weight
              -- 处理方案， 金重一致，工费本应该不一致，调成一致的， 结合sql调整

DBRK202404020379
								--  select  jz  ,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0) from t_ka_splsz where djh='DBRK202404020379'  order by jz
								--  select gold_weight , total_amount   from t_from_allocation_in_warehouse_detail where allocation_identity='18EB0FA0-C4D0-0143-8D1A-9F93D06DEECE'   order by gold_weight
								-- 处理方案， 流水和明细工费都不一致， 请调整 应该是jgfje导致的 调拨工费dbgfje需要减去件工费

DBRK202404020393
							--  select jz,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)  from t_ka_splsz where djh='DBRK202404020393'   and jz in (26.59) order by jz 
							-- select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EB1015-FDF0-01D2-A955-580F4B5E1032'  and gold_weight in (26.59)  order by gold_weight
							 -- 处理方案， 金重一致，工费本应该不一致，调成一致的， 结合sql调整
DBRK202404110606
							--  select jz,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)  from t_ka_splsz where djh='DBRK202404110606'   and jz in (3.02, 4.12, 4.68, 5.06, 5.35, 5.53, 5.59, 5.62, 5.7, 6.07, 6.25, 6.52) order by jz 
							-- select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18ECC69F-9270-06C3-B17A-DF8EFFE874AD'  and gold_weight in (3.02, 4.12, 4.68, 5.06, 5.35, 5.53, 5.59, 5.62, 5.7, 6.07, 6.25, 6.52)  order by gold_weight
							 -- 处理方案， 金重一致，工费本应该不一致，调成一致的， 结合sql调整

DBRK202404110608
							-- select jz,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)  from t_ka_splsz where djh='DBRK202404110608'   and jz in (2.93, 2.95, 2.97, 2.99, 4.12, 4.13, 4.14, 4.15, 5.08, 5.12, 5.15, 5.81, 5.81, 6.05, 6.08, 6.1, 6.13, 6.14, 6.17, 6.42, 6.44, 6.48, 6.6, 6.62, 6.75, 7.66, 7.74, 7.75) order by jz 
							-- select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18ECC69F-9280-07B0-B948-CD4E791B376F'  and gold_weight in (2.93, 2.95, 2.97, 2.99, 4.12, 4.13, 4.14, 4.15, 5.08, 5.12, 5.15, 5.81, 5.81, 6.05, 6.08, 6.1, 6.13, 6.14, 6.17, 6.42, 6.44, 6.48, 6.6, 6.62, 6.75, 7.66, 7.74, 7.75)  order by gold_weight
							 -- 处理方案， 部分还有件工费导致不一致，另外一部分是金重一致，工费调成一致的 了，应该是不一致的 ，结合 sql处理
DBRK202404110609
							--  select  jz  ,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0) from t_ka_splsz where djh='DBRK202404110609'  order by jz
						  --  select gold_weight , total_amount   from t_from_allocation_in_warehouse_detail where allocation_identity='18ECC69F-9280-07F2-AF63-9C732B28469A'   order by gold_weight
						  -- 处理方案， 流水和明细工费都不一致， 请调整 应该是jgfje导致的 调拨工费dbgfje需要减去件工费

DBRK202404110610
							--  select jz,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)  from t_ka_splsz where djh='DBRK202404110610'   and jz in (5.38) order by jz 
						  -- select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18ECC69F-9280-082B-8B10-136C3E280EAE'  and gold_weight in (5.38)  order by gold_weight
						   -- 处理方案， 金重一致，工费本应该不一致，调成一致的， 结合sql调整
DBRK202404110611
							--  select  jz  ,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0) from t_ka_splsz where djh='DBRK202404110611'  order by jz
						  --  select gold_weight , total_amount   from t_from_allocation_in_warehouse_detail where allocation_identity='18ECC69F-9290-08A1-A98F-4AA17A92D437'   order by gold_weight
						  -- 处理方案， 流水和明细工费都不一致请修改流水工费
-- 海南展厅

DBRK202404181409
								--  select jz,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0) from t_ka_splsz where djh='DBRK202404181409' order by jz
								--  select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EF1F70-1B10-002D-B474-AEC1488D2044'   order by gold_weight
								--  处理方案  流水里面有反审核的单子，反审核的单据，金重是负值，工费没设置成负值，还是正值，导致流水和工费的差异


DBRK202404191508 
								--  select  jz  ,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0) from t_ka_splsz where djh='DBRK202404191508'  order by jz
								--  select gold_weight , total_amount   from t_from_allocation_in_warehouse_detail where allocation_identity='18EF2269-E7F0-0088-8154-1A508D1A64D2'   order by gold_weight

								-- 处理问题（共涉及2个问题） 1、部分流水里面有反审核的单子，反审核的单据，金重是负值，工费没设置成负值，还是正值，导致流水和工费的差异
												-- 2、 存在重复流水，需要删除重复的流水

-- 江西展厅 
DBRK202404080467 
								 --  select * from t_ka_splsz where djh='DBRK202404080467'  and jz=6.43 order by jz  
								 --  处理方案  这个工费需要 dbgfje 减去 21 
DBRK202404080476 
								 --  select * from t_ka_splsz where djh='DBRK202404080476'  and jz=5.34 order by jz  
								 --  select * from t_from_allocation_in_warehouse_detail where allocation_identity='18EBCAD9-DD80-019F-B803-A13C62997CB1' and gold_weight=5.34  order by gold_weight    
								 --  处理方案 明细里面是69.42 流水里面是 85.44
DBRK202404090493
								--  select * from t_ka_splsz where djh='DBRK202404090493'  and jz in (4.15,4.65,6.21) order by jz 
                --  select * from t_from_allocation_in_warehouse_detail where allocation_identity='18EC0F10-1970-004D-A03F-2472C9CE6E88'  and gold_weight in (4.15,4.65,6.21)  order by gold_weight
                --  处理方案 
                					-- 金重4.15 ，下面一条dbgfje 不对，4.15有2笔流水,(33.20,74.7) 
                          --  4.65  有件工费 39 dbgfje需要减 件工费
                          --  6.21  有件工费 21 dbgfje需要减 件工费-
DBRK202404090506
								--  select * from t_ka_splsz where djh='DBRK202404090506'  and jz in (6.29) order by jz 
								--  select * from t_from_allocation_in_warehouse_detail where allocation_identity='18EC127E-CAE0-009B-A6D8-F87AB1FB0516'  and gold_weight in (6.29)  order by gold_weight
								--  处理方案  金重6.29 有件工费 21 dbgfje需要减 件工费
DBRK202404140749
								--   select jz,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0) from t_ka_splsz where djh='DBRK202404140749' order by jz
							  --  select * from t_from_allocation_in_warehouse_detail where allocation_identity='18EDBD21-8400-007D-A1C6-007F9CFFAE02'   order by gold_weight
							  -- 处理方案 流水里面没有记录工费，目前流水里面工费是0

								  


-- 南京展厅

DBRK202404020340
								 --  select * from t_ka_splsz where djh='DBRK202404020340'     and jz=3.04 order by jz 
								 -- select * from t_from_allocation_in_warehouse_detail where allocation_identity='18EB62F0-B930-01F7-903E-6ED2BEC510E0'  and gold_weight in (3.04)  order by gold_weight
								  -- 处理方案 流水里面的金重3.04一样，手动处理数据把工费调整成相同的，实际上应该是不一样的， 详细数据见sql,请调整其中一笔流水的工费
DBRK202404080481
								--  select jz,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)  from t_ka_splsz where djh='DBRK202404080481'      and jz in (3.09, 4.11, 4.12, 4.91, 5.46, 5.48, 5.53, 5.58, 5.58, 5.81, 5.86, 6.48, 6.61, 6.82, 6.85, 6.88, 7.46, 8.27, 8.27) order by jz 
								-- select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EBD90B-4BC0-016D-BB3D-FE8DA8840322'  and gold_weight in (3.09, 4.11, 4.12, 4.91, 5.46, 5.48, 5.53, 5.58, 5.58, 5.81, 5.86, 6.48, 6.61, 6.82, 6.85, 6.88, 7.46, 8.27, 8.27)  order by gold_weight

								-- 处理方案 金重一致，工费不一致，流水里面手动调成一致的了，请结合sql处理 

DBRK202404080485 

							--  select jz,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0) from t_ka_splsz where djh='DBRK202404080485' order by jz
							--  select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EBD90B-4B60-0000-9141-C3FE9892283D'   order by gold_weight 
							--  处理方案 工费基本都不一致，请结合sql重新处理流水工费数据

-- --------------------------------------------------------------------------------------------------------------

select   djh,SUM(jz) jz ,sum(ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)) from t_ka_splsz where  chf like '梦享会%' and rq>='2024-03-20'  GROUP BY djh  order by djh 


select allocation_code,total_gold_weight,total_amount from t_from_allocation_in_warehouse where allocation_code in (
select   djh  from t_ka_splsz where  chf like '梦享会%' and rq>='2024-03-20'  GROUP BY djh  order by djh 

)and approve_status=1  order by allocation_code
 

select   djh,SUM(jz) jz ,sum(ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)) from t_ka_splsz where  chf like '梦享会%' and rq>='2024-04-01'  GROUP BY djh  order by djh 


select allocation_code,total_gold_weight,total_amount from t_from_allocation_in_warehouse where allocation_code in (
select   djh  from t_ka_splsz where  chf like '梦享会%' and rq>='2024-04-01'  GROUP BY djh  order by djh 

)and approve_status=1  order by allocation_code
 
-- --------------------------------------------------------------------------------------------------------------
select   djh,SUM(jz) jz ,sum(ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)) from t_ka_splsz where  chf like '梦享会%' and rq>='2024-04-01'  GROUP BY djh  order by djh 


select allocation_code,total_gold_weight,total_amount from t_from_allocation_in_warehouse where allocation_code in (
select   djh  from t_ka_splsz where  chf like '梦享会%' and rq>='2024-04-01'  GROUP BY djh  order by djh 

)and approve_status=1  order by allocation_code
 
 
 
 select * from t_ka_splsz where djh='DBRK202404110609'   and jz in (2.93, 2.95, 2.97, 2.99, 4.12, 4.13, 4.14, 4.15, 5.08, 5.12, 5.15, 5.81, 5.81, 6.05, 6.08, 6.1, 6.13, 6.14, 6.17, 6.42, 6.44, 6.48, 6.6, 6.62, 6.75, 7.66, 7.74, 7.75) order by jz 
 
 select  jz  ,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0) from t_ka_splsz where djh='DBRK202404110611'  order by jz
 
  select  jz  ,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0) from t_ka_splsz where djh='DBRK202404110611'  order by jz

 
 select jz,ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)  from t_ka_splsz where djh='DBRK202404110611'   and jz in (5.38) order by jz 
select * from t_from_allocation_in_warehouse where allocation_code='DBRK202404110611' 
 select gold_weight , total_amount   from t_from_allocation_in_warehouse_detail where allocation_identity='18ECC69F-9290-08A1-A98F-4AA17A92D437'   order by gold_weight
select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18ECC69F-9280-082B-8B10-136C3E280EAE'  and gold_weight in (5.38)  order by gold_weight
-- --------------------------------------------------------------------------------------------------------------





-- --------------------------------------------------------------------------------------------------------------
TYDJDBC202404160002 --  调拨出库单 TYDBC202404160099  rq=2024-04-16   
TYDJDBC202404160003 --  调拨出库单 TYDBC202404200005  rq=2024-04-19
TYDJDBC202404180052 --  调拨出库单 TYDBC202404200076  rq=2024-04-19
YYDJDBC202404190005 --  调拨出库单 TYDBC202404200075  rq=2024-04-19




-- --------------------------------------------------------------------------------------------------------------


 -- DBRK202404160868
 select * from t_ka_splsz where djh='DBRK202404160868' and  jz in (5.510, 5.880, 6.110, 6.850, 7.310, 8.260)  order by jz
 select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EE6311-82D0-28AA-AE15-729BEC21F67B'   and gold_weight in (5.510, 5.880, 6.110, 6.850, 7.310, 8.260)  order by gold_weight
 
 -- DBRK202404170990
  select * from t_ka_splsz where djh='DBRK202404170990' and  jz in (6.230)  order by jz
 select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EEAC14-D3F0-345D-9730-75401FB0D0EF'   and gold_weight in (6.230)  order by gold_weight
 
 
 -- DBRK202404171068
  select * from t_ka_splsz where djh='DBRK202404171068' and  jz in (6.75)  order by jz
 select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EEB577-3AF0-4AE4-B331-4BAE1EC3F4EC'   and gold_weight in (6.75)  order by gold_weight
 
 
 -- DBRK202404171112
  select * from t_ka_splsz where djh='DBRK202404171112' and  jz in (5.53)  order by jz
 select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EEBED9-9640-51D4-8857-3DC10C67821B'   and gold_weight in (5.53)  order by gold_weight
 
 
 
  -- DBRK202404171112
  select * from t_ka_splsz where djh='DBRK202404181246' and  jz in (5.26,5.55)  order by jz
 select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EF0089-F3C0-5EC3-9535-82A5435F5F1D'   and gold_weight in (5.26,5.55)  order by gold_weight
 
  -- DBRK202404181262
  select * from t_ka_splsz where djh='DBRK202404181262' and  jz in (7.28)  order by jz
 select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EF0089-F3D0-5EEC-BC1A-AA45CF5CB3BC'   and gold_weight in (7.28)  order by gold_weight
 
   -- DBRK202404181318
  select * from t_ka_splsz where djh='DBRK202404181318' and  jz in (4.85)  order by jz
 select gold_weight,total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity='18EF08C7-55D0-7920-989C-C3A99B0D026E'   and gold_weight in (4.85)  order by gold_weight

-- --------------------------------------------------------------------------------------------------------------




15 0 * * * source ~/.bash_profile;/bin/sh /root/origin_data_load.sh








-- --------------------------------------------------------------------------------------------------------------

-- 北京展厅梦享会数据

-- DBRK202404110609
select  * from t_ka_splsz where djh='DBRK202404110609' and jz in (5.38,
5.88,
6.13
) order by jz 


select  gold_weight , total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity in (
select allocation_identity from t_from_allocation_in_warehouse where allocation_code='DBRK202404110609' and approve_status=1 and status=0
)   and gold_weight in (5.38,
5.88,
6.13
)  order by gold_weight



-- DBRK202404110608
select  * from t_ka_splsz where djh='DBRK202404110608' and jz in ( 
6.1,
6.42
) order by jz 


select  gold_weight , total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity in (
select allocation_identity from t_from_allocation_in_warehouse where allocation_code='DBRK202404110608' and approve_status=1 and status=0
)   and gold_weight in (6.1,
6.42
)  order by gold_weight




-- DBRK202404020365
select  * from t_ka_splsz where djh='DBRK202404020365' and jz in ( 
5.18
) order by jz 


select  gold_weight , total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity in (
select allocation_identity from t_from_allocation_in_warehouse where allocation_code='DBRK202404020365' and approve_status=1 and status=0
)   and gold_weight in (5.18
)  order by gold_weight






 -- DBRK202404020348
select  * from t_ka_splsz where djh='DBRK202404020348' and jz in ( 
5.01
) order by jz 


select  gold_weight , total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity in (
select allocation_identity from t_from_allocation_in_warehouse where allocation_code='DBRK202404020348' and approve_status=1 and status=0
)   and gold_weight in (5.01
)  order by gold_weight








-- --------------------------------------------------------------------------------------------------------------
select jz, ifnull(jcgfje,0)+ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0)  from t_ka_splsz where djh='DBRK202404020348' order by jz 

select  gold_weight , total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity in (
select allocation_identity from t_from_allocation_in_warehouse where allocation_code='DBRK202404020348' and approve_status=1 and status=0
)  order by gold_weight

 
 -- DBRK202404020348
select  * from t_ka_splsz where djh='DBRK202404020348' and jz in ( 
5.01
) order by jz 


select  gold_weight , total_amount  from t_from_allocation_in_warehouse_detail where allocation_identity in (
select allocation_identity from t_from_allocation_in_warehouse where allocation_code='DBRK202404020348' and approve_status=1 and status=0
)   and gold_weight in (5.01
)  order by gold_weight



-- --------------------------------------------------------------------------------------------------------------

yarn rmadmin -getServiceState rm1


netstat -antp | grep 2181  

















-- --------------------------------------------------------------------------------------------------------------

mysql 原理


客户端
			连接器
					 分析器：管理连接，权限验证
					 			 优化器：执行计划生成，索引选择
					 			 				执行器： 操作引擎，返回结果
					 			 							存储引擎：存储数据，提供读写接口
					 查询缓存：命中则直接返回结果

MyISAM存储引擎：
 作为mysql5.5以及之前的默认引擎，它具有以下特点：
（1）不支持事务；
（2）不支持外键，如果强行增加外键，不会提示错误，只是外键不其作用；
（3）对数据的查询缓存只会缓存索引，不会像InnoDB一样缓存数据，而且是利用操作系统本身的缓存；
（4）默认的锁粒度为表级锁，所以并发度很差，加锁快，锁冲突较少，所以不太容易发生死锁；
（5）支持全文索引（MySQL5.6之后，InnoDB存储引擎也对全文索引做了支持），但是MySQL的全文索引基本不会使用，对于全文索引，现在有其他成熟的解决方案，比如：ElasticSearch，Solr，Sphinx等。
（6）数据库所在主机如果宕机，MyISAM的数据文件容易损坏，而且难恢复；


InnoDB存储引擎
随着软件行业的不断发展，尤其是互联网行业的兴起，以前的存储引擎完全无法满足业务需求，所以Mysql在5.5版本后就以此存储引擎作为默认。InnoDB作为一款经典的存储引擎，它能够适应绝大多数企业的用途。
主要特点有：
（1）灾难恢复性比较好；
（2）支持事务。默认的事务隔离级别为可重复度，通过MVCC（并发版本控制）来实现的。
（3）使用的锁粒度为行级锁，可以支持更高的并发；
（4）支持外键；
（5）配合一些热备工具可以支持在线热备份；
（6）在InnoDB中存在着缓冲管理，通过缓冲池，将索引和数据全部缓存起来，加快查询的速度；
（7）对于InnoDB类型的表，其数据的物理组织形式是聚簇表。所有的数据按照主键来组织。数据和索引放在一块，都位于B+数的叶子节点上


索引应该是帮助MySQL高效获取数据的排好序的数据结构。

没错，索引就是一种数据结构，包括：

二叉树，一种子节点最多为两个的树形数据结构。
红黑树，一种从根节点到任意尾节点的路径之差不超过1的平衡二叉树
哈希表，一种通过哈希算法直接存储内存地址的数组
B树，一种在节点存储多条索引元素以及附带数据的树形结构
B+树，B树的变种，冗余存储了索引元素，在叶子节点存储了所有索引元素和附带数据，且含有双向指针
那么，索引到底是保存的什么呢？

一个完整的索引数据通常包含两部分：排序的值和对应的数据




聚族索引既然冗余了这么多数据，那么进行增删改操作岂不是不好维护？
得确，聚族索引在维护时需要进行额外的操作。但通常来说，一个表的数据查询的次数是要远远高于修改的次数，综合考虑，维护成本带来的收益还是相当可观的。
为什么InnoDB引擎推荐每个表都需要有主键，并且最好时整型的自增主键？如果不建主键怎么样？
首先，InnoDB并不强制需要用户建立主键，但它得确是必须存在主键的，当你没创建主键时，mysql会选择表中唯一的字段作为主键；若当你没有唯一字段时，mysql会根据你的插入顺序（俗称行数）来作为主键。
因为索引是根据索引字段来排序插入的，作为一颗B+树来维护（关于B+树的维护可以参见【链接】），既然排序，肯定整型自增的类型是天然排序的；如果不是整型，比如字符型，那么mysql就会根据字符编码和排序规则来排序，对比整型可以直接排序相当于是多了一个步骤。
主键索引是必须的吗？
主键索引是必须的，它是跟主键相与相存的，并且一般由mysql自动创建。
聚族索引相比非聚族索引谁快，为什么？
聚族索引要更快，因为聚族索引可以直接在一个磁盘文件中寻找到索引数据，而非聚族索引需要跨文件寻找完整数据（俗称“回表”）。
在建立索引时我们还可以选择hash索引，为什么一般很少用，它有使用场景吗？
hash索引数据结果类似于Java的HashMap，也会存在哈希碰撞。查询效率通常来说比B+树更高，但是只适合查找“=”，范围类查找无法使用该类型索引。如果一张表的需求只会有等值查询可以考虑哈希索引（这种需求应该很少吧）。
为什么InnoDB的非主键索引不用聚族索引而保存的是主键索引地址？
首先是节约存储空间；而更重要的是平衡维护的成本，如果所有索引都是聚族索引，每次的修改增加操作都会维护所有索引，这会涉及到数据的一致性问题（有的索引维护成功有的失败。。。）。
知道联合索引吗，它又有什么不同？
其实一般来说不推荐针对一个字段建立单值索引，更推荐建立联合索引。
联合索引同样是B+树来存储，会按照索引字段顺序依次排序放入。
B+树类索引是否支持范围查找，原理如何？
B+树支持范围查找，原理见下图，我相信你会一目了然。。。
为什么需要索引？
通常来说在没有缓存和索引的情况下，Mysql查找任何数据都是读取磁盘文件进行IO操作，并进行逐行扫描，直到查找到目标数据。在数据量很大或关联查询较复杂的情况下会极大的影响查询效率。
而索引作为一种有序并且查询效率极高的数据结构，可以快速的查找目标数据。



id列：该列为select语句执行的顺序，其中1为最先，null为最后。（主要针对包含子查询）。

select_type列：表示对应行是简单还是复杂的查询。

table列：表示该查询正在访问哪个表

type列（重点关注）：该查询的大概查询范围

	NULL：mysql能够在优化阶段分解查询语句，在执行阶段用不着再访问表或索引。

	const&system：mysql能对查询的某部分进行优化并将其转化成一个常量（可以看show warnings 的结果）。用于 primary key 或 unique key 的所有列与常数比较时，所以表最多有一个匹配行，读取1次，速度比较快。system是 const的特例，表里只有一条元组匹配时为system。

	eq_ref：primary key 或 unique key 索引的所有部分被连接使用 ，最多只会返回一条符合条件的记录。这可能是在 const 之外最好的联接类型了，简单的 select 查询不会出现这种 type。

	ref：相比 eq_ref，不使用唯一索引，而是使用普通索引或者唯一性索引的部分前缀，索引要和某个值相比较，可能会 找到多个符合条件的行。

	range：范围扫描通常出现在 in(), between ,> ,<, >= 等操作中。使用一个索引来检索给定范围的行。

	index：扫描全索引就能拿到结果，一般是扫描某个二级索引，这种扫描不会从索引树根节点开始快速查找，而是直接 对二级索引的叶子节点遍历和扫描，速度还是比较慢的，这种查询一般为使用覆盖索引，二级索引一般比较小，所以这 种通常比ALL快一些。

	ALL：即全表扫描，扫描你的聚簇索引的所有叶子节点。通常情况下这需要增加索引来进行优化了。


Mysql的日志系统
日志是mysql很重要的组成部分，它记录着mysql运行的各种信息，主要包括错误日志、查询日志、慢查询日志、事务日志、二进制日志几大类。
我们主要掌握二进制日志和事务日志就行了，这两种也是最重要的。

binlog日志
事务日志其实就是mysql自带的binlog日志，属于server层的。
它记录着所以的sql语句（除了查询）
理论上，只要磁盘够大，它可以一直写下去。

redolog日志
事务日志包括两个，分别是redolog和undolog
undolog日志
事务为什么重要？
什么是ACID？
原子性：一个操作不可分割（通常只业务上的一个操作，可能会涉及到多个sql操作）
一致性：事务开始和结束，对于数据来说结果是一致的（从数据层面的原子性）。
隔离性：当前事务不会受到其他事务的影响。
持久性：事务一旦提交，对数据的改变是永久的，即使出现宕机也能恢复。


高并发场景事务带来的问题
脏写：一个事务的操作覆盖了第二个事务的结果。
如：事务A对字段a查询结果为1，然后进行了业务逻辑操作，使a=0，最后将a=0更新到数据库了。但是在更新之前，可能出现事务B已经将a更新成了2，这样就影响了其他事务的更新。
脏读：一个事务查询到了其他事务未提交的数据。
幻读：一个事务对同一批数据进行了多次查询，发现数据有新增（强调数据的新增）


事务隔离界别	脏读	 		不可重复读		幻读
读未提交			可能	 		可能					可能
读已提交			不可能		可能       	可能
可重复读			不可能		不可能				可能
串行化				不可能		不可能				不可能


mysql默认隔离界别为可重复读，已经能满足绝大多数使用场景。




-- --------------------------------------------------------------------------------------------------------------
-- 23号库存日报表，千足金工费与单据总额不一致

select * from t_ka_splsz where (chf like '福州工厂%' or chf like '精工一部%' or chf like '精工二部%' or chf like '福州镶嵌工厂%' or chf like '福州K金工厂%') and rq='2024-04-23' and jsmc='千足金'
and wdmc='特艺城展厅'


select * from t_from_allocation_in_warehouse_detail where  allocation_identity in (

select allocation_identity from t_from_allocation_in_warehouse where allocation_code in (
'DBKXD202404230001',
'DBKXD202404230003',
'DBKXD202404230002'
))


select * from t_receive_detail where receive_identity in (
select  receive_identity  from t_receive where receive_code in (
'SJRK202404230012',
'SJRK202404230027'
))




select  * from t_ka_splsz where rq >='2024-04-23' and      ROUND(JCGFJE)=ROUND(FJGFJE) and JCGFJE>0 and swlx<>'客户退饰'














com.zfq.fo.flink.DataGetSocket



./bin/flink run-application -yqu hive -t  yarn-application -Dyarn.provided.lib.dirs="hdfs://mycluster/flink-dist" -c com.zfq.fo.flink.DataGetSocket  hdfs://mycluster/flink-dist/realtime-flink-1.0-SNAPSHOT.jar -host hadoop31 -port 8989

-- --------------------------------------------------------------------------------------------------------------
/flink-dist/realtime-flink-1.0-SNAPSHOT.jar


yarn-daemon.sh start nodemanager


#!/bin/bash
ps -ef |grep NodeManager|grep -v grep|awk -F " " '{print$2}'
if [ $? -ne 0 ]
then
echo "NodeManager进程在运行中....."
else 
/data/program/hadoop-2.7.2/sbin/yarn-daemon.sh start nodemanager
fi


-- 僵尸进程
ps -A -ostat,ppid,pid,cmd | grep -e '^[Zz]'  -- 找出父id 杀掉



mr-->DAG框架（tez）--->Spark流批处理框架，内存计算（伪实时）-->flink流批处理，内存计算（真正的实时计算）




-- --------------------------------------------------------------------------------------------------------------





select  djh,SUM(jz) as jz,ROUND(SUM(ifnull(jcgfje,0) + ifnull(FJGFJE,0)+IFNULL(jgfje,0)+IFNULL(dbgfje,0) ))   as je from t_ka_splsz where djm='调拨入库单' and rq>='2024-04-20' and jsmc<>'千足镶嵌' GROUP BY djh

order by djh ;

select allocation_code,total_gold_weight,total_amount from t_from_allocation_in_warehouse where  approve_status=1 and `status`=0  and allocation_code in (
select  djh  from t_ka_splsz where djm='调拨入库单' and rq>='2024-04-20' and jsmc<>'千足镶嵌' GROUP BY djh

order by djh ) order by allocation_code ;























-- --------------------------------------------------------------------------------------------------------------



























-- --------------------------------------------------------------------------------------------------------------



























-- --------------------------------------------------------------------------------------------------------------


























-- --------------------------------------------------------------------------------------------------------------




























-- --------------------------------------------------------------------------------------------------------------
















-- --------------------------------------------------------------------------------------------------------------



























-- --------------------------------------------------------------------------------------------------------------





















-- --------------------------------------------------------------------------------------------------------------


























-- --------------------------------------------------------------------------------------------------------------






























-- --------------------------------------------------------------------------------------------------------------



























-- --------------------------------------------------------------------------------------------------------------







































-- --------------------------------------------------------------------------------------------------------------


































-- --------------------------------------------------------------------------------------------------------------
































-- --------------------------------------------------------------------------------------------------------------










































-- --------------------------------------------------------------------------------------------------------------






































-- --------------------------------------------------------------------------------------------------------------

































-- --------------------------------------------------------------------------------------------------------------































-- --------------------------------------------------------------------------------------------------------------


























-- --------------------------------------------------------------------------------------------------------------


















-- --------------------------------------------------------------------------------------------------------------





















-- --------------------------------------------------------------------------------------------------------------








































-- --------------------------------------------------------------------------------------------------------------


























-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------