package rapidex.system.interceptor;


import org.apache.ibatis.executor.statement.StatementHandler;
import org.apache.ibatis.plugin.*;
import org.apache.ibatis.session.ResultHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Statement;
import java.util.Properties;


@Intercepts
(
     {
          @Signature(type = StatementHandler.class, method = "update", args = {Statement.class})
         ,@Signature(type = StatementHandler.class, method = "query",  args = {Statement.class, ResultHandler.class}) 
     }
)
public class UpdateInterceptor implements Interceptor
{
    private Logger log = LoggerFactory.getLogger(getClass());
    
    @Override
    public Object intercept(Invocation invocation) throws Throwable
    {
        StatementHandler handler = (StatementHandler) invocation.getTarget();
        
        //쿼리문
        String sql = handler.getBoundSql().getSql();

        //매핑 자료
        String param = handler.getParameterHandler().getParameterObject() != null ? handler.getParameterHandler().getParameterObject().toString() : "";
        
        log.debug(sql);
        log.debug(param);
       
        return invocation.proceed();
    }


    @Override
    public Object plugin(Object target)
    {
        return Plugin.wrap(target, this);
    }


    @Override
    public void setProperties(Properties properties)
    {
    }
}

