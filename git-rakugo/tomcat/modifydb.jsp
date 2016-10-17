<%@ page buffer="128kb" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,java.text.*" %>
<jsp:useBean id="bkS" class="jp.rakugo.nii.BookTableSelect" scope="page" />
<jsp:useBean id="bkU" class="jp.rakugo.nii.BookTableUpdate" scope="page" />
<jsp:useBean id="bwU" class="jp.rakugo.nii.BookWorkTableUpdate" scope="page" />
<jsp:useBean id="tmS" class="jp.rakugo.nii.TitleMasterSelect" scope="page" />
<jsp:useBean id="pmS" class="jp.rakugo.nii.PlayerMasterSelect" scope="page" />
<jsp:useBean id="kmU" class="jp.rakugo.nii.KanaMasterUpdate" scope="page" />
<jsp:useBean id="kmS" class="jp.rakugo.nii.KanaMasterSelect" scope="page" />
<jsp:useBean id="cmF" class="jp.rakugo.nii.CommonForm" scope="page" />
<jsp:useBean id="cmR" class="jp.rakugo.nii.CommonRakugo" scope="page" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<head>
<link rel="stylesheet" type="text/css" href="hibimor2.css">
<style type="text/css">
<!--
body {
  background-color: #fff8e7;
  color: 000066;
  line-height: 133%;
}
a:link {
  color: #007000;
}
-->
</style>
<title>DBアクセス</title>
<script language="JavaScript" type="text/javascript">
<!--
	function sendQuery(tarType) {
	/* マスタ rewrite */
		var strMsg = "";
		var goFlg = true;
		var wkDelInc = "";
		var obj;
		if (tarType == "btnMod") {
			strMsg = "Update OK?";
		} else if (tarType == "btnDel") {
			strMsg = "Delete OK?";
			obj = document.getElementById("selDb");
			if (obj.selectedIndex != 1) {
				//削除はかなマスタのみ
				alert("NO FUNCTION!");
				strMsg = "";
				goFlg = false;
			}
		}
		if (strMsg != "") {								//更新系は確認Dialogを出す。
			if (confirm(strMsg) == true) {
			} else {
				goFlg = false;
			}
		}
		if (goFlg == true) {
			document.formDB.formBtnType.value = tarType;
			document.formDB.method = "post";
			document.formDB.action = "modifydb.jsp";
			document.formDB.submit();
		}
	}
	function clearInp(btn) {
		if (btn == "sel1") {
			document.formDB.selColS1[0].selected = true;
			document.formDB.selEqS1[0].selected = true;
			document.formDB.inpS1.value = "";
		}
		if (btn == "sel2") {
			document.formDB.selAndS1[0].selected = true;
			document.formDB.selColS2[0].selected = true;
			document.formDB.selEqS2[0].selected = true;
			document.formDB.inpS2.value = "";
		}
		if (btn == "mod1") {
			document.formDB.selColM1[0].selected = true;
			document.formDB.inpM1.value = "";
		}
	}
	function openWindow(tar) {
		var i = document.formDB.selDb.selectedIndex;
		var s = document.formDB.selDb[i].value;
//		alert(s);
		var u = "downlo" + tar + ".jsp?db=";
		if (tar == "bk") {
			u += "book_t";
		} else {
			u += s;
		}
		window.open(u, '_blank');
	}
// -->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<a name="b0"></a>
<%!
	public HashMap hmDb;
//	private String[] DB_CODE = {"rakugo_t", "book_t", "title_m", "player_m"};
//	private String[] DB_DATA = {"落語", "書籍", "タイトルマスタ", "プレイヤマスタ"};
	private String[] DB_CODE = {"book_t","kana_m"};
	private String[] DB_DATA = {"書籍","かなマスタ"};

	public HashMap hmCol;
	private String[] COL_CODE
		= {"","vol_id", "seq", "title", "title_sort", "isbn",
		   "kana","letters"};
	private String[] COL_DATA
		= {"","書籍:VolId","書籍:Seq","書籍:Title", "書籍:TitleSort", "書籍:ISBN",
		   "かな:かな","かな:文字"};
	
	public HashMap hmAnd;
	private String[] AND_CODE = {"","AND", "OR"};
	private String[] AND_DATA = {"","AND", "OR"};
	
	public HashMap hmEq;
	private String[] EQ_CODE = {"","=", "LIKE %","LIKE %%"};
	private String[] EQ_DATA = {"","=", "LIKE %","LIKE %%"};
	
	//DBセレクタ作成と取得
	public String makeDb(String name, String id, String def) {
		hmDb = new HashMap(); 
		return buildOptions(name, id, def, 
			DB_CODE, DB_DATA, hmDb);
	}
	public String getDb(String key) {
		if (hmDb.containsKey(key)) {
			return hmDb.get(key).toString();
		} else {
			return "";
		}
	}
	//項目セレクタ作成と取得
	public String makeCol(String name, String id, String def) {
		hmCol = new HashMap(); 
		return buildOptions(name, id, def, 
			COL_CODE, COL_DATA, hmCol);
	}
	public String getCol(String key) {
		if (hmCol.containsKey(key)) {
			return hmCol.get(key).toString();
		} else {
			return "";
		}
	}
	//比較条件セレクタ作成と取得
	public String makeAnd(String name, String id, String def) {
		hmAnd = new HashMap(); 
		return buildOptions(name, id, def, 
			AND_CODE, AND_DATA, hmAnd);
	}
	public String getAnd(String key) {
		if (hmAnd.containsKey(key)) {
			return hmAnd.get(key).toString();
		} else {
			return "";
		}
	}
	//検索条件セレクタ作成と取得
	public String makeEq(String name, String id, String def) {
		hmEq = new HashMap(); 
		return buildOptions(name, id, def, 
			EQ_CODE, EQ_DATA, hmEq);
	}
	public String getEq(String key) {
		if (hmEq.containsKey(key)) {
			return hmEq.get(key).toString();
		} else {
			return "";
		}
	}
	
	private String buildOptions(String name, String id, String def,
			String[] code, String[] data,
			HashMap hm) {
	//<select>タグとHashMapの作成
		StringBuffer stB = new StringBuffer("<select");
		if (! name.equals("")) {
			stB.append(" name='").append(name).append("'");
		}
		if (! id.equals("")) {
			stB.append(" id='").append(id).append("'");
		}
		stB.append(">");
		for (int i = 0; i < code.length; i++) {
			stB.append("<option value='").append(code[i]).append("'");
			if (code[i].equals(def)) {
				stB.append(" selected");
			}
			stB.append(">").append(data[i]).append("</option>");
			//HashMap
			hm.put(code[i], data[i]);
		}
		stB.append("</select>");
		return stB.toString();
	}
	public boolean judgeSelectParameter(String c1, String e1, String i1, 
																			String a1,
																			String c2, String e2, String i2) {
		boolean okFlg = true;
		if ((c1.equals("")) && (c2.equals(""))) {
			okFlg = false;
		} else if ((! c1.equals("")) && (e1.equals(""))) {
			okFlg = false;
		} else if ((! c1.equals("")) && (i1.equals(""))) {
			okFlg = false;
		} else if ((! c2.equals("")) && (e2.equals(""))) {
			okFlg = false;
		} else if ((! c2.equals("")) && (i2.equals(""))) {
			okFlg = false;
		}
		if ((! c1.equals("")) && (! c2.equals(""))) {
			if (a1.equals("")) {
				okFlg = false;
			}
		}
		return okFlg;
	}
	public String makeSelectSql(String c1, String e1, String i1, 
															String a1,
															String c2, String e2, String i2) {
		StringBuffer stB = new StringBuffer("WHERE ");
		if (! c1.equals("")) {
			stB.append(c1).append(" ");
			if (e1.equals("=")) {
				stB.append(e1).append(" '").append(i1).append("'");
			} else if (e1.indexOf("%%") >= 0) {
				stB.append(" LIKE '%").append(i1).append("%'");
			} else {
				stB.append(" LIKE '").append(i1).append("%'");
			}
		}
		if (! c2.equals("")) {
			stB.append(" ").append(a1).append(" ");
			stB.append(c2).append(" ");
			if (e2.equals("=")) {
				stB.append(e2).append(" '").append(i2).append("'");
			} else if (e2.indexOf("%%") >= 0) {
				stB.append(" LIKE '%").append(i2).append("%'");
			} else {
				stB.append(" LIKE '").append(i2).append("%'");
			}
		}
		return stB.toString();
	}
%>
<%!
public String escapeString(String strEsc) {
//',",\ をescapeする
	StringBuffer sbfResult = new StringBuffer();
	for (int iEsc=0; iEsc<strEsc.length(); iEsc++) {
		switch(strEsc.charAt(iEsc)) {
		case '\'':
		case '@':
		case '<':
		case '>':
			sbfResult.append("\\").append(strEsc.charAt(iEsc));
			break;
		case '&':
			sbfResult.append("&amp;");
			break;
		case '"':
			sbfResult.append("&quot;");
			break;
		case '―':
			sbfResult.append("&mdash;");
			break;
		default:
			sbfResult.append(strEsc.charAt(iEsc));
			break;
		}
	}
	return sbfResult.toString().trim();
}
%>
<%
	//キャラクタ_セット宣言
	request.setCharacterEncoding("UTF-8");

	//いろいろフォーマット宣言
	SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat dateFmtH = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	DecimalFormat decFmt3 = new DecimalFormat("000");
	DecimalFormat decFmtC = new DecimalFormat("#,##0");

	//正規表現の宣言
	Pattern pat = Pattern.compile("[^0-9]");
	Matcher mat = pat.matcher("yyyy-MM-dd");
	//汎用カウンタ
	int i = 0;
	int j = 0;
	int k = 0;
	String tarDb;
/* 本日日付を生成 */
	Calendar parToday = Calendar.getInstance();
	String strDate = dateFmt.format(parToday.getTime());
//コンピュータ名取得	
	String sch_comName = cmR.getComputerName(request.getRequestURL().toString());
	
	String sch_selDb = cmR.convertNullToString(request.getParameter("selDb"));
	if (sch_selDb.equals("")) {
		sch_selDb = "book_t";
	}
	String sch_selColS1 = cmR.convertNullToString(request.getParameter("selColS1"));
	String sch_selEqS1 = cmR.convertNullToString(request.getParameter("selEqS1"));
	String sch_inpS1 = cmR.convertNullToString(request.getParameter("inpS1"));
	sch_inpS1 = escapeString(sch_inpS1);
	String sch_selAndS1 = cmR.convertNullToString(request.getParameter("selAndS1"));
	String sch_selColS2 = cmR.convertNullToString(request.getParameter("selColS2"));
	String sch_selEqS2 = cmR.convertNullToString(request.getParameter("selEqS2"));
	String sch_inpS2 = cmR.convertNullToString(request.getParameter("inpS2"));
	sch_inpS2 = escapeString(sch_inpS2);
	String sch_selColM1 = cmR.convertNullToString(request.getParameter("selColM1"));
	String sch_inpM1 = cmR.convertNullToString(request.getParameter("inpM1"));
	sch_inpM1 = escapeString(sch_inpM1);
	String sch_btn = cmR.convertNullToString(request.getParameter("formBtnType"));			/* 押下ボタン種 */
		
	String strSelColS1 = makeCol("selColS1", "selColS1", sch_selColS1);
	String valSelColS1 = getCol(sch_selColS1);
	String strSelEqS1 = makeEq("selEqS1", "selEqS1", sch_selEqS1);
	String valSelEqS1 = getEq(sch_selEqS1);
	String strSelAndS1 = makeAnd("selAndS1", "selAndS1", sch_selAndS1);
	String valSelAndS1 = getAnd(sch_selAndS1);
	String strSelColS2 = makeCol("selColS2", "selColS2", sch_selColS2);
	String valSelColS2 = getCol(sch_selColS2);
	String strSelEqS2 = makeEq("selEqS2", "selEqS2", sch_selEqS2);
	String valSelEqS2 = getEq(sch_selEqS2);
	String strSelColM1 = makeCol("selColM1", "selColM1", sch_selColM1);
	String valSelColM1 = getCol(sch_selColM1);

	String strCo[] = new String[0];
	String strDr[] = new String[0];
	
//DB Bundle
	cmR.connectJdbc6();
/* Query組み立て */
	/* 初期画面または押下ボタン不明なら Dummy空読み */
	StringBuffer query;
	StringBuffer dbMsg = new StringBuffer("");
	int counter = 0;
	
	query = new StringBuffer("");
	query.append(makeSelectSql(sch_selColS1, valSelEqS1, sch_inpS1,
		valSelAndS1, sch_selColS2, valSelEqS2, sch_inpS2));
	boolean okFlg = true;
	/* [更新]なら更新して再検索 */
	if (sch_btn.equals("btnMod")) {
		if (sch_selDb.equals("book_t")) {
			try {
				bkS.selectDB(query.toString(), "");
				for (i = 0; i < bkS.getResultCount(); i++) {
					bkU.initRec();
					bkU.setVolId(bkS.getVolId(i));
					bkU.setSeq(bkS.getSeq(i));
					if (sch_selColM1.equals("title")) {
						bkU.setTitle(sch_inpM1);
					}
					if (sch_selColM1.equals("title_sort")) {
						bkU.setTitleSort(sch_inpM1);
					}
					//VolId, Seq は更新しないコト。
					bkU.setModifyDate(bkS.getModifyDate(i));
					if (bkU.updateRec() < 1) {
						dbMsg.append("Update Error!");
					}
				}
			} catch (Exception e) {
				dbMsg.append("Select Parameter Error!");
			}
		} else if (sch_selDb.equals("kana_m")) {
			try {
				kmS.selectDB(query.toString(), "");
				for (i = 0; i < kmS.getResultCount(); i++) {
					kmU.initRec();
					kmU.setLetters(kmS.getLetters(i));
					kmU.setKana(kmS.getKana(i));
					if (kmU.updateRec() < 1) {
						dbMsg.append("Update Error!");
					}
				}
			} catch (Exception e) {
				dbMsg.append("Select Parameter Error!");
			}
		}
		sch_btn = "btnSel";
	}
	/* [削除]なら削除して再検索 */
	if (sch_btn.equals("btnDel")) {
		if (sch_selDb.equals("book_t")) {
				dbMsg.append("NO FUNCTION");
		} else if (sch_selDb.equals("kana_m")) {
			try {
				kmS.selectDB(query.toString(), "");
				for (i = 0; i < kmS.getResultCount(); i++) {
					if (kmU.deleteRec(kmS.getLetters(i), kmS.getKana(i)) < 1) {
						dbMsg.append("Delete Error!");
					}
				}
			} catch (Exception e) {
				dbMsg.append("Select Parameter Error!");
			}
		}
		sch_btn = "btnSel";
	}
	if (sch_btn.equals("btnSel")) {
		if (sch_selDb.equals("book_t")) {
			try {
				bkS.selectDB(query.toString(), "");
				counter = bkS.getResultCount();
			} catch (Exception e) {
				dbMsg.append("SELECT Error!");
				counter = 0;
			}
		} else if (sch_selDb.equals("kana_m")) {
			try {
				kmS.selectDB(query.toString() + " ORDER BY kana, cnt DESC, letters", "");
				counter = kmS.getResultCount();
			} catch (Exception e) {
				dbMsg.append("SELECT Error!");
				counter = 0;
			}
		}
	}
%>
<form name="formDB">
<table border="0" width="100%">
	<tr>
	<td width="50%">
		<h1>DBアクセス</h1>
	</td>
	<td align="center" id="AjaxState">
	</td>
	<td align="right">
		<%= sch_comName %>
	</td>
	</tr>
</table>
<hr>
<input type="hidden" name="formBtnType">
<input type="hidden" name="inpSel1" value="*" size="2" readonly>
<div class="divFloatR">
		<input type="button" name="btnDL"
				onclick="javascript: openWindow('ad');" value="Download"><br />
		<input type="button" name="btnDLbk"
				onclick="javascript: openWindow('bk');" value="BooksDownload">
</div>
<div>
Target:
		<%
			out.println(makeDb("selDb", "selDb", sch_selDb));
		%>
</div>
			<hr>
<table border="0">
	<tr>
		<td>
			WHERE
		</td>
		<td>
		<%
			out.println(makeCol("selColS1", "selColS1", sch_selColS1));
			out.println(makeEq("selEqS1", "selEqS1", sch_selEqS1));
		%>
			'<input name="inpS1" size="16" value="<%= sch_inpS1 %>">'
		</td>
		<td>
			<input type="button" onclick="javascript: clearInp('sel1');" value="クリア">
		</td>	
		<td align="center" rowspan="3">
			<input type="button" name="btnISel"
				onclick="javascript:sendQuery('btnSel')" value="SELECT">
		</td>
	</tr>
	<tr>
		<td></td>	
		<td>
		<%
			out.println(makeAnd("selAndS1", "selAndS1", sch_selAndS1));
		%>
		</td>	
		<td></td>	
	</tr>
	<tr>
		<td></td>	
		<td>
		<%
			out.println(makeCol("selColS2", "selColS2", sch_selColS2));
			out.println(makeEq("selEqS2", "selEqS2", sch_selEqS2));
		%>
			'<input name="inpS2" size="16" value="<%= sch_inpS2 %>">'
		</td>	
		<td>
			<input type="button" onclick="javascript: clearInp('sel2');" value="クリア">
		</td>	
	</tr>
	<tr>
		<td colspan="5"><hr /></td>	
	</tr>
	<tr>
		<td>
			SET
		</td>
		<td>
		<%
			out.println(makeCol("selColM1", "selColM1", sch_selColM1));
		%>
			=
			'<input name="inpM1" size="24" value="<%= sch_inpM1 %>">'
		</td>
		<td>
			<input type="button" onclick="javascript: clearInp('mod1');" value="クリア">
		</td>	
		<td align="center">
			<input type="button" name="btnMod"
				onclick="javascript:sendQuery('btnMod')" value="UPDATE">
		</td>
		<td class="fontSmall" rowspan="2" width="32%">
			※WHEREの条件に合致するレコードを更新/削除する。
		</td>
	</tr>
	<tr>
		<td>
		</td>
		<td>
		</td>
		<td>
		</td>	
		<td align="center">
			<input type="button" name="btnDel"
				onclick="javascript:sendQuery('btnDel')" value="DELETE">
		</td>
	</tr>
</table>
	<hr>
	<div align="Center">
			<input type="button" name="btnClose"
				onclick="javascript: window.close();" value="CLOSE">
	</div>
	<hr>
	<div>
	SQL: SELECT * FROM <%= sch_selDb %> <%= query.toString() %><br />
	<%= counter %>件
	</div>
	<hr />
	<table border="0">
<%
	strCo = new String[6];
	strDr = new String[6];
	for (i = 0; i < counter; i++) {
		if (sch_selDb.equals("book_t")) {
			strCo[0] = bkS.getVolId(i);
			strCo[1] = decFmt3.format(bkS.getSeq(i));
			strDr[1] = "right";
			strCo[2] = bkS.getTitle(i);
			strCo[3] = bkS.getTitleSort(i);
			try {
				strCo[4] = dateFmt.format(bkS.getGetDate(i));
			} catch (Exception e) {
				strCo[4] = "";
			}
			strCo[5] = dateFmtH.format(bkS.getModifyDate(i));
		} else if (sch_selDb.equals("kana_m")) {
			strCo[0] = decFmtC.format(kmS.getIncId(i));
			strDr[0] = "right";
			strCo[1] = kmS.getKana(i);
			strCo[2] = kmS.getLetters(i);
			strCo[3] = decFmtC.format(kmS.getCnt(i));
			strDr[3] = "right";
			strCo[4] = kmS.getMemo(i);
			strCo[5] = dateFmtH.format(kmS.getModifyDate(i));
		}
		if (i % 2 == 0) {
			out.println("<tr bgcolor='lavender'>");
		} else {
			out.println("<tr bgcolor='white'>");
		}
%>
			<td align="right"><%= decFmtC.format(i + 1) %></td>
<%
				for (j = 0; j < strCo.length; j++) {
					out.println("<td");
					if (strDr[j] != null) {
						out.println(" align='" + strDr[j] + "'");
					}
					out.println("'>" + strCo[j] + "</td>");
				}
%>
		</tr>
<%
	}
	cmR.closeJdbc();
%>
	</table>
<script language="JavaScript" type="text/javascript">
<!--
	if ("<%= dbMsg.toString() %>" != "") {
		document.getElementById("AjaxState").innerHTML =
			"<font color='red'>" + "<%= dbMsg.toString() %>" + "</font>";
	}
// -->
</script>
</form>
</body>
</html>