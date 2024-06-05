package com.zfq.fo.flink.transformation;

import com.zfq.fo.flink.pojo.WaterSensor;
import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.datastream.SingleOutputStreamOperator;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.util.Collector;

/**
 * @ClassName TransFlatMap
 * @Description TODO
 * @Author ZFQ
 * @Date 2024/6/3 下午 05:58
 * @Version 1.0
 */
public class TransFlatMap {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        DataStreamSource<WaterSensor> waterSensorDataStreamSource = env.fromElements(

                new WaterSensor("sensor_1", 1L, 1),
                new WaterSensor("sensor_1", 2L, 2),
                new WaterSensor("sensor_2", 2L, 2),
                new WaterSensor("sensor_3", 3L, 3)
        );
        SingleOutputStreamOperator<String> stringSingleOutputStreamOperator = waterSensorDataStreamSource.flatMap(new MyFlatMapFunction());
        stringSingleOutputStreamOperator.print();

        env.execute();

    }

    private static class MyFlatMapFunction implements FlatMapFunction<WaterSensor, String> {
        @Override
        public void flatMap(WaterSensor value, Collector<String> out) throws Exception {
            if (value.getId().equals("sensor_1")) {
                out.collect(value.getId());
            }else if (value.getId().equals("sensor_2")){
                out.collect(String.valueOf(value.getVc()));
                out.collect(String.valueOf(value.getTs()));
            }
        }
    }
}