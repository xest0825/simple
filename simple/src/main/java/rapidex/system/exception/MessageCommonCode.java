package rapidex.system.exception;

//import rapidex.common.util.CommUtil;

public enum MessageCommonCode implements IMessageCodeable {
	
	/**
	 ※ 사용법 ※
	 MSG0200("MSG_0200", "OK"),
	 변수명(변수코드값,변수설명)
	*/
	MSG0200("MSG_0200", "OK"),
	
	
	ERR0001("ERR_0001", "%1은(는) 필수 입력 항목입니다."),
	ERR0002("ERR_0002", "%1이(가) 존재하지 않습니다."),
	ERR0003("ERR_0003", "%1이(가) 불일치합니다."),
	ERR0004("ERR_0004", "중복된 데이타가 있습니다."),
	ERR0005("ERR_0005","데이타 처리중 에러가 발생하였습니다."),
	ERR0006("ERR_0006","데이타 처리중 에러가 발생하였습니다."),
	ERR0007("ERR_0007","데이타 처리중 에러가 발생하였습니다."),
	ERR0008("ERR_0008","데이타 처리중 에러가 발생하였습니다."),
	ERR0009("ERR_0009","필요 인자가 없어 에러가 발생하였습니다."),
	ERR0010("ERR_0010","xlsx 형식에 엑셀파일만 지원합니다."),
	ERR0011("ERR_0500","알수없는 오류가 발생했습니다."),
	ERR0012("ERR_0012","사용자아이디가 없거나 비밀번호가 맞지 않습니다. 관리자에게 문의해주세요."),
	ERR0013("ERR_0013","사용자아이디가 없거나 비밀번호가 맞지 않습니다. 관리자에게 문의해주세요."),
	ERR0014("ERR_0014","사용자아이디가 없거나 비밀번호가 맞지 않습니다. 관리자에게 문의해주세요."),
	ERR0015("ERR_0015","권한이 없습니다."),
	ERR0016("ERR_0016","사용자계정이 없습니다."),
	ERR0017("ERR_0017","계정이 잠겨있습니다. 관리자에게 문의해주세요.");

	private String messageCode;
	private String msg;

	@Override
	public String getMessageCode() {
		return this.messageCode;
	}
	@Override
	public String getMessage(String... args) {
//		return CommUtil.parseMessage(this.msg, args);
		return null;
	}
	
	MessageCommonCode(String messageCode, String msg) {
		this.messageCode = messageCode;
		this.msg = msg;
	}

}