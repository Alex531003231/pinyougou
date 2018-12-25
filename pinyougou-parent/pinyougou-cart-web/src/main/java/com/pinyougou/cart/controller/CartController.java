package com.pinyougou.cart.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.alibaba.fastjson.JSON;
import com.pinyougou.cart.service.CartService;
import entity.Cart;
import entity.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import util.CookieUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@RestController
@RequestMapping("/cart")
public class CartController {
    @Reference(timeout = 100000)
    private CartService cartService;
    @Autowired
    private HttpServletRequest request;
    @Autowired
    private HttpServletResponse response;

    /**
     * 购物车列表
     * @return
     */
    @RequestMapping("/findCartList")
    public List<Cart> findCartList(){

        //当前登录人账号
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        System.out.println("当前登录人："+username);

        //从cookie中取出购物车
        String cartListSrting = CookieUtil.getCookieValue(request, "cartList", "UTF-8");
        if (cartListSrting==null || cartListSrting.equals("")){
            cartListSrting="[]";
        }
        List<Cart> cartList_cookie = JSON.parseArray(cartListSrting, Cart.class);


        if (username.equals("anonymousUser")){//如果未登陆
            //读取本地购物车
            System.out.println("get cartListData from local_cookie");
            return cartList_cookie;
        }else {//如果已登录
            List<Cart> cartList_redis = cartService.findCartListFromRedis(username);//从redis中提取
            System.out.println("get data from redis");
            if (cartList_cookie.size()>0){//从redis中提取
                //得到合并后的购物车
                List<Cart> cartList = cartService.mergeCartList(cartList_cookie, cartList_redis);
                //将合并后的购物车存入redis
                cartService.saveCartListToRedis(username, cartList);
                //本地购物车清除
                util.CookieUtil.deleteCookie(request, response, "cartList");
                System.out.println("zhi xing le he bing cartList");
                return cartList;
            }


            return cartList_redis;

        }


    }

    @RequestMapping("/addGoodsToCartList")
    @CrossOrigin(origins="http://localhost:9105",allowCredentials="true") //跨域注解。需要springMVC版本在4.2及以上
    public Result addGoodsToCartList(Long itemId,Integer num){

//        response.setHeader("Access-Control-Allow-Origin", "http://localhost:9105");
//        response.setHeader("Access-Control-Allow-Credentials", "true");


        //当前登录人账号
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        System.out.println("当前登录人："+username);

        try {
            //从cookie中提取购物车
            List<Cart> cartList = findCartList();//获取购物车列表
            cartList=cartService.addGoodsToCartList(cartList,itemId,num);

            if (username.equals("anonymousUser")){//如果是未登录，保存到cookie
                CookieUtil.setCookie(request,response,"cartList",JSON.toJSONString(cartList),3600*24,"UTF-8");
                System.out.println("save data to cookie");
            }else {//如果是已登录，保存到redis
                System.out.println("save data to redis");
                cartService.saveCartListToRedis(username,cartList);

            }


            return new Result(true, "存入购物车成功");
        } catch (Exception e) {
            e.printStackTrace();
            return new Result(false,"存入购物车失败");
        }

    }












}
