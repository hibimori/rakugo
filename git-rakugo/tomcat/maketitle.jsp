<%@ page buffer="128kb" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.io.*,java.util.*,java.sql.*,java.text.*" %>
<jsp:useBean id="tmS" class="jp.rakugo.nii.TitleMasterSelect" scope="page" />
<jsp:useBean id="tmU" class="jp.rakugo.nii.TitleMasterUpdate" scope="page" />
<jsp:useBean id="cmF" class="jp.rakugo.nii.CommonForm" scope="page" />
<jsp:useBean id="cmR" class="jp.rakugo.nii.CommonRakugo" scope="page" />
<html lang="ja">
<head>
<title>Titleマスタ管理</title>
<link rel="stylesheet" type="text/css" href="makerakugo.css">
<script language="JavaScript" type="text/javascript" src="assistinput.js"></script>
<script language="JavaScript" src="inpcalendar.js"></script>
<script language="JavaScript" src="inpclock.js"></script>
<script language="JavaScript">
<!--
var rtn;
var openCalendar = "inpcalendar.jsp";
var openTitle = "maketitle.jsp";
var modTitlePrm1 = "?inpID=";
var modTitlePrm2 = "&inpModeTitle=EQ&formBtnType=btnID&tarCtrl=start.htm";
var wkURL;

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
	if (strMsg != "") {
		if (confirm(strMsg) == true) {
			if (document.formTitle.inpID.value.length != 6) {
				alert("No Match Length of ID");
				goFlg = false;
			}
		} else {
			goFlg = false;
		}
	}
	if (goFlg == true) {
		document.formTitle.formBtnType.value = tarType;
		document.formTitle.action = "maketitle.jsp";
		document.formTitle.method = "post";
		document.formTitle.submit();
	}
}
function selIDLine(tarID) {
/* 明細行でID選択 */
	document.formTitle.inpID.value = tarID;
	//IDでイコール検索しなおし
	sendQuery('btnID');
}
function openModWindow(tarID) {
/* マスタ更新用窓を開く */
	wkURL = openTitle + modTitlePrm1 + tarID + modTitlePrm2;
	rtn = window.open(wkURL, '_blank', 'toolbar=no,location=no,resizable=yes,status=yes,menubar=no,scrollbars=yes');
}
function openCalendarWindow(tarInp) {
/* ID/日付入力用窓を開く */
	var ref = document.getElementById("inp" + tarInp);
	var arrArg = ref.value.split(/\D/g);
	var now = new Date();
	var	y = now.getFullYear();
	var	m = now.getMonth() + 1;
	var	d = now.getDate();

	switch (arrArg.length) {
	case 0:
		break;
	case 1:
		if (tarInp.indexOf("ID") > 0) {
			y = parseInt(arrArg[0].substring(0, 2), 10);
			if (y > 70) {
				y += 1900;
			} else {
				y += 2000;
			}
			m = parseInt(arrArg[0].substring(2, 4), 10);
			d = parseInt(arrArg[0].substring(4, 6), 10);
		} else {
			y = 0;
			m = 0;
			d = parseInt(arrArg[0], 10);
		}
		break;
	case 2:
		y = 0;
		m = parseInt(arrArg[0], 10);
		d = parseInt(arrArg[1], 10);
		break;
	default:
		y = parseInt(arrArg[0], 10);
		m = parseInt(arrArg[1], 10);
		d = parseInt(arrArg[2], 10);
	}
	if ((isNaN(y) == true) ||
	    (isNaN(m) == true) ||
	    (isNaN(d) == true)) {
	  makeCalendar(tarInp, "");
	} else {
		now.setFullYear(y);
		now.setMonth(m - 1);
		now.setDate(d);
		makeCalendar(tarInp, now);
	}
}
function clearName(tarBtn) {
/* 検索文字列クリア */
	if ((tarBtn == "btnTitleClear") ||
	    (tarBtn == "btnAllClear")) {
		document.formTitle.inpTitle.value = "";
		document.formTitle.inpTitleSort.value = "";
	}
	if ((tarBtn == "btnSubClear") ||
	    (tarBtn == "btnAllClear")) {
		document.formTitle.inpSub.value = "";
		document.formTitle.inpSubSort.value = "";
	}
	if ((tarBtn == "btnUri") ||
	    (tarBtn == "btnAllClear")) {
		document.formTitle.inpURI.value = "";
	}
	if ((tarBtn == "btnMemo") ||
	    (tarBtn == "btnAllClear")) {
		document.formTitle.inpMemo.value = "";
	}
	if (tarBtn == "btnAllClear") {
		document.formTitle.inpSeq.value = "";
	}
}
// -->
</script>
<!-- jsp:include page="commonfunc.jsp" / -->
</head>
<body bgcolor="#FFFFFF" text="#000000">
<%
	request.setCharacterEncoding("UTF-8");
%>
<%!
	SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat dateFmtE = new SimpleDateFormat("yyyy.M/d(E) H:mm:ss");
	SimpleDateFormat dateFmtS = new SimpleDateFormat("yy.M/d");
%>
<%!
	public String escapeString(String str) {
	//',",\ をescapeする
		try {
			StringBuffer stB = new StringBuffer();
			for (int i = 0; i < str.length(); i++) {
				switch(str.charAt(i)) {
				case '\'':
				case '@':
				case '<':
				case '>':
					stB.append("\\").append(str.charAt(i));
					break;
				case '&':
					stB.append("&amp;");
					break;
				case '"':
					stB.append("&quot;");
					break;
				case '―':
					stB.append("&mdash;");
					break;
				default:
					stB.append(str.charAt(i));
					break;
				}
			}
			return stB.toString().trim();
		} catch (Exception e) {
			return "";
		}
	}
%>
<%
String[] strCo = new String[13];
String sch_comName = cmR.getComputerName(request.getRequestURL().toString());	//ホスト名

/* Formの検索条件を退避 */
String search_id = cmR.convertNullToString(request.getParameter("inpID"));
String search_title = cmR.convertNullToString(request.getParameter("inpTitle"));
String search_titleS = cmR.convertNullToString(request.getParameter("inpTitleSort"));
String search_sub = cmR.convertNullToString(request.getParameter("inpSub"));
String search_subS = cmR.convertNullToString(request.getParameter("inpSubSort"));
String search_cat = cmR.convertNullToString(request.getParameter("selCat"));
String search_seq = cmR.convertNullToString(request.getParameter("inpSeq"));
String search_URI = cmR.convertNullToString(cmR.convertNullToString(request.getParameter("inpURI")));
String search_memo = cmR.convertNullToString(request.getParameter("inpMemo"));
String search_modDate = "";     /* 更新日 */
String search_btn = cmR.convertNullToString(request.getParameter("formBtnType"));

String tarOwnerCtrl = cmR.convertNullToString(request.getParameter("tarCtrl"));
String tarTitleID = cmR.convertNullToString(request.getParameter("tarTitle"));
String tarSubID = cmR.convertNullToString(request.getParameter("tarSub"));
String tarProID = cmR.convertNullToString(request.getParameter("tarPro"));
String tarSouID = cmR.convertNullToString(request.getParameter("tarSou"));
String parChkTT = cmR.convertNullToString(request.getParameter("chkTT"));
String parChkTS = cmR.convertNullToString(request.getParameter("chkTS"));
String parChkTP = cmR.convertNullToString(request.getParameter("chkTP"));
String parChkTK = cmR.convertNullToString(request.getParameter("chkTK"));
String rtnTitleID = cmR.convertNullToString(request.getParameter("rtnTitle"));
String rtnSubID = cmR.convertNullToString(request.getParameter("rtnSub"));
String rtnProID = cmR.convertNullToString(request.getParameter("rtnPro"));
String rtnSouID = cmR.convertNullToString(request.getParameter("rtnSou"));
String parChkRT = cmR.convertNullToString(request.getParameter("chkRT"));
String parChkRS = cmR.convertNullToString(request.getParameter("chkRS"));
String parChkRP = cmR.convertNullToString(request.getParameter("chkRP"));
String parChkRK = cmR.convertNullToString(request.getParameter("chkRK"));

String parKeyword = cmR.convertNullToString(request.getParameter("inpKeyword"));
String parKeywordM = cmR.convertNullToString(request.getParameter("selKeyword"));
if (parKeywordM.equals("")) { parKeywordM = "GE"; }
String parKeywordT = cmR.convertNullToString(request.getParameter("selKeywordT"));
if (parKeywordT.equals("")) { parKeywordT = "T"; }
String parKeywordW = "";												/* where句ワークエリア */
String strTitleBar = "TitleDB: ";	/* タイトルバー */
StringBuffer sBfTitleBar = new StringBuffer("");	/* タイトルバー ワークエリア */

String strEQ;		/* Combo要素選択用ワーク */
String strGE;
String strIN;
Calendar parToday = Calendar.getInstance();
String nowDate = dateFmt.format(parToday.getTime());
//	rb = ResourceBundle.getBundle("rakugodb");
//	}
//	Class.forName(rb.getString("jdbc"));										/* Driver Load */
//	Connection db=DriverManager.getConnection(rb.getString("con"));	/* DB接続 */
/*	db.setReadOnly(true);		*/																/* 読み取り専用宣言 */
	//JDBC接続
	cmR.connectJdbc6();
%>
<%
/* Query組み立て */
	/* 初期画面または押下ボタン不明なら Dummy空読み */
	StringBuffer query = new StringBuffer();
	StringBuffer dbMsg = new StringBuffer();
	/* [検索]ボタンで… */
	if (search_btn.equals("btnID")) {
		if (search_id.equals("")) {
      query.append("WHERE id = 'Dummy'");			/* IDが空ならダミー検索 */
		} else {												/* 空ぢゃなきゃ完全一致検索 */
	    query.append("WHERE id = '").append(search_id).append("'");
		}
  }
	/* [前検索]なら小なり検索して１件目を採る */
	if (search_btn.equals("btnIDPrev")) {
      query.append("WHERE id < '").append(search_id);
      query.append("' ORDER BY id DESC LIMIT 0,1");
	}
	/* [次検索]なら大なり検索 */
	if (search_btn.equals("btnIDNext")) {
      query.append("WHERE id > '").append(search_id);
      query.append("' LIMIT 0,1");
	}
	/* タイトル[検索]で検索 */
	if (search_btn.equals("btnKeyword")) {
		if (parKeyword.equals("")) {
            query.append("WHERE id = 'Dummy'");
		} else {
			if (parKeywordM.equals("EQ")) {
				parKeywordW = escapeString(parKeyword);
			} else if (parKeywordM.equals("GE")) {
				parKeywordW = escapeString(parKeyword) + "%";
			} else {
				parKeywordW = "%" + escapeString(parKeyword) + "%";
			}
			if (parKeywordM.equals("EQ")) {
//				if (parKeywordT.indexOf("S") >= 0) {
                query.append("WHERE title_sort = '").append(parKeywordW).append("'");
                query.append(" OR subtitle_sort = '").append(parKeywordW).append("'");
//				} else {
//  		    query.append("WHERE title = '").append(parKeywordW).append("'");
                query.append(" OR title = '").append(parKeywordW).append("'");
                query.append(" OR subtitle = '").append(parKeywordW).append("'");
//				}
			} else {
                query.append("WHERE title_sort LIKE '").append(parKeywordW).append("'");
                query.append(" OR subtitle_sort LIKE '").append(parKeywordW).append("'");
                query.append(" OR title LIKE '").append(parKeywordW).append("'");
                query.append(" OR subtitle LIKE '").append(parKeywordW).append("'");
			}
		}
		sBfTitleBar.append(strTitleBar).append(search_title).append(search_sub);
		sBfTitleBar.append(search_titleS).append(search_subS);	//次画面のタイトルバー設定
	}
	/* [更新][追加]なら更新して再検索 */
	if ((search_btn.equals("btnMod")) ||
	    (search_btn.equals("btnAdd"))) {
			tmU.initRec();
      tmU.setId(escapeString(search_id));
			tmU.setTitle(escapeString(search_title));
			tmU.setTitleSort(escapeString(search_titleS));
			tmU.setSubtitle(escapeString(search_sub));
			tmU.setSubtitleSort(escapeString(search_subS));
			tmU.setCategory(escapeString(search_cat));
			try {
				tmU.setSeq(Integer.parseInt(search_seq));
			} catch (Exception e) {
				tmU.setSeq(0);
			}
			tmU.setUri(escapeString(search_URI));
			tmU.setMemo(escapeString(search_memo));
			if (search_btn.equals("btnAdd")) {
				if (tmU.insertRec() < 1) {
					dbMsg.append("Player Insert Error!");
				}
			} else {
				if (tmU.updateRec() < 1) {
					dbMsg.append("Player Update Error!");
				}
			}
			query = new StringBuffer();
	    query.append("WHERE id = '").append(search_id).append("'");
	}
	/* [削除]なら更新して再検索 */
	if (search_btn.equals("btnDel")) {
			tmU.deleteRec(search_id);
			query = new StringBuffer();
	    query.append("WHERE id = '").append(search_id).append("'");
	}
	if (query.toString().equals("")) {
			query.append("WHERE id = 'Dummy'");
	}
%>
<%
	/* DBを読む */
	tmS.selectDB(query.toString(), "");
	if (tmS.getResultCount() > 0) {
		//ID
		search_id = tmS.getId(0);
		//タイトル
		search_title = tmS.getTitle(0);
		search_titleS = tmS.getTitleSort(0);
		search_sub = tmS.getSubtitle(0);
		search_subS = tmS.getSubtitleSort(0);
		//カテゴリ
		search_cat = tmS.getCategory(0);
		if (search_cat.equals("")) {
			search_cat = "T";
		}
		if (!(parChkRT.equals("1"))) {		//タイトルIDが未確定で，
			if (search_cat.equals("T")) {		//カテゴリがタイトルなら，
				if (!(search_title.equals(""))) {
					rtnTitleID = search_id;			//タイトルIDをセット。
				}
			} else {
				rtnTitleID = "";							//カテゴリがタイトルでなきゃ空値。
			}
		}
		if (!(parChkRP.equals("1"))) {		//プログラムIDが未確定で，
			if (search_cat.equals("P")) {		//カテゴリがプログラムなら，
				rtnProID = search_id;				//タイトルIDをセット。
			} else {
				rtnProID = "";							//カテゴリがプログラムでなきゃ空値。
			}
		}
		if (!(parChkRK.equals("1"))) {		//プログラムIDが未確定で，
			if (search_cat.equals("K")) {		//カテゴリが局名なら，
				rtnSouID = search_id;				//タイトルIDをセット。
			} else {
				rtnSouID = "";							//カテゴリが局名でなきゃ空値。
			}
		}
		if (!(parChkRS.equals("1"))) {		//サブタイトルIDが未確定で，
			if ((search_cat.equals("T")) && (!(search_sub.equals("")))) {
				rtnSubID = search_id;					//カテゴリがタイトルかつサブタイトルが
			} else {												//空値以外ならタイトルIDをセット。
				rtnSubID = "";								//カテゴリがタイトルでなきゃ空値。
			}
		}
		//Seq
		try {
			search_seq = String.valueOf(tmS.getSeq(0));
		} catch (Exception e) {
			search_seq = "0";
		}
		if (search_seq.equals("0")) {
			search_seq = "";
		}
		//URI
		search_URI = tmS.getUri(0);
		search_memo = tmS.getMemo(0);	/* メモ */
		try {
			search_modDate = dateFmtE.format(tmS.getModifyDate(0));	/* 更新日 */
		} catch (Exception e) {
			search_modDate = "";
		}
	}
	if (sBfTitleBar.toString().equals("")) {
		sBfTitleBar.append(strTitleBar).append(search_title).append(search_sub);
	}
%>
<form name="formTitle">
<table border="0" width="100%">
	<tr>
	<td>
		<h1>MasterDB管理（演題マスタ）</h1>
	</td>
	<td align="center" id="AjaxState">
	</td>
	<td>
		<input name="outRow" size="6" type="text" readonly
		style="text-align: right;">
	</td>
	<td align="right">
		<%= sch_comName %>
	</td>
</tr>
</table>
<hr>
<!-- 親画面の各IDを表示 -->
<table border="1">
	<tr bgcolor="#eeeeee">
		<th>Owner's Controll</th>
		<th>Title</th>
		<th>SubTitle</th>
		<th>Program</th>
		<th>Source</th>
	</tr>
	<tr>
		<%
			if (parChkTT.equals("1")) { strCo[0] = "checked"; }
			if (parChkTS.equals("1")) { strCo[1] = "checked"; }
			if (parChkTP.equals("1")) { strCo[2] = "checked"; }
			if (parChkTK.equals("1")) { strCo[3] = "checked"; }
			if (parChkRT.equals("1")) { strCo[4] = "checked"; }
			if (parChkRS.equals("1")) { strCo[5] = "checked"; }
			if (parChkRP.equals("1")) { strCo[6] = "checked"; }
			if (parChkRK.equals("1")) { strCo[7] = "checked"; }
		%>
		<td><input type="text" name="tarCtrl" size="32" value="<%= tarOwnerCtrl %>" readonly></td>
		<td><input type="text" name="tarTitle" size="7" value="<%= tarTitleID %>" readonly>
				<input type="checkbox" name="chkTT" value="1" <%= strCo[0] %>></td>
		<td><input type="text" name="tarSub" size="7" value="<%= tarSubID %>" readonly>
				<input type="checkbox" name="chkTS" value="1" <%= strCo[1] %>></td>
		<td><input type="text" name="tarPro" size="7" value="<%= tarProID %>" readonly>
				<input type="checkbox" name="chkTP" value="1" <%= strCo[2] %>></td>
		<td><input type="text" name="tarSou" size="7" value="<%= tarSouID %>" readonly>
				<input type="checkbox" name="chkTK" value="1" <%= strCo[3] %>></td>
		<td><font size="-1">今回変更するIDにCheck</font><td>
	</tr>
<!-- 今回セットの各ID -->
	<tr>
		<td></td>
		<td><input type="text" name="rtnTitle" size="7" value="<%= rtnTitleID %>" readonly>
				<input type="checkbox" name="chkRT" value="1" <%= strCo[4] %>></td>
		<td><input type="text" name="rtnSub" size="7" value="<%= rtnSubID %>" readonly>
				<input type="checkbox" name="chkRS" value="1" <%= strCo[5] %>></td>
		<td><input type="text" name="rtnPro" size="7" value="<%= rtnProID %>" readonly>
				<input type="checkbox" name="chkRP" value="1" <%= strCo[6] %>></td>
		<td><input type="text" name="rtnSou" size="7" value="<%= rtnSouID %>" readonly>
				<input type="checkbox" name="chkRK" value="1" <%= strCo[7] %>></td>
		<td><font size="-1">変更が確定したIDにCheck</font><td>
	</tr>
</table>
<div id="divCalendar" class="div1"></div>
<table border="1" id="tblId">
<!-- IDとカテゴリ -->
	<tr align="center">
		<th bgcolor="silver" width="96" id="thTmID">
			<input name="btnCalID" type="button"
				onclick="javascript: openCalendarWindow('TmID')" value="TitleID">
		</th>
		<td>
			<input size="7" type="text" maxlength="6"
 				id="inpTmID"
				name="inpID" value="<%= search_id %>">
		</td>
		<td><input type="button" onclick="javascript:sendQuery('btnID')" name="btnKensaku" value="検索"></td>
		<td><input type="button" onclick="javascript:sendQuery('btnIDPrev')" name="btnKensakuPrev" value="前検索"></td>
		<td><input type="button" onclick="javascript:sendQuery('btnIDNext')" name="btnKensakuNext" value="次検索"></td>
		<th bgcolor="silver">
			検索
		</th>
		<td align="left">
			<input size="17" type="text" maxlength="255"
				name="inpKeyword" value="<%= parKeyword %>">
            <%
                //検索条件セレクタ
                out.println(cmF.makeSelectOption("selKeyword", "", parKeywordM));
            %>
		</td>
		<td align="center">
			<input type="button" name="btnKeyword"
				onclick="javascript: sendQuery('btnKeyword')" value="検索">
		</td>
  </tr>
<!--	<tr>
		<td colspan="6"></td>
		<td colspan="2">
		<%
			//検索条件セレクタ
//			out.println(cmF.makeSelectOption("selKeyword", "", parKeywordM));
		%>
		<%
			//姓名・かなセレクタ
//			out.println(cmF.makeSelectItemT("selKeywordT", "", parKeywordT));
		%>
		</td>
	</tr>
    -->
</table>
<table border="1">
<!-- タイトル編集 -->
	<tr>
		<th bgcolor="silver">題名</th>
		<td colspan="3">
			<input size="72" type="text" maxlength="255"
				name="inpTitle" value="<%= search_title %>"
				id="title" onblur="javascript: assistKana(this, 'tm')";>
		</td>
		<td align="center" rowspan="2">
			<input type="button" onclick="javascript:clearName('btnTitleClear')" value="クリア">
		</td>
	</tr>
	<tr>
		<th bgcolor="silver">かな</th>
		<td colspan="3">
			<input size="72" type="text" maxlength="255"
				name="inpTitleSort" value="<%= search_titleS %>"
				id="titleSort" onblur="javascript: assistKana(this, 'tm')";>
			<div id="titleSortWork"></div>
		</td>
	</tr>
<!-- サブタイトル編集 -->
	<tr>
		<th bgcolor="silver">副題</th>
		<td colspan="3">
			<input size="72" type="text" maxlength="255"
				name="inpSub" value="<%= search_sub %>"
				id="subtitle" onblur="javascript: assistKana(this, 'tm')";>
		</td>
		<td align="center" rowspan="2">
			<input type="button" onclick="javascript:clearName('btnSubClear')" value="クリア">
		</td>
	</tr>
	<tr>
		<th bgcolor="silver">かな</th>
		<td colspan="3">
			<input size="72" type="text" maxlength="255"
				name="inpSubSort" value="<%= search_subS %>"
				id="subtitleSort" onblur="javascript: assistKana(this, 'tm')";>
			<div id="subtitleSortWork"></div>
		</td>
	</tr>
	<tr>
		<th bgcolor="silver" width="96"><font size="-1">種類・SEQ</font></th>
		<td>
			<%
			//演題種別セレクタ
			out.println(cmF.makeTitleCategory("selCat", "", search_cat));
			%>
		</td>
		<td colspan="2">
			<input size="5" type="text" maxlength="6" name="inpSeq" value="<%= search_seq %>">
		</td>
		<td align="center">
			<input type="button" onclick="javascript:clearName('btnAllClear')" value="全クリア">
		</td>
	</tr>
<!-- URI編集 -->
	<tr>
		<th bgcolor="silver">URI</th>
		<td colspan="3">
			<input size="72" type="text" maxlength="255" name="inpURI" value="<%= search_URI %>">
		</td>
		<td align="center">
			<input type="button" onclick="javascript:clearName('btnUri')" value="クリア">
		</td>
	</tr>
<!-- メモ編集 -->
	<tr>
		<th bgcolor="silver">メモ</th>
		<td colspan="3">
			<input size="72" type="text" maxlength="255" name="inpMemo" value="<%= search_memo %>">
		</td>
		<td align="center">
			<input type="button" onclick="javascript:clearName('btnMemo')" value="クリア">
		</td>
	</tr>
<!-- 更新日表示 -->
	<tr align="center">
		<th bgcolor="silver">更新日</th>
		<td align="left"><%= search_modDate %></td>
		<td>
			<input type="Button" onclick="javascript: sendQuery('btnMod')" name="btnModTitle" value="更新">
		</td>
		<td>
			<input type="Button" onclick="javascript: sendQuery('btnAdd')" name="btnModTitle" value="追加">
		</td>
		<td>
			<input type="Button" onclick="javascript:sendQuery('btnDel')" name="btnModTitle" value="削除">
		</td>
	</tr>
</table>
<table border="1">
	<tr>
		<td width="96"></td>
		<td align="center" width="96"><input type="Button" onclick="javascript:rtnID()" name="btnOK" value="OK"></td>
		<td align="center" width="96"><input type="Button" onclick="javascript:window.close()" name="btnCancel" value="Cancel"></td>
	</tr>
</table>
<input name="formBtnType" type="hidden" value="<%= search_btn %>">
<input name="inpTitleBar" type="hidden" value="<%= sBfTitleBar.toString() %>">
</form>
<hr>
<form name="formList">
	<input name="inpModID" type="hidden" value="">
	<table border="0">
		<tr align="center" bgcolor=silver>
			<td>別窓</td>
			<td>同窓</td>
			<th>No.</th>
			<th>ID</th>
			<th>CAT</th>
			<th>TITLE</th>
			<th>TitleSort</th>
			<th>SUBTITLE</th>
			<th>SubSort</th>
			<th>SEQ</th>
			<th>MEMO</th>
			<th>MOD DATE</th>
		</tr>
<%
	int row = 0;
  for (int i = 0; i < tmS.getResultCount(); i++) {
		row = row + 1;
		//ID
		search_id = tmS.getId(i);
		search_title = tmS.getTitle(i);
		search_titleS = tmS.getTitleSort(i);
		search_sub = tmS.getSubtitle(i);
		search_subS = tmS.getSubtitleSort(i);
		search_cat = tmS.getCategory(i);
		//Seq
		try {
			search_seq = String.valueOf(tmS.getSeq(i));
		} catch (Exception e) {
			search_seq = "0";
		}
		//URI
		search_URI = tmS.getUri(i);
		search_memo = tmS.getMemo(i);	/* メモ */
		try {
			search_modDate = dateFmtS.format(tmS.getModifyDate(i));	/* 更新日 */
		} catch (Exception e) {
			search_modDate = "";
		}
		if (search_title.equals("")) {
			search_sub = cmR.addUri(search_sub, search_URI);
		} else {
			search_title = cmR.addUri(search_title, search_URI);
		}
%>
		<tr>
			<td>
				<input type="button" name="btnModID"
					onclick="javascript:openModWindow('<%= search_id %>')" value="Edit")>
			</td>
			<td>
				<input type="button" name="btnIDLine"
					onclick="javascript:selIDLine('<%= search_id %>')" value="Select")>
			</td>
			<td align="right"><%= row %></td>
			<td><%= search_id %></td>
			<td><%= search_cat %></td>
			<td><%= search_title %></td>
			<td><%= search_titleS %></td>
			<td><%= search_sub %></td>
			<td><%= search_subS %></td>
			<td align="right"><%= search_seq %></td>
			<td><%= search_memo %></td>
			<td><%= search_modDate %></td>
		</tr>
<%
	}
//  rs.close();
//rs2.close();
//	st.close();
//  db.close();
	cmR.closeJdbc();
%>
</table>
<br>
<%= row %>件
</form>
<script language="JavaScript" type="text/javascript">
<!--
	document.title = document.formTitle.inpTitleBar.value;
	document.formTitle.outRow.value = <%= row %> + "件";
	if ("<%= dbMsg.toString() %>" != "") {
		document.getElementById("AjaxState").innerHTML =
			"<font color='red'>" + "<%= dbMsg.toString() %>" + "</font>";
	}

function rtnID() {
/* 親画面にIDを返す */
	var wkTitle = "Push [更新]";
	var wkSub = "Push [更新]";
	if (document.formTitle.inpTitle.value != "") {
		wkTitle += "（" + document.formTitle.inpTitle.value + "）";
	}
	if (document.formTitle.inpSub.value != "") {
		wkSub += "（" + document.formTitle.inpSub.value + "）";
	}
	if (document.formTitle.tarCtrl.value.indexOf("form") >= 0) {
		if (document.formTitle.chkTT.checked == true) {
			window.opener.document.formRakugo.inpTitleID.value = document.formTitle.rtnTitle.value;
			window.opener.document.formRakugo.inpTitle.value = wkTitle;
		}
		if (document.formTitle.chkTS.checked == true) {
			window.opener.document.formRakugo.inpSubID.value = document.formTitle.rtnSub.value;
			window.opener.document.formRakugo.inpSub.value = wkSub;
		}
		if (document.formTitle.chkTP.checked == true) {
			window.opener.document.formRakugo.inpProgramID.value = document.formTitle.rtnPro.value;
			window.opener.document.formRakugo.inpProgram.value = wkTitle;
		}
		if (document.formTitle.chkTK.checked == true) {
			window.opener.document.<%= tarOwnerCtrl.substring(0, tarOwnerCtrl.indexOf(".")) %>.inpSourceID.value
				= document.formTitle.rtnSou.value;
			window.opener.document.<%= tarOwnerCtrl.substring(0, tarOwnerCtrl.indexOf(".")) %>.inpSource.value
				= wkTitle;
		}
	}
	window.close();
}
// -->
</script>
</body>
</html>
