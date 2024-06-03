package com.zfq.fo.flink.transformation;

import com.zfq.fo.flink.pojo.WaterSensor;
import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.datastream.SingleOutputStreamOperator;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

/**
 * @ClassName TransMap
 * @Description TODO
 * @Author ZFQ
 * @Date 2024/6/3 下午 04:21
 * @Version 1.0
 */
public class TransMap {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment executionEnvironment = StreamExecutionEnvironment.getExecutionEnvironment();

        DataStreamSource<WaterSensor> waterSensorDataStreamSource = executionEnvironment.fromElements(
                new WaterSensor("sensor_1", 1L, 1),
                new WaterSensor("sensor_2", 2L, 2)
        );
        //匿名函数
        SingleOutputStreamOperator<String> mapTransValue = waterSensorDataStreamSource.map(new MapFunction<WaterSensor, String>() {
            @Override
            public String map(WaterSensor value) throws Exception {
                return value.id;
            }
        });
        mapTransValue.print();
        // 内部类
        waterSensorDataStreamSource.map(new MyMapFunction()).print();

        executionEnvironment.execute();
    }
    //指定输入和输出类型
    private static class MyMapFunction implements MapFunction<WaterSensor,String> {
        @Override
        public String map(WaterSensor value) throws Exception {
            return "inner class:"+value.id;
        }
    }
}