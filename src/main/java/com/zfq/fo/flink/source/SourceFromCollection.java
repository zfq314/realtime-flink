package com.zfq.fo.flink.source;

import com.zfq.fo.flink.pojo.WaterSensor;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

import java.util.Arrays;
import java.util.List;

/**
 * @ClassName SourceFromCollection
 * @Description TODO 从集合中读取数据
 * @Author ZFQ
 * @Date 2024/4/29 下午 02:19
 * @Version 1.0
 */
public class SourceFromCollection {
    public static void main(String[] args) throws Exception
    {
        // 1. 创建执行环境
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        env.setParallelism(1);

        // 2. 从集合中读取数据
        List<WaterSensor> waterSensorList = Arrays.asList(
                new WaterSensor("ws_001", 1577844001L, 45),
                new WaterSensor("ws_002", 1577844002L, 43),
                new WaterSensor("ws_003", 1577844003L, 32)
        );
        env.fromCollection(waterSensorList)
                .print();
        env.execute();
    }
}