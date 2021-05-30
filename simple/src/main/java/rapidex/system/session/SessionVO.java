package rapidex.system.session;
import org.springframework.security.core.Authentication;

import rapidex.base.BaseVO;
import rapidex.system.security.model.User;

public class SessionVO {
	
	private String sessionID;
	private String location;
	private User user;
	private Authentication auth;
	
	public String getSessionID() {
		return sessionID;
	}
	public void setSessionID(String sessionID) {
		this.sessionID = sessionID;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public Authentication getAuth() {
		return auth;
	}
	public void setAuth(Authentication auth) {
		this.auth = auth;
	}
	
}
