package com.zfq.fo.flink.transformation;

import com.zfq.fo.flink.pojo.WaterSensor;
import org.apache.flink.api.common.functions.FilterFunction;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

/**
 * @ClassName TransFilter
 * @Description TODO
 * @Author ZFQ
 * @Date 2024/6/3 下午 04:50
 * @Version 1.0
 */
public class TransFilter {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment executionEnvironment = StreamExecutionEnvironment.getExecutionEnvironment();

        DataStreamSource<WaterSensor> waterSensorDataStreamSource = executionEnvironment.fromElements(
                new WaterSensor("sensor_1", 1L, 20),
                new WaterSensor("sensor_2", 11L, 30),
                new WaterSensor("sensor_1", 21L, 40)
        );
        //    1.实现FilterFunction，匿名类，保留的为true,删除的为false
        waterSensorDataStreamSource.filter(new FilterFunction<WaterSensor>() {
            @Override
            public boolean filter(WaterSensor value) throws Exception {
                return value.id.equals("sensor_1");
            }
        }).print();

        waterSensorDataStreamSource.filter(new MyFilterFunction()).print();
        executionEnvironment.execute();
    }

    private static class MyFilterFunction implements FilterFunction<WaterSensor> {
        @Override
        public boolean filter(WaterSensor value) throws Exception {
            return value.id.equals("sensor_2");
        }
    }
}