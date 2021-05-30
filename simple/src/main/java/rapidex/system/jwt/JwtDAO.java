package rapidex.system.jwt;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import rapidex.base.BaseDAO;

@Repository(value = "JwtDAO")
public class JwtDAO extends BaseDAO {
	private static final Logger logger = LoggerFactory.getLogger(JwtDAO.class);

	/**
	 * @desc : 본인인증 정보 입력 전 이전 메세지 URL취소상태로 변경
	 * @author : JANGCHAEHOON
	 * @since : 2020. 10. 30
	 * @return : int
	 */
	public int updateAuthenticationStatus(JwtVO authenticationVO) {
		return getSqlSession().update(getJwtmapper() + "updateAuthenticationStatus", authenticationVO);
	}
	
	/**
	 * @desc : 본인인증 URL 문자전송
	 * @author : JANGCHAEHOON
	 * @since : 2020. 10. 30
	 * @return : int
	 */
	public int insertAuthentication(JwtVO authenticationVO) {
		return getSqlSession().insert(getJwtmapper() + "insertAuthentication", authenticationVO);
	}
	
	/**
	 * @desc : 본인인증 페이지 이동전 인증정보가져오기
	 * @author : JANGCHAEHOON
	 * @since : 2020. 10. 30
	 * @return : Map
	 */
	public Map selectAuthentication(JwtVO authenticationVO) {
		Map reulstMap = new HashMap();
		reulstMap = getSqlSession().selectOne(getJwtmapper() + "selectAuthentication", authenticationVO);
		return reulstMap;
	}
	
	/**
	 * @desc : 본인인증 확인 로그 입력
	 * @author : JANGCHAEHOON
	 * @since : 2020. 10. 30
	 * @return : int
	 */
	public int insertAuthenticationLogs(Map resultMap) {
		return getSqlSession().insert(getJwtmapper() + "insertAuthenticationLogs", resultMap);
	}
	
	/**
	 * @desc : 본인인증 성공시 생년월일, 내국인, 성별 수정
	 * @author : JANGCHAEHOON
	 * @since : 2020. 10. 30
	 * @return : int
	 */
	public int updateAuthentication(Map resultMap) {
		return getSqlSession().update(getJwtmapper() + "updateAuthenticationBirth", resultMap);
	}
	
	/**
	 * @desc : 본인인증서비스 사인저장
	 * @author : yumi.jeon
	 * @since : 2018. 03. 19
	 * @return : int
	 */
	public int updateAuthenticationSign(JwtVO authenticationVO) {
		return getSqlSession().update(getJwtmapper() + "updateAuthenticationSign", authenticationVO);
	}
}
