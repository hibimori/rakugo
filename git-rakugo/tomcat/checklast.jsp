<%@ page buffer="128kb" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,javax.sql.*,javax.naming.*,java.text.*" %>
<jsp:useBean id="pmS" class="jp.rakugo.nii.PlayerMasterSelect" scope="page" />
<jsp:useBean id="cmR" class="jp.rakugo.nii.CommonRakugo" scope="page" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>LastModifyChecker</title>
<link rel="stylesheet" type="text/css" href="makerakugo.css">
<script language="JavaScript" src="assistinput.js"></script>
<script language="JavaScript" src="openwindow_b.js"></script>
<script language="JavaScript" src="inpcalendar.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
function sendQuery(tarType) {
/* マスタ rewrite */
	var strMsg = "";
	var goFlg = true;
	if (tarType == "btnMod") {
		strMsg = "Update OK?";
	} else if (tarType == "btnAdd") {
		strMsg = "Insert OK?";
	} else if (tarType == "btnDel") {
		strMsg = "Delete OK?";
	}
	if (strMsg != "") {								//更新系は確認Dialogを出す。
		if (confirm(strMsg) == true) {
			//［削除］なら入力チェックを無視して何でも消せる。
		} else {
			goFlg = false;
		}
	}
	if (goFlg == true) {
		document.formBook.method = "post";
		document.formBook.action = "checklast.jsp";
		document.formBook.submit();
	}
}
function clearData(tarType) {
	if (tarType == "inpViewD") {
		document.formBook.inpViewD.value = "";
	}
}
// -->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<h1>Last Modified Data.</h1>
<hr>
<%!
public String strNullCheck(String strChk) {
//文字列がnullなら""に置換して返す。以外はtrimする。
	String strResult = "";
	if (strChk != null) {
		strResult = strChk.trim();
	}
	return strResult;
}
%>
<%
	//キャラクタ_セット宣言
	request.setCharacterEncoding("UTF-8");

	//いろいろフォーマット宣言
	SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat dateFmtH = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	DecimalFormat decFmt = new DecimalFormat("0");
	DecimalFormat decFmt3 = new DecimalFormat("000");

String parSelBook = "select * from book_t";
String parSelRakugo = "select * from rakugo_t";
String parSelTitle = "select * from title_m";
String parWhere = " where modify_date >='";
String parOrderVol = " order by modify_date desc, vol_id, seq";
String parOrderID = " order by modify_date desc, id";
String parOrderMod = " order by modify_date desc limit 0,1";

/* Formの検索条件を退避 */
	String sch_modDate = strNullCheck(request.getParameter("inpViewD"));	/* 更新日 */

	String strDateB;		//書籍DBの最終更新日
	String strDateR;		//落語DBの最終更新日
	String strDateT;		//タイトルマスタDBの最終更新日
	String strDateP;		//演者マスタDBの最終更新日

	String dbModDate = "";
	String dbVolID = "";
	String dbSeq = "";
	String dbID = "";
	String dbTitle = "";

/* 本日日付を生成 */
	Calendar parToday = Calendar.getInstance();
	java.util.Date dateDate = parToday.getTime();	//本日日付date確保
	java.util.Date tmpDate = parToday.getTime();	//temp日付date
	int intYear;
	int intMonth;
	int intDate;
	if (sch_modDate.equals("")) {		//更新日指定がなければ本日日付
		tmpDate = parToday.getTime();
	} else {							//更新日指定ありのとき
		Pattern pat = Pattern.compile("[^0-9]");
		Matcher mat = pat.matcher(sch_modDate);		//今回日付を評価
		sch_modDate = mat.replaceAll("/");	//yyyy-mm-dd → yyyy/mm/dd
		if (sch_modDate.indexOf("/") >= 0) {
			try {
				DateFormat parser = DateFormat.getDateInstance();
				tmpDate = parser.parse(sch_modDate);
			}
			catch (ParseException e) {		//parse失敗したら本日日付
				tmpDate = parToday.getTime();
			}
		}
		sch_modDate = dateFmt.format(tmpDate);
	}
	intYear = tmpDate.getYear() + 1900;
	intMonth = tmpDate.getMonth() + 1;
	intDate = tmpDate.getDate();
%>
<form name="formBook">
<div id="divCalendar" class="div1"></div>
<table border="1" id="tblId">
	<tr>
	<th align="center" bgcolor="silver" id="thChkDt">
		<input name="btnModDate" onclick="javascript: openCalendarWindow('ChkDt')"
			type="button" value="更新日">
	</th>
	<td>
		<input id="inpChkDt" maxlength="10" name="inpViewD" size="12" type="text" value="<%= sch_modDate %>">
	</td>
	<td><input name="btnExec" onclick="javascript: sendQuery('inpViewD')" type="button" value="検索"></td>
	<td><input name="btnClearDate" onclick="javascript: clearData('inpViewD')" type="button" value="クリア"></td>
	</tr>
</table>
</form>
<hr>
<%
/* DB更新項目充足 */
//JDBC接続
/*
	cmR.connectJdbc();
	*/
	cmR.connectJdbc6();
	Connection db = cmR.getJdbc();
//DB Bundle
///	ResourceBundle rb=ResourceBundle.getBundle("rakugodb");	/* Bundle *//
//	Class.forName(rb.getString("jdbc"));							/* Driver Load */
//	Connection db=DriverManager.getConnection(rb.getString("con"));	/* DB接続 */
/*
	Context ctx = new InitialContext();
	DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/rakugo_db");
	Connection db = ds.getConnection();
*/

	db.setReadOnly(true);											/* 読み取り専用宣言 */

	Statement st=db.createStatement();
	Statement st2=db.createStatement();
/* Query組み立て */
	StringBuffer query;
	StringBuffer query2 = new StringBuffer(32);	//名称取得用Query退避エリア
	ResultSet rs;
%>
<%
//演題マスタDB
	//更新日指定有無で分岐
	if (sch_modDate.equals("")) {
		//DBの最新日取得
		query = new StringBuffer(32);
		query.append(parSelTitle).append(parOrderMod);
		rs = st.executeQuery(query.toString());
		if (rs.next()) {
			try {
				strDateT = dateFmt.format(rs.getTimestamp("modify_date"));
			} catch (Exception e) {
				strDateT = dateFmt.format(dateDate);
			}
		} else {
			strDateT = dateFmt.format(dateDate);
		}
	} else {
		strDateT = dateFmt.format(tmpDate);
	}
%>
【演題マスタ】title_m
<table border="1">
<%
	int i;
	//演題マスタDBの対象更新日rec取得
	query = new StringBuffer(32);
	query.append(parSelTitle).append(parWhere).append(strDateT).append("'").append(parOrderID);
	rs = st.executeQuery(query.toString());
	i = 0;
	while (rs.next()) {
		i += 1;
		dbModDate = dateFmtH.format(rs.getTimestamp("modify_date"));
		dbVolID = strNullCheck(rs.getString("id"));
		dbSeq = strNullCheck(rs.getString("category"));
		dbTitle = strNullCheck(rs.getString("title"));
%>
	<tr>
		<td align="right"><%= decFmt.format(i) %></td>
		<td><%= dbModDate %></td>
		<td><%= dbVolID %></td>
		<td><%= dbSeq %></td>
		<td><%= dbTitle %></td>
	</tr>
<%
	}
%>
<%
//演者マスタDB
	//更新日指定有無で分岐
	if (sch_modDate.equals("")) {
		//DBの最新日取得
		pmS.selectDB(parOrderMod, "");
		try {
			if (pmS.getResultCount() > 0) {
				strDateP = dateFmt.format(pmS.getModifyDate(0));
			} else {
				strDateP = dateFmt.format(dateDate);
			}
		} catch (Exception e) {
			strDateP = dateFmt.format(tmpDate);
		}
	} else {
		strDateP = dateFmt.format(tmpDate);
	}
%>
</table>
<hr align="right" width="16%">
【演者マスタ】player_m
<table border="1">
<%
	//演者マスタDBの対象更新日rec取得
	query = new StringBuffer(parWhere);
	query.append(strDateP).append("'").append(parOrderID);
	pmS.selectDB(query.toString(), "");
	try {
	for (i = 0; i < pmS.getResultCount(); i++){
		try {
			dbModDate = dateFmtH.format(pmS.getModifyDate(i));
		} catch (Exception e) {
			dbModDate = "failre";
		}
		dbVolID = strNullCheck(pmS.getId(i));
		dbSeq = strNullCheck(pmS.getNameFlg(i));
		dbTitle = strNullCheck(pmS.getFullName(i));
%>
	<tr>
		<td align="right"><%= decFmt.format(i + 1) %></td>
		<td><%= dbModDate %></td>
		<td><%= dbVolID %></td>
		<td><%= dbSeq %></td>
		<td><%= dbTitle %></td>
	</tr>
<%
	}
	} catch (Exception e) {
		out.println(query.toString());
	}
%>
</table>
<%
//落語DB
	//更新日指定有無で分岐
	if (sch_modDate.equals("")) {
		//落語DBの最新日取得
		query = new StringBuffer(32);
		query.append(parSelRakugo).append(parOrderMod);
		rs = st.executeQuery(query.toString());
		if (rs.next()) {
			strDateR = dateFmt.format(rs.getTimestamp("modify_date"));
		} else {
			strDateR = dateFmt.format(dateDate);
		}
	} else {
		strDateR = dateFmt.format(tmpDate);
	}
%>
<hr align="right" width="16%">
【落語DB】rakugo_t
<table border="1">
<%
	//落語DBの対象更新日rec取得
	query = new StringBuffer(32);
	query.append(parSelRakugo).append(parWhere).append(strDateR).append("'").append(parOrderVol);
	rs = st.executeQuery(query.toString());
	i = 0;
	while (rs.next()) {
		i += 1;
		dbModDate = dateFmtH.format(rs.getTimestamp("modify_date"));
		dbVolID = strNullCheck(rs.getString("vol_id"));
		dbSeq = decFmt3.format(rs.getInt("seq"));
		dbID = strNullCheck(rs.getString("title_id"));
		query2 = new StringBuffer();
		query2.append(parSelTitle).append(" where id = '").append(dbID).append("'");
		ResultSet rs2 = st2.executeQuery(query2.toString());
		if (rs2.next()) {
			dbTitle = strNullCheck(rs2.getString("title"));
		} else {
			dbTitle = "";
		}
%>
	<tr>
		<td align="right"><%= decFmt.format(i) %></td>
		<td><%= dbModDate %></td>
		<td><%= dbVolID %></td>
		<td><%= dbSeq %></td>
		<td><%= dbTitle %></td>
	</tr>
<%
	}
%>
</table>
<hr align="right" width="16%">
<%
//書籍DB
	//更新日指定有無で分岐
	query = new StringBuffer(32);
	if (sch_modDate.equals("")) {
		//書籍DBの最新日取得
		query.append(parSelBook).append(parOrderMod);
		rs = st.executeQuery(query.toString());
		if (rs.next()) {
			strDateB = dateFmt.format(rs.getTimestamp("modify_date"));
		} else {
			strDateB = dateFmt.format(dateDate);
		}
	} else {
		strDateB = dateFmt.format(tmpDate);
	}
%>
【書籍DB】book_t
<table border="1">
<%
	//書籍DBの対象更新日rec取得
	query = new StringBuffer(32);
	query.append(parSelBook).append(parWhere).append(strDateB).append("'").append(parOrderVol);
	rs = st.executeQuery(query.toString());
	i = 0;
	while (rs.next()) {
		i += 1;
		dbModDate = dateFmtH.format(rs.getTimestamp("modify_date"));
		dbVolID = strNullCheck(rs.getString("vol_id"));
		dbSeq = decFmt3.format(rs.getInt("seq"));
		dbTitle = strNullCheck(rs.getString("title"));
%>
	<tr>
		<td align="right"><%= decFmt.format(i) %></td>
		<td><%= dbModDate %></td>
		<td><%= dbVolID %></td>
		<td><%= dbSeq %></td>
		<td><%= dbTitle %></td>
	</tr>
<%
	}
	//JDBC切断
	cmR.closeJdbc();
%>
</table>
</body>
</html>