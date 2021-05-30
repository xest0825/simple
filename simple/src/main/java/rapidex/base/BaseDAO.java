package rapidex.base;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;

public class BaseDAO {
	
	@Resource(name="sqlSession")
	private SqlSessionTemplate sqlSession;
	
//	@Resource(name="sqlSessionSms")
//	private SqlSessionTemplate sqlSessionSms;
	
	private static final String JwtMapper = "Jwt.";  //jwt-mapper.xml jwt 발급 관련
//	private static final String JoinMapper = "Join."; //join-mapper.xml 회원 가입
	private static final String LogMapper = "Log.";
	private static final String UserMapper = "User.";
	private static final String RoleMapper = "Role.";
	

	public SqlSessionTemplate getSqlSession() {
		return sqlSession;
	}

//	public SqlSessionTemplate getSqlSessionSms() {
//		return sqlSessionSms;
//	}

	public static String getJwtmapper() {
		return JwtMapper;
	}

//	public static String getJoinmapper() {
//		return JoinMapper;
//	}

	public static String getLogmapper() {
		return LogMapper;
	}

	public static String getUsermapper() {
		return UserMapper;
	}

	public static String getRolemapper() {
		return RoleMapper;
	}
	
	
	
	
	

}
