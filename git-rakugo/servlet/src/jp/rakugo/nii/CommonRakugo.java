/**
 *
 */
package jp.rakugo.nii;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.DriverManager;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.ResourceBundle;
import java.util.regex.Pattern;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

/**
 * @author nii
 *
 */
public class CommonRakugo implements Serializable {

	static Connection db = null;		//JSP共通のConnection
	CommonForm cmF = new CommonForm();	//JSP共通Form部品

	public CommonRakugo() {}	//コンストラクタ

	public String getComputerName(String uri) {
	//uri中のドメインをコンピュータ名に変換
		String[] aryIP = {
			"localhost",
			"192.168.255.1", "192.168.255.2", "192.168.255.3",
			"192.168.255.4", "192.168.255.5", "192.168.255.6",
			"192.168.255.7", "192.168.255.8", "192.168.255.9",
			"192.168.255.10", "192.168.255.11", "192.168.255.12",
			"192.168.255.13", "192.168.255.14", "192.168.255.15",
			"192.168.255.100"};
		String[] aryHost = {
			"localhost",
			"AMALTHEA", "GANYMADE", "IO",
			"HIMALLIA", "ANANKE", "ANANKE(air)",
			"HIMALLIA(air)", "reserved", "THEMISTO",
			"GANYMADE(air)", "CHALDENE", "HARPALYKE",
			"KALYKE", "AITNE", "reserved",
			"PASIPHAE"};
		for (int i = 0; i < aryIP.length; i++) {
			if (uri.toLowerCase().indexOf("http://" + aryIP[i]) >= 0) {
				return aryHost[i];
			}
		}
		return "unknown";		//ヒットなければ"unknown"
	}
	//JDBC接続と切断
	public void connectJdbc() {
		//Tomcat5.5
		try {
			ResourceBundle rb=ResourceBundle.getBundle("rakugodb");	/* Bundle */
			Class.forName(rb.getString("jdbc"));							/* Driver Load */
			db=DriverManager.getConnection(rb.getString("con"));	/* DB接続 */
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public void connectJdbc6() {
		//Tomcat6
		try {
			Context ctx = new InitialContext();
			DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/rakugo_db");
			db = ds.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public Connection getJdbc() {
		return db;
	}
	public void closeJdbc() {
		try {
			db.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public String convertNullToString(String str) {
	//文字列がnullなら""に置換して返す。以外はtrimする。
		if (str == null) {
			return "";
		} else {
			return str.trim();
		}
	}
	public String convertNullToZeroString(String str) {
	//文字列がnullまたは""ならzero文字に置換して返す。以外はtrimする。
		try {
			if ((str == null) || (str.equals(""))) {
				return "0";
			} else {
				String s = str.trim();
				int i = Integer.parseInt(s);	//数値変換できなければ例外
				return s;
			}
		} catch (Exception e) {
			return "0";
		}
	}
	public int convertNullToZeroInt(int i) {
	//非数値ならzeroに置換して返す。
		try {
			return i += 0;
		} catch (Exception e) {
			return 0;
		}
	}
	public float convertNullToZeroFloat(float i) {
		//非数値ならzeroに置換して返す。
			try {
				return i += 0;
			} catch (Exception e) {
				return 0;
			}
		}
	public String convertNullToDateString(String str) {
	//文字列がnullまたは""なら"0000-00-00"に置換して返す。
		try {
			if ((str == null) || (str.equals(""))) {
				return "0000-00-00";	//あり得ない日付
			} else {
				String s = str.trim();
				return s;
			}
		} catch (Exception e) {
			return "0000-00-00";
		}
	}
	public int convertATo1(String str) {
	//１桁英字サインを数値に変換して返す。
	//		A:1, Z:26
		String strABC = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		int i = strABC.indexOf(str);
		if (i < 0) {
			i = 0;
		}
		return i;
	}
	public String addUri(String str, String uri) {
	//<a>タグで囲んで返す。
		String strResult = "";
		if ((str.trim().equals("")) || (uri.trim().equals(""))) {
			strResult = str.trim();
		} else {
			strResult = "<a href='" + uri.trim() + "' target='niin'>";
			strResult += str.trim() + "</a>";
		}
		return strResult;
	}
	public String fixDateFormat(String str) {
	//strを"yyyy-MM-dd"形式に整える。
		SimpleDateFormat dateFmt =
			new SimpleDateFormat("yyyy-MM-dd");
		try {
			return dateFmt.format(convertStringToDate(str));
		} catch (Exception e) {
			return "";
		}
	}
	public java.util.Date convertStringToDate(String str) {
	//strをDateに変換（yyyy-MM-dd）。
		try {
			int y = -1;
			int m = -1;
			int d = -1;

			Calendar today = Calendar.getInstance();
			Pattern pat = Pattern.compile("[^0-9]+");
			String[] strs = pat.split(str);	//y, m, dに分離
			pat = Pattern.compile("[0-9]+");
			String[] sprs = pat.split(str);	/* separater収集
											(y.m/d)のとき {"",".","/"} になる。 */
			switch (strs.length) {
			case 0:
				return null;
			case 1:
				d = Integer.parseInt(strs[0]);
				break;
			case 2:
				if (sprs[1].equals(".")) {
					y = Integer.parseInt(strs[0]);
					m = Integer.parseInt(strs[1]);
				} else {
					m = Integer.parseInt(strs[0]);
					d = Integer.parseInt(strs[1]);
				}
				break;
			default:
				if ((sprs[1].equals(".")) && (! sprs[2].equals("."))) {
				// yyyy.MM/dd
					y = Integer.parseInt(strs[0]);
					m = Integer.parseInt(strs[1]);
					d = Integer.parseInt(strs[2]);
				} else if ((! sprs[1].equals(".")) && (sprs[2].equals("."))) {
				// MM/dd.yyyy
					y = Integer.parseInt(strs[2]);
					m = Integer.parseInt(strs[0]);
					d = Integer.parseInt(strs[1]);
				} else {
				// yyyy/MM/dd
					y = Integer.parseInt(strs[0]);
					m = Integer.parseInt(strs[1]);
					d = Integer.parseInt(strs[2]);
				}
				break;
			}
			if (y >= 0) {
				if (y < 70) {
					y += 2000;
				} else if (y < 100) {
					y += 1900;
				}
				today.set(Calendar.YEAR, y);
			}
			if (m >= 0) {
				today.set(Calendar.MONTH, m - 1);
			}
			if (d >= 0) {
				today.set(Calendar.DATE, d);
			}
			return today.getTime();
		} catch (Exception e) {
			return null;
		}
	}

	public String fixTimeFormat(String str, String mode) {
	//strを"H:mm:ss"形式に整える。
		SimpleDateFormat timeFmtHMS =
				new SimpleDateFormat("H:mm:ss");
		SimpleDateFormat timeFmtHM =
				new SimpleDateFormat("H:mm");
		SimpleDateFormat timeFmtMS =
				new SimpleDateFormat("m:ss");
		try {
			java.util.Date dt = convertStringToTime(str, mode);

			if (mode.toUpperCase().equals("HM")) {
				return timeFmtHM.format(dt);
			} else 	if (mode.toUpperCase().equals("MS")) {
				return timeFmtMS.format(dt);
			} else {
				return timeFmtHMS.format(dt);
			}
		} catch (Exception e) {
			return "";
		}
	}
	public java.util.Date convertStringToTime(String str, String mode) {
	//strをDateに変換（H:mm:ss）。
		try {
			int h = -1;
			int m = -1;
			int s = -1;

			Calendar today = Calendar.getInstance();
			Pattern pat = Pattern.compile("[^0-9]+");
			String[] strs = pat.split(str);	//h, m, sに分離
			switch (strs.length) {
			case 0:
				return null;
			case 1:
				if (mode.toUpperCase().indexOf("S") >= 0) {
					s = Integer.parseInt(strs[0]);
				} else {
					m = Integer.parseInt(strs[0]);
				}
				break;
			case 2:
				if (mode.toUpperCase().indexOf("S") >= 0) {
					m = Integer.parseInt(strs[0]);
					s = Integer.parseInt(strs[1]);
				} else {
					h = Integer.parseInt(strs[0]);
					m = Integer.parseInt(strs[1]);
				}
				break;
			default:
				h = Integer.parseInt(strs[0]);
				m = Integer.parseInt(strs[1]);
				s = Integer.parseInt(strs[2]);
				break;
			}
			if (h >= 0) {
				today.set(Calendar.HOUR_OF_DAY, h);
			}
			if (m >= 0) {
				today.set(Calendar.MINUTE, m);
			}
			if (s >= 0) {
				today.set(Calendar.SECOND, s);
			}
			return today.getTime();
		} catch (Exception e) {
			return null;
		}
	}

	public String fixCurFormat(float f, String s) {
	//fを"#,##0""#,##0.00"形式に整える。
		DecimalFormat curFmt = new DecimalFormat("#,##0");
		DecimalFormat curFmt2 = new DecimalFormat("#,##0.00");
		String arrCur[] = {"$", "US"};
		try {
			for (int i = 0; i < arrCur.length; i++) {
				if (arrCur[i].equals(s.toUpperCase())) {
					return curFmt2.format(f);
				}
			}
			return curFmt.format(f);
		} catch (Exception e) {
			return "0";
		}
	}
	public String convertCurLetter(String s, String sw) {
	//"\"⇔"JP", "$"⇔"US"変換。
		String arrCountry[] = {"JP", "US"};
		String arrCurrency[] = {"\\", "$"};
		if (sw.equals("$U")) {
			//"$"→"US"
			for (int i = 0; i < arrCountry.length; i++) {
				if (arrCurrency[i].equals(s)) {
					return arrCountry[i];
				}
			}
			return s;
		} else {
			//"US"→"$"
			for (int i = 0; i < arrCountry.length; i++) {
				if (arrCountry[i].equals(s.toUpperCase())) {
					return arrCurrency[i];
				}
			}
			return s.toUpperCase();
		}
	}
	public String concatNames(String n1, String np1,
			String n2, String np2,
			String n3, String np3, String ns, String sp) {
	//３名を接続文字で結ぶ。
		String arrNames[] = {n1, n2, n3};
		String arrParts[] = {np1, np2, np3};
		StringBuffer stB = new StringBuffer();

		for (int i = 0; i < arrNames.length; i++) {
			if (! arrNames[i].equals("")) {
				if (! stB.toString().equals("")) {
					stB.append(sp);	//接続文字（"・"）
				}
				stB.append(arrNames[i]);
				if (! arrParts[i].equals("")) {
					stB.append("<span class='fontSmall'>（");
					stB.append(arrParts[i]);
					stB.append("）</span>");
				}
			}
		}
		if (ns.equals("1")) {
			stB.append("<span class='fontSmall'>ほか</span>");
		}
		return stB.toString();
	}
}
