package rapidex.common.util;

import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.ss.usermodel.Cell;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



/**
 * 공통 유틸
 */
@Component(value = "CommUtil")
public class CommUtil {
	
	
	private static final Logger logger = LoggerFactory.getLogger(CommUtil.class);
	/**
	 * 현재 일시에 해당하는 Calendar 객체를 반환함.
	 *
	 * <pre>
	 *  ex) Calendar cal = DateUtil.getCalendarInstance()
	 * </pre>
	 *
	 * @return 결과 calendar객체
	 */
	public static Calendar getCalendarInstance() {
		Calendar retCal = Calendar.getInstance();
		return retCal;
	}

	
	
	/**
	 * 입력한 년, 월, 일에 해당하는 Calendar 객체를 반환함. 일자를 바르게 입력하지않으면 엉뚱한 결과가 나타남..
	 *
	 * <pre>
	 *  ex) Calendar cal = DateUtil.getCalendarInstance(1982, 12, 02)
	 * </pre>
	 *
	 * @param year
	 *            년
	 * @param month
	 *            월
	 * @param date
	 *            일
	 * @return 결과 calendar객체
	 */
	public static Calendar getCalendarInstance(int year, int month, int date) {
		Calendar retCal = Calendar.getInstance();
		month--;

		retCal.set(year, month, date);

		return retCal;
	}

	/**
	 * 입력한 년, 월, 일, 시, 분, 초에 해당하는 Calendar 객체를 반환함.<br>
	 * 일자를 바르게 입력하지않으면 엉뚱한 결과가 나타남..
	 *
	 * <pre>
	 *  ex) Calendar cal = DateUtil.getCalendarInstance(1982, 12, 02, 12, 59, 59)
	 * </pre>
	 *
	 * @param year
	 *            년
	 * @param month
	 *            월
	 * @param date
	 *            일
	 * @param hour
	 *            시₩
	 * @param minute
	 *            분
	 * @param second
	 *            초
	 * @return 결과 calendar객체
	 */
	public static Calendar getCalendarInstance(int year, int month, int date,
			int hour, int minute, int second) {
		Calendar retCal = Calendar.getInstance();
		month--;

		retCal.set(year, month, date, hour, minute, second);

		return retCal;
	}

	/**
	 * calendar에 해당하는 일자를 type의 날짜형식으로 반환합니다.<br>
	 * 타입의 형식을 반드시 지켜야 합니다.<br>
	 * (자세한 사항은 SimpleDateFormat java document 참조.)
	 *
	 * <pre>
	 *  ex) Calendar cal = DateUtil.getCalendarInstance(1982, 12, 02, 12, 59, 59);
	 *      DateUtil.getDateFormat(cal, "yyyyMMddHHmmssSSS")
	 *      DateUtil.getDateFormat(cal, "yyyy-MM-dd hh:mm:ss")
	 *      DateUtil.getDateFormat(cal, "yyyy년MM월dd일 hh시mm분ss초")
	 * </pre>
	 *
	 * @param cal
	 *            calender객체
	 * @param type
	 *            변환타입
	 * @return 변환된 문자열
	 */
	public static String getDateFormat(Calendar cal, String type) {
		SimpleDateFormat dfmt = new SimpleDateFormat(type);
		return dfmt.format(cal.getTime());
	}

	/**
	 * 현재 일자를 입력된 type의 날짜로 반환합니다.<br>타입의 형식을 반드시 지켜야 합니다.<br>
	 * (자세한 사항은 SimpleDateFormat java document 참조.)
	 *
	 * <pre>
	 *  ex) DateUtil.getDateFormat("yyyyMMddHHmmssSSS")
	 *      DateUtil.getDateFormat("yyyy-MM-dd hh:mm:ss")
	 *      DateUtil.getDateFormat("yyyy년MM월dd일 hh시mm분ss초")
	 * </pre>
	 *
	 * @param type
	 *            날짜타입
	 * @return 결과 문자열
	 */
	public static String getDateFormat(String type) {
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat(type);
		return sdf.format(date);
	}

	/**
	 * Calender에 해당하는 날짜와 시각을 yyyyMMdd 형태로 변환 후 return.
	 *
	 * <pre>
	 *  ex) String date = DateUtil.getYyyymmdd()
	 * </pre>
	 *
	 * @param cal
	 *            Calender객체
	 * @return 결과 일자
	 */
	public static String getYyyymmdd(Calendar cal) {
		Locale currentLocale = new Locale("KOREAN", "KOREA");
		String pattern = "yyyyMMdd";
		SimpleDateFormat formatter = new SimpleDateFormat(pattern,
				currentLocale);
		return formatter.format(cal.getTime());
	}

	/**
	 * 현재 날짜와 시각을 yyyyMMddhhmmss 형태로 변환 후 return.
	 *
	 * <pre>
	 *
	 *  ex) String date = DateUtil.getCurrentDateTime()
	 * </pre>
	 *
	 * @return 현재 년월일시분초
	 */
	public static String getCurrentDateTime() {
		//자바 1.4 버전 현재 비스타에서 동작시 로컬타임을 잘못가져옴
		//표준시에서 9시간 차이나는것 만큼 표시해야 하는데..
		//비스타에서는 표준시로만 나타냅니다.
		//해결방안으로 setproperty를 추가합니다.
		// 2007.10.10 고재선
		System.setProperty("user.timezone", "Asia/Seoul");
		Date today = new Date();
		Locale currentLocale = new Locale("KOREAN", "KOREA");
		String pattern = "yyyyMMddHHmmss";
		SimpleDateFormat formatter = new SimpleDateFormat(pattern,
				currentLocale);
		return formatter.format(today);
	}

	/**
	 * 현재 시각을 hhmmss 형태로 변환 후 return.
	 *
	 * <pre>
	 *  ex) String date = DateUtil.getCurrentDateTime()
	 * </pre>
	 *
	 * @return 현재 시분초
	 */
	public static String getCurrentTime() {
		Date today = new Date();
		Locale currentLocale = new Locale("KOREAN", "KOREA");
		String pattern = "HHmmss";
		SimpleDateFormat formatter = new SimpleDateFormat(pattern,
				currentLocale);
		return formatter.format(today);

	}

	/**
	 * 현재 날짜를 yyyyMMdd 형태로 변환 후 return.
	 *
	 * <pre>
	 *
	 *  ex) String date = DateUtil.getCurrentDate()
	 * </pre>
	 *
	 * @return 현재 년월일
	 */
	public static String getCurrentDate() {
		return getCurrentDateTime().substring(0, 8);
	}
	
	/**
	 * 현재 날짜를 yyyy-MM-dd 형태로 변환 후 return.
	 *
	 * <pre>
	 *
	 *  ex) String date = DateUtil.getCurrentDate()
	 * </pre>
	 *
	 * @return 현재 년월일
	 */
	public static String getCurrentDateYYYYMMDD() {
		return getCurrentDateTime().substring(0, 4)+"-"+getCurrentDateTime().substring(4, 6)+"-"+getCurrentDateTime().substring(6, 8);
	}

	
	/**
     * 입력된 일자를 더한 날짜를 yyyyMMdd 형태로 변환 후 return.
     *
     *
     * @param yyyymmdd
     *            기준일자
     * @param addDay
     *            추가일
     * @return 연산된 일자
     * @see java.util.Calendar
     */
    public static String getDate(String yyyymmdd, int addDay) {
        Calendar cal = Calendar.getInstance(Locale.FRANCE);
        int new_yy = Integer.parseInt(yyyymmdd.substring(0, 4));
        int new_mm = Integer.parseInt(yyyymmdd.substring(4, 6));
        int new_dd = Integer.parseInt(yyyymmdd.substring(6, 8));

        cal.set(new_yy, new_mm - 1, new_dd);
        cal.add(Calendar.DATE, addDay);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
       
        return sdf.format(cal.getTime());
        
        // TODO
    }
    
    
	/**
	 * 년월주로 일자를 구하는 메소드.
	 *
	 * <pre>
	 *  ex) String date = DateUtil.getWeekToDay("200801" , 1, "yyyyMMdd")
	 * </pre>
	 *
	 * @param yyyymm
	 *            년월
	 * @param week
	 *            몇번째 주
	 * @param pattern
	 *            리턴되는 날짜패턴 (ex:yyyyMMdd)
	 * @return 연산된 날짜
	 * @see java.util.Calendar
	 */
	public static String getWeekToDay(String yyyymm, int week, String pattern) {

		Calendar cal = Calendar.getInstance(Locale.FRANCE);

		int new_yy = Integer.parseInt(yyyymm.substring(0, 4));
		int new_mm = Integer.parseInt(yyyymm.substring(4, 6));
		int new_dd = 1;

		cal.set(new_yy, new_mm - 1, new_dd);

		// 임시 코드
		if (cal.get(cal.DAY_OF_WEEK) == cal.SUNDAY) {
			week = week - 1;
		}

		cal.add(Calendar.DATE, (week - 1) * 7
				+ (cal.getFirstDayOfWeek() - cal.get(Calendar.DAY_OF_WEEK)));

		SimpleDateFormat formatter = new SimpleDateFormat(pattern,
				Locale.FRANCE);

		return formatter.format(cal.getTime());

	}

	/**
	 * 지정된 플래그에 따라 calendar에 해당하는 연도 , 월 , 일자를 연산한다.<br>
	 * (calendar객체의 데이터는 변하지 않는다.)
	 *
	 * <pre>
	 *  ex) Calendar cal = DateUtil.getCalendarInstance(1982, 12, 02, 12, 59, 59)
	 *      String date = DateUtil.getComputeDate(java.util.Calendar.MONTH , -10, cal);
	 *      결과 : 19820202
	 * </pre>
	 *
	 * @param field
	 *            연산 필드
	 * @param amount
	 *            더할 수
	 * @param cal
	 *            연산 대상 calendar객체
	 * @return 연산된 날짜
	 * @see java.util.Calendar
	 */
	public static String getComputeDate(int field, int amount, Calendar cal) {
		Calendar cpCal = (Calendar) cal.clone();
		cpCal.add(field, amount);
		return getYyyymmdd(cpCal);
	}

	/**
	 * 지정된 플래그에 따라 현재의 연도 , 월 , 일자를 연산한다.
	 *
	 * <pre>
	 *  ex) DateUtil.getComputeDate(java.util.Calendar.MONTH , 10);
	 *      결과 : 19820202
	 * </pre>
	 *
	 * @param field
	 *            연산 필드
	 * @param amount
	 *            더할 수
	 * @return 연산된 날짜
	 * @see java.util.Calendar
	 */
	public static String getComputeDate(int field, int amount) {
		return getComputeDate(field, amount, CommUtil.getCalendarInstance());
	}

	/**
	 * 입력된 일자를 더한 주를 구하여 return한다
	 *
	 * <pre>
	 *  ex) int date = DateUtil.getWeek(DateUtil.getCurrentYyyymmdd() , 0)
	 * </pre>
	 *
	 * @param yyyymmdd
	 *            년도별
	 * @param addDay
	 *            추가일
	 * @return 연산된 주
	 * @see java.util.Calendar
	 */
	public static int getWeek(String yyyymmdd, int addDay) {
		Calendar cal = Calendar.getInstance(Locale.FRANCE);
		int new_yy = Integer.parseInt(yyyymmdd.substring(0, 4));
		int new_mm = Integer.parseInt(yyyymmdd.substring(4, 6));
		int new_dd = Integer.parseInt(yyyymmdd.substring(6, 8));

		cal.set(new_yy, new_mm - 1, new_dd);
		cal.add(Calendar.DATE, addDay);

		int week = cal.get(Calendar.DAY_OF_WEEK);
		return week;
	}

	/**
	 * 입력된 년월의 마지막 일수를 return 한다.
	 *
	 * <pre>
	 *  ex) int date = DateUtil.getLastDayOfMon(2008 , 1)
	 * </pre>
	 *
	 * @param year
	 *            년
	 * @param month
	 *            월
	 * @return 마지막 일수
	 * @see java.util.Calendar
	 */
	public static int getLastDayOfMon(int year, int month) {

		Calendar cal = Calendar.getInstance();
		cal.set(year, month, 1);
		return cal.getActualMaximum(Calendar.DAY_OF_MONTH);

	}// :

	/**
	 * 입력된 년월의 마지막 일수를 return한다
	 *
	 * <pre>
	 *  ex) int date = DateUtil.getLastDayOfMon("2008")
	 * </pre>
	 *
	 * @param yyyymm
	 *            년월
	 * @return 마지막 일수
	 */
	public static int getLastDayOfMon(String yyyymm) {

		Calendar cal = Calendar.getInstance();
		int yyyy = Integer.parseInt(yyyymm.substring(0, 4));
		int mm = Integer.parseInt(yyyymm.substring(4)) - 1;

		cal.set(yyyy, mm, 1);
		return cal.getActualMaximum(Calendar.DAY_OF_MONTH);
	}

	/**
	 * 입력된 날자가 올바른지 확인합니다.
	 *
	 * <pre>
	 *  ex) boolean b = DateUtil.isCorrect("20080101")
	 * </pre>
	 *
	 * @param yyyymmdd
	 * @return boolean
	 */
	public static boolean isCorrect(String yyyymmdd) {
		boolean flag = false;
		if (yyyymmdd.length() < 8)
			return false;
		try {
			int yyyy = Integer.parseInt(yyyymmdd.substring(0, 4));
			int mm = Integer.parseInt(yyyymmdd.substring(4, 6));
			int dd = Integer.parseInt(yyyymmdd.substring(6));
			flag = CommUtil.isCorrect(yyyy, mm, dd);
		} catch (Exception ex) {
			return false;
		}
		return flag;
	}

	/**
	 * 입력된 날자가 올바른 날자인지 확인합니다.
	 *
	 * <pre>
	 *  ex) boolean b = DateUtil.isCorrect(2008,1,1)
	 * </pre>
	 *
	 * @param yyyy
	 * @param mm
	 * @param dd
	 * @return boolean
	 */
	public static boolean isCorrect(int yyyy, int mm, int dd) {
		if (yyyy < 0 || mm < 0 || dd < 0)
			return false;
		if (mm > 12 || dd > 31)
			return false;

		String year = "" + yyyy;
		String month = "00" + mm;
		String year_str = year + month.substring(month.length() - 2);
		int endday = CommUtil.getLastDayOfMon(year_str);

		if (dd > endday)
			return false;

		return true;

	}//:

	/**
	 * 현재의 요일을 구한다.
	 *
	 * <pre>
	 *  ex) int day = DateUtil.getDayOfWeek()
	 *      SUNDAY    = 1
	 *      MONDAY    = 2
	 *      TUESDAY   = 3
	 *      WEDNESDAY = 4
	 *      THURSDAY  = 5
	 *      FRIDAY    = 6
	 * </pre>
	 *
	 * @return 요일
	 * @see java.util.Calendar
	 */
	public static int getDayOfWeek() {
		Calendar rightNow = Calendar.getInstance();
		int day_of_week = rightNow.get(Calendar.DAY_OF_WEEK);
		return day_of_week;
	}//:

	
    /**
     * 입력받은 날짜의 요일을 반환한다.
     * @param yyyymmdd
     * @return
     */
    public static int getDayOfWeek(String yyyymmdd) {
        Calendar cal = Calendar.getInstance(Locale.KOREA);
        int new_yy = Integer.parseInt(yyyymmdd.substring(0, 4));
        int new_mm = Integer.parseInt(yyyymmdd.substring(4, 6));
        int new_dd = Integer.parseInt(yyyymmdd.substring(6, 8));

        cal.set(new_yy, new_mm - 1, new_dd);

        int day_of_week = cal.get(Calendar.DAY_OF_WEEK);
        return day_of_week;
    }//:
    
    

	/**
	 * 현재주가 올해 전체의 몇째주에 해당되는지 계산한다.
	 *
	 * <pre>
	 *  ex) int day = DateUtil.getWeekOfYear()
	 * </pre>
	 *
	 * @return 주
	 * @see java.util.Calendar
	 */
	public static int getWeekOfYear() {
		Locale LOCALE_COUNTRY = Locale.KOREA;
		Calendar rightNow = Calendar.getInstance(LOCALE_COUNTRY);
		int week_of_year = rightNow.get(Calendar.WEEK_OF_YEAR);
		return week_of_year;
	}//:

	/**
	 * 입력받은 yyyymmdd 가 전체의 몇주에 해당되는지 계산한다.
	 * @param yyyymmdd
	 * @return 주
	 */
    public static int getWeekOfYear(String yyyymmdd) {
        Calendar cal = Calendar.getInstance(Locale.KOREA);
        int new_yy = Integer.parseInt(yyyymmdd.substring(0, 4));
        int new_mm = Integer.parseInt(yyyymmdd.substring(4, 6));
        int new_dd = Integer.parseInt(yyyymmdd.substring(6, 8));

        cal.set(new_yy, new_mm - 1, new_dd);

        int week = cal.get(Calendar.WEEK_OF_YEAR);
        return week;
    }//:

    
    
    /**
     * 현재주가 현재월에 몇째주에 해당되는지 계산한다.
     *
     * <pre>
     *  ex) int day = DateUtil.getWeekOfMonth()
     * </pre>
     *
     * @return 주
     * @see java.util.Calendar
     */
    public static int getWeekOfMonth() {
        Locale LOCALE_COUNTRY = Locale.KOREA;
        Calendar rightNow = Calendar.getInstance(LOCALE_COUNTRY);
        int week_of_month = rightNow.get(Calendar.WEEK_OF_MONTH);
        return week_of_month;
    }//:

    
	/**
	 * 입력받은 yyyymmdd 해당월에 몇째주에 해당되는지 계산한다.
	 *
	 * <pre>
	 *  ex) int day = DateUtil.getWeekOfMonth("20110401")
	 * </pre>
	 *
	 * @return 주
	 * @see java.util.Calendar
	 */
	public static int getWeekOfMonth(String yyyymmdd) {

        Calendar cal = Calendar.getInstance(Locale.KOREA);
        int new_yy = Integer.parseInt(yyyymmdd.substring(0, 4));
        int new_mm = Integer.parseInt(yyyymmdd.substring(4, 6));
        int new_dd = Integer.parseInt(yyyymmdd.substring(6, 8));
    
        cal.set(new_yy, new_mm - 1, new_dd);
    
        int week = cal.get(Calendar.WEEK_OF_MONTH);
        return week;
    
	}//:
	



	/**
	 * 두 날짜간의 날짜수를 반환(윤년을 감안함)
	 *
	 * <pre>
	 *  ex) long date = DateUtil.getDifferDays("20080101", "20080202")
	 * </pre>
	 *
	 * @param startDate
	 *            시작 날짜
	 * @param endDate
	 *            끝 날짜
	 * @return 날수
	 * @see java.util.GregorianCalendar
	 */
	public static long getDifferDays(String startDate, String endDate) {
		GregorianCalendar StartDate = getGregorianCalendar(startDate);
		GregorianCalendar EndDate = getGregorianCalendar(endDate);
		long difer = (EndDate.getTime().getTime() - StartDate.getTime()
				.getTime()) / 86400000;
		return difer;
	}//:



	   /**
     * 두 시간에 대한 차리를 분 단위로 계산한다.
     * @param startDate yyyyMMddHHmmss
     * @param endDAte yyyyMMddHHmmss
     * @return 차이 분
     */
    public static long getDifferMin(String startDate, String endDAte){
        
        try {
            Date frDate = new SimpleDateFormat("yyyyMMddHHmmss").parse(startDate);
            Date toDate = new SimpleDateFormat("yyyyMMddHHmmss").parse(endDAte);
            
            long diffMil = toDate.getTime() - frDate.getTime();
            long diffSec = diffMil/1000;
            long  Min = (diffSec) / 60;
            
            if(Min < 0){
                Min = Min*-1;
            }
            
            return Min;
            
        } catch (ParseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return -1;
        }

    }//:
    

	/**
	 * 두 날짜간의 월수를 반환
	 *
	 * <pre>
	 *  ex) long date = DateUtil.getDifferMonths("20080101", "20080202")
	 * </pre>
	 *
	 * @param startDate
	 *            시작 날짜
	 * @param endDate
	 *            끝 날짜
	 * @return 월수
	 * @see java.util.GregorianCalendar
	 */
	public static int getDifferMonths(String startDate, String endDate) {
        GregorianCalendar cal1 = getGregorianCalendar(startDate);
        GregorianCalendar cal2 = getGregorianCalendar(endDate);
        
        int m = cal1.get(Calendar.YEAR) - cal2.get(Calendar.YEAR);
        int months = (m * 12) + (cal1.get(Calendar.MONTH) - cal2.get(Calendar.MONTH));
        return Math.abs(months);
	}//:


	/**
	 * GregorianCalendar 객체를 반환함.
	 *
	 * <pre>
	 *  ex) Calendar cal = DateUtil.getGregorianCalendar(DateUtil.getCurrentYyyymmdd())
	 * </pre>
	 *
	 * @param yyyymmdd
	 *            날짜 인수
	 * @return GregorianCalendar
	 * @see java.util.Calendar
	 * @see java.util.GregorianCalendar
	 */

	private static GregorianCalendar getGregorianCalendar(String yyyymmdd) {

		int yyyy = Integer.parseInt(yyyymmdd.substring(0, 4));
		int mm = Integer.parseInt(yyyymmdd.substring(4, 6));
		int dd = Integer.parseInt(yyyymmdd.substring(6));

		GregorianCalendar calendar = new GregorianCalendar(yyyy, mm - 1, dd, 0,
				0, 0);

		return calendar;

	}//:
	
	
	
	
	/**
	 * 날짜 형식 출력
	 * <p/>
	 * yyyy-MM-dd 형식
	 *
	 * @param date 대상 날짜
	 * @return 문자열
	 */
	public  String formatDate(Timestamp date) {
		if (date == null) {
			return "";
		}

		SimpleDateFormat format = new SimpleDateFormat("yyyy.MM.dd");


		return format.format(date);
	}
	
	/**
	 * 날짜 형식 출력
	 * <p/>
	 * yyyy-MM-dd HH:mm:ss 형식
	 *
	 * @param date 대상 날짜
	 *
	 * @return 문자열
	 */
	public  String formatDateWithTime(Timestamp date) {
		if (date == null) {
			return "";
		}

		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		return format.format(date);
	}
	/**
	 * 날짜 형식 출력
	 *
	 * @param date 대상 날짜 문자열
	 * @param separator 구분자
	 *
	 * @return formatted date string
	 */
	public  String formatDate(String date, String separator) {
		if (date == null || date.length() != 8) {
			return "";
		}
		if (separator == null) {
			separator = ". ";
		}

		StringBuilder sb = new StringBuilder();
		sb.append(date.substring(0, 4))
			.append(separator)
			.append(date.substring(4, 6))
			.append(separator)
			.append(date.substring(6, 8));
		return sb.toString();
	}
	
	/**
	 * {@code URLDecoder}를 이용하여 decoding된 URL을 반환한다.
	 *
	 * @param url 대상 문자열
	 *
	 * @return decoding된 URL
	 */
	public  String decodeURL(String url) {
		String decodedURL = "";

		if (StringUtils.isNotEmpty(url)) {
			try {
				decodedURL = URLDecoder.decode(url, "UTF-8");
			} catch (UnsupportedEncodingException e) {

			}
		}

		return decodedURL;
	}

	/**
	 * nvl
	 * <p/>
	 * value값이 null이면 replacement를 리턴하고,
	 * value값이 null이 아니면 value값을 리턴한다.
	 *
	 * @param value 원래 문자열
	 * @param replacement 치환문자열
	 *
	 * @return 결과문자열
	 */
	public  String nvl(String value, String replacement) {
		if (value == null || "".equals(value)) {
			return replacement;
		}
		return value;
	}
	
	/**
	 * nvl0
	 * <p/>
	 * value값이 null이거나 '0'이면 replacement를 리턴하고,
	 * value값이 null이 아니면 value값을 리턴한다.
	 *
	 * @param value 원래 문자열
	 * @param replacement 치환문자열
	 *
	 * @return 결과문자열
	 */
	public  String nvl0(String value, String replacement) {
		if (value == null || "".equals(value) || "0".equals(value)) {
			return replacement;
		}
		return value;
	}

	/**
	 * 문자열로부터 HTML/XML 태그를 제거함
	 *
	 * @param message
	 *
	 * @return String message without XML or HTML
	 */
	public  String stripHTMLTags(String message) {
		String noHTMLString = message.replaceAll("\\<.*?\\>", "");
		return noHTMLString;
	}
	
	/**
	 * 정규화 표현식을 문자열로 변환
	 * @param str
	 * @return
	 */
	public static  String codeToStr(String str) {
		str = str.replaceAll("&lt;", "<")
		 		 .replaceAll("&gt;", ">")
		 		 .replaceAll("&#039;", "'")
		 		 .replaceAll("&#034;", "\"")
		 		 .replaceAll("&amp;", "&");
		
		return str;
	}
	
	/**
	 * 문자열을 정규화 표현식으로 변환
	 * @param str
	 * @return
	 */
	public static String strToCode(String str) {
		str = str.replaceAll("&", "&amp;")
		 		 .replaceAll("<", "&lt;")
		 		 .replaceAll(">", "&gt;")
		 		 .replaceAll("'", "&#039;")
		 		 .replaceAll("\"", "&#034;");
		
		return str;
	}
	/**
	 * 문자열 길이만큼 줄임
	 *
	 * @param content 문자열
	 * @param length 길이
	 *
	 * @return 잘린 문자열
	 */
	public  String getFitString(String content, int length) {
		if (content == null) {
			return "";
		}
		String tmp = content;
		int slen = 0;
		int blen = 0;
		if (tmp.getBytes().length > length) {
			while (blen + 1 < length && slen < tmp.length()) {
				char c = tmp.charAt(slen);
				blen++;
				slen++;
				if (c > '\177') {
					blen++;
				}
			}
			tmp = tmp.substring(0, slen);
			if (content.length() > tmp.length()) {
				tmp += "...";
			}
		}
		return tmp;
	}
	
	/**
	 * 소문자 -> 대문자로 변경
	 *
	 * @param str {@code String}
	 * @return 대문자 반환
	 */
	public  String toUpperCase(String str) {
		if (StringUtils.isNotEmpty(str)) {
			return str.toUpperCase();
		}
		return "";
	}

	/**
	 * 대문자 -> 소문자로 변경
	 * @param str {@code String}
	 * @return 소문자 반환
	 */
	public  String toLowerCase(String str) {
		if (StringUtils.isNotEmpty(str)) {
			return str.toLowerCase();
		}
		return "";
	}
	
    /**
     * CLOB로 되어 있는 것을 String 으로 변경한다.
     * @param clob
     * @return
     */
	public static String getStringFromCLOB(java.sql.Clob clob) {
		StringBuffer sbf = new StringBuffer();
		java.io.Reader br = null;
		char[] buf = new char[1024];
		int readcnt;
		try {
			br = clob.getCharacterStream();
			while ((readcnt = br.read(buf, 0, 1024)) != -1) {
				sbf.append(buf, 0, readcnt);
			}
		} catch (Exception e) {

		} finally {
			if (br != null)
				try {
					br.close();
				} catch (IOException e) {

				}
		}
		return sbf.toString();
	}
    
	/**
	 * 이름을 숨길때 사용
	 * 예) 홍길동  ==> 홍○동
	 * 
	 * @param name
	 * @return
	 */
	public  String getHiddenName(String name) {
		String tmp = "";
		
		if(name.length() > 1) {
			tmp = name.substring(0, 1) + "○" + name.substring(2);
		} else {
			tmp = name;
		}
		
		return tmp;
	}
	
	/**
	 * Compute the hash value to check for "real person" submission.
	 * 
	 * @param  value  the entered value
	 * @return  its hash value
	 */
	public String rpHash(String value) {
		int hash = 5381;
		value = value.toUpperCase();
		for(int i = 0; i < value.length(); i++) {
			hash = ((hash << 5) + hash) + value.charAt(i);
		}
		return String.valueOf(hash);
	}
	
	
	/**
	 * 만 20세 이상인지 확인
	 * 
	 * @param year 년
	 * @param month 월 (1~12)
	 * @param day 일
	 * 
	 * @return 만 20세 이상인지 여부
	 */
	public boolean isOver20Years(int year, int month, int day) {
		Calendar birthday = Calendar.getInstance();
		birthday.set(Calendar.YEAR, year);
		birthday.set(Calendar.MONTH, month-1);
		birthday.set(Calendar.DAY_OF_MONTH, day);
		
		// 14년전 오늘 Calendar
		Calendar theday = Calendar.getInstance();
		theday.add(Calendar.YEAR, -19);

		return birthday.before(theday);
	}

	
	/**
	 * 주민번호를 받아서 생년월일(yyyyMMdd)을 리턴한다.
	 * 
	 * @param ssn 주민번호
	 * @return 생년월일
	 */
	public String getBirth8(String ssn) {
		if (ssn == null) {
			//"ssn is null."
			return null;
		}
		if (ssn.length() < 7) {
			//ssn.length()
			return null;
		}
		String prefix = "20";
		char sexCode = ssn.charAt(6);
		if (sexCode == '1' || sexCode == '2' ||
				sexCode == '5' || sexCode == '6') {
			prefix = "19";
		}
		return prefix + ssn.substring(0, 6);
	}
	
		
    /**
     * 응답을 HTML로 보낸다.
     *
     * @param response 응답
     * @param data HTML DATA
     */
	public static  void outHTML(HttpServletResponse response, String data, String charset) {
        charset = (charset == null) ? "utf-8" : charset;
        response.setContentType("text/html; charset=" + charset);
        //response.setStatus(response.SC_OK);  // 정상
        
        response.setStatus(HttpServletResponse.SC_OK);  // 정상
        
        printToClient(response, data, charset);
    }//:
    
    /**
     * data를 응답으로 보낸다.
     *
     * @param response 웹응답
     * @param data 응답데이타
     * @param charset 문자셋
     */
    public static  void printToClient(HttpServletResponse response, String data, String charset) {
        PrintWriter out = null;

        try {
            out = new PrintWriter(response.getWriter());
            out.print(data);
            out.flush();
        } catch (Exception e) {
            response.setStatus(500); 
            logger.error(e.getMessage());
        } finally {
            if (out != null)
                out.close();
        }
    }
    
    /**
     * alert 메시지 전송후 메인으로 이동
     * @param response
     * @param message
     * @param backyn
     * @throws Exception
     */
    public void sendAlertMsg(HttpServletResponse response, String message) throws Exception {

    	String sContents = "";

    	response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();							
		
		try {
			sContents = "<script type='text/javascript'>";
			sContents += "alert('" + message + "');";
			sContents += "location.href='/index.go';";
			sContents += "</script>";
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
		}
		
		out.println(sContents);
		out.close();	

	}
    
    /**
     * alert 메시지 전송후 url 로 이동
     * @param response
     * @param message
     * @param url
     * @throws Exception
     */
    public static void sendAlertMsg(HttpServletResponse response, String message, String url) throws Exception {

    	String sContents = "";

    	response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();							
		
		try {
			sContents = "<script type='text/javascript'>";
			sContents += "alert('" + message + "');";
			sContents += "location.href='"+url+"';";
			sContents += "</script>";
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
		}
		
		out.println(sContents);
		out.close();	

	}

    public void sendAlert(HttpServletResponse response, String message) throws Exception {

    	String sContents = "";

    	response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();							
		
		try {
			sContents = "<script type='text/javascript'>";
			sContents += "alert('" + message + "');";
			sContents += "</script>";
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
		}
		
		out.println(sContents);
		out.close();	
    }

    /**
     * 난수 생성
	 * @param scerno 난수영역 시작 값
	 * @param ecerno 난수영역 끝 값
	 * @return 생성된 난수
	 * @throws Exception
	 */
	public int makeRandomInt(int scerno , int ecerno) throws Exception {
		int result = 0;
		double cerno_range = ecerno - scerno +1; 
    
		try{
    		Random randomGenerator = new Random();
			result= (int) (randomGenerator.nextDouble() * cerno_range + scerno);
		}catch(Exception e){
			e.getStackTrace();
			logger.error(e.getMessage());
		}
		return result;
	}
	
	
	/**
	 * request 정보 로그 출력
	 * @param request
	 */
	@SuppressWarnings("rawtypes")
	public void logforRequestParameter(HttpServletRequest request){
		
	 Map map = request.getParameterMap();
	 Iterator it = map.keySet().iterator();
	 Object key = null;
	 String[] value = null;

	 while(it.hasNext()){
		  key = it.next();
		  value = (String[]) map.get(key);
		  for(int i = 0 ; i < value.length; i++) {
			  logger.info("key ==> " + key +  " value ===> " +value[i]  + " index i ==> " + i);
		  }
	 }

	}
	
	/**
	 * shell 명령어 실행
	 * @param ContentsDwonloadPath
	 * @param url
	 * @return
	 * @throws Exception
	 */
	public boolean callShellCommand(String ContentsDwonloadPath, String url) throws Exception {
		
		boolean result = true;
		String command  = ContentsDwonloadPath + "getContents.sh " + ContentsDwonloadPath + "temp.html " + url + " "+ ContentsDwonloadPath + "temputf8.html";
		
		logger.debug("************************");
		logger.debug("command  ==> {}", command);
		logger.debug("************************");
		
		java.lang.Runtime runTime = java.lang.Runtime.getRuntime();
		java.lang.Process process = runTime.exec(command);
		logger.info(process.waitFor()+"");
		
		BufferedReader br = new BufferedReader(new InputStreamReader(process.getInputStream()));
		for(String str;(str = br.readLine())!=null;){
			logger.info(str);
		}
		  
		if(process.exitValue()!=0){
			logger.error("************************");
			logger.error("셀이 정상종료 되지 않았습니다.");
			logger.error("************************");
			result = false;
		}
		
		logger.debug("************************");
		logger.debug("프로그램 종료");
		logger.debug("************************");
		
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	public static boolean isEmpty(Object obj)
	{
		if( obj instanceof String ) return obj==null || "".equals(obj.toString().trim());
		else if( obj instanceof List ) return obj==null || ((List<?>)obj).isEmpty();
		else if( obj instanceof Map ) return obj==null || ((Map)obj).isEmpty();
		else if( obj instanceof Object[] ) return obj==null || Array.getLength(obj)==0;
		else return obj==null;
	}

	public static boolean isNotEmpty(Object obj)
	{
		return !isEmpty(obj);
	}
	
	public static boolean isEquals(Object sobj, Object tobj)
	{
		if(CommUtil.isNotEmpty(sobj))
		{
			return sobj.equals(tobj);
		}
		return false;
	}
	public static boolean isNotEquals(Object sobj, Object tobj)
	{
		return !isEquals(sobj,tobj);
	}
	
	public static String subString(String str, int start, int end)
	{
		return str.substring(start, end);	
	}
	
	
    /**
     * joson JSONObject를  response에 전달한다.
     * @param response
     * @param jsononject
     * @param resultcode 결과코드 200 정상 500 에러 etc...
     * @throws Exception
     */
    public static void sendjson(HttpServletResponse response, JSONObject jsononject ,int resultcode) throws Exception {

    	response.setContentType("application/json");
    	response.setCharacterEncoding("UTF-8");
    	response.setStatus(resultcode);
    	PrintWriter out = response.getWriter();							
		
		try {
			out.println(jsononject.toString());
			out.close();	
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	}
    
    /**
     * joson JSONArray를  response에 전달한다.
     * @param response
     * @param jsononarry
     * @param resultcode 결과코드 200 정상 500 에러 etc...
     * @throws Exception
     */
    public void sendjson(HttpServletResponse response, JSONArray jsononarry , int resultcode) throws Exception {

    	response.setContentType("application/json");
    	response.setCharacterEncoding("UTF-8");
    	response.setStatus(resultcode);
		PrintWriter out = response.getWriter();							
		
		try {
			out.println(jsononarry.toString());
			out.close();	
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	}
    
    /**
     * 
     * convertMapToObject
     *
     * 개발: sja
     * @date 2014. 4. 22. : 오후 4:09:10
     * file : CommUtil.java 
     * @param map
     * @param objClass
     * @return
     */
    @SuppressWarnings("rawtypes")
	public static Object convertMapToObject(Map map, Object objClass){
        String keyAttribute = null;
        String setMethodString = "set";
        String methodString = null;
        Iterator itr = map.keySet().iterator();
        while(itr.hasNext()){

            keyAttribute = (String) itr.next();
            methodString = setMethodString+keyAttribute.substring(0,1).toUpperCase()+keyAttribute.substring(1);
            try {
                Method[] methods = objClass.getClass().getDeclaredMethods();
                
                for(int i=0;i<=methods.length-1;i++){
                	
                    if(methodString.equals(methods[i].getName())){
                    	
                    	  if(map.get(keyAttribute) instanceof Boolean )
                    	  {
                    		  if((boolean) map.get(keyAttribute))
                    		  {
                    			  methods[i].invoke(objClass, true);
                    		  }else{
                    			  methods[i].invoke(objClass, false);
                    		  }
                    	  }
//                    	  else if((map.get(keyAttribute) instanceof ArrayList)){
//		               		methods[i].invoke(objClass, (ArrayList)map.get(keyAttribute));
//		            	  }
                    	  else if(!(map.get(keyAttribute) instanceof ArrayList))
                    	  {
                    		  if(map.get(keyAttribute) == null){
                    			  methods[i].invoke(objClass, "");
                    		  }
                    		  else
                    		  {
                                  methods[i].invoke(objClass, map.get(keyAttribute).toString());
                    		  }
                    	  }
                    }
                }
            } catch (SecurityException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            } catch (InvocationTargetException e) {
                e.printStackTrace();
            }
        }
        return objClass;
    }
    
    /**
     * 
     * ConverObjectToMap
     *
     * 개발: sja
     * @date 2014. 4. 22. : 오후 4:09:18
     * file : CommUtil.java 
     * @param obj
     * @return
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map ConverObjectToMap(Object obj){
        try {
            //Field[] fields = obj.getClass().getFields(); //private field는 나오지 않음.
            Field[] fields = obj.getClass().getDeclaredFields();
            Map resultMap = new HashMap();
            for(int i=0; i<=fields.length-1;i++){
                fields[i].setAccessible(true);
                resultMap.put(fields[i].getName(), fields[i].get(obj));
            }
            
            logger.debug("resultMap[{}]" , resultMap);
            
            return resultMap;
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return null;
    }

	/**
	 * 렌덤 스트링 생성 
	 * @return
	 */
	public static String getUUID(){
		UUID uuid = UUID.randomUUID();
		return uuid.toString();
	}
	
	/**
	 * 
	 * @desc Excel의 Cell value를 리턴한다.  
	 *
	 * @author lws
	 * @date 2014. 5. 23. : 오후 3:10:53
	 * @file CommUtil.java 
	 * @package genexon.comm.util
	 * @return String 
	 * @param cell
	 * @return
	 * @throws Exception

	 */
	public static String getExcelCellValue(Cell cell)throws Exception {
		
		String pv  = "";
		
		try 
		{
			switch (cell.getCellType())
			{
				case Cell.CELL_TYPE_STRING:
						
					pv = (cell.getStringCellValue().toString().replace(" ", "").trim());
					break;
				case Cell.CELL_TYPE_NUMERIC:
					
					if (HSSFDateUtil.isCellDateFormatted(cell)){  
				        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");  
				        pv = formatter.format(cell.getDateCellValue()); 
				    } 
					else if (org.apache.poi.ss.usermodel.DateUtil.isCellDateFormatted(cell))
					{
						pv = (cell.getDateCellValue().toString());
					}
					else
					{					 
						cell.setCellType(Cell.CELL_TYPE_STRING);
						pv = (cell.getStringCellValue().toString().replace(" ", "").trim());
						//pv =   Double.toString(cell.getNumericCellValue());
					}
					break;
				case Cell.CELL_TYPE_BOOLEAN:
	
					pv = String.valueOf((cell.getBooleanCellValue()));
						break;
				case Cell.CELL_TYPE_FORMULA:
									
						pv = (cell.getCellFormula());
						break;
				default:
					pv = (cell.getDateCellValue().toString());
			}
		} catch (Exception  e) {
		    throw e;
		}
		return pv;
	}
	
	
	/**
	 * @desc 숫자인지 여부 리턴
	 * @author SonJooArm
	 * @date 2014. 6. 16.
	 * @file CommUtil.java 
	 * @package genexon.comm.util
	 * @return boolean 
	 * @param s
	 * @return
	 */
	public static boolean isStringDouble(String s) {
        try {
            Double.parseDouble(s);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
	}
	
    public static Object convJonObjToPojo(JSONObject jobj, Class<?> c){
        
        
        return JSONObject.toBean(jobj, c);
    } 

    

    /**
     * @desc JSONObject to Pojo
     * @author SonJooArm
     * @date 2014. 7. 25.
     * @file CommUtil.java 
     * @package genexon.comm.util
     * @return Object 
     * @param map
     * @param objClass
     * @return
     */
    @SuppressWarnings("rawtypes")
    public static Object convertJSONToObject(JSONObject json, Object objClass){
        String keyAttribute = null;
        String setMethodString = "set";
        String methodString = null;
        Iterator itr = json.keySet().iterator();
        while(itr.hasNext()){

            keyAttribute = (String) itr.next();
            methodString = setMethodString+keyAttribute.substring(0,1).toUpperCase()+keyAttribute.substring(1);
            try {
                Method[] methods = objClass.getClass().getDeclaredMethods();
                
                for(int i=0;i<=methods.length-1;i++){
                    
                    if(methodString.equals(methods[i].getName())){
                        
                          if(json.get(keyAttribute) instanceof Boolean )
                          {
                              if((boolean) json.get(keyAttribute))
                              {
                                  methods[i].invoke(objClass, true);
                              }else{
                                  methods[i].invoke(objClass, false);
                              }
                          }
//                        else if((map.get(keyAttribute) instanceof ArrayList)){
//                          methods[i].invoke(objClass, (ArrayList)map.get(keyAttribute));
//                        }
                          else if(!(json.get(keyAttribute) instanceof ArrayList))
                          {
                              if(json.get(keyAttribute) == null){
                                  methods[i].invoke(objClass, "");
                              }
                              else
                              {
                                  methods[i].invoke(objClass, json.get(keyAttribute).toString());
                              }
                          }
                    }
                }
            } catch (SecurityException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            } catch (InvocationTargetException e) {
                e.printStackTrace();
            }
        }
        return objClass;
    }
    
    /**
     * @param JSONObject
     * @apiNote JSONObject를 Map<String, String> 형식으로 변환처리.
     * @return Map<String,String>
     * **/
    @SuppressWarnings("unchecked")
    public static Map<String, Object> getMapFromJsonObject(JSONObject jsonObj){
        Map<String, Object> map = null;
        
        try {
           map = new ObjectMapper().readValue(jsonObj.toString(), Map.class);
        } catch (JsonParseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (JsonMappingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return map;
    }


	
	/**
	 * 렌덤 스트링 생성('-' 제외한 문자만)
	 * @return
	 */
	public static String getUUIDExceptDash(){
		UUID uuid = UUID.randomUUID();
		return uuid.toString().replaceAll("-", "");
	}
	
	
	/**
	 * base64 to imgFile
	 * @author jjt
	 * @since 2019.11.05
	 */
	public static void base64ToImg(String base64, String path) throws Exception{
		if(base64.indexOf(",") > -1){
			base64 = base64.split(",")[1];
		}
		byte[] data = Base64.decodeBase64(base64);
		OutputStream stream = null;
		try {
			stream = new FileOutputStream(path);
		    stream.write(data);
		}catch (Exception e) {
			logger.error(e.getMessage());
		}finally {
			if(stream!=null)	stream.close();
		}
	}
	
//	public static JSONArray JsonFromObject(Object obj){
//	    JSONArray rtnArr = JSONArray.fromObject(obj);
//	    
//	    for(int i=0;i<rtnArr.size();i++)
//	    {
//	        JsonConfig.DEFAULT_JSON_VALUE_PROCESSOR_MATCHER
//	        rtnArr.fromObject(arg0, arg1)
//	    }
//	}
	
	/**
	 * HttpURLConnection으로 ERP 데이터 받아오기(JSONObject 형식)
	 * @param erp_synk_url
	 * @return JSONObject
	 */
	public static JSONObject getApiData(String apiUrl, String reqMethod, Map<String, String> paramMap) throws IOException, Exception {
		JSONObject jsonObj = new JSONObject();
		BufferedReader bReader = null;
		OutputStream os = null;
		OutputStreamWriter writer = null;
		int HttpResult = 0;
		String param = "";
		
		try {
			URL conUrl = new URL(apiUrl);
			
			if(apiUrl.contains("https://")) {
				logger.info("Https URLConnection!");
				HttpsURLConnection connection = (HttpsURLConnection) conUrl.openConnection();
				
				connection.setHostnameVerifier(new HostnameVerifier() {
					@Override
					public boolean verify(String hostname, SSLSession session) {
						return false;
					}
				});
				
				// SSL setting  
				SSLContext context = SSLContext.getInstance("TLS");  
				context.init(null, null, null);  // No validation for now  
				connection.setSSLSocketFactory(context.getSocketFactory());
				
				connection.setRequestProperty("dataType", "json");
				connection.setDoInput(true);            // 입력스트림 사용여부
		        connection.setDoOutput(true);            // 출력스트림 사용여부
		        connection.setUseCaches(false);        // 캐시사용 여부
		        connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
		        connection.setReadTimeout(10000);        // 타임아웃 설정 ms단위
		        connection.setRequestMethod(reqMethod);  // or GET
		        
				os = connection.getOutputStream();
				writer = new OutputStreamWriter(os);
				
				Iterator<String> iterator = paramMap.keySet().iterator();
				while (iterator.hasNext()) {
			        String key = iterator.next();
			        if(null != paramMap.get(key) && !"null".equals(paramMap.get(key).toString())){
			        	writer.write("&"+key+"="+URLEncoder.encode(paramMap.get(key).toString(), "UTF-8"));
			        }else{
			        	writer.write("&"+key+"="+"");
			        }
			    }
				
				writer.flush();
				
				HttpResult = connection.getResponseCode();
				
				StringBuilder stringBuilder = new StringBuilder();
				logger.info("connection Code = " + HttpResult);
				
				if( HttpResult == HttpURLConnection.HTTP_OK ) {
					bReader = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
					String line = null;
					while( (line = bReader.readLine()) != null ) {
						stringBuilder.append(line + "\n");
					}
					
					param = stringBuilder.toString();
					jsonObj = (JSONObject) JSONObject.fromObject(param);
					
				} else {
					logger.info("connection.getResponseMessage()="+connection.getResponseMessage());
				}
			}else{
				logger.info("Http URLConnection!");
				HttpURLConnection connection = (HttpURLConnection) conUrl.openConnection();
				connection.setRequestProperty("Content-Type", "application/json; utf-8");
//				connection.setRequestProperty("dataType", "json");
				connection.setRequestProperty("Accept", "application/json");
				connection.setDoInput(true);            // 입력스트림 사용여부
		        connection.setDoOutput(true);            // 출력스트림 사용여부
		        connection.setUseCaches(false);        // 캐시사용 여부
		        // connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
		        
		        connection.setReadTimeout(10000);        // 타임아웃 설정 ms단위
		        connection.setRequestMethod(reqMethod);  // or GET
		        
				os = connection.getOutputStream();
				writer = new OutputStreamWriter(os);
				String jsonstring = new ObjectMapper().writeValueAsString(paramMap);
				jsonstring = new String(jsonstring.getBytes("UTF-8"), "EUC-KR");
				
				/*				
				Iterator<String> iterator = paramMap.keySet().iterator();
				while (iterator.hasNext()) {
			        String key = iterator.next();
			        if(null != paramMap.get(key) && !"null".equals(paramMap.get(key).toString())){
			        	writer.write("&"+key+"="+URLEncoder.encode(paramMap.get(key).toString(), "UTF-8"));
			        }else{
			        	writer.write("&"+key+"="+"");
			        }
			    }
			    */
				writer.write(jsonstring);
				
				writer.flush();
				
				HttpResult = connection.getResponseCode();
				
				StringBuilder stringBuilder = new StringBuilder();
				logger.info("connection Code = " + HttpResult);
				
				if( HttpResult == HttpURLConnection.HTTP_OK ) {
					bReader = new BufferedReader(new InputStreamReader(connection.getInputStream(), "EUC-KR"));
					String line = null;
					while( (line = bReader.readLine()) != null ) {
						stringBuilder.append(line + "\n");
					}
					param = stringBuilder.toString();
					logger.debug("param ==> ");
					logger.debug(param);
					logger.debug("param <== ");
					jsonObj = (JSONObject) JSONObject.fromObject(param);
//					JSONParser parser  = new JSONParser();
//					jsonObj = (JSONObject) parser.parse(param);
					logger.debug("jsonObj ==> ");
					logger.debug(jsonObj.toString());
					logger.debug("jsonObj <== ");
				} else {
					logger.info("connection.getResponseMessage()="+connection.getResponseMessage());
				}
			}
			
		}catch(IOException ioe) {
			return null;
		}catch(Exception e) {
			return null;
		}finally {
			if(bReader != null) bReader.close();
			if(writer != null) writer.close();
			if(os != null) os.close();
		}
		
		return jsonObj;
	}
	
	/**
	 * Base64 데이터 정해진 byte[]로 변환
	 * @author jjt
	 * @since 2018.08.27
	 */
	public static synchronized byte[] base64ToByteArr(String base64) {

		String str = base64;
		byte[] imageBytes = null;
		if(base64 != null) {

			if(base64.indexOf("base64") != -1) {
				str = str.split(",")[1];
			}

			imageBytes = DatatypeConverter.parseBase64Binary(str);
		}


		return imageBytes;
	}
	
	/**
	 * 공통 Error, Info 메시지 내용에 해당하는 문자열을 Replace 한다.
	 * @param msg 메시지내용
	 * @param val Replace 할 Object(숫자 문자 및 단건)
	 * @return Replace 된 메시지 내용
	 */
	public static String parseMessage(String msg, Object val){
		
	String[] vals = {val.toString()};
	
	return parseMessage(msg, vals);
	}
}