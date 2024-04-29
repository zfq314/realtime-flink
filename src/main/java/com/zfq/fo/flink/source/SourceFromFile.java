package com.zfq.fo.flink.source;

import org.apache.flink.api.common.eventtime.WatermarkStrategy;
import org.apache.flink.connector.file.src.FileSource;
import org.apache.flink.connector.file.src.reader.TextLineInputFormat;
import org.apache.flink.core.fs.Path;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;

import javax.annotation.Resources;


/**
 * @ClassName SourceFromFile
 * @Description TODO 从文件中读取数据
 * @Author ZFQ
 * @Date 2024/4/29 下午 02:28
 * @Version 1.0
 */
public class SourceFromFile {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        //获取resource
        String path = Resources.class.getResource("/hello.txt").getPath();
        FileSource fileSource = FileSource.forRecordStreamFormat(new TextLineInputFormat(), new Path(path)).build();

        env.fromSource(fileSource, WatermarkStrategy.noWatermarks(), "fileSource").print();
        env.execute();
    }
}