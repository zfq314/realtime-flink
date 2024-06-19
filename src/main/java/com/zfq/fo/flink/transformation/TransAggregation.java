package com.zfq.fo.flink.transformation;

import com.zfq.fo.flink.pojo.WaterSensor;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.datastream.SingleOutputStreamOperator;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

/**
 * @ClassName TransAggregation
 * @Description TODO
 * @Author ZFQ
 * @Date 2024/6/19 下午 02:17
 * @Version 1.0
 */
public class TransAggregation {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        env.setParallelism(1);

        DataStreamSource<WaterSensor> waterSensorDataStreamSource = env.fromElements(
                new WaterSensor("sensor_1", 1000L, 10),
                new WaterSensor("sensor_2", 3000L, 30),
                new WaterSensor("sensor_1", 4000L, 40),
                new WaterSensor("sensor_1", 2000L, 20)
        );

        // 一个聚合算子，会为每一个key保存一个聚合的值，在Flink中我们把它叫作“状态”（state）
        SingleOutputStreamOperator<WaterSensor> vc = waterSensorDataStreamSource.keyBy(data -> data.id).max("vc");
        vc.print();
        // 输出  聚合算子是有状态的
        //WaterSensor [id=sensor_1, ts=1000, vc=10]
        //WaterSensor [id=sensor_2, ts=3000, vc=30]
        //WaterSensor [id=sensor_1, ts=1000, vc=40]
        //WaterSensor [id=sensor_1, ts=1000, vc=40]
        env.execute();
    }
}