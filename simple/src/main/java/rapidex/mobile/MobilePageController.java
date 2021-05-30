package rapidex.mobile;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import rapidex.system.security.CustomUserDetailsHelper;
import rapidex.system.security.model.User;


@Controller(value="MobilePageController")
public class MobilePageController {
	
	private static final Logger logger = LoggerFactory.getLogger(MobilePageController.class);
	
	/**
	 * 메인 전 액션
	 * @since 
	 */
	@RequestMapping(value={"/m/before_main.do"})
	public String doBeforeMain(HttpServletRequest req) throws Exception{
		logger.debug("Do something before main page.");
		return "redirect: /m/main.go";
	}
	
	/**
	 * 모바일 로그인 페이지
	 * @since 
	 */
	@RequestMapping(value={"/m/login.go"})
	public ModelAndView goMobileLogin(HttpServletRequest req) throws Exception{
		ModelAndView mv = new ModelAndView("/mobile/login");
		logger.debug("login page ................ fail = " 	  + req.getParameter("fail"));
		logger.debug("login page ................ s.s.l.e = " + req.getParameter("SPRING_SECURITY_LAST_EXCEPTION"));
		mv.addObject("fail", req.getParameter("fail"));
		mv.addObject("SPRING_SECURITY_LAST_EXCEPTION", req.getParameter("SPRING_SECURITY_LAST_EXCEPTION"));
		return mv;
	}
	
	@RequestMapping(value={"/m/loginFail.go"})
	public String redirectMobileLogin(HttpServletRequest req, RedirectAttributes redirect) throws Exception{
		logger.debug("login page ................ fail = " 	  + req.getAttribute("fail"));
		logger.debug("login page ................ s.s.l.e = " + req.getAttribute("SPRING_SECURITY_LAST_EXCEPTION"));
		redirect.addAttribute("fail", req.getAttribute("fail"));
		redirect.addAttribute("SPRING_SECURITY_LAST_EXCEPTION", req.getAttribute("SPRING_SECURITY_LAST_EXCEPTION"));
		return "redirect: /m/login.go";
	}
	
	/**
	 * 모바일 메인
	 * @since 
	 */
	@RequestMapping(value={"/m/main.go"})
	public ModelAndView goMobileMain(HttpServletRequest req) throws Exception{
		ModelAndView mv = new ModelAndView("/mobile/main");
		String uuid = "";
		User user = (User) CustomUserDetailsHelper.getAuthenticatedUser();
		mv.addObject("User", user);
		return mv;
	}

}
