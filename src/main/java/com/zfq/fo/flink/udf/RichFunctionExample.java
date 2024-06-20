package com.zfq.fo.flink.udf;

import org.apache.flink.api.common.functions.RichMapFunction;
import org.apache.flink.configuration.Configuration;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

/**
 * @ClassName RichFunctionExample
 * @Description TODO
 * @Author ZFQ
 * @Date 2024/6/19 下午 03:46
 * @Version 1.0
 */
public class RichFunctionExample {
    public static void main(String[] args) throws Exception {
        //“富函数类”也是DataStream API提供的一个函数类的接口，所有的Flink函数类都有其Rich版本。富函数类一般是以抽象类的形式出现的。
        // 例如：RichMapFunction、RichFilterFunction、RichReduceFunction等。
        //与常规函数类的不同主要在于，富函数类可以获取运行环境的上下文，并拥有一些生命周期方法，所以可以实现更复杂的功能。
        //Rich Function有生命周期的概念。典型的生命周期方法有：
        //open()方法，是Rich Function的初始化方法，也就是会开启一个算子的生命周期。当一个算子的实际工作方法例如map()或者filter()方法被调用之前，open()会首先被调用。
        //close()方法，是生命周期中的最后一个调用的方法，类似于结束方法。一般用来做一些清理工作。
        //需要注意的是，这里的生命周期方法，对于一个并行子任务来说只会调用一次；而对应的，实际工作方法，例如RichMapFunction中的map()，在每条数据到来后都会触发一次调用。
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
         env.fromElements(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
                .map(new RichMapFunction<Integer, Integer>() {
                    @Override
                    public void open(Configuration parameters) throws Exception {
                        super.open(parameters);
                        System.out.println("索引是：" + getRuntimeContext().getIndexOfThisSubtask() + " 的任务的生命周期开始");
                    }

                    @Override
                    public Integer map(Integer value) throws Exception {
                        return value == null ? null : value * 2;
                    }

                    @Override
                    public void close() throws Exception {
                        super.close();
                        System.out.println("索引是：" + getRuntimeContext().getIndexOfThisSubtask() + " 的任务的生命周期结束");
                    }
                })
                .print();

        env.execute();
    }

}