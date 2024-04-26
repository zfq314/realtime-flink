package com.zfq.fo.flink;


import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.java.ExecutionEnvironment;
import org.apache.flink.api.java.operators.AggregateOperator;
import org.apache.flink.api.java.operators.FlatMapOperator;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.util.Collector;

import javax.annotation.Resources;

/**
 * @ClassName BatchWordCount
 * @Description TODO flink批处理程序
 * @Author ZFQ
 * @Date 2024/4/26 上午 11:26
 * @Version 1.0
 */
public class BatchWordCount {
    public static void main(String[] args) throws Exception {
        ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();
        env.setParallelism(1);
        //读取resouce下的文件代码
        String path = Resources.class.getResource("/log4j2.xml").getPath();
        FlatMapOperator<String, Tuple2<String, Long>> stringTuple2FlatMapOperator = env.readTextFile(path)
                .flatMap(
                        new FlatMapFunction<String, Tuple2<String, Long>>() {
                            @Override
                            public void flatMap(String value, Collector<Tuple2<String, Long>> out) throws Exception {
                                String[] words = value.split(" ");
                                for (String word : words) {
                                    out.collect(new Tuple2<>(word, 1L));
                                }
                            }
                        }
                );
        AggregateOperator<Tuple2<String, Long>> result = stringTuple2FlatMapOperator.groupBy(0).sum(1);
        result.print();
    }
}