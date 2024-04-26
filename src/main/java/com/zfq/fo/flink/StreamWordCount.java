package com.zfq.fo.flink;

import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.streaming.api.datastream.DataStreamSink;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.util.Collector;

import javax.annotation.Resources;


/**
 * @ClassName StreamWordCount
 * @Description TODO 流处理
 * @Author ZFQ
 * @Date 2024/4/26 下午 01:38
 * @Version 1.0
 */
public class StreamWordCount {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        env.setParallelism(1);
        // 读取文件
        DataStreamSource<String> stringDataStreamSource = env.readTextFile(Resources.class.getResource("/log4j2.xml").getPath());
        // 转换
        DataStreamSink<Tuple2<String, Long>> result = stringDataStreamSource.flatMap(new FlatMapFunction<String, Tuple2<String, Long>>() {
            @Override
            public void flatMap(String value, Collector<Tuple2<String, Long>> out) throws Exception {
                String[] s = value.split(" ");
                for (String s1 : s) {
                    out.collect(new Tuple2<>(s1, 1L));
                }
            }
            // 分组
        }).keyBy(data -> data.f0).sum(1).print();
        // 执行
        env.execute();
    }

}