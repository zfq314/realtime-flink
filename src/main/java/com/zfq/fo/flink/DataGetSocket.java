package com.zfq.fo.flink;

import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.api.java.utils.ParameterTool;
import org.apache.flink.streaming.api.datastream.SingleOutputStreamOperator;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.util.Collector;

/**
 * @ClassName DataGetSocket
 * @Description TODO 从socket获取数据
 * @Author ZFQ
 * @Date 2024/4/26 下午 02:28
 * @Version 1.0
 */
public class DataGetSocket {
    //main方法 参数传入 -host hadoop331 -port 8989
    public static void main(String[] args) throws Exception {
        // 获取执行环境
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        env.setParallelism(1);
        // 获取参数
        ParameterTool parameterTool = ParameterTool.fromArgs(args);
        // 判断参数
        if (parameterTool.getNumberOfParameters() != 2) {
            System.out.println("参数错误");
            return;
        }
        // 获取参数
        String host = parameterTool.get("host");
        int port = parameterTool.getInt("port");
        // 获取数据
        SingleOutputStreamOperator<Tuple2<String, Long>> result = env.socketTextStream(host, port)
                // 处理数据
                .flatMap(new FlatMapFunction<String, Tuple2<String, Long>>() {
                    @Override
                    // 处理数据
                    public void flatMap(String value, Collector<Tuple2<String, Long>> out) throws Exception {
                        // 处理数据
                        String[] words = value.split(" ");
                        // 遍历
                        for (String word : words) {
                            // 输出
                            out.collect(new Tuple2<>(word, 1L));
                        }
                    }
                }).keyBy(0)
                .sum(1);
        // 打印
        result.print();
        // 执行
        env.execute("DataGetSocket");


    }
}