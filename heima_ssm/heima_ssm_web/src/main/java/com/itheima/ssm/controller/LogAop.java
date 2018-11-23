package com.itheima.ssm.controller;

import com.itheima.ssm.domain.SysLog;
import com.itheima.ssm.service.ISysLogService;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Method;
import java.util.Date;

@Component
@Aspect
public class LogAop {


    @Autowired
    private HttpServletRequest request;

    @Autowired
    private ISysLogService sysLogService;

    private Date visitTime;
    private Class clazz;
    private Method method;

    @Before("execution(* com.itheima.ssm.controller.*.*(..))")
    public void doBefore(JoinPoint jp) throws NoSuchMethodError{
        visitTime=new Date();//当前时间就是开始访问的时间
        clazz=jp.getTarget().getClass();//具体要访问的类
        //获取当前访问的类
        MethodSignature signature=(MethodSignature)jp.getSignature();
        method=signature.getMethod();
    }


    /**
     * 后置通知
     * @param jp
     * @throws Exception
     */
    @After("execution(* com.itheima.ssm.controller.*.*(..))")
    public void doAfter(JoinPoint jp) throws Exception{
        //获取访问的时长
        long time=new Date().getTime()-visitTime.getTime();


        String url = "";
        //获取url
        if (clazz !=null && method != null && clazz != LogAop.class){
            //获取类上的@Requestmapping("/orders")
            RequestMapping classAnnotation =(RequestMapping) clazz.getAnnotation(RequestMapping.class);
            if (classAnnotation != null){
                String[] classValue = classAnnotation.value();
//                获取方法上的@Requestmapping("xxx")
                RequestMapping methodAnnotation = method.getAnnotation(RequestMapping.class);
                if (methodAnnotation != null){
                    String[] methodValue = methodAnnotation.value();
                    url=classValue[0]+methodValue[0];

                    //获取访问ip
                    String ip = request.getRemoteAddr();
                    //从上下文获取当前登录用户
                    SecurityContext context = SecurityContextHolder.getContext();
                    User user =(User) context.getAuthentication().getPrincipal();
                    String username = user.getUsername();

                    //将日志信息封装到SysLog对象
                    SysLog sysLog=new SysLog();
                    sysLog.setExecutionTime(time);
                    sysLog.setIp(ip);
                    sysLog.setMethod("[类名] "+clazz.getName()+ "[方法名] " +method.getName());
                    sysLog.setUrl(url);
                    sysLog.setUsername(username);
                    sysLog.setVisitTime(visitTime);

                    //调用service完成操作
                    sysLogService.save(sysLog);
                }
            }
        }
    }
}
