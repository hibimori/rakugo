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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author nii
 *
 */
public class HuriganaSearch extends HttpServlet {
	public void doPost(HttpServletRequest request,
				HttpServletResponse response)
				throws ServletException, IOException {
		doGet(request, response);
	}
	public void doGet(HttpServletRequest request,
				HttpServletResponse response) 
				throws ServletException, IOException {

		CommonRakugo cmR = new CommonRakugo();
		ArrayList arrK = new ArrayList();
		ArrayList arrP = new ArrayList();
		int i, j;

		response.setContentType("text/xml; charset=utf-8");
		response.setHeader("Cache-Control", "no-cache");
		log(request);
		String str = request.getParameter("str");
		String id = request.getParameter("id");
		String db = request.getParameter("db");
		//JDBC接続
		cmR.connectJdbc6();
		//DBを完全一致検索して既存のふりがなを求める
		arrK = getHurigana(str, db);
		

		if (arrK.size() == 0) {
			//DBになければカナかな変換
			arrP = convertKataToHira(str);
			arrK.add(arrP.get(0).toString());
		}
		
		PrintWriter out = response.getWriter();
		StringBuffer strB = new StringBuffer();
		strB.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		strB.append("<data>");
		strB.append("<str>").append(str).append("</str>");
		for (i = 0; i < arrK.size(); i++) {
			strB.append("<hurigana>").append(arrK.get(i).toString());
			strB.append("</hurigana>");
		}
		strB.append("<id>").append(id).append("</id>");
		strB.append("<db>").append(db).append("</db>");
		//ふりがなをかな・かな以外でパーツ分けする。
		//arrP[0]はふりがな全体
		for (i = 1; i < arrP.size(); i++) {
			//パーツ毎のふりがなを求める。
			str = arrP.get(i).toString();
			arrK = getHurigana(str, "kn");
			strB.append("<part><pstr>").append(str).append("</pstr>");
			for (j = 0; j < arrK.size(); j++) {
				strB.append("<pkana>").append(arrK.get(j).toString());
				strB.append("</pkana>");
			}
			strB.append("</part>");
		}
		strB.append("</data>");
		out.println(strB.toString());
		out.close();
		out.flush();
		cmR.closeJdbc();
	}
	private ArrayList getHurigana(String str, String db) {
		StringBuffer strB = new StringBuffer();
		ArrayList arrK = new ArrayList();
		int i;
		if (db.equals("pm")) {
			strB.append("WHERE last_name = '").append(str);
			strB.append("' OR first_name = '").append(str);
			strB.append("' OR family_name = '").append(str);
			strB.append("'");
			PlayerMasterSelect pms = new PlayerMasterSelect();
			pms.selectDB(strB.toString(), "");
			if (pms.getResultCount() > 0) {
				if (pms.getLastName(0).equals(str)) {
					arrK.add(pms.getLastSort(0));
				} else if (pms.getFirstName(0).equals(str)) {
					arrK.add(pms.getFirstSort(0));
				} else {
					arrK.add(pms.getFamilySort(0));
				}
			}
		} else if (db.equals("tm")) {
			strB.append("WHERE title = '").append(str);
			strB.append("' OR subtitle = '").append(str);
			strB.append("'");
			TitleMasterSelect tms = new TitleMasterSelect();
			tms.selectDB(strB.toString(), "");
			if (tms.getResultCount() > 0) {
				if (tms.getTitle(0).equals(str)) {
					arrK.add(tms.getTitleSort(0));
				} else {
					arrK.add(tms.getSubtitleSort(0));
				}
			}
		} else if (db.equals("bk")) {
			strB.append("WHERE title = '").append(str);
			strB.append("'");
			BookTableSelect bkt = new BookTableSelect();
			bkt.selectDB(strB.toString(), "");
			if (bkt.getResultCount() > 0) {
				arrK.add(bkt.getTitleSort(0));
			}
		} else if (db.equals("rk")) {
			strB.append("WHERE title = '").append(str);
			strB.append("'");
			RakugoTableSelect rkt = new RakugoTableSelect();
			rkt.selectDB(strB.toString(), "");
			if (rkt.getResultCount() > 0) {
				arrK.add(rkt.getMemo(0));
			}
		} else if (db.equals("kn")) {
			strB.append("WHERE letters = '").append(str);
			strB.append("' ORDER BY cnt DESC, kana");
			KanaMasterSelect knm = new KanaMasterSelect();
			knm.selectDB(strB.toString(), "");
			for (i = 0; i < knm.getResultCount(); i++) {
				arrK.add(knm.getKana(i));
			}
		}
		return arrK;
	}
	public ArrayList convertKataToHira(String str) {
	/* 引数s（文字列）のカタカナをひらがなに変換する。
	*/
		String tblKata[] = {
				"アカサタナハマヤラワガザダバパァャヮ",
                "イキシチニヒミイリヰギジヂビピィ",
                "ウクスツヌフムユルウグズヅブプゥッュヴ",
                "エケセテネヘメエレヱゲゼデベペェ",
                "オコソトノホモヨロヲゴゾドボポォョン"};
		String tblHira[] = {
				"あかさたなはまやらわがざだばぱぁゃゎ",
                "いきしちにひみいりいぎじぢびぴぃゐ",
                "うくすつぬふむゆるうぐずづぶぷぅっゅぶ",
                "えけせてねへめえれえげぜでべぺぇゑ",
                "おこそとのほもよろをごぞどぼぽぉょん"};
		String strC = ",.・_＿/／?？!！&＆“”+＋-－＊[]";
		boolean hit;
		int dan = 0;		//母音の段
		int p;
		int i, j;
		String c = "";
		StringBuffer b = new StringBuffer();
		StringBuffer bp = new StringBuffer();
		String prvChar = "";
		//記号類を除去
		Pattern pat = Pattern.compile("[　，、．。\'\"「」『』()（）［］【】]");
		Matcher mat = pat.matcher(str);
		String strwk = mat.replaceAll(" ");
		//正規表現の指定でエラーになる文字を消す。
		hit = true;
		j = 0;
		while (hit == true) {
			hit = false;
			for (i = j; i < strwk.length(); i++) {
				c = strwk.substring(i, i + 1);
				if (c.equals(".") || c.equals("*")) {
				//変な意味があるメタ文字は個別に消去。
					strwk = strwk.substring(0, i) + " "
						+ strwk.substring(i + 1, strwk.length());
					j = i;
					hit = true;
					break;
				} else {
					p = strC.indexOf(c);
					if (p >= 0) {
						strwk = strwk.replaceAll(c, " ");
						j = i;
						hit = true;
						break;
					}
				}
			}
		}
		//カナを探してかなに変換する。
		for (i = 0; i < strwk.length(); i++) {
			c = strwk.substring(i, i + 1);
			if (c.equals("ー")) {
			//長音記号なら直前文字の母音を採る。
				c = tblHira[dan].substring(0, 1);
				b.append(c);
			} else {
			//カナかな変換
				hit = false;
				for (j = 0; j < tblKata.length; j++) {
					p = tblKata[j].indexOf(c);
					if (p >= 0) {
						//ヒットしたらかなに置換
						c = tblHira[j].substring(p, p + 1);
						//長音記号のために母音を待避
						switch (j) {
						case 3:
							dan = 1;	//エ段はイ音を残す
							break;
						case 4:
							dan = 2;	//オ段はウ音を残す。
							break;
						default:
							dan = j;	//ア段・イ段・ウ段はそのまま
							break;
						}
						hit = true;
						break;
					}
				}
				b.append(c);
				if (hit == false) {
					//長音記号のためにひらがなの母音も待避
					hit = false;
					for (j = 0; j < tblHira.length; j++) {
						p = tblHira[j].indexOf(c);
						if (p >= 0) {
							switch (j) {
							case 3:
								dan = 1;	//え段はい音を残す
								break;
							case 4:
								dan = 2;	//お段はう音を残す。
								break;
							default:
								dan = j;	//あ段・い段・う段はそのまま
							break;
							}
							hit = true;
							break;
						}
					}
				}
			}
		}
		//ふりがなにかな以外が交じっていれば分離
		for (i = 0; i < b.toString().length(); i++) {
			c = b.toString().substring(i, i + 1);
			hit = false;
			for (j = 0; j < tblHira.length; j++) {
				p = tblHira[j].indexOf(c);
				if (p >= 0) {
					hit = true;
					break;
				}
			}
			if (hit == true) {
				if (prvChar.equals("K")) {
					//直前の文字がかな以外なら区切り文字のspaceをセット
					bp.append(" ");
				}
				prvChar = "H";
			} else {
				if (prvChar.equals("H")) {
					//直前の文字がかななら区切り文字のspaceをセット
					bp.append(" ");
				}
				prvChar = "K";
			}
			bp.append(c);
		}
		//Return配列生成
		ArrayList arrKana = new ArrayList();
		//Return配列[0]にふりがな全体をセット。
		arrKana.add(b.toString().toUpperCase().trim());
		//Return配列[1]..[n]にかな・かな以外文字列をセット。
		String arrBp[] = null;
		if (bp.toString().trim() != "") {
			pat = Pattern.compile("[ ]+");
			arrBp = pat.split(bp.toString());
			for (i = 0; i < arrBp.length; i++) {
				if (! arrBp[i].trim().equals("")) {
					arrKana.add(arrBp[i].toUpperCase());
				}
			}
		}
		return arrKana;
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
