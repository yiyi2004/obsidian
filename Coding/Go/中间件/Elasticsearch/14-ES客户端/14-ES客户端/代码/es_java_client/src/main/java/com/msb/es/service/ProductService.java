package com.msb.es.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.msb.es.entity.Product;
import com.msb.es.mapper.ProductMapper;
import org.springframework.stereotype.Service;

@Service
public class ProductService extends ServiceImpl<ProductMapper, Product> {
}
