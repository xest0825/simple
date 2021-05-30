package rapidex.index;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;



/**
 * 관리자 사이트와 모바일 사이트를 분리하여 각각의 시스템 로그인 페이지로 분기
 * @author yoonsik.choi
 * @since 2021-05-14
 */
@Controller(value="IndexPageController")
public class IndexPageController {

	private static final Logger logger = LoggerFactory.getLogger(IndexPageController.class);


	/**
	 * @description 인덱스 페이지 이동
	 * @since 2021-05-20
	 * @param request, response
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/index.go")
	public ModelAndView index(HttpServletRequest req, HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView();
	    logger.debug("/index.go");
	    String menuOrder = "";
	    String returnLocation = "";
	    try {
	    	//RETURN URL 변경
	    	menuOrder = null==req.getSession().getAttribute("adminSite")?"":req.getSession().getAttribute("adminSite").toString();
	    	
	    	if(menuOrder.length() > 0){
	    		
	    		returnLocation = "redirect: /login.go";
	    		
	    	}else{
	    		
	    		returnLocation = "redirect: /m/login.go";
	    		
	    	}
		} catch (Exception e) {
			// 로그인 실패
			logger.debug("Error 발생");
			e.printStackTrace();
			req.logout();
	    	if(menuOrder.length() > 0){
	    		
	    		returnLocation = "redirect: /login.go?fail=true";
	    		
	    	}else{
	    		
	    		returnLocation = "redirect: /m/login.go?fail=true";
	    		
	    	}
		}
	    logger.info(" x x x x x x x x x x x x x x x x x x x x x x x x x ");
	    logger.info(" returnLocation -> " + returnLocation);
	    logger.info(" x x x x x x x x x x x x x x x x x x x x x x x x x ");
	    mv.setViewName(returnLocation);
	    return mv;
	}
	
	
	/**
	 * 로그인 리다이렉트
	 * @since 
	 */
	@RequestMapping(value={"/login.go"})
	public String gologin() throws Exception{
		// Do something before main page
		return "/admin/login";
	}
	
	
	/**
	 * 로그인 리다이렉트
	 * @since 
	 */
	@RequestMapping(value={"/test/login.go"})
	public String gologinTest() throws Exception{
		// Do something before main page
		return "/admin/login";
	}
	
	/**
	 * 로그인 리다이렉트
	 * @since 
	 */
	@RequestMapping(value={"/test/test/login.go"})
	public String gologinTestTest() throws Exception{
		// Do something before main page
		return "/admin/login";
	}
	

	
	@RequestMapping(value={"/pop.pop"})
	public String pop() throws Exception{
		// Do something before main page
		return "/comm/pop";
	}
	@RequestMapping(value={"/test/pop.pop"})
	public String poprest() throws Exception{
		// Do something before main page
		return "/comm/pop";
	}


	
	
  	
  	
}
