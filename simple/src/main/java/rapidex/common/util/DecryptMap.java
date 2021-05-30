package rapidex.common.util;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * 복호화 한다.
 *
 */
public class DecryptMap extends HashMap<String, Object> {

	private final Map<String, String> lowerCaseMap = new HashMap<String, String>();
	CryptoUtil cutil = new CryptoUtil();
	 private Pattern decrypt = Pattern.compile("^(telno|perno|customer_perno|email|customer_email|customer_telno|owner_perno|account_no|contractor_perno|contractor_telno|contractor_email)$");

	/**
	 * Required for serialization support.
	 *
	 * @see java.io.Serializable
	 */
	private static final long serialVersionUID = -2848100435296897392L;

	
	public String ExceptionData(String KEY,String DATA) {
		DATA = null==DATA?"":DATA;		
		if("email".indexOf(KEY) !=-1) {
			if("@".equals(DATA)) {
				DATA = DATA.replace("@","");
			}
		}
		
		return DATA;
	}
	
	@Override
	public boolean containsKey(Object key) {
		return super.containsKey(key.toString().toLowerCase());
	}


	@Override
	public Object get(Object key) {
		String Stringkey = key.toString().toLowerCase();
		if(decrypt.matcher(Stringkey).matches()) {
			try {
				
				Object ob = super.get(Stringkey);
				//System.out.println(Stringkey);
				//System.out.println(String.valueOf(ob));
				//System.out.println(cutil.decrypt(ob.toString()));
				
				return ExceptionData(Stringkey,cutil.decrypt(ob.toString()));
			} catch (Exception e) {
				return super.get(key.toString().toLowerCase());
			}
		}
		return super.get(key.toString().toLowerCase());
	}


	@Override
	public Object put(String key, Object value) {
		String Stringkey = key.toString().toLowerCase();
		if(decrypt.matcher(Stringkey).matches()) {
			try {
				//System.out.println(cutil.decrypt(value.toString()));
				return super.put(key.toString().toLowerCase(), ExceptionData(Stringkey,cutil.decrypt(value.toString())));
			} catch (Exception e) {
				return super.put(key.toString().toLowerCase(), value);
			}
		}
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
