/**
 * 
 */
package jp.rakugo.nii;

import java.io.*;
import java.text.*;
import java.util.*;
import java.util.regex.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * @author nii
 *
 */
public class HuriganaStore extends HttpServlet {
	public void doPost(HttpServletRequest request,
				HttpServletResponse response)
				throws ServletException, IOException {
		doGet(request, response);
	}
	public void doGet(HttpServletRequest request,
				HttpServletResponse response) 
				throws ServletException, IOException {

		CommonRakugo cmR = new CommonRakugo();
		ArrayList arrS = new ArrayList();
		ArrayList arrK = new ArrayList();
		int i;

		response.setContentType("text/xml; charset=utf-8");
		response.setHeader("Cache-Control", "no-cache");
		log(request);
		
		i = 0;
		while (request.getParameter("str" + i) != null) {
			arrS.add(request.getParameter("str" + i));
			arrK.add(request.getParameter("kana" + i));
			i++;
		}
		String mode = request.getParameter("mode");
		String db = request.getParameter("db");
		//JDBC接続
		cmR.connectJdbc6();
		//ふりがなマスタに格納する。
		for (i = 0; i < arrS.size(); i++) {
			if (mode.equals("store")) {
				storeHurigana(arrS.get(i).toString(), arrK.get(i).toString(), db);
			}
		}
		
		PrintWriter out = response.getWriter();
		StringBuffer strB = new StringBuffer();
		strB.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		strB.append("<data>");
		for (i = 0; i < arrS.size(); i++) {
			strB.append("<str>").append(arrS.get(i).toString()).append("</str>");
			strB.append("<kana>").append(arrK.get(i).toString()).append("</kana>");
		}
		strB.append("<db>").append(db).append("</db>");
		strB.append("</data>");
		out.println(strB.toString());
		out.close();
		out.flush();
		cmR.closeJdbc();
	}
	private void storeHurigana(String str, String kana, String db) {
		StringBuffer strB = new StringBuffer();
		int i, rtn;
		if (db.equals("kn")) {
			KanaMasterSelect kmS = new KanaMasterSelect();
			KanaMasterUpdate kmU = new KanaMasterUpdate();

			//格納項目セット
			kmU.initRec();
			kmU.setLetters(str);
			kmU.setKana(kana);
			kmU.setMemo("");

			//DB存在確認
			strB.append("WHERE letters = '").append(str);
			strB.append("' AND kana = '").append(kana);
			strB.append("'");
			kmS.selectDB(strB.toString(), "");
			if (kmS.getResultCount() > 0) {
				//DB既存ならカウンタ１up
				try {
					i = kmS.getCnt(0) + 1;
					kmU.setCnt(i);				
					//Rec更新
					rtn = kmU.updateRec();
				} catch (Exception e) {
					//桁溢れ？
				}
			} else {
				//格納項目セット
				kmU.setCnt(1);
				//Rec格納
				rtn = kmU.insertRec();
			}
		}
	}
	private void log(HttpServletRequest request) {
		try {
			ServletContext application = getServletConfig().getServletContext();
			StringBuffer sb = new StringBuffer();
			Calendar cal = Calendar.getInstance();
			java.util.Date dat = cal.getTime();
			SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM");
			SimpleDateFormat fmtH = new SimpleDateFormat("yy.MM/dd HH:mm:ss");
			String fNam = "HuriganaStore" + fmt.format(dat).toString() + ".log";
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
