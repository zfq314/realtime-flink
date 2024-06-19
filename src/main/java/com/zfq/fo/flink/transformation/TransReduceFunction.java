package com.zfq.fo.flink.transformation;

import com.zfq.fo.flink.pojo.WaterSensor;
import org.apache.flink.api.common.functions.ReduceFunction;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

/**
 * @ClassName TransReduceFunction
 * @Description TODO 使用reduce实现max和maxBy的功能。
 * reduce可以对已有的数据进行归约处理，把每一个新输入的数据和当前已经归约出来的值，再做一个聚合计算。
 * reduce操作也会将KeyedStream转换为DataStream。它不会改变流的元素数据类型，所以输出类型和输入类型是一样的。
 * @Author ZFQ
 * @Date 2024/6/19 下午 02:51
 * @Version 1.0
 */
public class TransReduceFunction {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment executionEnvironment = StreamExecutionEnvironment.getExecutionEnvironment();
        executionEnvironment.setParallelism(1);


        executionEnvironment
                .socketTextStream("hadoop31", 7777)
                .map(new WaterSensorMapFunction())
                .keyBy(WaterSensor::getId)
                .reduce(new ReduceFunction<WaterSensor>() {
                    @Override
                    public WaterSensor reduce(WaterSensor value1, WaterSensor value2) throws Exception {
                        System.out.println("TransReduceFunction.reduce");

                        int maxVc = Math.max(value1.getVc(), value2.getVc());
                        //实现max(vc)的效果  取最大值，其他字段以当前组的第一个为主
                        //value1.setVc(maxVc);
                        //实现maxBy(vc)的效果  取当前最大值的所有字段
                        if (value1.getVc() > value2.getVc()) {
                            value1.setVc(maxVc);
                            return value1;
                        } else {
                            value2.setVc(maxVc);
                            return value2;
                        }
                    }
                })
                .print();

        executionEnvironment.execute();

    }
}