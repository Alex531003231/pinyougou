package com.itheima.ssm.service;

import com.itheima.ssm.domain.Product;

import java.util.List;

public interface IProductService {


    //查询所有产品信息
    List<Product> findAll() throws Exception;

    void save(Product product) throws Exception;
}
