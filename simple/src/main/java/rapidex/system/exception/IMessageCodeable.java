package rapidex.system.exception;

public interface IMessageCodeable {
	String getMessageCode();
	String getMessage(String... args);
}