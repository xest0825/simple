package rapidex.system.esapi;

public class OwaspValidationException extends RuntimeException {

	private static final long serialVersionUID = -8032796196482532554L;

	public OwaspValidationException(String message) {
		super(message);
	}

	public OwaspValidationException(String message, Throwable cause) {
		super(message, cause);
	}

	public OwaspValidationException(Throwable cause) {
		super(cause);
	}
}