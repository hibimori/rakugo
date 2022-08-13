/**
 * 
 */
package jp.rakugo.nii;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import jakarta.servlet.*;
import jakarta.servlet.http.*;

/**
 * @author nii
 *
 */
public class FullNameSet extends HttpServlet {
	public void doPost(HttpServletRequest request,
				HttpServletResponse response)
				throws ServletException, IOException {
		doGet(request, response);
	}
	public void doGet(HttpServletRequest request,
				HttpServletResponse response) 
				throws ServletException, IOException {

		response.setContentType("text/xml; charset=utf-8");
		response.setHeader("Cache-Control", "no-cache");
		log(request);
		String last = request.getParameter("last");
		String first = request.getParameter("first");
		String full = request.getParameter("full");
		String sw = request.getParameter("sw");
		String id = request.getParameter("id");

		String fullname = getFullName(last, first, full, sw);

		PrintWriter out = response.getWriter();
		StringBuffer strB = new StringBuffer();
		strB.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		strB.append("<data>");
		strB.append("<fullname>").append(fullname).append("</fullname>");
		strB.append("<id>").append(id).append("</id>");
		strB.append("</data>");
		out.println(strB.toString());
		
		out.close();
		out.flush();
	}
	private String getFullName(String last, String first,
			String full, String sw) {
		StringBuffer stB = new StringBuffer("");
		String n1, n2, n3;
		int i, l, p;
		if (sw.equals("A")) {
			n1 = last.trim();
			n2 = "";
			n3 = first.trim();
		} else {
			n1 = first.trim();
			n2 = "";
			n3 = last.trim();
		}
		Pattern pat;
		Matcher mat;
		//FullNameの分解
		String eachName[] = full.split(" ");
		//MiddleNameの抽出
		switch (eachName.length) {
		case 0:
			return "";
		case 1:
			//姓除去
			pat = Pattern.compile(n1);
			mat = pat.matcher(full);
			n2 = mat.replaceFirst("");
			//名除去
			pat = Pattern.compile(n3);
			mat = pat.matcher(n2);
			n2 = mat.replaceFirst("");
			break;
		default:
			//姓除去
			for (i = 0; i < eachName.length; i++) {
				if (eachName[i].equals(n1)) {
					eachName[i] = "";
					break;
				}
			}
			//名除去
			for (i = 0; i < eachName.length; i++) {
				if (eachName[i].equals(n3)) {
					eachName[i] = "";
					break;
				}
			}
			//MiddleName抽出
			for (i = 0; i < eachName.length; i++) {
				if (! eachName[i].equals("")) {
					n2 += " " + eachName[i];
				}
			}
			break;
		}
		//姓名連結
		String eachName2[] = {n1, n2.trim(), n3};
		pat = Pattern.compile("[a-zA-Z0-9]");
		for (i = 0; i < eachName2.length; i++) {
			if (stB.toString().equals("")) {
				stB.append(eachName2[i]);
			} else {
				if (! eachName2[i].equals("")) {
					l = stB.toString().length();
					try {
						if ((pat.matcher(stB.toString().substring(l - 1, l)).find()) ||
							(pat.matcher(eachName2[i].substring(0, 1)).find())) {
							stB.append(" ");
						}
					} catch (Exception e) {
					}
					stB.append(eachName2[i]);
				}
			}
		}
		return stB.toString();
	}
	private void log(HttpServletRequest request) {
		try {
			ServletContext application = getServletConfig().getServletContext();
			StringBuffer sb = new StringBuffer();
			Calendar cal = Calendar.getInstance();
			java.util.Date dat = cal.getTime();
			SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM");
			SimpleDateFormat fmtH = new SimpleDateFormat("yy.MM/dd HH:mm:ss");
			String fNam = "HuriganaSearch" + fmt.format(dat).toString() + ".log";
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
