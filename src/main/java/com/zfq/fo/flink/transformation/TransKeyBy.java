package com.zfq.fo.flink.transformation;

import com.zfq.fo.flink.pojo.WaterSensor;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.datastream.KeyedStream;
import org.apache.flink.streaming.api.datastream.SingleOutputStreamOperator;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

/**
 * @ClassName TransKeyBy
 * @Description TODO
 * @Author ZFQ
 * @Date 2024/6/5 下午 03:45
 * @Version 1.0
 */
public class TransKeyBy {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment environment = StreamExecutionEnvironment.getExecutionEnvironment();

        DataStreamSource<WaterSensor> waterSensorDataStreamSource = environment.fromElements(
                new WaterSensor("sensor_1", 1590732872000L, 20),
                new WaterSensor("sensor_1", 1590732890000L, 50),
                new WaterSensor("sensor_2", 1590732892000L, 10),
                new WaterSensor("sensor_3", 1590732896000L, 10)

        );
        //流的类型变了，由原来的WaterSensor变为了KeyedStream
        KeyedStream<WaterSensor, String> waterSensorStringKeyedStream = waterSensorDataStreamSource.keyBy(data -> data.getId());
        SingleOutputStreamOperator<WaterSensor> vc = waterSensorStringKeyedStream.sum("vc");
        vc.print();

        environment.execute();

    }
}