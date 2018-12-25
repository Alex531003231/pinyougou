package com.pinyougou.seckill.controller;


import com.alibaba.dubbo.config.annotation.Reference;
import com.pinyougou.pay.service.WeixinPayService;
import com.pinyougou.pojo.TbSeckillOrder;
import com.pinyougou.seckill.service.SeckillOrderService;
import entity.Result;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * 支付控制层
 */



@RestController
@RequestMapping("/pay")
public class PayController {
    @Reference
    private WeixinPayService weixinPayService;
    @Reference(timeout = 5000)
    private SeckillOrderService seckillOrderService;


    @RequestMapping("/createNative")
    public Map createNative(){
        //获取当前登录用户
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        //到redis查询秒杀订单
        TbSeckillOrder seckillOrder = seckillOrderService.searchOrderFromRedisByUserId(userId);

        //判断秒杀订单存在

        if (seckillOrder!=null){
            long fen=(long)(seckillOrder.getMoney().doubleValue()*100);//金额(分)
            return weixinPayService.createNative(seckillOrder.getId()+"",+fen+"");
        }else {
            return new HashMap();
        }
    }



    @RequestMapping("/queryPayStatus")
    public Result queryPayStatus(String out_trade_no){

        //1.获取当前登录用户
        String username = SecurityContextHolder.getContext().getAuthentication().getName();

        Result result=null;
        int x=0;
        while(true){

            Map<String,String> map = weixinPayService.queryPayStatus(out_trade_no);//调用查询
            if(map==null){
                result=new Result(false, "支付发生错误");
                break;
            }
            if(map.get("trade_state").equals("SUCCESS")){//支付成功
                result=new Result(true, "支付成功");
                //保存订单
                seckillOrderService.saveOrderFromRedisToDb(username, Long.valueOf(out_trade_no) ,map.get("transaction_id"));
                break;
            }

            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            //为了不让循环无休止地运行，我们定义一个循环变量，如果这个变量超过了这个值则退出循环，设置时间为 5 分钟
            x++;
            if (x>=100){
                result=new Result(false,"二维码超时");

                //1.调用微信的关闭订单接口
                Map payresult = weixinPayService.closePay(out_trade_no);
                if(payresult!=null &&  "FAIL".equals( payresult.get("return_code"))){//如果返回结果是正常关闭
                    if ("ORDERPAID".equals(payresult.get("err_code"))){
                        result=new Result(true,"支付成功");
                        seckillOrderService.saveOrderFromRedisToDb(username,Long.valueOf(out_trade_no),map.get("transaction_id"));
                    }
                }
                if (result.isFlag()==false){
                    System.out.println("超时,取消订单");
                    //2.调用删除
                    seckillOrderService.deleteOrderFromRedis(username,Long.valueOf(out_trade_no));
                }
                break;
            }

        }
        return result;
    }




}
