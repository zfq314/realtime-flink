package com.zfq.fo.flink.source;

import org.apache.flink.api.common.eventtime.WatermarkStrategy;
import org.apache.flink.api.common.serialization.SimpleStringSchema;
import org.apache.flink.connector.kafka.source.KafkaSource;
import org.apache.flink.connector.kafka.source.enumerator.initializer.OffsetsInitializer;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

/**
 * @ClassName SourceFromKafka
 * @Description TODO 从kafka中读取数据
 * @Author ZFQ
 * @Date 2024/5/5 下午 02:59
 * @Version 1.0
 */
public class SourceFromKafka {
    public static void main(String[] args) throws Exception {
        //需要新增pom依赖
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        //设置并行度
        env.setParallelism(4);

        // 从kafka中读取数据
        KafkaSource<String> kafkaSource = KafkaSource.<String>builder()
                // kafka集群地址
                .setBootstrapServers("hadoop31:9092")
                // 订阅主题
                .setTopics("sync_jx_decent_cloud")
                // 消费组
                .setGroupId("origin_table")
                // 从最新位置开始消费
                .setStartingOffsets(OffsetsInitializer.latest())
                // 设置反序列化器
                .setValueOnlyDeserializer(new SimpleStringSchema())
                // 构建kafkaSource
                .build();
        // 从kafka中读取数据
        DataStreamSource<String> kafka_source = env.fromSource(kafkaSource, WatermarkStrategy.noWatermarks(), "kafka source");
        kafka_source.print("kafka");
        env.execute();

    }
}
