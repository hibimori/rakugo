/**
 *
 */
package jp.rakugo.nii;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author nii
 *
 */
public class CalendarAssist extends HttpServlet {
/*
 *	日付の範囲を受けとって，その間の休日および
 *	VolIDがDBに存在する日付を返す。
 *		lo: yyyyMMdd
 *		hi: yyyyMMdd
 *		db: xx
 */
	private ArrayList arrH;		//休日リスト
	private ArrayList arrI;		//DB既存リスト
	private ArrayList arrG;		//取得日リスト
	private SimpleDateFormat dateFmt = new SimpleDateFormat("yyyyMMdd");
	private SimpleDateFormat dateFmt10 = new SimpleDateFormat("yyyy-MM-dd");

	public void doPost(HttpServletRequest request,
				HttpServletResponse response)
				throws ServletException, IOException {
		doGet(request, response);
	}
	public void doGet(HttpServletRequest request,
				HttpServletResponse response)
				throws ServletException, IOException {

		CommonRakugo cmR = new CommonRakugo();
		int i;
		arrH = new ArrayList();	//休日リスト初期化
		arrI = new ArrayList();	//DB既存リスト初期化
		arrG = new ArrayList();	//取得日リスト初期化

		response.setContentType("text/xml; charset=utf-8");
		response.setHeader("Cache-Control", "no-cache");
		log(request);
		String lo = cmR.convertNullToString(request.getParameter("lo"));
		String hi = cmR.convertNullToString(request.getParameter("hi"));
		String db = cmR.convertNullToString(request.getParameter("db"));
		String col = cmR.convertNullToString(request.getParameter("col"));
		//JDBC接続
		cmR.connectJdbc6();
		//日付範囲に存在するVolIDを日付に変換したリストを取得。
		getVolIdDates(lo, hi, db);
		//日付範囲に存在する取得日リストを取得。
		getGetDates(lo, hi, db);
		//JDBC切断
		cmR.closeJdbc();
		//日付範囲の休日リストを取得。
		getHolidays(lo, hi);

		PrintWriter out = response.getWriter();
		StringBuffer strB = new StringBuffer();
		strB.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		strB.append("<data>");
		for (i = 0; i < arrI.size(); i++) {
			strB.append("<volId>").append(arrI.get(i).toString());
			strB.append("</volId>");
		}
		for (i = 0; i < arrH.size(); i++) {
			strB.append("<holiday>").append(arrH.get(i).toString());
			strB.append("</holiday>");
		}
		for (i = 0; i < arrG.size(); i++) {
			strB.append("<getDate>").append(arrG.get(i).toString());
			strB.append("</getDate>");
		}
		strB.append("<lo>").append(lo).append("</lo>");
		strB.append("<hi>").append(hi).append("</hi>");
		strB.append("<db>").append(db).append("</db>");
		strB.append("<col>").append(col).append("</col>");
		strB.append("</data>");
		out.println(strB.toString());
		out.close();
		out.flush();
	}
	private void getVolIdDates(String lo, String hi, String db) {
		StringBuffer strId = new StringBuffer();
		StringBuffer strVolId = new StringBuffer();
//		ArrayList arrI = new ArrayList();
		int i;
		String loKey = lo.substring(2, 8);
		String hiKey = hi.substring(2, 8);
		if (Integer.parseInt(loKey) > Integer.parseInt(hiKey)) {
			// "991226" - "000205" のケース
			strId.append("WHERE id >= '").append(loKey);
			strId.append("' OR id <= '").append(hiKey);
			strId.append("' ORDER BY id");
			strVolId.append("WHERE vol_id >= '").append(loKey);
			strVolId.append("' OR vol_id <= '").append(hiKey);
			strVolId.append("' ORDER BY vol_id");
		} else {
			strId.append("WHERE id >= '").append(loKey);
			strId.append("' AND id <= '").append(hiKey);
			strId.append("' ORDER BY id");
			strVolId.append("WHERE vol_id >= '").append(loKey);
			strVolId.append("' AND vol_id <= '").append(hiKey);
			strVolId.append("' ORDER BY vol_id");
		}
		String volId = "";
		if (db.equals("pm")) {
			PlayerMasterSelect pms = new PlayerMasterSelect();
			pms.selectDB(strId.toString(), "");
			for (i = 0; i < pms.getResultCount(); i++) {
				volId = pms.getId(i);
				arrI.add(getYyyyMmDd(volId, null));
			}
		} else if (db.equals("tm")) {
			TitleMasterSelect tms = new TitleMasterSelect();
			tms.selectDB(strId.toString(), "");
			for (i = 0; i < tms.getResultCount(); i++) {
				volId = tms.getId(i);
				arrI.add(getYyyyMmDd(volId, null));
			}
		} else if (db.equals("bk")) {
			BookTableSelect bkt = new BookTableSelect();
			bkt.selectDB(strVolId.toString(), "");
			for (i = 0; i < bkt.getResultCount(); i++) {
				volId = getYyyyMmDd(bkt.getVolId(i), null);
				if (arrI.size() > 0) {
					if (! arrI.get(arrI.size() - 1).toString().equals(volId)) {
						arrI.add(volId);
					}
				} else {
					arrI.add(volId);
				}
			}
		} else if (db.equals("rk")) {
			RakugoTableSelect rkt = new RakugoTableSelect();
			rkt.selectDB(strVolId.toString(), "");
			for (i = 0; i < rkt.getResultCount(); i++) {
				volId = getYyyyMmDd(rkt.getVolId(i), null);
				if (arrI.size() > 0) {
					if (! arrI.get(arrI.size() - 1).toString().equals(volId)) {
						arrI.add(volId);
					}
				} else {
					arrI.add(volId);
				}
			}
		}
//		return arrI;
	}
	private void getGetDates(String lo, String hi, String db) {
		StringBuffer strDate = new StringBuffer();
		Calendar getCalendar = Calendar.getInstance();
		int i;
		String loKey = getYyyyMmDd(lo, null);
		String hiKey = getYyyyMmDd(hi, null);
		strDate.append("WHERE get_date >= '").append(loKey);
		strDate.append("' AND get_date <= '").append(hiKey);
		strDate.append("' ORDER BY get_date");

		String strGetDate = "";
		if (db.equals("bk")) {
			BookTableSelect bkt = new BookTableSelect();
			bkt.selectDB(strDate.toString(), "");
			for (i = 0; i < bkt.getResultCount(); i++) {
				getCalendar.setTime(bkt.getGetDate(i));
				strGetDate = getYyyyMmDd("", getCalendar);
				if (arrG.size() > 0) {
					if (! arrG.get(arrG.size() - 1).toString().equals(strGetDate)) {
						arrG.add(strGetDate);
					}
				} else {
					arrG.add(strGetDate);
				}
			}
		}
	}
	public String getYyyyMmDd(String s, Calendar d) {
	/*
	 *  引数s（String）のVolIdを日付文字列に変換する。
	 *  （yyMMdd→19yyMMdd, 20yyMMdd）
	 *  引数d（Date）を日付文字列に変換する。
	 *  （yyyy-MM-dd→yyyyMMdd）
	 */
		Calendar ymd = Calendar.getInstance();
		int yy, mm, dd;
		String str = "";
		if (d == null) {
			try {
				switch (s.length()) {
				case 6:
					yy = Integer.parseInt(s.substring(0, 2), 10);
					mm = Integer.parseInt(s.substring(2, 4), 10);
					dd = Integer.parseInt(s.substring(4, 6), 10);
					if (yy >= 70) {
						yy += 1900;
					} else {
						yy += 2000;
					}
					ymd.set(yy, mm - 1, dd);
					str = dateFmt.format(ymd.getTime());
					break;
				default:
					yy = Integer.parseInt(s.substring(0, 4), 10);
					mm = Integer.parseInt(s.substring(4, 6), 10);
					dd = Integer.parseInt(s.substring(6, 8), 10);
					ymd.set(yy, mm - 1, dd);
					str = dateFmt10.format(ymd.getTime());
					break;
				}
			} catch (Exception e) {
			}

		} else {
			ymd = d;
			str = dateFmt.format(ymd.getTime());
		}
		return str;
	}

	private void getHolidays(String lo, String hi) {
	/*
	 *	日付範囲に存在する休日を生成する（月単位）。
	 */
//		ArrayList arrR = new ArrayList();
		int wkY, wkM;
		int hiY, hiM;
		int od, eq;
		try {
			wkY = Integer.parseInt(lo.substring(0, 4), 10);
			wkM = Integer.parseInt(lo.substring(4, 6), 10);
			hiY = Integer.parseInt(hi.substring(0, 4), 10);
			hiM = Integer.parseInt(hi.substring(4, 6), 10);
			Calendar wkDate = Calendar.getInstance();
			wkDate.set(wkY, wkM - 1, 1, 0, 0, 0);
			Calendar hiDate = Calendar.getInstance();
			hiDate.set(hiY, hiM, 0, 0, 0, 0);
//			Calendar nwDate = Calendar.getInstance();
			while (wkDate.getTimeInMillis() <= hiDate.getTimeInMillis()) {
//				nwDate.set(wkY, wkM - 1, 1);
				switch (wkM) {
				case 1:		//１月
					//元日
					if (wkY >= 1948) {
						addArrH(wkY, wkM, 1, 1);
						/*
						nwDate.set(Calendar.DATE, 1);
						arrR.add(nwDate);
						*/
					}
					//成人の日
					if (wkY >= 2000) {
						addArrH(wkY, wkM, getHappyMonday(wkY, wkM, 2), 0);
						/*
						nwDate.set(Calendar.DATE,
							getHappyMonday(wkY, wkM, 2));
						arrR.add(nwDate);
						*/
					} else 	if (wkY >= 1948) {
						addArrH(wkY, wkM, 15, 1);
					}
					break;
				case 2:		//２月
					//建国記念の日
					if (wkY >= 1967) {
						addArrH(wkY, wkM, 11, 1);
					}
					break;
				case 3:		//３月
					//春分の日
					addArrH(wkY, wkM, getEquinoxDay(wkY, wkM), 1);
					/*
					nwDate.set(Calendar.DATE,
							getEquinoxDay(wkY, wkM));
					arrR.add(nwDate);
					*/
					break;
				case 4:		//４月
					//天皇誕生日・みどりの日
					if (wkY >= 1948) {
						addArrH(wkY, wkM, 29, 1);
					}
					break;
				case 5:		//５月
					//憲法記念日
					if (wkY >= 1986) {
						addArrH(wkY, wkM, 3, 0);
					} else 	if (wkY >= 1948) {
						addArrH(wkY, wkM, 3, 1);
					}
					if (wkY >= 2007) {
						//みどりの日・昭和の日
						addArrH(wkY, wkM, 4, 0);
					} else 	if (wkY >= 1986) {
						//国民の休日
						addArrH(wkY, wkM, 4, 2);
						/*
						if (nwDate.get(Calendar.DAY_OF_WEEK)
							!= Calendar.SUNDAY) {
							arrR.add(nwDate);
						}
						*/
					}
					//こどもの日
					if (wkY >= 2007) {
						addArrH(wkY, wkM, 5, 3);
					} else if (wkY >= 1948) {
						addArrH(wkY, wkM, 5, 1);
					}
					break;
				case 7:		//７月
					//海の日
					if (wkY >= 2003) {
						addArrH(wkY, wkM, getHappyMonday(wkY, wkM, 3), 0);
					} else if (wkY >= 1996) {
						addArrH(wkY, wkM, 20, 1);
					}
					break;
				case 8:		//８月
					//山の日
					if (wkY >= 2016) {
						addArrH(wkY, wkM, 11, 1);
					}
					break;
				case 9:		//９月
					od = getHappyMonday(wkY, wkM, 3);	//敬老の日
					eq = getEquinoxDay(wkY, wkM);		//秋分の日
					//敬老の日
					if (wkY >= 2003) {
						addArrH(wkY, wkM, od, 0);
					} else if (wkY >= 1948) {
						addArrH(wkY, wkM, 15, 1);
					}
					//秋分の日
					addArrH(wkY, wkM, eq, 1);
					//国民の休日
					if (wkY >= 1986) {
						if (eq - od == 2) {
							addArrH(wkY, wkM, eq - 1, 2);
						}
					}
					break;
				case 10:	//10月
					//体育の日
					if (wkY >= 2000) {
						addArrH(wkY, wkM, getHappyMonday(wkY, wkM, 2), 0);
					} else if (wkY >= 1966) {
						addArrH(wkY, wkM, 10, 1);
					}
					break;
				case 11:	//11月
					if (wkY >= 1948) {
						//文化の日
						addArrH(wkY, wkM, 3, 1);
						//勤労感謝の日
						addArrH(wkY, wkM, 23, 1);
					}
					break;
				case 12:	//12月
					//天皇誕生日
					if (wkY >= 1989) {
						addArrH(wkY, wkM, 23, 1);
				}
				}
				wkDate.add(Calendar.MONTH, 1);
				wkY = wkDate.get(Calendar.YEAR);
				wkM = wkDate.get(Calendar.MONTH) + 1;
			}
			/*
			//月曜振替
			j = arrR.size();
			for (i = 0; i < j; i++) {
				nwDate = (Calendar)arrR.get(i);
				if (nwDate.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
					nwDate.add(Calendar.DATE, 1);
					arrR.add(nwDate);
				}
			}
			//文字列化
			j = arrR.size();
			for (i = 0; i < j; i++) {
//				arrH.add(getYyyyMmDd(null, (Calendar)arrR.get(i)));
			}
			*/
		} catch (Exception e) {
			e.printStackTrace();
		}
//		return arrH;
	}
	private void addArrH(int y, int m, int d, int a) {
	/*
	 *	arrHに追加
	 *		a: 0: 月曜振替ナシ
	 *		   1: 月曜振替あり
	 *		   2: 国民の休日（日曜なら非休日）
	 *		   3: 平日振替あり
	 */
		Calendar calD = Calendar.getInstance();
		calD.set(y, m - 1, d);
		int wd = calD.get(Calendar.DAY_OF_WEEK);

		switch (a) {
		case 0:
			arrH.add(dateFmt.format(calD.getTime()));
			break;
		case 1:		//日曜なら月曜振替あり
			arrH.add(dateFmt.format(calD.getTime()));
			//月曜振替
			if (y >= 1973) {
				if (wd == Calendar.SUNDAY) {
					calD.add(Calendar.DATE, 1);
					arrH.add(dateFmt.format(calD.getTime()));
				}
			}
			break;
		case 2:		//日曜なら追加しない
			if (wd != Calendar.SUNDAY) {
				arrH.add(dateFmt.format(calD.getTime()));
			}
			break;
		case 3:		//直近の平日振替
			arrH.add(dateFmt.format(calD.getTime()));
			//直近平日振替（yy.5/6の場合）
			switch (wd) {
			case Calendar.SUNDAY:
			case Calendar.MONDAY:
			case Calendar.TUESDAY:
				calD.add(Calendar.DATE, 1);
				arrH.add(dateFmt.format(calD.getTime()));
			}
			break;
		}
	}
	private int getHappyMonday(int y, int m, int w) {
	/*
	 *	当月当週の月曜日の日を返す。
	 */
		Calendar toMonth = Calendar.getInstance();
		toMonth.set(y, m - 1, 1);
		int wd = toMonth.get(Calendar.DAY_OF_WEEK);
		int dd = (9 - wd) % 7 + 1;	//第１月曜日の日
		return dd + (w - 1) * 7;
	}
	private int getEquinoxDay(int y, int m) {
	/*
	 * 	春分の日・秋分の日の日を返す（1980-2099年有効）。
	 */
		float pS = 20.8431f;		//春分の日基本数
		float pA = 23.2488f;		//秋分の日基本数
		float pC = 0.242194f;		//共通の基本数
		float p;
		int c = (y - 1980) / 4;
		int d;

		if (m == 3) {
			p = pS;
		} else {
			p = pA;
		}
		d = (int)(p + pC * (y - 1980) - c);
		return d;
	}

	private void log(HttpServletRequest request) {
		try {
			ServletContext application = getServletConfig().getServletContext();
			StringBuffer sb = new StringBuffer();
			Calendar cal = Calendar.getInstance();
			java.util.Date dat = cal.getTime();
			SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM");
			SimpleDateFormat fmtH = new SimpleDateFormat("yy.MM/dd HH:mm:ss");
			String fNam = "CalendarAssist" + fmt.format(dat).toString() + ".log";
			FileWriter fw = new FileWriter(application.getRealPath(fNam), true);
			BufferedWriter bw = new BufferedWriter(fw, 10);
			sb.append(fmtH.format(dat).toString()).append("\t");
			sb.append(request.getServletPath()).append("\t");
			sb.append(request.getHeader("referer")).append("\t");
			sb.append(request.getHeader("user-agent")).append("\t");
			bw.write(sb.toString());
			bw.newLine();
			bw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
