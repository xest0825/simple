package rapidex.system.log;

public class ActionLogVO {
	
	private String action_seq;
	private String action_dtm; 		/* DATETIME  		'액션 일시'   */
	private String user_uuid; 		/* VARCHAR(256)  	'사용자 UUID' */
	private String action_url; 		/* VARCHAR(200)  	'액션 URL'    */
	private String user_ip;			/* VARCHAR(30) 		'사용자 IP'   */
	private String conn_env;			/* VARCHAR(1000) 	'접속 환경'   */
	private String conn_id;			/* VARCHAR(1000)    '접속 ID' 	  */
	private String param; 			/* TEXT  			'파라미터'    */
	
	
	public String getAction_seq() {
		return action_seq;
	}
	public void setAction_seq(String action_seq) {
		this.action_seq = action_seq;
	}
	public String getAction_dtm() {
		return action_dtm;
	}
	public void setAction_dtm(String action_dtm) {
		this.action_dtm = action_dtm;
	}
	public String getUser_uuid() {
		return user_uuid;
	}
	public void setUser_uuid(String user_uuid) {
		this.user_uuid = user_uuid;
	}
	public String getAction_url() {
		return action_url;
	}
	public void setAction_url(String action_url) {
		this.action_url = action_url;
	}
	public String getUser_ip() {
		return user_ip;
	}
	public void setUser_ip(String user_ip) {
		this.user_ip = user_ip;
	}
	public String getConn_env() {
		return conn_env;
	}
	public void setConn_env(String conn_env) {
		this.conn_env = conn_env;
	}
	public String getConn_id() {
		return conn_id;
	}
	public void setConn_id(String conn_id) {
		this.conn_id = conn_id;
	}
	public String getParam() {
		return param;
	}
	public void setParam(String param) {
		this.param = param;
	}
	
	

}
