package com.msb.es.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName(value = "car_serial_brand")
public class CarSerialBrand {
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;
    private Integer master_brand_id;
    private String master_brand_name;
    private Integer brand_id;
    private String brand_name;
    private Integer series_id;
    private String series_name;
    private Integer model_id;
    private String sale_name;
}
