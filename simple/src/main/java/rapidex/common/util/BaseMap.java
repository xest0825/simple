package rapidex.common.util;

import java.util.HashMap;
import java.util.Map;

/**
 * 소문자로 바꾼다.
 * @author 김현욱
 *
 */
public class BaseMap extends HashMap<String, Object> {

	private final Map<String, String> lowerCaseMap = new HashMap<String, String>();

	/**
	 * Required for serialization support.
	 *
	 * @see java.io.Serializable
	 */
	private static final long serialVersionUID = -2848100435296897392L;


	@Override
	public boolean containsKey(Object key) {
		return super.containsKey(key.toString().toLowerCase());
	}


	@Override
	public Object get(Object key) {
		return super.get(key.toString().toLowerCase());
	}


	@Override
	public Object put(String key, Object value) {
		return super.put(key.toLowerCase(), value);
	}


	@Override
	public void putAll(Map<? extends String, ?> m) {
		for (Map.Entry<? extends String, ?> entry : m.entrySet()) {
			String key = entry.getKey();
			Object value = entry.getValue();
			this.put(key, value);
		}
	}

	@Override
	public Object remove(Object key) {
		Object realKey = lowerCaseMap.remove(key.toString().toLowerCase());
		return super.remove(realKey);
	}
}
