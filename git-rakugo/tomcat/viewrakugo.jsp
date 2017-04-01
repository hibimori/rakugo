<%@ page buffer="140kb" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.io.*,java.util.*,java.util.regex.*, java.sql.*,java.text.*,org.apache.xerces.parsers.*,org.xml.sax.*,org.w3c.dom.*"
%>
<jsp:useBean id="rkS" class="jp.rakugo.nii.RakugoTableSelect" scope="page" />
<jsp:useBean id="tmS" class="jp.rakugo.nii.TitleMasterSelect" scope="page" />
<jsp:useBean id="pmS" class="jp.rakugo.nii.PlayerMasterSelect" scope="page" />
<jsp:useBean id="cmF" class="jp.rakugo.nii.CommonForm" scope="page" />
<jsp:useBean id="cmR" class="jp.rakugo.nii.CommonRakugo" scope="page" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<head>
<link rel="stylesheet" type="text/css" href="viewrakugo.css">
<%
	//キャラクタ_セット宣言
	request.setCharacterEncoding("UTF-8");
/* タイトル用にIDを取得 */
	String sch_id = request.getParameter("inpID");	/* ID */
%>
<script language="JavaScript" type="text/javascript">
<!--
	var titleWidth = 128;
	var playerWidth = 64;
function changeFontSize(c, x) {
	var w = 100;
	var div = document.getElementById("div" + c);
	var obj = document.getElementById("inp" + c + "W");
	var tbl = document.getElementById("tbl" + c);
	try {
		w = parseInt(obj.value, 10);
  	if (isNaN(w) == true) {
  		w = 100;
  	} else {
  		w = Math.floor(w + x);
  	}
	} catch (e) {
	}
	obj.value = w;
	tbl.style.fontSize = w + "%";
	div.style.width = "120mm";
//	sendQuery("btnView");
}
function changeWidth(c, x) {
	var w = 100;
	var obj = document.getElementById("inp" + c + "W");
	var col = document.getElementById("col" + c);
	try {
		w = parseInt(obj.value, 10);
  	if (isNaN(w) == true) {
  		w = 128;
  	} else {
  		w = Math.floor(w * x);
  	}
  	if (w == parseInt(obj.value, 10)) {
  		if (x > 1) {
  			w = parseInt(obj.value, 10) + 1;
  		} else {
  			w = parseInt(obj.value, 10) - 1;
  		}
  	}
  	if (w < 1) { w = 1; }
	} catch (e) {
	}
	obj.value = w;
	col.style.width = w + "px";
	sendQuery("btnView");
}
function checkAll(mode) {
	var all = document.formRakugo.chkAll.checked;
	var r = all;
	var r1 = all;
	var r2 = all;
	if (mode.indexOf("r") >= 0) {
		document.formRakugo.chkAll.checked = false;
		r = true;
		all = false;
	}
	if (mode == "r1") {
		r1 = true;
		r2 = false;
		all = false;
	}
	if (mode == "r2") {
		r1 = false;
		r2 = true;
		all = false;
	}
	document.formRakugo.chkID.checked = all;
	document.formRakugo.chkSeq.checked = r;
	document.formRakugo.chkTitle.checked = r;
	document.formRakugo.chkSub.checked = r;
	document.formRakugo.chkTSeq.checked = all;
	document.formRakugo.chkPro.checked = r;
	document.formRakugo.chkP1.checked = r;
//	document.formRakugo.chkP2.checked = all;
//	document.formRakugo.chkP3.checked = all;
	document.formRakugo.chkMemo.checked = all;
	document.formRakugo.chkSou.checked = all;
	document.formRakugo.chkLen.checked = r1;
	document.formRakugo.chkDate.checked = r;
	document.formRakugo.chkTime.checked = all;
	document.formRakugo.chkCat.checked = all;
	document.formRakugo.chkMed.checked = all;
	document.formRakugo.chkSur.checked = all;
	document.formRakugo.chkCo.checked = all;
	document.formRakugo.chkNR.checked = all;
	document.formRakugo.chkMod.checked = all;

//	sendQuery("btnView");
}
function addSize(x) {
	var wkDVD = document.formRakugo.inpSizeDVD.value;
	var wkMD = document.formRakugo.inpSizeMD.value;
	var wkAdd = parseInt(x);
	if (isNaN(wkDVD)) {
		wkDVD = 200;
	} else {
		wkDVD = parseInt(wkDVD);
	}
	if (isNaN(wkMD)) {
		wkMD = 140;
	} else {
		wkMD = parseInt(wkMD);
	}
	wkDVD = wkDVD + wkAdd;
	wkMD = wkMD + wkAdd;
	if (x == 0) {
		wkDVD = 200;
		wkMD = 140;
	}
	if (wkDVD < 0) { wkDVD = 0; }
	if (wkMD < 0) { wkMD = 0; }
	document.formRakugo.inpSizeDVD.value = wkDVD;
	document.formRakugo.inpSizeMD.value = wkMD;
}
function fitTitles(c) {
/*
	該当のカラムの修正値を印刷用テーブルに
	反映させる。
	c: カラム名
*/
	var i;
	var tar, ref;
	for (i = 0; i < 255; i++) {
		tar = document.getElementById("cell" + c + i);
		ref = document.getElementById("fit" + c + i);
		if (tar == null) {
			break;
		}
		tar.innerHTML = ref.value;
	}
}
function sendQuery(tarType) {
/* マスタ rewrite */
	if (tarType == "btnView") {
		document.formRakugo.method = "post";
		document.formRakugo.action = "viewrakugo.jsp";
		document.formRakugo.submit();
	}
}
function ctrlVisible() {
	var flg = "none";
	var val = "元に戻す";
	var i;
	var arrDiv = new Array();
	arrDiv[0] = document.getElementById("divComName");
	arrDiv[1] = document.getElementById("divHeader");
	arrDiv[2] = document.getElementById("divFontList");
	if (arrDiv[0].style.display == "none") {
		flg = "block";
		val = "印刷リスト以外消去";
	}
	for (i = 0; i < arrDiv.length; i++) {
		arrDiv[i].style.display = flg;
	}
	document.getElementById("btnCV").value = val;
}
// -->
</script>
<title>落語DB印刷(<%= sch_id %>)</title>
</head>
<body>
<%!
public String escapeString(String strEsc) {
//',",\ をescapeする
	StringBuffer sbfResult = new StringBuffer();
	for (int iEsc=0; iEsc<strEsc.length(); iEsc++) {
		switch(strEsc.charAt(iEsc)) {
		case '@':
		case '<':
		case '>':
			sbfResult.append("\\").append(strEsc.charAt(iEsc));
			break;
		case '&':
			sbfResult.append("&amp;");
			break;
		case '\'':
			sbfResult.append("&apos;");
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
	//いろいろフォーマット宣言
	SimpleDateFormat timeFmt5 = new SimpleDateFormat("H:mm:ss");
	SimpleDateFormat timeFmt4 = new SimpleDateFormat("m:ss");
	SimpleDateFormat timeFmtS = new SimpleDateFormat("H:mm");
	SimpleDateFormat dateFmtS = new SimpleDateFormat("yy.M/d(E)");
	DecimalFormat decFmt3 = new DecimalFormat("000");
	DecimalFormat decFmt6 = new DecimalFormat("000000");

//コンピュータ名取得
	String sch_comName = cmR.getComputerName(request.getRequestURL().toString());
/* Formの検索条件を退避 */
	String sch_seq = "";							/* SEQ */
	String sch_titleID;					/* タイトルID */
	String sch_title;					/* タイトル */
	String sch_titleSeq;			/* タイトルの連番 */
	String sch_strTitleSeqSin;		/* Seq文字の括弧有無 */
	String sch_strTitleSeq;			/* Seq文字 */
	String sch_subID;				/* サブタイトルID */
	String sch_sub = "";				/* サブタイトル */
	String sch_player1ID;			/* プレイヤ１ID */
	String sch_player1Name;			/* プレイヤ１姓名 */
	String sch_player2ID;			/* プレイヤ２ID */
	String sch_player2Name;			/* プレイヤ２姓名 */
	String sch_player3ID;			/* プレイヤ３ID */
	String sch_player3Name;			/* プレイヤ３姓名 */
	String sch_player4 = "";		/* プレイヤ４サイン */
	String sch_programID;			/* 番組ID */
	String sch_program;			/* 番組 */
	String sch_sourceID;						/* 局名ID */
	String sch_source = "";						/* 局名 */
	String sch_sourceS1;		/* 局名モード1 */
	String sch_sourceS2;		/* 局名モード2 */
	String sch_recDate;		/* 録画日 */
	String sch_recDateC = "0";		/* Chk録画日 */
	String sch_recTime = "";		/* 録画時 */
	String sch_recTimeC = "0";		/* Chk録画時 */
	String sch_recLen;		/* 録画長 */
	String sch_recLenC = "0";		/* Chk録画日 */
	String sch_attCat = "";					/* 属性 */
	String sch_attMed = "";					/* 媒体 */
	String sch_attCh = "";					/* ch */
	String sch_attCo = "";					/* 複写 */
	String sch_attNR = "";					/* NR */
	String sch_memo;					/* メモ */
	String sch_modDate = "";																					/* 更新日 */
	String sch_btn = cmR.convertNullToString(request.getParameter("formBtnType"));				/* 押下ボタン種 */
	String parIDC = cmR.convertNullToString(request.getParameter("chkID"));							/* ID表示Chkbox */
	String parSeqC = cmR.convertNullToString(request.getParameter("chkSeq"));				/* Seq表示Chkbox */
	String parTitleC = cmR.convertNullToString(request.getParameter("chkTitle"));				/* Title表示Chkbox */
	String parSubC = cmR.convertNullToString(request.getParameter("chkSub"));				/* Subtitle表示Chkbox */
	String parTSeqC = cmR.convertNullToString(request.getParameter("chkTSeq"));				/* TitleSeq表示Chkbox */
	String parProC = cmR.convertNullToString(request.getParameter("chkPro"));				/* Program表示Chkbox */
	String parSouC = cmR.convertNullToString(request.getParameter("chkSou"));				/* Source表示Chkbox */
	String parP1C = cmR.convertNullToString(request.getParameter("chkP1"));				/* Player1表示Chkbox */
	String parP2C = cmR.convertNullToString(request.getParameter("chkP2"));				/* Player2表示Chkbox */
	String parP3C = cmR.convertNullToString(request.getParameter("chkP3"));				/* Player3表示Chkbox */
	String parLenC = cmR.convertNullToString(request.getParameter("chkLen"));				/* Length表示Chkbox */
	String parDateC = cmR.convertNullToString(request.getParameter("chkDate"));				/* RecDate表示Chkbox */
	String parTimeC = cmR.convertNullToString(request.getParameter("chkTime"));				/* RecTime表示Chkbox */
	String parCatC = cmR.convertNullToString(request.getParameter("chkCat"));				/* Category表示Chkbox */
	String parMedC = cmR.convertNullToString(request.getParameter("chkMed"));				/* Media表示Chkbox */
	String parSurC = cmR.convertNullToString(request.getParameter("chkSur"));				/* Surround表示Chkbox */
	String parCoC = cmR.convertNullToString(request.getParameter("chkCo"));				/* Copy表示Chkbox */
	String parNRC = cmR.convertNullToString(request.getParameter("chkNR"));				/* NR表示Chkbox */
	String parMemoC = cmR.convertNullToString(request.getParameter("chkMemo"));				/* Memo表示Chkbox */
	String parModC = cmR.convertNullToString(request.getParameter("chkMod"));				/* 更新日表示Chkbox */
	String parSizeDVD = cmR.convertNullToString(request.getParameter("inpSizeDVD"));				/* font size DVD */
	if (parSizeDVD.equals("")) { parSizeDVD = "200"; }
	String parSizeMD = cmR.convertNullToString(request.getParameter("inpSizeMD"));				/* font size MD */
	if (parSizeMD.equals("")) { parSizeMD = "140"; }
	String parCase = cmR.convertNullToString(request.getParameter("inpCase"));	/* ケース背表紙 */
	parCase = escapeString(parCase);
	String parTitleW = cmR.convertNullToString(request.getParameter("inpTitleW"));
	String parPlayerW = cmR.convertNullToString(request.getParameter("inpPlayerW"));
	String parProgramW = cmR.convertNullToString(request.getParameter("inpProgramW"));
	String parCardW = cmR.convertNullToString(request.getParameter("inpCardW"));
//	if (parTitleW.equals("")) { parTitleW = "256"; }

/* Checkbox要素選択用ワーク */
	String strCo[] = new String[32];
	if (parIDC.equals("")) { parIDC = "0"; }
	if (parIDC.equals("1")) { strCo[0] = "checked"; }
	if (parSeqC.equals("")) { parSeqC = "0"; }
	if (parSeqC.equals("1")) { strCo[1] = "checked"; }
	if (parTitleC.equals("")) { parTitleC = "0"; }
	if (parTitleC.equals("1")) { strCo[2] = "checked"; }
	if (parSubC.equals("")) { parSubC = "0"; }
	if (parSubC.equals("1")) { strCo[3] = "checked"; }
	if (parTSeqC.equals("")) { parTSeqC = "0"; }
	if (parTSeqC.equals("1")) { strCo[4] = "checked"; }
	if (parProC.equals("")) { parProC = "0"; }
	if (parProC.equals("1")) { strCo[5] = "checked"; }
	if (parSouC.equals("")) { parSouC = "0"; }
	if (parSouC.equals("1")) { strCo[6] = "checked"; }
	if (parP1C.equals("")) { parP1C = "0"; }
	if (parP1C.equals("1")) { strCo[7] = "checked"; }
	if (parP2C.equals("")) { parP2C = "0"; }
	if (parP2C.equals("1")) { strCo[8] = "checked"; }
	if (parP3C.equals("")) { parP3C = "0"; }
	if (parP3C.equals("1")) { strCo[9] = "checked"; }
	if (parLenC.equals("")) { parLenC = "0"; }
	if (parLenC.equals("1")) { strCo[10] = "checked"; }
	if (parDateC.equals("")) { parDateC = "0"; }
	if (parDateC.equals("1")) { strCo[11] = "checked"; }
	if (parTimeC.equals("")) { parTimeC = "0"; }
	if (parTimeC.equals("1")) { strCo[12] = "checked"; }
	if (parCatC.equals("")) { parCatC = "0"; }
	if (parCatC.equals("1")) { strCo[13] = "checked"; }
	if (parMedC.equals("")) { parMedC = "0"; }
	if (parMedC.equals("1")) { strCo[14] = "checked"; }
	if (parSurC.equals("")) { parSurC = "0"; }
	if (parSurC.equals("1")) { strCo[15] = "checked"; }
	if (parCoC.equals("")) { parCoC = "0"; }
	if (parCoC.equals("1")) { strCo[16] = "checked"; }
	if (parNRC.equals("")) { parNRC = "0"; }
	if (parNRC.equals("1")) { strCo[17] = "checked"; }
	if (parMemoC.equals("")) { parMemoC = "0"; }
	if (parMemoC.equals("1")) { strCo[18] = "checked"; }
	if (parModC.equals("")) { parModC = "0"; }
	if (parModC.equals("1")) { strCo[19] = "checked"; }

/* 表示用ワーク項目 */
StringBuffer sBfTitle;	//Title・SubTitle連結
StringBuffer sBfPlayer;	//Player1-3連結
StringBuffer sBfRecDate;	//RecDate・Time連結
StringBuffer sBfAtt;	//Cat-NR連結
StringBuffer sBfCase;			//ケース背表紙タイトル

//JDBC接続
	cmR.connectJdbc6();
/* Query組み立て */
	/* 初期画面または押下ボタン不明なら Dummy空読み */
	StringBuffer query = new StringBuffer();
	StringBuffer query2;			//名称取得用Query退避エリア
	StringBuffer dbMsg = new StringBuffer();

 	query.append("WHERE vol_id = '").append(sch_id).append("'");
	query.append(" ORDER BY vol_id, seq");
%>
<div class="divFloatR" id="divComName">
	<div "AjaxState">
	</div>
	<div>
		<%= sch_comName %>
	</div>
</div>
<div id="divHeader">
<form name="formRakugo">
<table border="1">
  <tbody>
    <tr align="center">
      <td><input size="7" type="text" maxlength="6" readonly name="inpID" value="<%= sch_id %>"></td>
      <td><input type="button" onclick="javaScript: sendQuery('btnView')" name="btnView" value="再検索"></td>
      <td class="fontSmall" colspan="2">
  			Title幅:<input type="text" id="inpTitleW" name="inpTitleW" size="4" maxlength="3"
  				value="<%= parTitleW %>" style="text-align: right">px
  			<a href="javascript: changeWidth('Title', 0.9)">＜</a>
      	<a href="javascript: changeWidth('Title', 1.1)">＞</a>
  		</td>
      <td class="fontSmall" colspan="2">
  			Player幅:<input type="text" id="inpPlayerW" name="inpPlayerW" size="4" maxlength="3"
  				value="<%= parPlayerW %>" style="text-align: right">px
  			<a href="javascript: changeWidth('Player', 0.9)">＜</a>
      	<a href="javascript: changeWidth('Player', 1.1)">＞</a>
  		</td>
      <td class="fontSmall" colspan="2">
  			Program幅:<input type="text" id="inpProgramW" name="inpProgramW" size="4" maxlength="3"
  				value="<%= parProgramW %>" style="text-align: right">px
  			<a href="javascript: changeWidth('Program', 0.9)">＜</a>
      	<a href="javascript: changeWidth('Program', 1.1)">＞</a>
  		</td>
      <td><input type="checkbox" name="chkAll" onclick="javascript: checkAll('all')"></td>
    </tr>
    <tr>
      <td><input type="checkbox" name="chkID" value="1" <%= strCo[0] %>>ID</td>
      <td><input type="checkbox" name="chkSeq" value="1" <%= strCo[1] %>>Seq</td>
      <td><input type="checkbox" name="chkTitle" value="1" <%= strCo[2] %>>Title</td>
      <td><input type="checkbox" name="chkSub" value="1" <%= strCo[3] %>>SubTitle</td>
      <td><input type="checkbox" name="chkTSeq" value="1" <%= strCo[4] %>>TSeq</td>
      <td><input type="checkbox" name="chkPro" value="1" <%= strCo[5] %>>Program</td>
      <td><input type="checkbox" name="chkP1" value="1" <%= strCo[7] %>>Player</td>
<!--      <td><input type="checkbox" name="chkP2" value="1" <%= strCo[8] %>>Player2</td>
      <td><input type="checkbox" name="chkP3" value="1" <%= strCo[9] %>>Player3</td>	-->
      <td><input type="checkbox" name="chkLen" value="1" <%= strCo[10] %>>Length</td>
      <td><input type="checkbox" name="chkDate" value="1" <%= strCo[11] %>>Date</td>
      <td><a href="javascript: checkAll('r1')">reset1</a></td>
    </tr>
    <tr>
      <td><input type="checkbox" name="chkSou" value="1" <%= strCo[6] %>>Source</td>
      <td><input type="checkbox" name="chkCat" value="1" <%= strCo[13] %>>Category</td>
      <td><input type="checkbox" name="chkMed" value="1" <%= strCo[14] %>>Media</td>
      <td><input type="checkbox" name="chkSur" value="1" <%= strCo[15] %>>CH</td>
      <td><input type="checkbox" name="chkCo" value="1" <%= strCo[16] %>>Copy</td>
      <td><input type="checkbox" name="chkNR" value="1" <%= strCo[17] %>>NR</td>
      <td><input type="checkbox" name="chkMemo" value="1" <%= strCo[18] %>>Memo</td>
      <td><input type="checkbox" name="chkMod" value="1" <%= strCo[19] %>>Mod</td>
      <td><input type="checkbox" name="chkTime" value="1" <%= strCo[12] %>>Time</td>
      <td><a href="javascript: checkAll('r2')">reset2</a></td>
    </tr>
  </tbody>
</table>
<hr>
</div>
<!-- 印刷用ブロックの開始 -->
<div>
カード幅:<input type="text" id="inpCardW" name="inpCardW" size="4" maxlength="3"
  				value="<%= parCardW %>" style="text-align: right" readonly>%
  			<a href="javascript: changeFontSize('Card', -10)">-10</a>
  			<a href="javascript: changeFontSize('Card', -1)">-1</a>
      	<a href="javascript: changeFontSize('Card', 1)">+1</a>
      	<a href="javascript: changeFontSize('Card', 10)">+10</a>
</div>
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
<div class="indexCard" id="divCard">
<div>
<span class="volID">
	<%= sch_id %>
</span>
</div>
<table class="table1 fontSmall" id="tblCard" style="width:115mm">
    <tr>
		<%
			//補正用入力欄テーブル生成
			StringBuffer sbfCard = new StringBuffer();
			sbfCard.append("<table border='0'><tr>");
			
			if (parIDC.equals("1")) { out.println("<th class='komidasi'>VolID</th>"); }
			if (parSeqC.equals("1")) { out.println("<th class='komidasi'>Seq</th>"); }
			if ((parTitleC.equals("1")) ||
					(parSubC.equals("1"))     ) {
				out.println("<th class='komidasi' id='colTitle' width='");
				out.println(parTitleW);
				out.println(" nowrap'>Title</th>");
			}
//			if (parSubC.equals("1")) { out.println("<th class='komidasi'>SubTitle</th>"); }
			if ((parP1C.equals("1")) ||
					(parP2C.equals("1")) ||
					(parP3C.equals("1"))   ) {
				out.println("<th class='komidasi' id='colPlayer' width='");
				out.println(parPlayerW);
				out.println("'>Player</th>");
			}
//		if (parP2C.equals("1")) { out.println("<th class='komidasi'>Player2</th>"); }
//		if (parP3C.equals("1")) { out.println("<th class='komidasi'>Player3</th>"); }
			if (parProC.equals("1")) {
				out.println("<th class='komidasi' id='colProgram' width='");
				out.println(parProgramW);
				out.println("'>Program</th>");
			}
if (parLenC.equals("1")) { out.println("<th class='komidasi' style='white-space: nowrap;'>Length</th>"); }
			if ((parDateC.equals("1")) ||
					(parTimeC.equals("1"))   ) { out.println("<th class='komidasi'>Date</th>"); }
//			if (parTimeC.equals("1")) { out.println("<th class='komidasi'>Time</th>"); }
			if (parSouC.equals("1")) { out.println("<th class='komidasi'>Source</th>"); }
			if ((parCatC.equals("1")) ||
					(parMedC.equals("1")) ||
					(parSurC.equals("1")) ||
					(parCoC.equals("1")) ||
					(parNRC.equals("1"))    ) { out.println("<th class='komidasi'>Attribute</th>"); }
			if (parMemoC.equals("1")) { out.println("<th class='komidasi'>Memo</th>"); }
			if (parModC.equals("1")) { out.println("<th class='komidasi'>Modify</th>"); }
			 %>
    </tr>
<%
/* DBを読む */
	rkS.selectDB(query.toString(), "");
//	out.println(query.toString());
//	out.println(break_id);
	int row = 0;
	String parBgcolor1 = "bgcolor='white'";
	String parBgcolor2 = "bgcolor='lavender'";
	String strBgcolor = "";
	sBfCase = new StringBuffer("");
%>
<%
	int i = 0;
  for (i = 0; i < rkS.getResultCount(); i++) {
		row += 1;
		if (row % 2 == 0) {
			strBgcolor = parBgcolor2;
		} else {
			strBgcolor = parBgcolor1;
		}
		sch_id = rkS.getVolId(i);
		sch_seq = decFmt3.format(rkS.getSeq(i));
		//タイトルマスタDBからタイトル取得
		sch_titleID = rkS.getTitleId(i);
		if (sch_titleID.equals("")) {
			sch_title = "";
			sch_sub = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_titleID).append("'");
			tmS.selectDB(query2.toString(), "");
			if (tmS.getResultCount() > 0) {
				sch_title = tmS.getTitle(0);
				sch_sub = tmS.getSubtitle(0);
			} else {
				sch_title = "";
				sch_sub = "";
			}
		}
		//背ラベルタイトル
		if (sBfCase.toString().equals("")) {
			sBfCase.append(sch_title);
		} else {
			if (rkS.getCategorySin(i).equals("R")) {
				sBfCase.append("・");
				sBfCase.append(sch_title);
			}
		}
%>
<%
		//タイトルマスタDBからサブタイトル取得
		sch_subID = rkS.getSubtitleId(i);
		if (! sch_subID.equals("")) {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_subID).append("'");
			tmS.selectDB(query2.toString(), "");
			if (tmS.getResultCount() > 0) {
				sch_sub = tmS.getSubtitle(0);
			}
		}
		//タイトルマスタDBからプログラム名取得
		sch_programID = rkS.getProgramId(i);
		if (sch_programID.equals("")) {
			sch_program = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_programID).append("'");
			tmS.selectDB(query2.toString(), "");
			if (tmS.getResultCount() > 0) {
				sch_program = tmS.getTitle(0);
			} else {
				sch_program = "";
			}
		}
		//タイトルマスタDBから局名取得
		sch_sourceID = rkS.getSourceId(i);
		if (sch_sourceID.equals("")) {
			sch_source = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_sourceID).append("'");
			tmS.selectDB(query2.toString(), "");
			if (tmS.getResultCount() > 0) {
				sch_source = tmS.getTitle(0);
			} else {
				sch_source = "";
			}
		}
%>
<%
		//録画日時取得
		sch_recDateC = rkS.getRecDateFlg(i);
		try {
			if (sch_recDateC.equals("1")) {
				sch_recDate = dateFmtS.format(rkS.getRecDate(i));
			} else {
				sch_recDate = "";
			}
		} catch (Exception e) {
			sch_recDate = "";
		}
		sch_recTimeC = rkS.getRecTimeFlg(i);
		try {
			if (sch_recTimeC.equals("1")) {
				sch_recTime = timeFmtS.format(rkS.getRecTime(i));
			} else {
				sch_recTime = "";
			}
		} catch (Exception e) {
			sch_recTime = "";
		}
		//録画長取得
		sch_recLenC = rkS.getRecLengthFlg(i);
		try {
			if (sch_recLenC.equals("1")) {
				sch_recLen = timeFmt5.format(rkS.getRecLength(i));
				if (sch_recLen.substring(0,2).equals("0:")) {
					sch_recLen = timeFmt4.format(rkS.getRecLength(i));
				}
			} else {
				sch_recLen = "";
			}
		} catch (Exception e) {
			sch_recLen = "";
		}
%>
<%
		//属性取得
		sch_attCat = rkS.getCategorySin(i);
		cmF.makeField("", "", sch_attCat);
		sch_attCat = cmF.getField(sch_attCat);
		
		sch_attMed = rkS.getMediaSin(i);
		cmF.makeMedia("", "", sch_attMed);
		sch_attMed = cmF.getMedia(sch_attMed);

		sch_attCh = rkS.getSurSin(i);
		cmF.makeSurround("", "", sch_attCh);
		sch_attCh = cmF.getSurround(sch_attCh);
		
		sch_attCo = rkS.getCopySin(i);
		cmF.makeGeneration("", "", sch_attCo);
		sch_attCo = cmF.getGeneration(sch_attCo);
		
		sch_attNR = rkS.getNrSin(i);
		cmF.makeNR("", "", sch_attNR);
		sch_attNR = cmF.getNR(sch_attNR);
%>
<%
		//タイトルSeq整形
		sch_strTitleSeq = rkS.getStrTitleSeq(i);
		sch_strTitleSeqSin = rkS.getStrTitleSeqSin(i);
		if (sch_strTitleSeqSin.equals("1")) {
			if (sch_strTitleSeq.length() == 0) {
				if (rkS.getTitleSeq(i) == 0) {
					sch_titleSeq = "";
				} else {
					sch_titleSeq = " (" + String.valueOf(rkS.getTitleSeq(i)) + ")";
				}
			} else {
				sch_titleSeq = " " + sch_strTitleSeq;
			}
		} else {
			sch_titleSeq = "";
		}
		//memo取得
		sch_memo = rkS.getMemo(i);
		//更新日取得
		try {
			sch_modDate = dateFmtS.format(rkS.getModifyDate(i));
		} catch (Exception e) {
			sch_modDate = "";
		}
%>
<%
		//演者マスタDBから姓名１取得
		sch_player1ID = rkS.getPlayer1Id(i);
		if (sch_player1ID.equals("")) {
			sch_player1Name = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_player1ID).append("'");
			pmS.selectDB(query2.toString(), "");
			if (pmS.getResultCount() > 0) {
				sch_player1Name = pmS.getFullName(0);
			} else {
				sch_player1Name = "";
			}
		}
		//演者マスタDBから姓名２取得
		sch_player2ID = rkS.getPlayer2Id(i);
		if (sch_player2ID.equals("")) {
			sch_player2Name = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_player2ID).append("'");
			pmS.selectDB(query2.toString(), "");
			if (pmS.getResultCount() > 0) {
				sch_player2Name = pmS.getFullName(0);
			} else {
				sch_player2Name = "";
			}
		}
		//演者マスタDBから姓名３取得
		sch_player3ID = rkS.getPlayer3Id(i);
		if (sch_player3ID.equals("")) {
			sch_player3Name = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_player3ID).append("'");
			pmS.selectDB(query2.toString(), "");
			if (pmS.getResultCount() > 0) {
				sch_player3Name = pmS.getFullName(0);
			} else {
				sch_player3Name = "";
			}
		}
		sch_player4 = rkS.getPlayer4Sin(i);
%>
		<tr <%= strBgcolor %>>
<%
/* 項目連結 */
		//タイトル - サブタイトル - 連結
		sBfTitle = new StringBuffer();
		if (parTitleC.equals("1")) {
			sBfTitle.append(sch_title);
		}
		if ((parSubC.equals("1")) && (!(sch_sub.equals("")))) {
			if (sBfTitle.toString().trim().equals("")) {
				sBfTitle.append(sch_sub);
			} else {
				sBfTitle.append(" - ").append(sch_sub).append(" -");
			}
		}
		//プレイヤ１・２・３連結
		cmF.makePlayerPart("", "", "");
		sBfPlayer = new StringBuffer("");
		sBfPlayer.append(cmR.concatNames(
			sch_player1Name, cmF.getPlayerPart(rkS.getPlayer1Sin(i)),
			sch_player2Name, cmF.getPlayerPart(rkS.getPlayer2Sin(i)),
			sch_player3Name, cmF.getPlayerPart(rkS.getPlayer3Sin(i)),
			sch_player4, "<br />"));
/*		if (sch_player4.equals("1")) {
			sBfPlayer.append("<span class='fontSmall'>ほか</span>");
		}
		*/
		//録画日付 時刻連結
		sBfRecDate = new StringBuffer("");
		if (parDateC.equals("1")) {
			sBfRecDate.append(sch_recDate);
		}
		if (parTimeC.equals("1")) {
			if (sBfRecDate.toString().trim().equals("")) {
				sBfRecDate.append(sch_recTime);
			} else {
				sBfRecDate.append(" ").append(sch_recTime);
			}
		}
		//カテゴリ 媒体 ch Copy NR連結
		sBfAtt = new StringBuffer("");
		if (parCatC.equals("1")) {
			sBfAtt.append(sch_attCat);
		}
		if (parMedC.equals("1")) {
			if (sBfAtt.toString().equals("")) {
				sBfAtt.append(sch_attMed);
			} else {
				sBfAtt.append(",").append(sch_attMed);
			}
		}
		if (parSurC.equals("1")) {
			if (sBfAtt.toString().equals("")) {
				sBfAtt.append(sch_attCh);
			} else {
				sBfAtt.append(",").append(sch_attCh);
			}
		}
		if (parCoC.equals("1")) {
			if (sBfAtt.toString().equals("")) {
				sBfAtt.append(sch_attCo);
			} else {
				sBfAtt.append(",").append(sch_attCo);
			}
		}
		if (parNRC.equals("1")) {
			if (sBfAtt.toString().equals("")) {
				sBfAtt.append(sch_attNR);
			} else {
				sBfAtt.append(",").append(sch_attNR);
			}
		}
		//印刷用テーブル出力
		if (parIDC.equals("1")) {
			out.println("<td align='center' id='cellId" + String.valueOf(i) + "'>");
			out.println(sch_id + "</td>");
		}
		if (parSeqC.equals("1")) {
			out.println("<td align='center' id='cellSeq" + String.valueOf(i) + "'>");
			out.println(sch_seq + "</td>");
		}
		if ((parTitleC.equals("1")) ||
				(parSubC.equals("1"))     ) {
			if (parTSeqC.equals("1")) {
				if (sch_titleSeq.length() > 0) {
					sBfTitle.append(" ").append(sch_titleSeq);
				}
			}
			out.println("<td id='cellTitle" + String.valueOf(i) + "' nowrap>");
			out.println(sBfTitle.toString() + "</td>");
		}
		if ((parP1C.equals("1")) ||
				(parP2C.equals("1")) ||
				(parP3C.equals("1"))   ) {
			out.println("<td id='cellPlayer" + String.valueOf(i) + "' nowrap>");
			if (sBfPlayer.length() == 0) {
				out.println("&nbsp;</td>");
			} else {
				out.println(sBfPlayer.toString() + "</td>");
			}
		}
		if (parProC.equals("1")) {
			out.println("<td id='cellProgram" + String.valueOf(i) + "' nowrap>");
			if (sch_program.length() == 0) {
				out.println("&nbsp;</td>");
			} else {
				out.println(sch_program + "</td>");
			}
		}
		if (parLenC.equals("1")) {
			out.println("<td style='white-space: nowrap;' align='right' class='cellLen' nowrap>");
			if (sch_recLen.length() == 0) {
				out.println("&nbsp;</td>");
			} else {
				out.println(sch_recLen + "</td>");
			}
		}
		if ((parDateC.equals("1")) ||
				(parTimeC.equals("1"))   ) {
			out.println("<td nowrap class='fontSmall' nowrap>");
			if (sBfRecDate.length() == 0) {
				out.println("&nbsp;</td>");
			} else {
				out.println(sBfRecDate.toString() + "</td>");
			}
		}
		if (parSouC.equals("1")) { out.println("<td>" + sch_source + "</td>"); }
		if ((parCatC.equals("1")) ||
				(parMedC.equals("1")) ||
				(parSurC.equals("1")) ||
				(parCoC.equals("1")) ||
				(parNRC.equals("1"))    ) {
			out.println("<td>" + sBfAtt.toString() + "</td>");
		}
		if (parMemoC.equals("1")) { out.println("<td>" + sch_memo + "</td>"); }
		if (parModC.equals("1")) {
			out.println("<td nowrap>");
			if (sch_modDate.equals("")) {
				out.println("&nbsp;</td>");
			} else {
				out.println(sch_modDate + "</td>");
			}
		}
		//印刷文字列補正テーブル待避
		sbfCard.append("<td class='textCenter'>").append(sch_seq).append("</td>");
		sbfCard.append("<td><input id='fitTitle").append(String.valueOf(i));
		sbfCard.append("' size='32' type='text' value='");
		sbfCard.append(sBfTitle.toString()).append("'></td>");
		sbfCard.append("<td><input id='fitPlayer").append(String.valueOf(i));
		sbfCard.append("' size='32' type='text' value=\"");
		sbfCard.append(sBfPlayer.toString()).append("\"></td>");
		sbfCard.append("<td><input id='fitProgram").append(String.valueOf(i));
		sbfCard.append("' size='32' type='text' value='");
		sbfCard.append(sch_program).append("'></td>");
		sbfCard.append("</tr>");
%>
		</tr>
<%
	}
	if (parCase.equals("")) {
		parCase = sBfCase.toString();
	}
	sbfCard.append("<tr><td></td>");
	String wkCol = "";
	for (int j = 0; j < 3; j++) {
		switch (j) {
		case 0:
			wkCol = "Title";
			break;
		case 1:
			wkCol = "Player";
			break;
		case 2:
			wkCol = "Program";
			break;
		}
		sbfCard.append("<td><input onclick='javascript: fitTitles(\"");
		sbfCard.append(wkCol);
		sbfCard.append("\");' type='button' value='");
		sbfCard.append(wkCol);
		sbfCard.append("反映'></td>");
	}
	sbfCard.append("</tr></table>");
%>
</table>
</div>
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
<br />
<%= row %>件
<input id="btnCV" onclick="javascript: ctrlVisible()" type="button" value="印刷リスト以外消去">
<div id="divFontList">
<hr>
<%
	out.println(sbfCard.toString());
%>
<hr>
<input size="64" type="text" name="inpCase" value="<%= parCase %>">
<table>
	<tr>
		<td><a href="javascript: addSize(-50)">-50</a></td>
		<td><a href="javascript: addSize(-10)">-10</a></td>
		<td><a href="javascript: addSize(-5)">-5</a></td>
		<td><a href="javascript: addSize(-1)">-1</a></td>
		<td><a href="javascript: addSize(0)">Default</a></td>
		<td><a href="javascript: addSize(1)">+1</a></td>
		<td><a href="javascript: addSize(5)">+5</a></td>
		<td><a href="javascript: addSize(10)">+10</a></td>
		<td><a href="javascript: addSize(50)">+50</a></td>
		<td>DVD:<input type="text" name="inpSizeDVD" size="4" value="<%= parSizeDVD %>">%</td>
		<td>MD:<input type="text" name="inpSizeMD" size="4" value="<%= parSizeMD %>">%</td>
    <td><input type="button" onclick="javaScript: sendQuery('btnView')" name="btnView" value="再検索"></td>
	</tr>
</table>
</form>
<hr>
<%
//実行PCのフォント一覧を fonts.txt として別途作成しておく（Tab区切）。
java.util.ArrayList fontList = new java.util.ArrayList();
String cssDVD = "border-right: 0px; height: 50px; padding-left: 1%;";
String cssMD = "border-right: 0px; height: 12px; padding-left: 1%;";

StringTokenizer tkn;
FileReader fr = new FileReader(application.getRealPath("fonts.txt"));
BufferedReader br = new BufferedReader(fr);
String strFont;
while (br.ready()) {
	tkn = new StringTokenizer(br.readLine(), "\t");
	if (tkn.hasMoreTokens()) {
		strFont = tkn.nextToken();
		if (!(strFont.equals(""))) {
			switch (strFont.charAt(0)) {
			case '/':
			case '\'':
			case ';':
			case ':':
			case ' ':
				break;
			default:
				i += 1;
				fontList.add(strFont);	//先頭カラムのフォント名しか遣わない。
			}
		}
	}
}
br.close();
out.println("<table class='table2'>");
for (i = 0; i < fontList.size(); i++) {
	out.println("<tr><td colspan='2'><font size='-1'>" + fontList.get(i).toString());
	out.println("</font></td><td>");
	out.println("----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8");
	out.println("</td></tr><tr>");
	out.println("<td align='right'>" + (i + 1) + "</td>");
	out.println("<td class='caseVolID'>" + sch_id + "</td>");
	out.println("<td style='" + cssDVD + "font-size: " + parSizeDVD + "%;");
	out.println(" font-family: \"" + fontList.get(i).toString() + "\";'>" + parCase + "</td></tr>");
	out.println("<tr><td></td>");
	out.println("<td class='caseVolID'>" + sch_id + "</td>");
	out.println("<td style='" + cssMD + "font-size: " + parSizeMD + "%;");
	out.println(" font-family: \"" + fontList.get(i).toString() + "\";'>" + parCase + "</td></tr>");
}
out.println("</table>");
	//JDBC切断
	cmR.closeJdbc();
%>
</div>
<div align="center">
<input type="button" name="btnClose" value="Close" onclick="javascript: window.close()">
</div>
<script language="JavaScript" type="text/javascript">
<!--
	if ("<%= dbMsg.toString() %>" != "") {
		document.getElementById("AjaxState").innerHTML =
			"<font color='red'>" + "<%= dbMsg.toString() %>" + "</font>";
	}
// -->
</script>
</body>
</html>