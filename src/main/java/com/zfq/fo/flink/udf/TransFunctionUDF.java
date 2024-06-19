package com.zfq.fo.flink.udf;

import com.zfq.fo.flink.pojo.WaterSensor;
import com.zfq.fo.flink.transformation.TransFilter;
import org.apache.flink.api.common.functions.FilterFunction;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.datastream.SingleOutputStreamOperator;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

/**
 * @ClassName TransFunctionUDF
 * @Description TODO
 * @Author ZFQ
 * @Date 2024/6/19 下午 03:10
 * @Version 1.0
 */
public class TransFunctionUDF {
    public static void main(String[] args) throws Exception {
        //用户自定义函数（user-defined function，UDF），即用户可以根据自身需求，重新实现算子的逻辑。
        //用户自定义函数分为：函数类、匿名函数、富函数类。
        //Flink暴露了所有UDF函数的接口，具体实现方式为接口或者抽象类，例如MapFunction、FilterFunction、ReduceFunction等。
        //所以用户可以自定义一个函数类，实现对应的接口。
        //需求：用来从用户的点击数据中筛选包含“sensor_1”的内容：
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        DataStreamSource<WaterSensor> waterSensorDataStreamSource = env.fromElements(
                new WaterSensor("sensor_1", 1000L, 20),
                new WaterSensor("sensor_1", 2000L, 50),
                new WaterSensor("sensor_2", 2000L, 10),
                new WaterSensor("sensor_3", 3000L, 30)
        );
        SingleOutputStreamOperator<WaterSensor> result = waterSensorDataStreamSource.filter(new TransFilter.MyFilterFunction());
        result.print();
        //匿名函数 方式二
        waterSensorDataStreamSource.filter(new FilterFunction<WaterSensor>() {
            @Override
            public boolean filter(WaterSensor value) throws Exception {
                return value.getId().equals("sensor_3");
            }
        }).print();
        //方式二优化         //map函数使用Lambda表达式，不需要进行类型声明
        waterSensorDataStreamSource.filter(value -> value.getId().equals("sensor_3")).print();
        //方式二再优化,匿名类,抽取关键字，公共方式
        waterSensorDataStreamSource.filter(new FilterFunctionImpl("sensor_3")).print();
        env.execute();
    }

    private static class FilterFunctionImpl implements FilterFunction<WaterSensor> {
        private String id;
        public FilterFunctionImpl(String id) {
            this.id = id;
        }

        @Override
        public boolean filter(WaterSensor value) throws Exception {
            return this.id.equals(value.id);
        }
    }
}