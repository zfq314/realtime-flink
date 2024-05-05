package com.zfq.fo.flink.source;

import org.apache.flink.api.common.eventtime.WatermarkStrategy;
import org.apache.flink.api.common.typeinfo.Types;
import org.apache.flink.api.connector.source.util.ratelimit.RateLimiterStrategy;
import org.apache.flink.connector.datagen.source.DataGeneratorSource;
import org.apache.flink.connector.datagen.source.GeneratorFunction;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

/**
 * @ClassName SourceDataGenerator
 * @Description TODO 从数据生成器读取数据
 * @Author ZFQ
 * @Date 2024/5/5 下午 04:27
 * @Version 1.0
 */
public class SourceDataGenerator {
    public static void main(String[] args) throws Exception {
        // 1. 创建执行环境
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        env.setParallelism(4);

        DataGeneratorSource<String> source = new DataGeneratorSource<>(
                new GeneratorFunction<Long, String>() {
                    @Override
                    public String map(Long value) throws Exception {
                        return "Number:" + value;
                    }
                },
                // 生成Long类型的数据
                Long.MAX_VALUE,
                // 每秒生成10个数据
                RateLimiterStrategy.perSecond(10),
                // 指定数据类型
                Types.STRING
        );
        env.fromSource(source, WatermarkStrategy.noWatermarks(), "data-generator").print();
        env.execute();
    }
}