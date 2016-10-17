<%@ page buffer="128kb" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,java.text.*" %>
<jsp:useBean id="pmS" class="jp.rakugo.nii.PlayerMasterSelect" scope="page" />
<jsp:useBean id="pmU" class="jp.rakugo.nii.PlayerMasterUpdate" scope="page" />
<jsp:useBean id="cmF" class="jp.rakugo.nii.CommonForm" scope="page" />
<jsp:useBean id="cmR" class="jp.rakugo.nii.CommonRakugo" scope="page" />
<html lang="ja">
<head>
<title>Playerマスタ管理</title>
<link rel="stylesheet" type="text/css" href="makerakugo.css">
<script language="JavaScript" type="text/javascript" src="assistinput.js"></script>
<script language="JavaScript" src="inpcalendar.js"></script>
<script language="JavaScript" src="inpclock.js"></script>
<script language="JavaScript">
<!--
var rtn;
var openCalendar = "inpcalendar.jsp";
var openPlayer = "makeplayer.jsp";
var modPlayerPrm1 = "?formID=";
var modPlayerPrm2 = "&formModeSei=GE&formModeMei=GE&selNameFlg=A&formModeGroup=GE&formBtnType=btnID&tarCtrl=start.htm";
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
			if (document.formPlayer.formID.value.length != 6) {
				alert("No Match Length of ID");
				goFlg = false;
			}
		} else {
			goFlg = false;
		}
	}
	if (goFlg == true) {
		document.formPlayer.formBtnType.value = tarType;
		document.formPlayer.method = "post";
		document.formPlayer.action = "makeplayer.jsp";
		document.formPlayer.submit();
	}
}
function selIDLine(tarID) {
/* 明細行でID選択 */
	document.formPlayer.formID.value = tarID;
	//IDでイコール検索しなおし
	sendQuery('btnID');
}
function openModWindow(tarID) {
/* マスタ更新用窓を開く */
wkURL = openPlayer + modPlayerPrm1 + tarID + modPlayerPrm2;
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
	if ((tarBtn == "btnSeiClear") || (tarBtn == "btnAllClear")) {
		document.formPlayer.formSei.value = "";
		document.formPlayer.formSeiSort.value = "";
	}
	if ((tarBtn == "btnMeiClear") || (tarBtn == "btnAllClear")) {
		document.formPlayer.formMei.value = "";
		document.formPlayer.formMeiSort.value = "";
	}
	if ((tarBtn == "btnGroupClear") || (tarBtn == "btnAllClear")) {
		document.formPlayer.formGroup.value = "";
		document.formPlayer.formGroupSort.value = "";
	}
	if ((tarBtn == "btnFullClear") || (tarBtn == "btnAllClear")) {
		document.formPlayer.formFull.value = "";
	}
	if ((tarBtn == "btnUri") || (tarBtn == "btnAllClear")) {
		document.formPlayer.formURI.value = "";
	}
	if ((tarBtn == "btnMemo") || (tarBtn == "btnAllClear")) {
		document.formPlayer.formMemo.value = "";
	}
	if (tarBtn == "btnAllClear") {
		document.formPlayer.formSeq.value = "";
	}
}
function exchangeName() {
/* 姓⇔名逆転 */
	var wk1;
 	wk1 = document.formPlayer.formSei.value;
	document.formPlayer.formSei.value = document.formPlayer.formMei.value;
 	document.formPlayer.formMei.value = wk1;
 	wk1 = document.formPlayer.formSeiSort.value;
	document.formPlayer.formSeiSort.value = document.formPlayer.formMeiSort.value;
	document.formPlayer.formMeiSort.value = wk1;
	
	assistFullName("force");
//	makeFullName("rev");
}
function checkFullName(mode) {
/* SENDの前に姓名設定有無チェック
	設定済みならSEND，以外は設定のみ。
*/
	var str = document.formPlayer.formFull.value;
	
	if (str == "") {
		assistFullName("auto");
		alert("Check \"FullName\" and try again.");
	} else {
		sendQuery(mode);
	}
}
// -->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<%
	request.setCharacterEncoding("UTF-8");
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
/* Formの検索条件を退避 */
String sch_comName = cmR.getComputerName(request.getRequestURL().toString());
String search_id = request.getParameter("formID");							/* ID */
String search_nameL = cmR.convertNullToString(request.getParameter("formSei"));		/* 姓 */
String search_nameLS = cmR.convertNullToString(request.getParameter("formSeiSort"));	/* 姓ふりがな */
String search_nameLM = cmR.convertNullToString(request.getParameter("formModeSei"));			/* 姓検索モード */
String search_nameFL = cmR.convertNullToString(request.getParameter("formFull"));				/* 姓名 */
String search_nameF = cmR.convertNullToString(request.getParameter("formMei"));					/* 名 */
String search_nameFS = cmR.convertNullToString(request.getParameter("formMeiSort"));			/* 名ふりがな */
String search_nameFM = cmR.convertNullToString(request.getParameter("formModeMei"));			/* 名検索モード */
String search_nameJ = cmR.convertNullToString(request.getParameter("selNameFlg"));	/* 姓名順 */
if (search_nameJ.equals("")) { search_nameJ = "A"; }
String search_nameG = cmR.convertNullToString(request.getParameter("formGroup"));				/* グループ名 */
String search_nameGS = cmR.convertNullToString(request.getParameter("formGroupSort"));		/* グループ名ふりがな */
String search_nameGM = cmR.convertNullToString(request.getParameter("formModeGroup"));		/* グループ検索モード */
if (search_nameGM.equals("")) { search_nameGM = "GE"; }
String search_seq = cmR.convertNullToString(request.getParameter("formSeq"));						/* 代目 */
String search_krnID = cmR.convertNullToString(request.getParameter("formKanrenID"));			/* 関連ID */
String search_URI = cmR.convertNullToString(request.getParameter("formURI"));		/* URI */
String search_memo = cmR.convertNullToString(request.getParameter("formMemo"));					/* メモ */
String search_modDate = "";												/* 更新日 */
String search_btn = cmR.convertNullToString(request.getParameter("formBtnType"));				/* 押下ボタン種 */
if (search_btn.equals("")) { search_btn = "dummy"; }

String tarOwnerCtrl = cmR.convertNullToString(request.getParameter("tarCtrl"));	/* 親画面のCntroll */
String tarTitleID = cmR.convertNullToString(request.getParameter("tarTitle"));				/* 親画面のTitleID */
String tarP1ID = cmR.convertNullToString(request.getParameter("tarP1"));				/* 親画面のPlayer1ID */
String tarP2ID = cmR.convertNullToString(request.getParameter("tarP2"));				/* 親画面のPlayer2ID */
String tarP3ID = cmR.convertNullToString(request.getParameter("tarP3"));				/* 親画面のPlayer3ID */
String parChkT1 = cmR.convertNullToString(request.getParameter("chkT1"));				//親画面Player1ID確定サイン
String parChkT2 = cmR.convertNullToString(request.getParameter("chkT2"));				//親画面Player2ID確定サイン
String parChkT3 = cmR.convertNullToString(request.getParameter("chkT3"));				//親画面Player3ID確定サイン
String rtnP1ID = cmR.convertNullToString(request.getParameter("rtnP1"));				/* 返すPlayer1ID */
String rtnP2ID = cmR.convertNullToString(request.getParameter("rtnP2"));				/* 返すPlayer2ID */
String rtnP3ID = cmR.convertNullToString(request.getParameter("rtnP3"));				/* 返すPlayer3ID */
String parChkR1 = cmR.convertNullToString(request.getParameter("chkR1"));				//返すPlayer1ID確定サイン
String parChkR2 = cmR.convertNullToString(request.getParameter("chkR2"));				//返すPlayer2ID確定サイン
String parChkR3 = cmR.convertNullToString(request.getParameter("chkR3"));				//返すPlayer3ID確定サイン
String parKeyword = cmR.convertNullToString(request.getParameter("inpKeyword"));	/* 文字列検索Word */
String parKeywordM = cmR.convertNullToString(request.getParameter("selKeyword"));		/* 文字列検索モード */
if (parKeywordM.equals("")) { parKeywordM = "GE"; }
String parKeywordT = cmR.convertNullToString(request.getParameter("selKeywordT"));	/* 文字列検索種 */
if (parKeywordT.equals("")) { parKeywordT = "T"; }
String parKeywordW = "";												/* where句ワークエリア */
String strTitleBar = "PlayerDB: ";	/* タイトルバー */
StringBuffer sBfTitleBar = new StringBuffer("");	/* タイトルバー ワークエリア */

String strEQ;		/* Combo要素選択用ワーク */
String strGE;
String strIN;

SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat dateFmtE = new SimpleDateFormat("yyyy.M/d(E) H:mm:ss");
SimpleDateFormat dateFmtS = new SimpleDateFormat("yy.M/d(E)");

Calendar parToday = Calendar.getInstance();
String nowDate = dateFmt.format(parToday.getTime());
/* DB接続 */
	cmR.connectJdbc6();
/* 検索Query組み立て */
	/* 初期画面または押下ボタン不明なら Dummy空読み */
	String query = "WHERE id = 'Dummy'";
	StringBuffer dbMsg = new StringBuffer();
	/* [検索]ボタンで… */
	if (search_btn.equals("btnID")) {
		if (search_id.equals("")) {
      query = "ORDER BY id LIMIT 0,1";			/* IDが空なら先頭検索 */
		} else {											/* 空ぢゃなきゃ完全一致検索 */
	    query = "WHERE id = '" + search_id + "'";
		}
  }
	/* [前検索]なら小なり検索して１件目を採る */
	if (search_btn.equals("btnIDPrev")) {
		query = "WHERE id < '" + search_id + "' ORDER BY id DESC LIMIT 0,1";
	}
	/* [次検索]なら大なり検索 */
	if (search_btn.equals("btnIDNext")) {
		query = "WHERE id > '" + search_id + "' LIMIT 0,1";
	}
	/* 姓名所属[検索]で検索 */
	if (search_btn.equals("btnKeyword")) {
		if (parKeyword.equals("")) {
      query = "WHERE id = 'Dummy'";
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
                query = "WHERE last_sort = '" + parKeywordW + "'";
                query += " OR first_sort = '" + parKeywordW + "'";
                query += " OR family_sort = '" + parKeywordW + "'";
//				} else {
                query += " OR last_name = '" + parKeywordW + "'";
                query += " OR first_name = '" + parKeywordW + "'";
                query += " OR family_name = '" + parKeywordW + "'";
                query += " OR full_name = '" + parKeywordW + "'";
//				}
            } else {
//				if (parKeywordT.indexOf("S") >= 0) {
                query = "WHERE last_sort LIKE '" + parKeywordW + "'";
                query += " OR first_sort LIKE '" + parKeywordW + "'";
                query += " OR family_sort LIKE '" + parKeywordW + "'";
//				} else {
//  		    query = "WHERE last_name LIKE '" + parKeywordW + "'";
                query += " OR last_name LIKE '" + parKeywordW + "'";
                query += " OR first_name LIKE '" + parKeywordW + "'";
                query += " OR family_name LIKE '" + parKeywordW + "'";
                query += " OR full_name LIKE '" + parKeywordW + "'";
//				}
			}
		}
		sBfTitleBar.append(strTitleBar).append(parKeywordW);	//次画面のタイトルバー設定
	}
	/* [更新][追加]なら更新して再検索 */
	if ((search_btn.equals("btnMod")) ||
	    (search_btn.equals("btnAdd"))) {
			pmU.initRec();
      pmU.setId(escapeString(search_id));
			pmU.setLastName(escapeString(search_nameL));
			pmU.setLastSort(escapeString(search_nameLS));
			pmU.setFullName(escapeString(search_nameFL));
			pmU.setFirstName(escapeString(search_nameF));
			pmU.setFirstSort(escapeString(search_nameFS));
			pmU.setFamilyName(escapeString(search_nameG));
			pmU.setFamilySort(escapeString(search_nameGS));
			pmU.setNameFlg(escapeString(search_nameJ));
			try {
				pmU.setNameSeq(Integer.parseInt(search_seq));
			} catch (Exception e) {
				pmU.setNameSeq(0);
			}
			pmU.setRelateId(escapeString(search_krnID));
			pmU.setUri(escapeString(search_URI));
			pmU.setMemo(escapeString(search_memo));
			
			if (search_btn.equals("btnAdd")) {
				if (pmU.insertRec() < 1) {
					dbMsg.append("Player Insert Error!");
				}
			} else {
				if (pmU.updateRec() < 1) {
					dbMsg.append("Player Update Error!");
				}
			}
	    query = "WHERE id = '" + search_id + "'";
	}
	/* [削除]なら更新して再検索 */
	if (search_btn.equals("btnDel")) {
			pmU.deleteRec(search_id);
	    query = "WHERE id = '" + search_id + "'";
	}
	/* DBを読む */
	pmS.selectDB(query, "");	//JavaBeans
	int i = 0;
	if (pmS.getResultCount() > 0) {
		search_id = pmS.getId(i);
		if (!(parChkR1.equals("1"))) {		//Player1IDが未確定なら
			rtnP1ID = search_id;						//タイトルIDをセット。
		}
		if (!(parChkR2.equals("1"))) {		//Player2IDが未確定なら
			rtnP2ID = search_id;						//タイトルIDをセット。
		}
		if (!(parChkR3.equals("1"))) {		//Player3IDが未確定なら
			rtnP3ID = search_id;						//タイトルIDをセット。
		}
		search_nameL = pmS.getLastName(i);		/* 姓 */
		search_nameLS = pmS.getLastSort(i);	/* 姓ふりがな */
		search_nameFL = pmS.getFullName(i);	/* 姓名 */
		search_nameF = pmS.getFirstName(i);	/* 名 */
		search_nameFS = pmS.getFirstSort(i);	/* 名ふりがな */
		search_nameJ = pmS.getNameFlg(i);
		if (search_nameJ.equals("")) { search_nameJ = "A"; }
		search_nameG = pmS.getFamilyName(i);		/* グループ名 */
		search_nameGS = pmS.getFamilySort(i);	/* グループ名ふりがな */
		try {
			search_seq = String.valueOf(pmS.getNameSeq(i));						/* 代目 */
			if (search_seq.equals("0")) { search_seq = ""; }
		} catch (Exception e) {
			search_seq = "";
		}
		search_krnID = pmS.getRelateId(i);			/* 関連ID */
		search_URI = pmS.getUri(i);		/* URI */
		search_memo = pmS.getMemo(i);				/* メモ */
		try {
			search_modDate = dateFmtE.format(pmS.getModifyDate(i));				/* 更新日 */
		} catch (Exception e) {
			search_modDate = "";
		}
	}
	if (sBfTitleBar.toString().equals("")) {
		sBfTitleBar.append(strTitleBar).append(search_nameL).append(search_nameF).append(search_nameG);
	}
%>
<form name="formPlayer">
<table border="0" width="100%">
	<tr><td>
		<h1>MasterDB管理（演者マスタ）</h1>
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
		<th>Player1</th>
		<th>Player2</th>
		<th>Player3</th>
	</tr>
	<tr>
		<%
			String[] strCo = new String[6];
			if (parChkT1.equals("1")) { strCo[0] = "checked"; }
			if (parChkT2.equals("1")) { strCo[1] = "checked"; }
			if (parChkT3.equals("1")) { strCo[2] = "checked"; }
			if (parChkR1.equals("1")) { strCo[3] = "checked"; }
			if (parChkR2.equals("1")) { strCo[4] = "checked"; }
			if (parChkR3.equals("1")) { strCo[5] = "checked"; }
		%>
		<td><input type="text" name="tarCtrl" size="24" value="<%= tarOwnerCtrl %>" readonly></td>
		<td><input type="text" name="tarP1" size="8" value="<%= tarP1ID %>" readonly>
				<input type="checkbox" name="chkT1" value="1" <%= strCo[0] %>></td>
		<td><input type="text" name="tarP2" size="8" value="<%= tarP2ID %>" readonly>
				<input type="checkbox" name="chkT2" value="1" <%= strCo[1] %>></td>
		<td><input type="text" name="tarP3" size="8" value="<%= tarP3ID %>" readonly>
				<input type="checkbox" name="chkT3" value="1" <%= strCo[2] %>></td>
		<td><font size="-1">今回変更するIDにCheck</font></td>
	</tr>
<!-- 今回セットの各ID -->
	<tr>
		<td></td>
		<td><input type="text" name="rtnP1" size="8" value="<%= rtnP1ID %>" readonly>
				<input type="checkbox" name="chkR1" value="1" <%= strCo[3] %>></td>
		<td><input type="text" name="rtnP2" size="8" value="<%= rtnP2ID %>" readonly>
				<input type="checkbox" name="chkR2" value="1" <%= strCo[4] %>></td>
		<td><input type="text" name="rtnP3" size="8" value="<%= rtnP3ID %>" readonly>
				<input type="checkbox" name="chkR3" value="1" <%= strCo[5] %>></td>
		<td><font size="-1">変更が確定したIDにCheck</font></td>
	</tr>
</table>
<div id="divCalendar" class="div1"></div>
<table border="1" id="tblId">
<!-- IDの制御 -->
	<tr>
		<th bgcolor="silver" width="96" id="thPmID">
			<input name="btnCalID" type="button"
				onclick="javascript: openCalendarWindow('PmID')" value="PlayerID">
		</th>
		<td>
			<input size="8" type="text" maxlength="6"
 				id="inpPmID"
				name="formID" value="<%= search_id %>">
		</td>
		<td align="center">
			<input type="submit" onclick="javascript:sendQuery('btnID')" name="formKensaku" value="検索">
		</td>
		<td align="center">
			<input type="button" onclick="javascript:sendQuery('btnIDPrev')" name="formKensakuPrev" value="前検索">
		</td>
		<td align="center">
			<input type="button" onclick="javascript:sendQuery('btnIDNext')" name="formKensakuNext" value="次検索">
		</td>
		<!-- th bgcolor="silver" rowspan="2" -->
		<th bgcolor="silver">
			検索
		</th>
		<td align="left">
			<input size="10" type="text" maxlength="255"
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
	<!-- tr>
		<td colspan="6"></td>
		<td colspan="2">
		<%
			//姓名・かなセレクタ
//			out.println(cmF.makeSelectItemP("selKeywordT", "", parKeywordT));
		%>
		</td>
	</tr -->
</table>
<table border="1">
<!-- 姓の制御 -->
	<tr>
		<th bgcolor="silver" width="96">姓・かな</th>
		<td colspan="2">
			<input size="32" type="text" maxlength="255"
			 name="formSei" value="<%= search_nameL %>"
			 id="sei" onblur="javascript: assistKana(this, 'pm');">
		</td>
		<td colspan="2">
			<input size="32" type="text" maxlength="255"
			 name="formSeiSort" value="<%= search_nameLS %>"
			 id="seiSort" onblur="javascript: assistKana(this, 'pm');">
			<div id="seiSortWork"></div>
		</td>
		<td align="center">
			<input type="button" onclick="javascript:clearName('btnSeiClear')" value="クリア">
		</td>
	</tr>
<!-- 名の制御 -->
	<tr>
		<th bgcolor="silver">名・かな</th>
		<td colspan="2">
			<input size="32" type="text" maxlength="255"
			 name="formMei" value="<%= search_nameF %>"
			 id="mei" onblur="javascript: assistKana(this, 'pm');">
		</td>
		<td colspan="2">
			<input size="32" type="text" maxlength="255"
			 name="formMeiSort" value="<%= search_nameFS %>"
		   id="meiSort" onblur="javascript: assistKana(this, 'pm');">
			<div id="meiSortWork"></div>
		</td>
		<td align="center">
			<input type="button" onclick="javascript:clearName('btnMeiClear')" value="クリア">
		</td>
	</tr>
	<tr>
		<th bgcolor="silver" style="font-size:90%">所属・かな</th>
		<td colspan="2">
			<input size="32" type="text" maxlength="255"
			 name="formGroup" value="<%= search_nameG %>"
			 id="group" onblur="javascript: assistKana(this, 'pm');">
		</td>
		<td colspan="2">
			<input size="32" type="text" maxlength="255"
			 name="formGroupSort" value="<%= search_nameGS %>"
			 id="groupSort" onblur="javascript: assistKana(this, 'pm');">
			<div id="groupSortWork"></div>
		</td>
		<td align="center">
			<input type="button" onclick="javascript:clearName('btnGroupClear')" value="クリア">
		</td>
	</tr>
	<tr>
		<th bgcolor="silver">姓名</th>
		<td colspan="3">
			<input size="52" type="text" maxlength="255"
				name="formFull" value="<%= search_nameFL %>"
				id="fullname" onblur="javascript: assistFullName('auto');">
		</td>
		<td>
			<input size="3" type="text" maxlength="3" name="formSeq" value="<%= search_seq %>">代目
		</td>
		<td align="center">
			<input type="button" onclick="javascript:clearName('btnFullClear')" value="クリア">
		</td>
	</tr>
<!-- 検索条件の制御 -->
	<tr>
		<th bgcolor="silver">
			<input name="btnCalKrnID" type="button" onclick="javascript: openCalendarWindow('formKanrenID')" value="関連ID">
		</th>
		<td>
			<input size="8" type="text" maxlength="6" name="formKanrenID" value="<%= search_krnID %>">
		</td>
		<td>
<%
			//姓名・かなセレクタ
			out.println(cmF.makeNameOrder("selNameFlg", "nameOrder", search_nameJ));
%>
		</td>
		<td align="center">
			<input type="button" onclick="javascript:assistFullName('force');" value="姓名リセット">
		</td>
		<td align="center">
			<input type="button" onclick="javascript:exchangeName()" value="姓⇔名">
		</td>
		<td align="center">
			<input type="button" onclick="javascript:clearName('btnAllClear')" value="全クリア">
		</td>
	</tr>
	<tr>
		<th bgcolor="silver">URI</th>
		<td colspan="4">
			<input size="64" type="text" maxlength="255" name="formURI" value="<%= search_URI %>">
		</td>
		<td align="center">
			<input type="button" onclick="javascript:clearName('btnUri')" value="クリア">
		</td>
	</tr>
	<tr>
		<th bgcolor="silver">メモ</th>
		<td colspan="4">
			<input size="64" type="text" maxlength="255" name="formMemo" value="<%= search_memo %>">
		</td>
		<td align="center">
			<input type="button" onclick="javascript:clearName('btnMemo')" value="クリア">
		</td>
	</tr>
    <tr align="center">
      <th bgcolor="silver">更新日</th>
      <td align="left" colspan="2"><%= search_modDate %></td>
      <td>
			<input type="Button" onclick="javascript: checkFullName('btnMod')"
				name="btnModPlayer" value="更新">
		</td>
		<td>
			<input type="Button" onclick="javascript: checkFullName('btnAdd')"
				name="btnModPlayer" value="追加">
		</td>
		<td>
			<input type="Button" onclick="javascript: sendQuery('btnDel')"
				name="btnModPlayer" value="削除">
		</td>
    </tr>
  </tbody>
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
		<th>NAME</th>
		<th>SORT</th>
		<th>GROUP</th>
		<th>SORT</th>
		<th>GEN.</th>
		<th>MODE</th>
		<th>REL.ID</th>
		<th>MEMO</th>
		<th>MOD DATE</th>
	</tr>
<%
	int row = 0;
	String strName = "";
	String strSort = "";
	//明細用に上の検索結果を再利用
	for (i = 0; i < pmS.getResultCount(); i++) {
		row++;
		search_id = pmS.getId(i);
		search_nameFL = pmS.getFullName(i);	/* 姓名 */
		search_nameLS = pmS.getLastSort(i);	/* 姓ふりがな */
		search_nameFS = pmS.getFirstSort(i);	/* 名ふりがな */
		search_nameJ = pmS.getNameFlg(i);
		search_nameG = pmS.getFamilyName(i);		/* グループ名 */
		search_nameGS = pmS.getFamilySort(i);	/* グループ名ふりがな */
		try {
			search_seq = String.valueOf(pmS.getNameSeq(i));						/* 代目 */
//			if (search_seq.equals("0")) { search_seq = ""; }
		} catch (Exception e) {
			search_seq = "";
		}
		search_krnID = pmS.getRelateId(i);			/* 関連ID */
		search_URI = pmS.getUri(i);		/* URI */
		search_memo = pmS.getMemo(i);				/* メモ */
		try {
			search_modDate = dateFmtS.format(pmS.getModifyDate(i));				/* 更新日 */
		} catch (Exception e) {
			search_modDate = "";
		}
		strName = cmR.addUri(search_nameFL, search_URI);
		search_nameG = cmR.addUri(search_nameG, search_URI);
		if (search_nameJ.equals("A")) {
			strSort = search_nameLS + " " + search_nameFS;
		} else {
			strSort = search_nameFS + " " + search_nameLS;
		}
%>
<tr>
<td><input type="button" name="btnModID" onclick="javascript:openModWindow('<%= search_id %>')" value="Edit")></td>
<td><input type="button" name="btnIDLine" onclick="javascript:selIDLine('<%= search_id %>')" value="Select")></td>
			<td align="right"><%= i + 1 %></td>
<td><%= search_id %></td>
<td><%= strName %></td>
<td><%= strSort %></td>
<td><%= search_nameG %></td>
<td><%= search_nameGS %></td>
<td align="right"><%= search_seq %></td>
<td align="center"><%= search_nameJ %></td>
<td><%= search_krnID %></td>
<td><%= search_memo %></td>
<td><%= search_modDate %></td>
</tr>
<%
	}
	//JDBC切断
	cmR.closeJdbc();
%>
</table>
<br>
<%= row %>件
</form>
<script language="JavaScript" type="text/javascript">
<!--
	document.title = document.formPlayer.inpTitleBar.value;
	document.formPlayer.outRow.value = <%= row %> + "件";
	if ("<%= dbMsg.toString() %>" != "") {
		document.getElementById("AjaxState").innerHTML =
			"<font color='red'>" + "<%= dbMsg.toString() %>" + "</font>";
	}
function rtnID() {
/* 親画面にIDを返す */
	var wkName = "Push [更新]（" + document.formPlayer.formFull.value + "）";

	if (document.formPlayer.tarCtrl.value.indexOf("form") >= 0) {
		if (document.formPlayer.chkT1.checked == true) {
			window.opener.document.<%= tarOwnerCtrl.substring(0, tarOwnerCtrl.indexOf(".")) %>.inpP1ID.value
				= document.formPlayer.rtnP1.value;
			window.opener.document.<%= tarOwnerCtrl.substring(0, tarOwnerCtrl.indexOf(".")) %>.inpP1.value
				= wkName;
		}
		if (document.formPlayer.chkT2.checked == true) {
			window.opener.document.<%= tarOwnerCtrl.substring(0, tarOwnerCtrl.indexOf(".")) %>.inpP2ID.value
				= document.formPlayer.rtnP2.value;
			window.opener.document.<%= tarOwnerCtrl.substring(0, tarOwnerCtrl.indexOf(".")) %>.inpP2.value
				= wkName;
		}
		if (document.formPlayer.chkT3.checked == true) {
			window.opener.document.<%= tarOwnerCtrl.substring(0, tarOwnerCtrl.indexOf(".")) %>.inpP3ID.value
				= document.formPlayer.rtnP3.value;
			window.opener.document.<%= tarOwnerCtrl.substring(0, tarOwnerCtrl.indexOf(".")) %>.inpP3.value
				= wkName;
		}
	}
	window.close();
}
// -->
</script>
</body>
</html>