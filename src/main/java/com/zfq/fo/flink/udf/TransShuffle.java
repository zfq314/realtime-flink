package com.zfq.fo.flink.udf;

import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

/**
 * @ClassName TransShuffle
 * @Description TODO shuffle 算子 每次打印的结果不一样
 * @Author ZFQ
 * @Date 2024/6/20 上午 10:51
 * @Version 1.0
 */
public class TransShuffle
{
    public static void main(String[] args) throws Exception
    {
        StreamExecutionEnvironment executionEnvironment = StreamExecutionEnvironment.getExecutionEnvironment();
        executionEnvironment.setParallelism(3);
        executionEnvironment.fromElements(
                    222,
                    333,
                    444
        ).shuffle().print();


        executionEnvironment.execute();
    }
}