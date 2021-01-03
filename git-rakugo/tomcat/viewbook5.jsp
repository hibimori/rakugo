<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,java.text.*" %>
<!--
	1.10	2019-11-16	ジュリアン日付のリンクに［入院日記］オプションを追加。
-->
<jsp:useBean id="bkS" class="jp.rakugo.nii.BookTableSelect" scope="page" />
<jsp:useBean id="bvS" class="jp.rakugo.nii.BookViewTableSelect" scope="page" />
<jsp:useBean id="bvU" class="jp.rakugo.nii.BookViewTableUpdate" scope="page" />
<jsp:useBean id="tmS" class="jp.rakugo.nii.TitleMasterSelect" scope="page" />
<jsp:useBean id="pmS" class="jp.rakugo.nii.PlayerMasterSelect" scope="page" />
<jsp:useBean id="cdS" class="jp.rakugo.nii.CodeMasterSelect" scope="page" />
<jsp:useBean id="cdU" class="jp.rakugo.nii.CodeMasterUpdate" scope="page" />
<jsp:useBean id="cmF" class="jp.rakugo.nii.CommonForm" scope="page" />
<jsp:useBean id="cmR" class="jp.rakugo.nii.CommonRakugo" scope="page" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<head>
<link rel="stylesheet" type="text/css" href="hibimor2.css">
<link rel="stylesheet" type="text/css" href="makerakugo.css">
<link rel="stylesheet" type="text/css" href="hibi2011.css">
<style type="text/css">
body {
  background-color: #fff8e7;
  color: 000066;
  font-family: 'ＭＳ ゴシック';
  line-height: 133%;
}
a:link {
  color: #007000;
}
</style>
<title>BookDB 書影Table HTML5</title>
<script language="JavaScript" src="assistinput.js"></script>
<script language="JavaScript" src="openwindow_b.js"></script>
<script language="JavaScript" src="assistinput_mb.js"></script>
<script language="JavaScript" src="assistinput_vb.js"></script>
<script language="JavaScript" src="inpcalendar.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
function sendQuery(tarType) {
/* マスタ rewrite */
	var strMsg = "";
	var goFlg = true;
	var wkDelInc = "";
	if (tarType == "btnDel") {
		strMsg = "Delete OK?";
	} else if (tarType == "btnAllDel") {
		strMsg = "Delete All OK?";
	} else if (tarType == "btnOldDel") {
		strMsg = "Delete Older OK?";
	} else if (tarType == "btnViewA") {
		strMsg = "aiBo Date fix OK?";
	} else if (tarType == "btnViewL") {
		strMsg = "ListVal fix OK?";
	}
	if (strMsg != "") {								//更新系は確認Dialogを出す。
		if (confirm(strMsg) == true) {
			//［削除］なら入力チェックを無視して何でも消せる。
			if (tarType == "btnDel") {
				//削除チェックのチェック
				for (i = 0; i < document.formBook.inpRows.value; i++) {
					if (document.formBook.chkDel[i].checked == true) {
						if (wkDelInc == "") {
							wkDelInc = document.formBook.inpIncID[i].value;
						} else {
							wkDelInc = wkDelInc + "," + document.formBook.inpIncID[i].value;
						}
					}
				}
			} else {
				if (isNaN(document.formBook.inpListVal.value)) {
					document.formBook.inpListVal.value = "000";
				}
			}
		} else {
			goFlg = false;
		}
	}
	if (goFlg == true) {
		if (tarType == "btnHTML1") {
			document.formBook.selViewN.value = "1";
		} else if (tarType == "btnHTML2") {
			document.formBook.selViewN.value = "2";
		} else {
			document.formBook.selViewN.value = "0";
		}
		document.formBook.formBtnType.value = tarType;
		document.formBook.inpIncIDTbl.value = wkDelInc;
		if (document.formBook.chkViewE.checked == true) {
			document.formBook.chkViewE.value= "1";
		} else {
			document.formBook.chkViewE.value= "0";
		}
		document.formBook.method = "post";
		if (document.location.toString().indexOf("viewbook5b.jsp") >= 0) {
			document.formBook.action = "viewbook5.jsp";
		} else {
			var rtn = window.open(document.location.toString(), '_blank', parNoToolbar);
		//	document.formBook.action = "viewbook5b.jsp";
			document.formBook.action = "viewbook5.jsp";
		}
		document.formBook.submit();
	}
}
// -->
</script>
<script type="text/javascript" src="ckeditor/ckeditor.js"></script>
</head>
<body bgcolor="#FFFFFF" text="#000000" >
<a name="b0"></a>
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
	request.setCharacterEncoding("Shift_JIS");

	//いろいろフォーマット宣言
	SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat dateFmtID = new SimpleDateFormat("yyyyMMdd");
	SimpleDateFormat dateFmtMD = new SimpleDateFormat("M/d");
	SimpleDateFormat dateFmtE = new SimpleDateFormat("yy.M/d(E) H:mm:ss");
	DecimalFormat decFmt = new DecimalFormat("0");
	DecimalFormat decFmt2 = new DecimalFormat("00");
	DecimalFormat decFmt3 = new DecimalFormat("000");
	DecimalFormat decFmtW = new DecimalFormat("0.0");
	DateFormat datePs = DateFormat.getDateInstance();

	//正規表現の宣言
	Pattern pat = Pattern.compile("[^0-9]");
	Matcher mat = pat.matcher("yyyy-MM-dd");
	//汎用カウンタ
	int i = 0;
	int j = 0;

/* 本日日付を生成 */
	Calendar parToday = Calendar.getInstance();
	String strDate = dateFmt.format(parToday.getTime());
	int nowY = parToday.get(Calendar.YEAR);
	int nowM = parToday.get(Calendar.MONTH) + 1;
	int nowD = parToday.get(Calendar.DATE);
	int nowW = parToday.get(Calendar.DAY_OF_WEEK);		// 1:日曜, 7:土曜
	int nowJ = parToday.get(Calendar.DAY_OF_YEAR);

//コンピュータ名取得
	String sch_comName = cmR.getComputerName(request.getRequestURL().toString());

/* Formの検索条件を退避 */
String sch_incIDTbl = cmR.convertNullToString(request.getParameter("inpIncIDTbl"));	/* increaseID */
String sch_inpRows = cmR.convertNullToString(request.getParameter("inpRows"));			/* 前回行数 */
if (sch_inpRows.equals("")) { sch_inpRows = "0"; }

int tblIncID[] = new int[Integer.valueOf(sch_inpRows).intValue() + 1];
int wkCnt = 0;
int wkPos;
boolean flgIncID = false;
if (!(sch_incIDTbl.equals(""))) {
	while (flgIncID == false) {				//削除するrecのincIDを分離退避
		wkPos = sch_incIDTbl.indexOf(",");
		switch(wkPos) {
		case -1:
			wkCnt = wkCnt + 1;
			tblIncID[wkCnt] = Integer.valueOf(sch_incIDTbl).intValue();
			flgIncID = true;
			break;
		case 0:
			sch_incIDTbl = sch_incIDTbl.substring(1, sch_incIDTbl.length());
			break;
		default:
			wkCnt = wkCnt + 1;
			tblIncID[wkCnt] = Integer.valueOf(sch_incIDTbl.substring(0, wkPos)).intValue();
			sch_incIDTbl = sch_incIDTbl.substring(wkPos + 1, sch_incIDTbl.length());
			break;
		}
	}
}
String sch_incID = "";		/* 個別のincID */
String sch_id = cmR.convertNullToString(request.getParameter("inpID"));		/* ID */
String sch_seq = cmR.convertNullToString(request.getParameter("inpSeq"));		/* SEQ */
String sch_title;
String sch_titleSeq;
String sch_titleSeqC;
String sch_titleSort;
String sch_player1ID;
String sch_player1Sei;
String sch_player1Mei;
String sch_player2ID;
String sch_player2Sei;
String sch_player2Mei;
String sch_player3ID;
String sch_player3Sei;
String sch_player3Mei;
String sch_player1Sin;
String sch_player2Sin;
String sch_player3Sin;
String sch_player4;
String sch_sourceID;
String sch_source = "";
String sch_asin = "";
String sch_getDate;
String sch_getDateC;
String sch_urlA;
String sch_imgA;
String sch_urlB;
String sch_imgB;
String sch_urlC;
String sch_imgC;
String sch_urlE;
String sch_imgE;
String sch_imgS;
String sch_storeS;
String sch_media;
String sch_memo;
String sch_modDate;
String sch_btn = request.getParameter("formBtnType");			/* 押下ボタン種 */

//日記雛型コントロール
String strCo[] = new String[12];		/* Combo要素選択用ワーク */
//ブランク期間雛型
String sch_chkViewF = cmR.convertNullToString(request.getParameter("chkViewF"));	//ブランク日付Check
if (!(sch_chkViewF.equals("1"))) { sch_chkViewF = "0"; }
if (sch_chkViewF.equals("0")) {
	strCo[0] = "";
} else {
	strCo[0] = "checked";
}
String sch_viewF = cmR.convertNullToString(request.getParameter("inpViewF"));			// ブランク開始日
String sch_viewT = cmR.convertNullToString(request.getParameter("inpViewT"));			// ブランク終了日
//本日日付雛型
String sch_viewD = cmR.convertNullToString(request.getParameter("inpViewD"));			//きょう日付
String sch_chkViewD = cmR.convertNullToString(request.getParameter("chkViewD"));	//きょう日付Check
if (!(sch_chkViewD.equals("1"))) { sch_chkViewD = "0"; }
if (sch_chkViewD.equals("0")) {
	strCo[1] = "";
	sch_viewD = strDate;			//きょう日付

} else {
	strCo[1] = "checked";
}
String sch_rdoViewD = cmR.convertNullToString(request.getParameter("rdoViewD"));		//きょう色
if (sch_rdoViewD.equals("")) { sch_rdoViewD = "2"; }
switch(sch_rdoViewD.charAt(0)) {
case '1':
	strCo[4] = "checked";	//日曜祝日
case '7':
	strCo[5] = "checked";	//土曜
default:
	strCo[6] = "checked";	//平日
}
String sch_chkViewE = cmR.convertNullToString(request.getParameter("chkViewE"));	//入院中日記
//	out.println(sch_chkViewE);
if (sch_chkViewE.equals("1")) {
	strCo[11] = "checked";
} else {
	strCo[11] = "";
}
//out.println("strCo11=" + strCo[11]); 
//激痩せ年間雛型
String sch_viewS = cmR.convertNullToString(request.getParameter("inpViewS"));
String sch_viewW = cmR.convertNullToString(request.getParameter("inpViewW"));
String sch_viewM = cmR.convertNullToString(request.getParameter("inpViewM"));
//aiBoトピック雛型
String sch_viewA = cmR.convertNullToString(request.getParameter("inpViewA"));			//aiBo前前回日
String sch_viewB = cmR.convertNullToString(request.getParameter("inpViewB"));			//aiBo前回日
String sch_chkViewA = cmR.convertNullToString(request.getParameter("chkViewA"));	//aiBo日付Check
if (!(sch_chkViewA.equals("1"))) { sch_chkViewA = "0"; }
if (sch_chkViewA.equals("0")) {
	strCo[3] = "";
	sch_viewA = strDate;
	sch_viewB = strDate;
} else {
	strCo[3] = "checked";
}
String sch_lastA = "";			//aiBo前前回日(DB)
String sch_lastB = "";			//aiBo前回日　(DB)
String sch_modA = "";			//aiBoRec更新日　(DB)
String sch_modV = "";			//書影Rec更新日　(DB)
String sch_modW = "";			//体重Rec更新日　(DB)
//書影Table雛型
String sch_listVal = cmR.convertNullToString(request.getParameter("inpListVal"));
if (sch_listVal.equals("")) { sch_listVal = "001"; }
String sch_chkViewL = cmR.convertNullToString(request.getParameter("chkViewL"));
if (!(sch_chkViewL.equals("1"))) { sch_chkViewL = "0"; }
if (sch_chkViewL.equals("0")) {
	strCo[7] = "";
} else {
	strCo[7] = "checked";
}
//書影要否Check
String sch_selViewN = cmR.convertNullToString(request.getParameter("selViewN"));
if (sch_selViewN.equals("")) { sch_selViewN = "0"; }
/*
switch(sch_selViewN.charAt(0)) {
case '1':
	strCo[9] = "selected";	//書影不要
	break;
case '2':
	strCo[10] = "selected";	//書影のみ
	break;
default:
	strCo[8] = "selected";	//通常
}
*/
String sch_lastVal = "000";
String sch_lastRows = "0";
String ctrl_volID;						//管理Rec退避用
//DB Bundle
	cmR.connectJdbc6();
/* Query組み立て */
	/* 初期画面または押下ボタン不明なら Dummy空読み */
	StringBuffer query;			//書影Table全件検索用Query
	StringBuffer query2;			//名称取得用Query退避エリア
	StringBuffer dbMsg = new StringBuffer();	//DB更新メセイジ
%>
<%
	/* [追加]なら更新して再検索 */
	if (sch_btn.equals("btnAdd")) {
		//既存recを削除
		bvU.initRec();
		bvU.setVolId(sch_id);
		bvU.setSeq(Integer.parseInt(sch_seq));
		if (bvU.deleteRec() < 0) {
			dbMsg.append("既存Rec削除失敗！");
		}
		//当該レコードをBookDBから採取
		query = new StringBuffer();
		query.append("WHERE vol_id = '").append(sch_id);
		query.append("' AND seq = '").append(sch_seq).append("'");
		bkS.selectDB(query.toString(), "");
		//書影TableDBにコピー
		if (bkS.getResultCount() > 0) {
			bvU.initRec();
			bvU.setVolId(bkS.getVolId(0));
			bvU.setSeq(bkS.getSeq(0));
			bvU.setTitleSort(bkS.getTitleSort(0));
			bvU.setTitleSeq(bkS.getTitleSeq(0));
			if (bvU.insertRec() < 1) {
				dbMsg.append("BookTableコピー失敗！");
			}
		} else {
			dbMsg.append("BookTable取得失敗！");
		}
	}
%>
<%
	/* [削除]なら更新して再検索 */
	if (sch_btn.equals("btnDel")) {
		bvU.initRec();
		for (i = 0; i < tblIncID.length; i++) {
			bvU.setIncId(tblIncID[i]);
			if (bvU.deleteRec() < 0) {
				dbMsg.append("[削除]失敗！");
			}
		}
	}
	/* [全削除]なら更新して再検索 */
	if (sch_btn.equals("btnAllDel")) {
		bvU.initRec();
		if (bvU.deleteRec() < 0) {
			dbMsg.append("[全削除]失敗！");
		}
	}
	/* [最新日付を除いて削除]なら更新して再検索 */
	if (sch_btn.equals("btnOldDel")) {
		bvS.selectDB("ORDER BY modify_date DESC", "");
		if (bvS.getResultCount() > 0) {
			bvU.initRec();
			bvU.setModifyDate(bvS.getModifyDate(0));
			if (bvU.deleteRec() < 0) {
				dbMsg.append("[最新日付以外削除]失敗！");
			}
		}
	}
%>
<%
	/* 激痩せ年間［算出］なら更新して再検索 */
	if (sch_btn.equals("btnViewW")) {
		cdU.deleteRec("0000W0", 0);		//いったん削除
		cdU.initRec();
		cdU.setVolId("0000W0");
		cdU.setSeq(0);
		cdU.setMemo("激痩せ年間 0:Today 1:Base");
		try {	//現在の体重として格納（kg→ｇ）
			cdU.setInt0((int)(Float.parseFloat(sch_viewW) * 1000));
		} catch (Exception e) {
			cdU.setInt0(6580);
		}
		try {	//基準の体重として格納（kg→ｇ）
			cdU.setInt1((int)(Float.parseFloat(sch_viewS) * 1000));
		} catch (Exception e) {
			cdU.setInt1(6580);
		}
		if (cdU.insertRec() < 0) {
			dbMsg.append("Weight Rec Insert Error!");
		}
	}
	/* aiBo日付［確定］なら更新して再検索 */
	if (sch_btn.equals("btnViewA")) {
		cdU.deleteRec("0000A0", 0);		//いったん削除
		cdU.initRec();
		cdU.setVolId("0000A0");
		cdU.setSeq(0);
		cdU.setMemo("aiBo 0:Today 1:Prev 2:Prev2 3:Prev3");
		try {	//本日日付
			cdU.setDatetime0(datePs.parse(cmR.fixDateFormat(strDate).replace("-", "/")));
		} catch (Exception e) {
			cdU.setDatetime0(datePs.parse("1961/12/10"));
		}
		try {	//当日を前回へスライド格納
			cdU.setDatetime1(datePs.parse(cmR.fixDateFormat(sch_viewD).replace("-", "/")));
		} catch (Exception e) {
			cdU.setDatetime1(datePs.parse("1961/12/10"));
		}
		try {	//前回日を前前回へスライド格納
			cdU.setDatetime2(datePs.parse(cmR.fixDateFormat(sch_viewB).replace("-", "/")));
		} catch (Exception e) {
			cdU.setDatetime2(datePs.parse("1961/12/10"));
		}
		try {	//前前回日を前前前回へスライド格納（遣わない）
			cdU.setDatetime3(datePs.parse(cmR.fixDateFormat(sch_viewA).replace("-", "/")));
		} catch (Exception e) {
			cdU.setDatetime3(datePs.parse("1961/12/10"));
		}
		if (cdU.insertRec() < 0) {
			dbMsg.append("Aibo Rec Insert Error!");
		}
	}
	/* ListValue［確定］なら更新して再検索 */
	if (sch_btn.equals("btnViewL")) {
		cdU.deleteRec("000000", 0);		//いったん削除
		cdU.initRec();
		cdU.setVolId("000000");
		cdU.setSeq(0);
		cdU.setMemo("ListValue採番用");
		try {	//LastValとして格納
			cdU.setInt0(Integer.parseInt(sch_listVal));
		} catch (Exception e) {
			cdU.setInt0(0);
		}
		try {	//LastRowとして格納
			cdU.setInt1(Integer.parseInt(sch_inpRows));
		} catch (Exception e) {
			cdU.setInt1(0);
		}
		if (cdU.insertRec() < 1) {
			dbMsg.append("List Rec Insert Error!");
		}
	}
// 書影Table管理DB
	//激痩せ年間情報を取得
	float baseWeight;
	float nowWeight;
	float diffWeight;
	cdS.selectDB("WHERE vol_id='0000W0' AND seq='0'", "");

	try {

	if (cdS.getResultCount() > 0) {
		nowWeight = Float.valueOf(cdS.getInt0(0)).floatValue() / 1000;
		baseWeight = Float.valueOf(cdS.getInt1(0)).floatValue() / 1000;
		try {
			sch_modW = dateFmtE.format(cdS.getModifyDate(0));
		} catch (Exception e) {
			sch_modW = strDate;
		}
	} else {
		try {
			baseWeight = Float.valueOf(sch_viewS).floatValue();
		} catch (NumberFormatException e) {
			baseWeight = 77.2f;
		}
		try {
			nowWeight = Float.valueOf(sch_viewW).floatValue();
		} catch (NumberFormatException e) {
			nowWeight = 67.0f;
		}
		try {
			diffWeight = Float.valueOf(sch_viewM).floatValue();
		} catch (NumberFormatException e) {
			diffWeight = 0;
		}
		sch_modW = strDate;
	}
	} catch (Exception e) {
		nowWeight = 0;
		baseWeight = 0;
		diffWeight = 0;
		sch_modW = strDate;
//		out.println("cdS.getResultCount is null 1");
	}

	diffWeight = nowWeight - baseWeight;
	sch_viewS = decFmtW.format(baseWeight);
	sch_viewW = decFmtW.format(nowWeight);
	sch_viewM = decFmtW.format(diffWeight);
	//aiBo日付を取得
	cdS.selectDB("WHERE vol_id='0000A0' AND seq='0'", "");
	try {

	if (cdS.getResultCount() > 0) {
		try {
			sch_lastA = dateFmt.format(cdS.getDatetime2(0));
		} catch (Exception e) {
			sch_lastA = strDate;
		}
		try {
			sch_lastB = dateFmt.format(cdS.getDatetime1(0));
		} catch (Exception e) {
			sch_lastB = strDate;
		}
		try {
			sch_modA = dateFmtE.format(cdS.getModifyDate(0));
		} catch (Exception e) {
			sch_modA = strDate;
		}
		if (sch_chkViewA.equals("0")) {
			sch_viewA = sch_lastA;
			sch_viewB = sch_lastB;
		}
	} else {
		sch_lastA = strDate;
		sch_lastB = strDate;
		sch_viewA = strDate;
		sch_viewB = strDate;
		sch_modA = strDate;
	}
	} catch (Exception e) {
		strDate = "";
		sch_lastA = strDate;
		sch_lastB = strDate;
		sch_viewA = strDate;
		sch_viewB = strDate;
		sch_modA = strDate;
//		out.println("cdS.getResultCount is null 2");
	}

	//書影Table前回情報を取得
	cdS.selectDB("WHERE vol_id='000000' AND seq='0'", "");
	try {

	if (cdS.getResultCount() > 0) {
		sch_lastVal = decFmt3.format(cdS.getInt0(0));
		sch_lastRows = decFmt.format(cdS.getInt1(0));
		sch_modV = dateFmtE.format(cdS.getModifyDate(0));
		if (sch_chkViewL.equals("0")) {
			sch_listVal = sch_lastVal;
			if (!(dateFmt.format(cdS.getModifyDate(0)).equals(strDate))) {
				sch_listVal = decFmt3.format(cdS.getInt0(0) + cdS.getInt1(0));
			}
			strCo[7] = "";
		}
	}
	} catch (Exception e) {
		sch_lastVal = "000";
		sch_lastRows = "0";
		sch_modV = "";
		sch_listVal = "001";
		strCo[7] = "";
//		out.println("cdS.getResultCount is null 3");
	}
%>
<form name="formBook">
<table border="0" width="100%">
	<tr>
	<td width="50%">
		<h1>書影Table HTML5</h1>
	</td>
	<td class="fontSmall">［<a href="#b50">雛型</a>］［<a
		href="http://www.amazon.co.jp/exec/obidos/tg/listmania/list-browse/-/1ZMFRAD8NNOZ7/"
		target="_blank">ListMania</a>］［<a href="http://www.asahi-net.or.jp/~SU2N-NI/index.htm" target="_blank">nii.n表紙</a>］［<a href="http://graph.hatena.ne.jp/nii/edit" target="_blank">はてなグラフ</a>］
</td>
	<td align="center" id="AjaxState">
	</td>
	<td align="right">
		<%= sch_comName %>
	</td>
	</tr>
</table>
<hr>
<!-- 書影リスト作表開始 -->
	<input name="inpModID" type="hidden" value="">
	<table border="0">
		<tr align="center" bgcolor="silver">
			<th></th>
			<td>
				<input type="checkbox" name="chkDelTitle" onclick="javascript: assistInpDataV('chkDel')">削
			</td>
			<th>inc</th>
			<th>vol/seq</th>
			<th>書名</th>
			<th>著者</th>
			<th>出版社</th>
			<th>ASIN</th>
			<th>媒体</th>
			<th>img</th>
			<th>memo</th>
			<th>日付</th>
		</tr>
<%
	int rows = 9;
	int rowsImg = 0;
	String strLine1 = "bgcolor=white";
	String strLine2 = "bgcolor=lavender";
	String strMakeBookLink = "";
	String strTitleLink = "";
	String parLink = "&selKeyword=GE&selKeywordT=T&selImg=B&formBtnType=btnIDSeq";
	String clsLine = "";
	/* 書影TableDBを全件読む */
	bvS.selectDB("ORDER BY title_sort,title_seq,vol_id,seq", "");
	try {

	if (bvS.getResultCount() > 0) {
		rows = bvS.getResultCount();
	} else {
		rows = 0;
	}
	} catch (Exception e) {
		rows = 0;
//		out.println("bvS.getResultCount is null 4");
	}
	//書影TableDBの退避場所
	String aryTitle[] = new String[rows];
	String aryTitleLink[] = new String[rows];
	String aryAuthor[] = new String[rows];
//	String aryAuthorS[] = new String[rows];
	String aryPublish[] = new String[rows];
	String aryURLA[] = new String[rows];
	String aryURLB[] = new String[rows];
	String aryURLC[] = new String[rows];
	String aryURLE[] = new String[rows];
	String aryImg[] = new String[rows];
	String aryImgS[] = new String[rows];
	String aryMedia[] = new String[rows];
	String aryMemo[] = new String[rows];
	String aryAlt[] = new String[rows];
	int aryImgTable[] = new int[rows];	//書影有無配列
	rows = 0;							//書影有無配列のサイズを決めたらまた初期化。
%>
<%
	try {

	for (i = 0; i < bvS.getResultCount(); i++) {
		sch_incID = decFmt.format(bvS.getIncId(i));			/* incID */
		sch_id = cmR.convertNullToString(bvS.getVolId(i));				/* ID */
		sch_seq = decFmt3.format(bvS.getSeq(i));			/* Seq */
		try {
			sch_modDate = dateFmtMD.format(bvS.getModifyDate(i));		/* 更新日 */
		} catch (Exception e) {
			sch_modDate = "0000-00-00";
		}
		//ViewBook一覧でのMakeBookリンク
		strMakeBookLink = cmR.addUri(sch_id + "/" + sch_seq,
			"makebook.jsp?inpID=" + sch_id + "&inpSeq=" + sch_seq + parLink);
%>
<%
		/* BookDBから情報取得 */
		query2 = new StringBuffer();
		query2.append("WHERE vol_id = '").append(sch_id).append("'");
		query2.append(" AND seq = '").append(sch_seq).append("'");
		bkS.selectDB(query2.toString(), "");
		if (bkS.getResultCount() > 0) {
			sch_title = escapeString(bkS.getTitle(0));		/* タイトル */
			sch_titleSeq = String.valueOf(bkS.getTitleSeq(0));	/* タイトル連番 */
			sch_titleSeqC = bkS.getTitleSeqSin(0);	/* 連番サイン */
			sch_player1ID = bkS.getAuthor1Id(0);
			sch_player2ID = bkS.getAuthor2Id(0);
			sch_player3ID = bkS.getAuthor3Id(0);
			sch_player1Sin = bkS.getAuthor1Sin(0);
			sch_player2Sin = bkS.getAuthor2Sin(0);
			sch_player3Sin = bkS.getAuthor3Sin(0);
			sch_player4 = bkS.getAuthor4Sin(0);	/* 著者4サイン */
			sch_sourceID = bkS.getPublishId(0);	/* 出版社ID */
			sch_urlA = bkS.getUrlA(0);
			sch_urlB = bkS.getUrlB(0);
			sch_urlC = bkS.getUrlC(0);
			sch_urlE = bkS.getUrlE(0);
			sch_imgA = bkS.getImgA(0);
			sch_imgB = bkS.getImgB(0);
			sch_imgC = bkS.getImgC(0);
			sch_imgE = bkS.getImgE(0);
			sch_imgS = bkS.getImgSin(0);			/* 書影サイン */
			sch_storeS = bkS.getStoreSin(0);			/* 電子書店サイン */
			sch_media = bkS.getMediaSin(0);			/* 媒体サイン */
			sch_memo = bkS.getMemo(0);				/* メモ */
			wkPos = sch_urlA.indexOf("/ASIN/");
			if (wkPos >= 0) {
				sch_asin = sch_urlA.substring(wkPos + 6, wkPos + 16);
			} else {
				sch_asin = "";
			}
		} else {
			sch_title = "";
			sch_titleSeq = "";
			sch_titleSeqC = "";
			sch_player1ID = "";
			sch_player2ID = "";
			sch_player3ID = "";
			sch_player1Sin = "";
			sch_player2Sin = "";
			sch_player3Sin = "";
			sch_player4 = "";
			sch_sourceID = "";
			sch_asin = "";
			sch_urlA = "";
			sch_urlB = "";
			sch_urlC = "";
			sch_urlE = "";
			sch_imgA = "";
			sch_imgB = "";
			sch_imgC = "";
			sch_imgE = "";
			sch_imgS = "";
			sch_storeS = "";
			sch_media = "";
			sch_memo = "";
		}
%>
<%
		//その他URLがあればタイトルにリンク設定
		strTitleLink = cmR.addUri(sch_title, sch_urlC);
		
		if (sch_titleSeqC.equals("1")) {		/* タイトル連番 */
			sch_title = sch_title + " (" + sch_titleSeq + ")";
			strTitleLink += " (" + sch_titleSeq + ")";
		}

		rows = rows + 1;						//件数カウント
		if (sch_imgS.equals("")) {
			sch_imgS = "-";						//書影ナシを"-"表示
		} else {
			aryImgTable[rowsImg] = rows - 1;	//書影のあるrecの位置を退避
			rowsImg = rowsImg + 1;				//書影数カウント
		}
		if (clsLine.equals(strLine1) == true) {
			clsLine = strLine2;
		} else {
			clsLine = strLine1;
		}
		//タイトルマスタDBから出版社名取得
		if (!(sch_sourceID.equals(""))) {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_sourceID).append("'");
			tmS.selectDB(query2.toString(), "");
			if (tmS.getResultCount() > 0) {
				sch_source = cmR.addUri(tmS.getTitle(0), tmS.getUri(0));
			} else {
				sch_source = "";
			}
		}
		//演者マスタDBから姓名１取得
		cmF.makePlayerPart("selDummy", "", "");	//ダミーのselectタグ
		if (sch_player1ID.equals("")) {
			sch_player1Sei = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_player1ID).append("'");
			pmS.selectDB(query2.toString(), "");
			if (pmS.getResultCount() > 0) {
				sch_player1Sei = pmS.getFullName(0);
				sch_player1Sei = cmR.addUri(sch_player1Sei, pmS.getUri(0));
			} else {
				sch_player1Sei = "";
			}
		}
		if (sch_player2ID.equals("")) {
			sch_player2Sei = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_player2ID).append("'");
			pmS.selectDB(query2.toString(), "");
			if (pmS.getResultCount() > 0) {
				sch_player2Sei = pmS.getFullName(0);
				sch_player2Sei = cmR.addUri(sch_player2Sei, pmS.getUri(0));
			} else {
				sch_player2Sei = "";
			}
		}
		if (sch_player3ID.equals("")) {
			sch_player3Sei = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_player3ID).append("'");
			pmS.selectDB(query2.toString(), "");
			if (pmS.getResultCount() > 0) {
				sch_player3Sei = pmS.getFullName(0);
				sch_player3Sei = cmR.addUri(sch_player3Sei, pmS.getUri(0));
			} else {
				sch_player3Sei = "";
			}
		}
		//３姓名連結
		sch_player1Sei = cmR.concatNames(
			sch_player1Sei, cmF.getPlayerPart(sch_player1Sin),
			sch_player2Sei, cmF.getPlayerPart(sch_player2Sin),
			sch_player3Sei, cmF.getPlayerPart(sch_player3Sin),
			sch_player4, "・");
		//配列に退避
		aryTitle[rows - 1] = escapeString(sch_title);
		aryTitleLink[rows - 1] = strTitleLink;
		aryAuthor[rows - 1] = sch_player1Sei;
		/*
		if (sch_player4.equals("1")) {
			aryAuthorS[rows - 1] = "ほか";
		} else {
			aryAuthorS[rows - 1] = "";
		}
		*/
		aryPublish[rows - 1] = sch_source;
		aryURLA[rows - 1] = sch_urlA;
		aryURLB[rows - 1] = sch_urlB;
		aryURLC[rows - 1] = sch_urlC;
		aryURLE[rows - 1] = sch_urlE;
		aryImg[rows - 1] = "";
		aryImgS[rows - 1] = sch_imgS;
		if (sch_imgS.equals("A")) {
			aryImg[rows - 1] = sch_imgA;
			aryAlt[rows - 1] = "; amazon";
		}
		if (sch_imgS.equals("B")) {
			aryImg[rows - 1] = sch_imgB;
			aryAlt[rows - 1] = "; honto";
		}
		if (sch_imgS.equals("C")) {
			aryImg[rows - 1] = sch_imgC;
			aryAlt[rows - 1] = "";
		}
		if (sch_imgS.equals("E")) {
			aryImg[rows - 1] = sch_imgE;
			if (sch_storeS.equals("A")) {
				aryAlt[rows - 1] = "; KindleStore";
			} else if (sch_storeS.equals("G")) {
				aryAlt[rows - 1] = "; GooglePlayBooks";
			} else if (sch_storeS.equals("J")) {
				aryAlt[rows - 1] = "; J-Comics";
			} else if (sch_storeS.equals("O")) {
				aryAlt[rows - 1] = "; O'Reilly";
			} else if (sch_storeS.equals("R")) {
				aryAlt[rows - 1] = "; ReaderStore";
			} else if (sch_storeS.equals("W")) {
				aryAlt[rows - 1] = "; Bookwalker";
			} else {
				aryAlt[rows - 1] = "";
			}
		}
		aryMedia[rows - 1] = sch_media;
		aryMemo[rows - 1] = sch_memo;
%>
		<tr <%= clsLine %>>
			<td align="right"><%= rows %></td>
			<td align="center"><input type="checkbox" name="chkDel"></td>
			<td align="right">
				<%= sch_incID %>
				<input name="inpIncID" type="hidden" value="<%= sch_incID %>">
			</td>
			<td align="center"><%= strMakeBookLink %></td>
			<td><%= strTitleLink %></td>
			<td><%= sch_player1Sei %></td>
			<td><%= sch_source %></td>
			<td><%= sch_asin %></td>
			<td align="center"><%= sch_media %></td>
			<td align="center"><%= sch_imgS %></td>
			<td class="fontSmall">
				<%= sch_memo %>
				<input name="inpMemo" type="hidden" value="<%= sch_memo %>">
			</td>
			<td><%= sch_modDate %></td>
		</tr>
<%
	}
	} catch (Exception e) {
//		out.println("vbS.getResultCount is null 5");
	}
%>
	</table>
<input name="formBtnType" type="hidden" value="<%= sch_btn %>">
<input name="inpIncIDTbl" type="hidden" value="">
<input type="hidden" name="inpRows" value="<%= rows %>">
<!-- 検索結果が１件でも明細項目nameを配列にして添字参照するためのダミー -->
<input type="hidden" name="chkDel" checked=false>
<input type="hidden" name="inpIncID" value="">
<hr><a name="b50"></a>
<table border="0">
	<tr align="center">
		<td><%= rows %>件</td>
		<td>（<%= rowsImg %>書影）</td>
		<td>
			<input type="button" name="btnDel" value="削除"
				onclick="javascript: sendQuery('btnDel');">
		</td>
		<td>
			<input type="button" name="btnDel" value="最新日付を除いて削除"
				onclick="javascript: sendQuery('btnOldDel');">
		</td>
		<td>
			<input type="button" name="btnDel" value="全削除"
				onclick="javascript: sendQuery('btnAllDel');">
		</td>
		<td>
			<input type="button" name="btnClose" value="Close"
				onclick="javascript: window.close();">
		</td>
	<tr>
</table>
<div class="divCenter"><span class="fontSmall">［<a href="#b0">TOP</a>］</span></div>
<hr>
<div class="divFloatR">
	<textarea name="txtHTML" rows="32" cols="48"></textarea>
</div>
<div id="divCalendar" class="div1"></div>
<table border="1" id="tblId">
	<tr>
		<th bgcolor="silver" colspan="7">ブランク日付</th>
	</tr>
	<tr align="center">
		<td><input name="chkViewF" type="checkbox" value="1" <%= strCo[0] %>></td>
		<td id="thViewF">
			<input name="btnViewF"
				onclick="javascript: openCalendarWindow('ViewF')"
				type="button" value="開始日">
		</td><td>
			<input maxlength="10"
				id="inpViewF"
				name="inpViewF" size="12" type="text"
				value="<%= sch_viewF %>">
		</td>
		<td id="thViewT">
			<input name="btnViewT"
				onclick="javascript: openCalendarWindow('ViewT')"
				type="button" value="終了日">
		</td>
		<td colspan="2">
			<input maxlength="10"
				id="inpViewT"
				name="inpViewT" size="12" type="text"
				value="<%= sch_viewT %>">
		</td>
		<td>
			<input name="btnViewFC" onclick="javascript: clearInpDataV('btnViewFC')"
				 type="button" value="クリア">
		</td>
	</tr>
	<tr>
		<th bgcolor="silver" colspan="7">タイトル日付</th>
	</tr>
	<tr align="center" bgcolor="lavender">
		<td>
			<input name="chkViewD" type="checkbox" value="1" <%= strCo[1] %>>
		</td>
		<td id="thViewD">
			<input name="btnViewD"
				onclick="javascript: openCalendarWindow('ViewD')"
				type="button" value="きょう">
		</td><td>
			<input maxlength="10"
				id="inpViewD"
				name="inpViewD" size="12" type="text"
				value="<%= sch_viewD %>">
		</td>
	<%
//	out.println("tdのstrCo[11]=" + strCo[11]);
%>
		<td align="left" colspan="4">
			<input name="rdoViewD" type="radio" value="2" <%= strCo[6] %>>平日
			<input name="rdoViewD" type="radio" value="7" <%= strCo[5] %>>土曜
			<input name="rdoViewD" type="radio" value="1" <%= strCo[4] %>>日祝
			<input name="chkViewE" type="checkbox" value="1" <%= strCo[11] %>>入院中
		</td>
	</tr>
	<tr bgcolor="silver">
		<th colspan="5">激痩せ年間</th>
		<td align="right" colspan="2" class="fontSmall"><%= sch_modW %></td>
	</tr>
	<tr align="center">
		<td>
		</td>
		<td colspan="5">
			<input maxlength="5" name="inpViewW" size="4" type="text" value="<%= sch_viewW %>"> kg（現在体重）<!--
			 - 
			<input maxlength="5" name="inpViewS" size="6" type="text" value="<%= sch_viewS %>">
		kg = 
			<input maxlength="5" name="inpViewM" size="6" type="text" value="<%= sch_viewM %>" readonly>
		kg
		-->
		</td>
		<td>
			<input name="btnViewW" onclick="javascript: sendQuery('btnViewW')"
				 type="button" value="算出">
		</td>
	</tr>
	<tr bgcolor="silver">
		<th colspan="5">aiBo日付</th>
		<td align="right" colspan="2" class="fontSmall"><%= sch_modA %></td>
	</tr>
	<tr align="center" bgcolor="lavender">
		<td><input name="chkViewA" type="checkbox" value="1" <%= strCo[3] %>></td>
		<td id="thViewA">
			<input name="btnViewA"
				onclick="javascript: openCalendarWindow('ViewA')"
				type="button" value="前前日">
		</td>
		<td>
			<input maxlength="10"
 				id="inpViewA"
  			name="inpViewA" size="12" type="text"
				value="<%= sch_viewA %>">
			<!-- input id="inpViewA"
  			 type="date"
				value="<%= sch_viewA %>"-->
		</td>
		<td id="thViewB">
			<input name="btnViewB"
				onclick="javascript: openCalendarWindow('ViewB')"
				type="button" value="前回日">
		</td>
		<td colspan="2">
			<input maxlength="10"
 				id="inpViewB"
  	 		name="inpViewB" size="12" type="text"
				value="<%= sch_viewB %>">
		</td>
		<td>
			<input name="btnViewA" onclick="javascript: sendQuery('btnViewA')"
				 type="button" value="確定">
		</td>
	</tr>
	<tr align="center" bgcolor="lavender">
		<td></td>
		<th bgcolor="silver">前回</td>
		<td><%= sch_lastA %></td>
		<td></td>
		<td colspan="2"><%= sch_lastB %></td>
		<td></td>
	</tr>
	<tr bgcolor="silver">
		<th colspan="5">きょうの愉しみ</th>
		<td align="right" colspan="2" class="fontSmall"><%= sch_modV %></td>
	</tr>
	<tr align="center">
		<td>
			<input name="chkViewL" type="checkbox" value="1" <%= strCo[7] %>>
		</td>
		<th bgcolor="silver">今回</th>
		<td class="fontSmall">
			<a href="javascript: addSeq(-1, 'listVal')")>▽</a>
			<input maxlength="4" name="inpListVal" size="4" type="text"
				value="<%= sch_listVal %>">
			<a href="javascript: addSeq(1, 'listVal')")>△</a>
		</td>
		<th bgcolor="silver">前回</th>
		<td><%= sch_lastVal %></td>
		<td align="right"><%= sch_lastRows %>件</td>
		<td>
			<input name="btnViewL" onclick="javascript: sendQuery('btnViewL')"
				type="button" value="確定">
		</td>
	</tr>
	<tr align="center" valign="center" bgcolor="lavender">
		<th colspan="2" bgcolor="silver">
<!--		<%
			//書影要否セレクタの設定
			out.println(cmF.makeBookView("selViewN", "", sch_selViewN));
		%>
-->
			雛形作成
			<input name="selViewN" type="hidden" value="0">
		</th>
		<td colspan="5">
			<input name="btnHTML0" onclick="javascript: sendQuery('btnHTML0')"
				 type="button" value="書影つき雛型">
			<input name="btnHTML" onclick="javascript: sendQuery('btnHTML1')"
				 type="button" value="書影なし雛型">
			<input name="btnHTML" onclick="javascript: sendQuery('btnHTML2')"
				 type="button" value="書影のみ">
		</td>
	</tr>
</table>
<hr>
<div>
<textarea class="ckeditor" id="editor" name="editor" cols="64" rows="4"></textarea>
</div>
<hr>
<%!
public String htmDateTable(Calendar tarDate, int tarW, String tarWw, String tarWm, String tarNyu) {
	//日付Table記述
	SimpleDateFormat dateFmtS = new SimpleDateFormat("yyyy.M/d(E)");
	SimpleDateFormat dateFmtYM = new SimpleDateFormat("yyyyMM");
	SimpleDateFormat dateFmtD = new SimpleDateFormat("d");
	SimpleDateFormat dateFmtID = new SimpleDateFormat("yyyyMMdd");
	DecimalFormat decFmtJ = new DecimalFormat("0");
/*	//日記htm置き場（2006.1 - 2010.12）
	String hdtPath = "file:///d:/webber/nikkk/";
	//日記htm置き場（2011.1 - 2015.12）
	String hdtPath = "file:///d:/webber/nikkl/";
	//日記htm置き場（2016.1 - 2020.12）
	String hdtPath = "file:///d:/webber/nikkm/";
*/
	//日記htm置き場（2021.1 - 2025.12）
	String hdtPath = "file:///d:/webber/nikkn/";
	StringBuffer hdtTable = new StringBuffer();
	String hdtW = new String();
	String hdtID = new String();
	String hdtJ = new String();

	java.util.Date hdtDate = tarDate.getTime();
	int j = tarDate.get(Calendar.DAY_OF_YEAR);
	hdtJ = "";
	if (j < 100) { hdtJ = "&nbsp;"; }
	if (j < 10) { hdtJ = hdtJ.concat("&nbsp;"); }
	hdtJ = hdtJ.concat(decFmtJ.format(j));

	if (tarW == 9) {
		tarW = tarDate.get(Calendar.DAY_OF_WEEK);
	}
	/*
	tarDate.add(Calendar.DATE,-1);					//前日リンク用日付
	java.util.Date hdtDateP = tarDate.getTime();
	tarDate.add(Calendar.DATE, 2);					//翌日リンク用日付
	java.util.Date hdtDateN = tarDate.getTime();
	tarDate.add(Calendar.DATE,-1);					//日付を元に戻す。
	*/
	//曜日指定がないとき引数日付の曜日を使用
	switch (tarW) {
	case 1:
		hdtW = "Sun";
		break;
	case 7:
		hdtW = "Sat";
		break;
	default:
		hdtW = "Mon";
	}
	//TableタグID生成
	hdtID = "t" + dateFmtID.format(hdtDate);

	hdtTable.append("<h2 id='").append(hdtID).append("'>");
	hdtTable.append("<span class='date").append(hdtW);
	hdtTable.append("' onclick='javascript:showCalendar(\\\"");
	hdtTable.append(hdtID).append("\\\");'");
	hdtTable.append(" style='cursor:pointer;'>&nbsp;");
	hdtTable.append(dateFmtS.format(hdtDate)).append("&nbsp;</span>");

	//a nameタグID生成
	hdtID = "d" + dateFmtD.format(hdtDate);
	//TOP/BOTTOMリンク記述
	hdtTable.append("<a id='").append(hdtID);	//当日id
	hdtTable.append("'></a>");

	hdtTable.append("<span class='fontSmall'>&nbsp;");
	hdtTable.append("<a href='").append(hdtPath).append(dateFmtYM.format(hdtDate));
	if (tarNyu.equals("1")) {
		hdtTable.append("nyu.html#");		//入院日記内アンカ
	} else {
		hdtTable.append(".html#");
	}
	hdtTable.append(hdtID).append("'>");
	hdtTable.append(hdtJ).append("</a>&nbsp;");
	//日曜日特例
	if (tarDate.get(Calendar.DAY_OF_WEEK) == 1) {
		hdtTable.append("｜&nbsp;");
		//hdtTable.append("｜&nbsp;<a href='");
		//hdtTable.append("http://graph.hatena.ne.jp/nii/since%201998/");
		//hdtTable.append("' target='niin'>");
		//hdtTable.append(tarWw).append("kg</a>");
		hdtTable.append(tarWw).append("kg");
	}
	//１日特例
	if (tarDate.get(Calendar.DATE) == 1) {
		hdtTable.append("&nbsp;｜&nbsp;200,000");
	}
	hdtTable.append("</span></h2>");
	
	return hdtTable.toString();
}
public String aiboDateTable(Calendar tarDate, Calendar tarDateA, Calendar tarDateB) {
	//日付Table記述
	SimpleDateFormat dateFmtYM = new SimpleDateFormat("yyyyMM");
	SimpleDateFormat dateFmtYMD = new SimpleDateFormat("yyMMdd");
	SimpleDateFormat dateFmtD = new SimpleDateFormat("d");
	//日記htm置き場（2021.1 - 2025.12）
	String adtPath = "file:///d:/webber/nikkn/";

	StringBuffer adtTable = new StringBuffer();
	java.util.Date adtDate = tarDate.getTime();
	java.util.Date adtDateA = tarDateA.getTime();
	java.util.Date adtDateB = tarDateB.getTime();

	//今回分のTable
	adtTable.append("<h3 id='aibo").append(dateFmtYMD.format(adtDate)).append("'>");
	adtTable.append("【<a href='").append(adtPath).append(dateFmtYM.format(adtDateB)).append(".html");
	adtTable.append("#aibo").append(dateFmtYMD.format(adtDateB)).append("'>");
	adtTable.append("＜</a>aiBo").append(dateFmtYMD.format(adtDate)).append("＞】</h3>");
/*	//前回分のTable
	adtTable.append("<h3 id='aibo").append(dateFmtYMD.format(adtDateB)).append("'>");
	adtTable.append("【<a href='").append(adtPath).append(dateFmtYM.format(adtDateA)).append(".html");
	adtTable.append("#aibo").append(dateFmtYMD.format(adtDateA)).append("'>");
	adtTable.append("＜</a>aiBo").append(dateFmtYMD.format(adtDateB));
	adtTable.append("<a href='").append(adtPath).append(dateFmtYM.format(adtDate)).append(".html");
	adtTable.append("#aibo").append(dateFmtYMD.format(adtDate)).append("'>＞</a>】</h3>");
*/
	adtTable.append("<ul class='listSq'><li>　</li></ul><p>。</p><p>。</p>");
	return adtTable.toString();
}
%>
<%
// 日記雛型記述開始
	StringBuffer sbfHTML = new StringBuffer(255);
	Calendar calDate = Calendar.getInstance();
	Calendar calDate2 = Calendar.getInstance();
	Calendar calDate3 = Calendar.getInstance();
	java.util.Date wkDate = calDate.getTime();
	java.util.Date wkDate2 = calDate.getTime();
	java.util.Date wkDate3 = calDate.getTime();
	DateFormat parser = DateFormat.getDateInstance();
	String htmW;
	String slaDate;
	//ブランク期間の日付Table
	if (sch_chkViewF.equals("1")) {		//ブランク日付のあるとき
		try {
			mat = pat.matcher(sch_viewF);	//ブランク開始日付を評価
			slaDate = mat.replaceAll("/");	//yyyy-mm-dd → yyyy/mm/dd
			wkDate = parser.parse(slaDate);
			calDate.set(wkDate.getYear() + 1900, wkDate.getMonth(), wkDate.getDate());
			wkDate = calDate.getTime();
		} catch (ParseException e) {
			calDate = Calendar.getInstance();
			calDate.add(Calendar.DATE,-1);
			wkDate = calDate.getTime();
		}
		try {
			mat = pat.matcher(sch_viewT);	//ブランク終了日付を評価
			slaDate = mat.replaceAll("/");	//yyyy-mm-dd → yyyy/mm/dd
			wkDate2 = parser.parse(slaDate);
			calDate.set(wkDate2.getYear() + 1900, wkDate2.getMonth(), wkDate2.getDate());
			wkDate2 = calDate.getTime();
		} catch (ParseException e) {
			calDate = Calendar.getInstance();
			calDate.add(Calendar.DATE,-1);
			wkDate2 = calDate.getTime();
		}
		wkDate3 = wkDate;
		switch (wkDate3.getDay()) {
		case 0:							//getDay()は0が日曜
			htmW = "Sun";
			break;
		case 6:							//getDay()は6が土曜
			htmW = "Sat";
			break;
		default:
			htmW = "Mon";
		}
		sbfHTML.append("<article id='dr").append(dateFmtID.format(wkDate3)).append("skip' ");
		sbfHTML.append("class='dailyDiv").append(htmW).append("2'>");
		calDate.set(wkDate3.getYear() + 1900, wkDate3.getMonth(), wkDate3.getDate());
		while (!(wkDate3.after(wkDate2))) {
			sbfHTML.append(htmDateTable(calDate, 9, sch_viewW, sch_viewM, sch_chkViewE));	//日付Table作成
			calDate.add(Calendar.DATE, 1);				//日付１up
			wkDate3 = calDate.getTime();
		}
		sbfHTML.append("</article>");
	}
%>
<%
	//日記タイトル日付Table
	if (sch_chkViewD.equals("1")) {
		try {						//タイトル日付が任意のとき
			mat = pat.matcher(sch_viewD);
			slaDate = mat.replaceAll("/");
			wkDate = parser.parse(slaDate);
			nowY = wkDate.getYear() + 1900;
			nowM = wkDate.getMonth() + 1;
			nowD = wkDate.getDate();
			nowW = Integer.parseInt(sch_rdoViewD);
			calDate.set(nowY, nowM - 1, nowD);
		} catch (ParseException e) {	//タイトル日付のフォーマットエラー
			wkDate = parToday.getTime();
			nowY = wkDate.getYear() + 1900;
			nowM = wkDate.getMonth() + 1;
			nowD = wkDate.getDate();
			nowW = Integer.parseInt(sch_rdoViewD);
			calDate.set(nowY, nowM - 1, nowD);
		}
	} else {
		calDate = parToday;			//タイトル日付に本日日付セット
		nowW = calDate.get(Calendar.DAY_OF_WEEK);
	}
	switch (nowW) {
	case 1:							//Calendar.DAY_OF_WEEKは1が日曜
		htmW = "Sun";
		break;
	case 7:							//Calendar.DAY_OF_WEEKは7が土曜
		htmW = "Sat";
		break;
	default:
		htmW = "Mon";
	}
	if (!(sch_selViewN.equals("2"))) {		//書影のみのとき日付なし
		sbfHTML.append("<article id='dr").append(dateFmtID.format(wkDate3));
		sbfHTML.append("' class='dailyDiv").append(htmW).append("2'>");
		sbfHTML.append(htmDateTable(calDate, nowW, sch_viewW, sch_viewM, sch_chkViewE));	//日付Table作成
	}
%>
<%
	//aiBoブロック記述
	if (sch_chkViewA.equals("1")) {
		try {						//aiBo前前回日付のとき
			mat = pat.matcher(sch_viewA);
			slaDate = mat.replaceAll("/");
			wkDate = parser.parse(slaDate);
			nowY = wkDate.getYear() + 1900;
			nowM = wkDate.getMonth() + 1;
			nowD = wkDate.getDate();
			calDate2.set(nowY, nowM - 1, nowD);
		} catch (ParseException e) {
			wkDate = parToday.getTime();
			nowY = wkDate.getYear() + 1900;
			nowM = wkDate.getMonth() + 1;
			nowD = wkDate.getDate();
			calDate2.set(nowY, nowM - 1, nowD);
		}
		try {						//aiBo前回日付のとき
			mat = pat.matcher(sch_viewB);
			slaDate = mat.replaceAll("/");
			wkDate = parser.parse(slaDate);
			nowY = wkDate.getYear() + 1900;
			nowM = wkDate.getMonth() + 1;
			nowD = wkDate.getDate();
			calDate3.set(nowY, nowM - 1, nowD);
		} catch (ParseException e) {
			wkDate = parToday.getTime();
			nowY = wkDate.getYear() + 1900;
			nowM = wkDate.getMonth() + 1;
			nowD = wkDate.getDate();
			calDate3.set(nowY, nowM - 1, nowD);
		}
		sbfHTML.append("<div class='divTopic'>");
		sbfHTML.append(aiboDateTable(calDate, calDate2, calDate3));	//日付Table作成
		sbfHTML.append("</div>");
	}
%>
<%
	//日記本文部記述
	if (sch_selViewN.equals("2")) {
		sbfHTML.append("<div class='divTopic'>");
	} else {										//書影のみのとき空段落なし
		sbfHTML.append("<div class='divTopic' ");
		for (i = 0; i < 3; i++) {
			sbfHTML.append("id='d").append(nowD).append("a").append(i).append("'>");
			sbfHTML.append("<ul class='listSq'><li>　</li></ul><p>。</p><p>。</p>");
			sbfHTML.append("</div><div class='divTopic' ");
		}
		sbfHTML.append("id='d").append(nowD).append("a").append(i).append("'>");
		sbfHTML.append("<p>。</p><p>。</p></div>");
	}
	//書影Table記述（【きょうの愉しみ】)
	int wkCol = 0;
	int wkRow = 0;
	int nowCol = 0;
	int nowRow = 0;
	int cntCell = 0;
	int idxImg = 0;
	int startVal = Integer.parseInt(sch_listVal);
	if ((sch_selViewN.equals("2")) && (sch_chkViewL.equals("0"))) {
	  startVal = 1;
	}
	switch (rowsImg) {		//今回の列数を決定
	case 0:
		wkCol = 0;
		break;
	case 1:
		wkCol = 1;
		break;
	case 2:
	case 3:
	case 4:
		wkCol = 2;
		break;
	default:
		wkCol = 3;
	}
	if ((wkCol > 0) && (!(sch_selViewN.equals("1")))) {		//書影のあるときのみ
		if (!(sch_selViewN.equals("2"))) {		//書影のみのときタイトルなし
			sbfHTML.append("<div class='divTopic' id='tnsm").append(nowD).append("'>");
			sbfHTML.append("<h3>【");
    /*<a href='http://graph.hatena.ne.jp/nii/graph?graphname=");
			sbfHTML.append("%E3%81%8D%E3%82%87%E3%81%86%E3%81%AE%E6%84%89%E3%81%97%E3%81%BF");
			sbfHTML.append("&startdate=").append(nowY).append("-01-01");
			sbfHTML.append("&enddate=").append(nowY).append("-").append(decFmt2.format(nowM));
			sbfHTML.append("-").append(decFmt2.format(nowD)).append("&mode=detail");
			sbfHTML.append("' target='niin'>きょうの愉しみ</a>*/
            sbfHTML.append("きょうの愉しみ】</h3>");
		}
		nowRow = rowsImg / wkCol;
		if (nowRow * wkCol == rowsImg) {
			wkRow = nowRow;		//今回の行数（空セルなし）
		} else {
			wkRow = nowRow + 1;	//今回の行数（空セルあり）
		}
		if (rowsImg == 6) {		//書影数６のときだけ例外に３行
			wkRow = 3;
		}
		sbfHTML.append("<div class='divFloatR'><table class='fontSmall'><tbody>");
		cntCell = 1;
		for (nowRow = 1; nowRow <= wkRow; nowRow++) {		//行ループ
			sbfHTML.append("<tr class='bookPhoto'>");
			for (nowCol = 1; nowCol <= wkCol; nowCol++) {	//列ループ
				if (nowCol < wkCol - (rowsImg - cntCell)) {
					//最終行で列余りなら空セルにする。
					sbfHTML.append("<td></td>");
				} else {
					if ((rowsImg == 6) && (nowRow == 2) && (nowCol == 1)) {
						sbfHTML.append("<td></td>");	//書影数６のときの例外処理
					} else {
						//書影およびリンクURLの作成
						idxImg = aryImgTable[cntCell - 1];	//書影有無Tableから本体格納インデクス取得
						sbfHTML.append("<td>");
						if (aryImgS[idxImg].equals("A")) {
							if (!(aryURLA[idxImg].equals(""))) {
								sbfHTML.append("<a href='").append(aryURLA[idxImg]).append("' target='niin'>");
							}
						}
						if (aryImgS[idxImg].equals("B")) {
							if (!(aryURLB[idxImg].equals(""))) {
								sbfHTML.append("<a href='").append(aryURLB[idxImg]).append("' target='niin'>");
							}
						}
						if (aryImgS[idxImg].equals("C")) {
							if (!(aryURLC[idxImg].equals(""))) {
								sbfHTML.append("<a href='").append(aryURLC[idxImg]).append("' target='niin'>");
							}
						}
						if (aryImgS[idxImg].equals("E")) {
							if (!(aryURLE[idxImg].equals(""))) {
								sbfHTML.append("<a href='").append(aryURLE[idxImg]).append("' target='niin'>");
							}
						}
						sbfHTML.append("<img alt='").append(aryTitle[idxImg]).append("の書影");
						sbfHTML.append("' title='").append(aryTitle[idxImg]).append(aryAlt[idxImg]);
						sbfHTML.append("' src='").append(aryImg[idxImg]);
						if (wkCol > 2) {
							sbfHTML.append("' width='80' />");	//３列以上のときのWidth
						} else {
							sbfHTML.append("' width='88' />");	//３列未満のときのWidth
						}
						if (!(aryImgS[idxImg].equals(""))) {
							sbfHTML.append("</a>");
						}
						if (aryImgS[idxImg].equals("B")) {
						//A8.net専用のダミーimg
							if (aryURLB[idxImg].indexOf("a8.net") >= 0) {
								sbfHTML.append("<img width='1' height='1' src='");
								sbfHTML.append("http://www18.a8.net/0.gif");
								sbfHTML.append("?a8mat=163J66+B1PKVM+10UY+HUSFL");
								sbfHTML.append("' alt='' />");
							}
						}
						sbfHTML.append("<br>");
						if (aryURLB[idxImg].equals("")) {
							sbfHTML.append("[honto｜");
						} else {
							sbfHTML.append("[<a href='").append(aryURLB[idxImg]).append("' target='niin'>");
							sbfHTML.append("honto</a>｜");
						}
						if (aryURLA[idxImg].equals("")) {
							sbfHTML.append("amazon]");
						} else {
							sbfHTML.append("<a href='").append(aryURLA[idxImg]).append("' target='niin'>");
							sbfHTML.append("amazon</a>]");
						}
						sbfHTML.append("</td>");
						cntCell = cntCell + 1;
					}
				}
			}
			sbfHTML.append("</tr>");
		}
		sbfHTML.append("</tbody></table></div>");
%>
<%
	//きょうの愉しみリスト
		sbfHTML.append("<ol>");
		for (i = 0; i < rows; i++) {
			if ((i == 0) && (startVal != 1)) {
				sbfHTML.append("<li value='").append(decFmt.format(startVal)).append("'>");
			} else {
				sbfHTML.append("<li>");
			}
			sbfHTML.append("<span class='spanUL'>");
			sbfHTML.append(aryTitleLink[i]);
%>
<%
			//書籍以外は媒体名を付加
			if (!(aryMedia[i].equals("H"))) {
				sbfHTML.append("<span class='fontSmall'> [");
				try {
					cmF.makeMedia("", "", "");
					sbfHTML.append(cmF.getMedia(aryMedia[i]));
				} catch (Exception e) {
					sbfHTML.append(aryMedia[i]);
				}
				sbfHTML.append("]</span>");
			}
%>
<%
			sbfHTML.append("｜").append(aryAuthor[i]);
/*
			if (!(aryAuthorS[i].equals(""))) {
				sbfHTML.append("<span class='fontSmall'>");
				sbfHTML.append(aryAuthorS[i]).append("</span>");
			}
*/
			sbfHTML.append("｜").append(aryPublish[i]).append("</span>");
%>
<%
			if (aryMemo[i].equals("")) {
				sbfHTML.append("</li>");
			} else {
				sbfHTML.append("<ul class='ulNone'><li>").append(aryMemo[i]);
				sbfHTML.append("</li></ul></li>");
			}
		}
%>
<%
		sbfHTML.append("</ol></div>");
	}
%>
<%
	if (!(sch_selViewN.equals("2"))) {		//書影のみのとき<div>閉じなし
		sbfHTML.append("<div class='divCenter fontSmall'>");
    sbfHTML.append("［<a href='#b99'>▽</a>｜<a href='#top'>△</a>］</div></article>");
	}
%>
<script language="JavaScript" type="text/javascript">
<!--
	var strT = "<%= sbfHTML.toString() %>";
	document.formBook.txtHTML.value = strT;
	document.write(strT);
	var strButton = "<%= sch_btn %>";
/*	if ((strButton == "btnHTML") || (strButton.indexOf("View") >= 0)) {
		document.formBook.btnHTML.focus();
	}
*/
	if ("<%= dbMsg.toString() %>" != "") {
		document.getElementById("AjaxState").innerHTML =
			"<font color='red'>" + "<%= dbMsg.toString() %>" + "</font>";
	}
	document.formBook.txtHTML.select();
	document.execCommand("copy");
	document.formBook.txtHTML.focus();
// -->
</script>
</form>
</body>
</html>