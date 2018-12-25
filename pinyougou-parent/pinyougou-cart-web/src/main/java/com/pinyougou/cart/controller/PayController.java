package com.pinyougou.cart.controller;


import com.alibaba.dubbo.config.annotation.Reference;
import com.pinyougou.order.service.OrderService;
import com.pinyougou.pay.service.WeixinPayService;
import com.pinyougou.pojo.TbPayLog;
import entity.Result;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import util.IdWorker;

import java.util.HashMap;
import java.util.Map;

/**
 * 支付控制层
 */
@RestController
@RequestMapping("/pay")
public class PayController {
    @Reference(timeout = 10000)
    private WeixinPayService weixinPayService;
    @Reference(timeout = 10000)
    private OrderService orderService;


    @RequestMapping("/createNative")
    public Map createNative(){
        /*
            IdWorker idWorker=new IdWorker();
            //订单号通过分布式 ID 生成器生成，金额暂时写死，后续开发我们再对接业务系统得到订单号和金额
            return weixinPayService.createNative(idWorker.nextId()+"","1");
        */
        //获取当前用户
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        //到redis查询支付日志
        TbPayLog payLog = orderService.searchPayLogFromRedis(userId);
        //判断支付日志存在
        if (payLog!=null){
            return weixinPayService.createNative(payLog.getOutTradeNo(),payLog.getTotalFee()+"");
        }else {
            return new HashMap();
        }

    }

    @RequestMapping("/queryPayStatus")
    public Result queryPayStatus(String out_trade_no){
        Result result=null;
        int x=0;
        while (true){
            //调用查询接口
            Map<String,String> map=weixinPayService.queryPayStatus(out_trade_no);
            if (map==null){
                result=new Result(false,"支付出错");
                break;
            }
            if (map.get("trade_state").equals("SUCCESS")){//如果成功
                result=new Result(true,"支付成功");
                //修改订单状态
                orderService.updateOrderStatus(out_trade_no,map.get("transaction_id"));

                break;
            }
            try {
                Thread.sleep(3000);//间隔3秒查询一次
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            //为了不让循环无休止地运行，我们定义一个循环变量，如果这个变量超过了这个值则退出循环，设置时间为 5 分钟
            x++;
            if (x>=100){
                result=new Result(false,"二维码超时");
                break;
            }
        }

        return result;
    }

}
