package rapidex.system.log;

public class ErrorLogVO {
	
	private String err_seq;
	private String err_dtm; /* DATETIME '오류 일시' */
	private String err_sts; /* VARCHAR(10) '오류 상태 (코드)' */
	private String err_cls; /* VARCHAR(200) '오류 발생 클래스' */
	private String err_msg; /* VARCHAR(4000) '오류 메시지' */
	private String err_trc; /* VARCHAR(4000) '오류 트레이스' */
	private String param; /* TEXT */
	private String user_uuid; /* VARCHAR(256) '사용자 UUID' */
	private String conn_id; /* VARCHAR(256) '접속 ID' */
	
	public String getErr_seq() {
		return err_seq;
	}
	public void setErr_seq(String err_seq) {
		this.err_seq = err_seq;
	}
	public String getErr_dtm() {
		return err_dtm;
	}
	public void setErr_dtm(String err_dtm) {
		this.err_dtm = err_dtm;
	}
	public String getErr_sts() {
		return err_sts;
	}
	public void setErr_sts(String err_sts) {
		this.err_sts = err_sts;
	}
	public String getErr_cls() {
		return err_cls;
	}
	public void setErr_cls(String err_cls) {
		this.err_cls = err_cls;
	}
	public String getErr_msg() {
		return err_msg;
	}
	public void setErr_msg(String err_msg) {
		this.err_msg = err_msg;
	}
	public String getErr_trc() {
		return err_trc;
	}
	public void setErr_trc(String err_trc) {
		this.err_trc = err_trc;
	}
	public String getParam() {
		return param;
	}
	public void setParam(String param) {
		this.param = param;
	}
	public String getUser_uuid() {
		return user_uuid;
	}
	public void setUser_uuid(String user_uuid) {
		this.user_uuid = user_uuid;
	}
	public String getConn_id() {
		return conn_id;
	}
	public void setConn_id(String conn_id) {
		this.conn_id = conn_id;
	}
	
}
