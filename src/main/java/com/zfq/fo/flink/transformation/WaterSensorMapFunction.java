package com.zfq.fo.flink.transformation;

import com.zfq.fo.flink.pojo.WaterSensor;
import org.apache.flink.api.common.functions.MapFunction;

/**
 * @ClassName WaterSensorMapFunction
 * @Description TODO
 * @Author ZFQ
 * @Date 2024/6/19 下午 02:50
 * @Version 1.0
 */
public class WaterSensorMapFunction implements MapFunction<String, WaterSensor> {
    @Override
    public WaterSensor map(String value) throws Exception {
        String[] datas = value.split(",");
        return new WaterSensor(datas[0], Long.valueOf(datas[1]), Integer.valueOf(datas[2]));
    }
}