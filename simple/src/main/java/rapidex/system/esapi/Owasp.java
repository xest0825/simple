package rapidex.system.esapi;

import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import org.owasp.esapi.ESAPI;
import org.owasp.esapi.Encoder;
import org.owasp.esapi.Encryptor;
import org.owasp.esapi.Validator;
import org.owasp.esapi.codecs.Codec;
import org.owasp.esapi.crypto.CipherText;
import org.owasp.esapi.crypto.PlainText;
import org.owasp.esapi.errors.EncodingException;
import org.owasp.esapi.errors.EncryptionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Owasp {
	private static final Logger LOGGER = LoggerFactory.getLogger(Owasp.class);

	public static final short ENC_BASE64 = 1;

	public static final short ENC_CSS = 2;

	public static final short ENC_DN = 3;

	public static final short ENC_HTML = 4;

	public static final short ENC_HTML_ATTR = 5;

	public static final short ENC_JAVA_SCRIPT = 6;

	public static final short ENC_LDAP = 7;

	// public static final short ENC_OS=8;

	// public static final short ENC_SQL=9;

	public static final short ENC_URL = 10;

	public static final short ENC_VB_SCRIPT = 11;

	public static final short ENC_XML = 12;

	public static final short ENC_XML_ATTR = 13;

	public static final short ENC_XPATH = 14;

	private static Validator validator = ESAPI.validator();

	private static Encoder encoder = ESAPI.encoder();

	private static Encryptor encryptor = ESAPI.encryptor();

	protected static Charset charset = Charset.forName("UTF-8");

	public static void main(String[] args) {

		String plain = "abc";

		String encrypted = Owasp.encrypt(plain);

		String decrypted = Owasp.decrypt(encrypted);

		LOGGER.debug(plain + "::" + decrypted + "::" + encrypted);

		String fileName = "abc.exe";

		LOGGER.debug("isValidFileName:" + Owasp.isValidFileName(fileName));

		List<String> allowedExtensions = new ArrayList<>();

		allowedExtensions.add("jpg");

		LOGGER.debug("isValidFileName:" + Owasp.isValidFileName(fileName, allowedExtensions));

	}

	public static boolean isValidFileName(String inputFileName) {

		return validator.isValidFileName("checkFileName", inputFileName, false);

	}

	public static boolean isValidFileName(String inputFileName, List<String> allowedExtensions) {

		return validator.isValidFileName("checkFileName", inputFileName, allowedExtensions, false);

	}

	public static String encrypt(String input) throws SecurityException {

		try {

			CipherText ciphertext = encryptor.encrypt(new PlainText(input));

			byte[] b = ciphertext.asPortableSerializedByteArray();

			return new String(Base64.getEncoder().encode(b));

		} catch (EncryptionException ee) {

			throw new SecurityException(ee);

		}

	}

	public static String decrypt(String input) throws SecurityException {

		try {

			byte[] b = Base64.getDecoder().decode(input);

			CipherText restoredCipherText = CipherText.fromPortableSerializedBytes(b);

			PlainText plainText = encryptor.decrypt(restoredCipherText);

			return plainText.toString();

		} catch (EncryptionException ee) {

			throw new SecurityException(ee);

		}

	}

	public static String encode(String item, short encFor) throws SecurityException {

		try {

			switch (encFor) {

			case ENC_BASE64:

				return encoder.encodeForBase64(item.getBytes(charset), false);

			case ENC_CSS:

				return encoder.encodeForCSS(item);

			case ENC_DN:

				return encoder.encodeForDN(item);

			case ENC_HTML:

				return encoder.encodeForHTML(item);

			case ENC_HTML_ATTR:

				return encoder.encodeForHTMLAttribute(item);

			case ENC_JAVA_SCRIPT:

				return encoder.encodeForJavaScript(item);

			case ENC_LDAP:

				return encoder.encodeForLDAP(item);

			// case ENC_OS:return encoder.encodeForOS(codec, item);

			// case ENC_SQL:return encoder.encodeForSQL(codec, item);

			case ENC_URL:

				return encoder.encodeForURL(item);

			case ENC_VB_SCRIPT:

				return encoder.encodeForVBScript(item);

			case ENC_XML:

				return encoder.encodeForXML(item);

			case ENC_XML_ATTR:

				return encoder.encodeForXMLAttribute(item);

			case ENC_XPATH:

				return encoder.encodeForXPath(item);

			}

			throw new SecurityException("invalid target encoding defintion");

		} catch (EncodingException e) {

			throw new SecurityException(e);

		}

	}

	public static String encodeSQL(Codec<?> codec, String item) throws SecurityException {

		return encoder.encodeForSQL(codec, item);

	}

	public String getValidSafeHTML(String text, int maxLength, boolean allowNull) throws SecurityException {

		try {

			return validator.getValidSafeHTML("safeHtml", text, maxLength, allowNull);

		} catch (Exception e) {

			throw new SecurityException(e);

		}

	}

}