package com.zfq.fo.flink.udf;

 import org.apache.flink.api.common.functions.Partitioner;
 import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.datastream.DataStreamSource;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

/**
 * @ClassName TransShuffle
 * @Description TODO shuffle 算子 每次打印的结果不一样
 * @Author ZFQ
 * @Date 2024/6/20 上午 10:51
 * @Version 1.0
 */
public class TransShuffle {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment executionEnvironment = StreamExecutionEnvironment.getExecutionEnvironment();
        executionEnvironment.setParallelism(3);
        DataStreamSource<Integer> integerDataStreamSource = executionEnvironment.fromElements(
                2,
                3,
                4
        );
        integerDataStreamSource
                .shuffle().print("shuffle");
        // rebalance rebalance使用的是Round-Robin负载均衡算法，可以将输入流数据平均分配到下游的并行任务中去。
        integerDataStreamSource
                .rebalance().print("rebalance");
        //重缩放分区和轮询分区非常相似。当调用rescale()方法时，其实底层也是使用Round-Robin算法进行轮询，
        // 但是只会将数据轮询发送到下游并行任务的一部分中。rescale的做法是分成小团体，发牌人只给自己团体内的所有人轮流发牌。
        integerDataStreamSource.
                rescale().print("rescale");
        //  这种方式其实不应该叫做“重分区”，因为经过广播之后，数据会在不同的分区都保留一份，可能进行重复处理。
        //  可以通过调用DataStream的broadcast()方法，将输入数据复制并发送到下游算子的所有并行任务中去。
        integerDataStreamSource.
                broadcast().print("broadcast");
        //全局分区也是一种特殊的分区方式。这种做法非常极端，通过调用.global()方法，
        // 会将所有的输入流数据都发送到下游算子的第一个并行子任务中去。这就相当于强行让下游任务并行度变成了1，
        // 所以使用这个操作需要非常谨慎，可能对程序造成很大的压力。
        integerDataStreamSource.
                global().print("global");

        //自定义分区
        DataStream<Integer> integerDataStream1 = integerDataStreamSource.
                partitionCustom(new CustomPartitioner()
                        , value -> value.toString());
        DataStream<Integer> integerDataStream = integerDataStream1;
        integerDataStream.print("custom");
        executionEnvironment.execute();
    }


    private static class CustomPartitioner implements Partitioner<String> {
        @Override
        public int partition(String key, int numPartitions) {
            return Integer.parseInt(key) % numPartitions;
        }
    }
}