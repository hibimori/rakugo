//*****************************************************************
//  日付入力支援（共通） for Rakugo, BookTable Tool
//    (c) Copyright 2007; nii.n All Rights Reserved.
//    1.10  07.7/7		書籍取得日の既存データ表示を追加
//    1.00  07.6/21		1stリリース
//*****************************************************************
var calendarTarId = "";

function makeCalendar(id, t) {
//setTrace("makeCalendar("+id+","+t+")");
/*
	日付選択窓の作成
		id:	セットする部品のID。当該頁でユニークになるコト（String）
		t:	初期表示する日付（Date）
*/
	var tarDiv = document.getElementById("divCalendar");
	var nowDatetime = new Date();
	if (t == "") {
		t = nowDatetime;
	}
	var calendarLine = "";
	calendarLine += id;
	calendarLine += "<table class='table1'><tr>";
	calendarLine += "<td class='cellDate' id='tdCalendarY'>";
	calendarLine += "<div id='divCalendarY'></div>";
	calendarLine += "<input type='hidden' id='hdnCalendarY' value='' />";
	calendarLine += "</td><td>.</td>";
	calendarLine += "<td class='cellDate' id='tdCalendarM'>";
	calendarLine += "<div id='divCalendarM'></div>";
	calendarLine += "<input type='hidden' id='hdnCalendarM' />";
	calendarLine += "</td><td>/</td>";
	calendarLine += "<td class='cellDate' id='tdCalendarD'>";
	calendarLine += "<div id='divCalendarD'></div>";
	calendarLine += "<input type='hidden' id='hdnCalendarD' />";
	calendarLine += "</td>";
	calendarLine += "<td>";
	calendarLine += " <input onclick='javascript: resetCalendar(1)'";
	calendarLine += " type='button' value='NOW' />";
	calendarLine += "</td>";
	calendarLine += "</tr></table>";
	calendarLine += "<div id='divCalendarTblY' class='div2'>";
	calendarLine += "<table align='center' border='0'>";
	calendarLine += "<tr>";
	calendarLine += "<td id='tdCalendarYL'>&lt;</td>";
	calendarLine += "<td id='tdCalendarYC' class='tbl1'></td>";
	calendarLine += "<td id='tdCalendarYR'>&gt;</td>";
	calendarLine += "</tr></table>";
	calendarLine += "</div>";
	calendarLine += "<div id='divCalendarTblM' class='div2'>";
	calendarLine += "<table align='center' border='0'>";
	calendarLine += "<tr>";
	calendarLine += "<td id='tdCalendarML'>&lt;</td>";
	calendarLine += "<td id='tdCalendarMC' class='tbl1'></td>";
	calendarLine += "<td id='tdCalendarMR'>&gt;</td>";
	calendarLine += "</tr></table>";
	calendarLine += "</div>";
	calendarLine += "<div id='divCalendarTblD' class='div2'>";
	calendarLine += "<table align='center' border='0'>";
	calendarLine += "<tr>";
	calendarLine += "<td id='tdCalendarDL'>&lt;</td>";
	calendarLine += "<td id='tdCalendarDC' class='tbl1'></td>";
	calendarLine += "<td id='tdCalendarDR'>&gt;</td>";
	calendarLine += "</tr></table>";
	calendarLine += "</div>";
	calendarLine += "<div>";
	calendarLine += getStrDatetime(nowDatetime, "yyyy.M/d(E) H:mm:ss");
	calendarLine += "</div>";
	calendarLine += "<div>";
	calendarLine += "<input onclick='";
	calendarLine += "javascript: returnCalendar(\"" + id + "\");'";
	calendarLine += " type='button' value='OK' />";
	calendarLine += " <input onclick='javascript: wipeCalendar()'";
	calendarLine += " type='button' value='Cancel' />";
	calendarLine += "</div>";
	tarDiv.innerHTML = calendarLine;
	calendarTarId = id;
	setCalendarDate(t);
	showCalendarY(t);
	showCalendarM(t);
	showCalendarD(t);
	showCalendar(id);
}
function getStrDatetime(d, f) {
/*
	日時のフォーマット
		d: Date
		f: 様式
			（出現順が y, M, d, E, H, m, s であるコト）
			"yyyyMMDD"
			"yyyy-MM-DD"
			"yyyy.M/d(E) H:mm:ss"
			"H:mm:ss"
*/
	var arrD = new Array();		//各要素の数値待避
	var arrE1 = ["yy", "M", "d", "E", "H", "m", "s"];
	var arrE2 = ["yyyy", "MM", "dd", "E", "HH", "mm", "ss"];
	var arrL1 = [2, 1, 1, 1, 1, 1, 1];	//arrE1の最小長
	var arrL2 = [4, 2, 2, 1, 2, 2, 2];	//arrE2のデータ長
	var arrL = new Array();		//arrE1またはE2のデータ長
	var arrP1 = new Array();	//arrE1の開始位置
	var arrP2 = new Array();	//arrE2の開始位置
	var arrP = new Array();		//各要素の開始位置
	var arrF = new Array();		//編集済み要素の格納
	var arrSpr = new Array();		//要素間区切り文字の格納
	var m;
	var str = "";
	
	//各要素の待避
	arrD[0] = d.getFullYear();
	arrD[1] = d.getMonth() + 1;
	arrD[2] = d.getDate();
	arrD[3] = d.getDay();
	arrD[4] = d.getHours();
	arrD[5] = d.getMinutes();
	arrD[6] = d.getSeconds();
	//指定されている要素の編集
	arrP[0] = 0;
	for (i = 0; i < arrE1.length; i++) {
		arrP2[i] = f.indexOf(arrE2[i]);
		arrP1[i] = f.indexOf(arrE1[i]);
		if (arrP2[i] >= 0) {
			arrF[i] = getStrDec(arrD[i], arrL2[i]);
			arrP[i] = arrP2[i];
			arrL[i] = arrE2[i].length;
		} else if (arrP1[i] >= 0) {
			if (arrL1[i] > 1) {
				arrF[i] = getStrDec(arrD[i], arrL1[i]);
			} else {
				arrF[i] = "" + arrD[i];
			}
			arrP[i] = arrP1[i];
			arrL[i] = arrE1[i].length;
		} else {
			arrF[i] = "";
			if (i > 0) {
				arrP[i] = arrP[i - 1] + arrL[i - 1];
			} else {
				arrP[i] = 0;
			}
			arrL[i] = 0;
		}
	}
	if (arrF[3] != "") {
		//曜日名称の補完
		arrF[3] = getWeekdayName(d);
	}
	//要素間の約物抽出
	for (i = 1; i < arrP.length; i++) {
		m = arrP[i - 1] + arrL[i - 1];
		if (m > arrP[i]) {
			arrSpr[i - 1] = "";
		} else {
			arrSpr[i - 1] = f.substring(m, arrP[i]);
		}
	}
	//要素と約物の連結
	for (i = 0; i < arrF.length - 1; i++) {
		str += arrF[i];
		str += arrSpr[i];
	}
	str += arrF[arrF.length - 1];
	return str;
}
function getStrDec(d, c) {
/*
	数値編集（前ZERO付加）
		d: 数値
		c: 桁数
*/
	var str = "" + d;
	if (str.length > c) {
		str = str.substring(str.length - c);
	} else {
		while (str.length < c) {
			str = "0" + str;
		}
	}
	return str;
}
function setCalendarDate(t) {
//alert(t);
/*
	引数の日付を日付表示窓に表示
*/
	var ye = t.getFullYear();
	var mo = t.getMonth() + 1;
	var da = t.getDate();

  document.getElementById("divCalendarY").innerHTML = ye;
  document.getElementById("divCalendarM").innerHTML = mo;
  document.getElementById("divCalendarD").innerHTML = da;
	document.getElementById("hdnCalendarY").value = ye;
  document.getElementById("hdnCalendarM").value = mo;
  document.getElementById("hdnCalendarD").value = da;
}
function showCalendar(id) {
//setTrace("showCalendar("+id+")");
	var tarDiv = document.getElementById("divCalendar");
	var pPar;
//	if (id.indexOf("ID") >= 0) {
		pPar = document.getElementById("tblId");
//	} else {
//		pPar = document.getElementById("tblDate");
//	}
	var pTar = document.getElementById("th" + id);
	tarDiv.style.top = (pPar.offsetTop + 24) + "px";
	tarDiv.style.left = pTar.offsetLeft + "px";
	tarDiv.style.display = "block";
}
function wipeCalendar() {
//setTrace("wipeCalendar("+")");
	var tarDiv = document.getElementById("divCalendar");
	tarDiv.style.display = "none";
}

function getLink(str, uri, tar) {
	var rtn = "";
	rtn += "<a href='" + uri + "'";
	if (tar != "") {
		rtn += " target='" + tar + "'";
	}
	rtn += ">" + str + "</a>";
	return rtn;
}
function showCalendarY(t) {
//setTrace("showCalendarY("+t+")");
	var c, r;
	var s = "";
	var l;
	var y = t.getFullYear();
	var m = t.getMonth() + 1;
	var d = t.getDate();
/*	var yS;
	c = Math.floor(y / 10) * 10;
	if (c == y) {
		yS = y - 9;
	} else {
		yS = c + 1;
	}
	yS = y - 2;
	*/
	var i = y - 2;
	var tarDiv = document.getElementById("divCalendarTblY");
	var tarTdL = document.getElementById("tdCalendarYL");
	var tarTdC = document.getElementById("tdCalendarYC");
	var tarTdR = document.getElementById("tdCalendarYR");

	//中央の年テイブル
	s += "<table class='table1'>";

	for (r = 0; r < 1; r++) {
		s += "<tr>";
		for (c = 0; c < 5; c++) {
			l = "javascript: selDate(" + i + "," + m + "," + d + ",\"Y\");";
			s += "<td class='";
			if (i == y) {
				s += "cellHit";
			} else {
				s += "cellTime";
			}
			s += "' id='y" + i + "'>";
			s += getLink(i, l, "");
			s += "</td>";
			i ++;
		}
		s += "</tr>";
	}
	s += "</table>";
	tarTdC.innerHTML = s;
	//左端の"<"リンク
	l = "javascript: selDate(" + (y - 5) + "," + m + "," + d + ",\"Y\");";
	tarTdL.innerHTML = "<div class='cellPointer' onclick='" + l + "'>＜</div>";
	//右端の">"リンク
	l = "javascript: selDate(" + (y + 5) + "," + m + "," + d + ",\"Y\");";
	tarTdR.innerHTML = "<div class='cellPointer' onclick='" + l + "'>＞</div>";
	tarDiv.style.display = "block";
}
function showCalendarM(t) {
	var c, r;
	var s = "";
	var l;
	var y = t.getFullYear();
	var m = t.getMonth() + 1;
	var d = t.getDate();
	var i = m - 3;	//リンク用
	var j;					//表示用
	var tarDiv = document.getElementById("divCalendarTblM");
	var tarTdL = document.getElementById("tdCalendarML");
	var tarTdC = document.getElementById("tdCalendarMC");
	var tarTdR = document.getElementById("tdCalendarMR");

	//中央の月テイブル
	s += "<table class='table1'>";

	for (r = 0; r < 1; r++) {
		s += "<tr>";
		for (c = 0; c < 7; c++) {
			l = "javascript: selDate(" + y + "," + i + "," + d + ",\"M\");";
			s += "<td class='";
			if (i == m) {
				s += "cellHit";
			} else {
				s += "cellTime";
			}
			if (i > 12) {
				j = i - 12;
			} else if (i < 1) {
				j = i + 12;
			} else {
				j = i;
			}
			s += "' id='m" + j + "'>";
			s += getLink(getWideDec(j), l, "");
			s += "</td>";
			i ++;
		}
		s += "</tr>";
	}
	s += "</table>";
	tarTdC.innerHTML = s;
	//左端の"<"リンク
	l = "javascript: selDate(" + y + "," + (m - 7) + "," + d + ",\"Y\");";
	tarTdL.innerHTML = "<div class='cellPointer' onclick='" + l + "'>＜</div>";
	//右端の">"リンク
	l = "javascript: selDate(" + y + "," + (m + 7) + "," + d + ",\"Y\");";
	tarTdR.innerHTML = "<div class='cellPointer' onclick='" + l + "'>＞</div>";
	tarDiv.style.display = "block";
}
function showCalendarD(t) {
//setTrace("showCalendarD("+t+")");
	var c, r;
	var s = "";
	var l;
	var y = t.getFullYear();
	var m = t.getMonth() + 1;
	var d = t.getDate();
	var dS = new Date(y, m - 1, 1);
	var dE = new Date(y, m, 0);
	var dSw = dS.getDay();
	var dW;
	var dL;
	var todayDate = new Date();
	var tY = todayDate.getFullYear();
	var tM = todayDate.getMonth() + 1;
	var tD = todayDate.getDate();
	var iY, iM, iD;
	var tarDiv = document.getElementById("divCalendarTblD");
	var tarTdL = document.getElementById("tdCalendarDL");
	var tarTdC = document.getElementById("tdCalendarDC");
	var tarTdR = document.getElementById("tdCalendarDR");
	//中央の日テイブル
	dW = new Date(1961, 11, 10);
	s += "<table class='table1'><tr>";
	for (c = 0; c < 7; c++) {
		iY = dW.getFullYear();
		iM = dW.getMonth() + 1;
		iD = dW.getDate();
		s += "<th class='cellWeekday' id='thWd" + c + "'";
		switch (c) {
		case 0:
			s += " style='color:red;'>";
			break;
		case 6:
			s += " style='color:blue;'>";
			break;
		default:
			s += ">";
		}
		s += getWeekdayName(dW) + "</th>";
		dW = new Date(iY, iM - 1, iD + 1);
	}
	s += "</tr>";
	dW = new Date(y, m - 1, 1 - dSw);
	dL = new Date(y, m - 1, 1 - dSw);
	for (r = 0; r < 6; r++) {
		s += "<tr>";
		for (c = 0; c < 7; c++) {
			iY = dW.getFullYear();
			iM = dW.getMonth() + 1;
			iD = dW.getDate();
			l = "javascript: selDate("
				+ iY + "," + iM + "," + iD + ",&quot;D&quot;);";
			s += "<td class='";
			if ((dW < dS) || (dW > dE)) {
				s += "cellOutMonth";
			} else if ((iY == tY) &&
			           (iM == tM) &&
                 (iD == tD)) {
				s += "cellToday";
			} else if (iD == d) {
				s += "cellHit";
			} else if (c == 0) {
				s += "cellSunday";
			} else if (c == 6) {
				s += "cellSatday";
			} else {
				s += "cellTime";
			}
			s += "' id='tdD" + iY + getStrDec(iM, 2) + getStrDec(iD, 2);
//			s += "' onclick='" + l +
			s += "'>";
			s += getLink(getWideDec(iD), l, "");
			s += "</td>";
			if ((c == 6) && (dW >= dE)) {
				r = 9;
				break;
			} else {
				dW = new Date(iY, iM - 1, iD + 1);
			}
		}
		s += "</tr>";
	}
	s += "</table>";
	tarTdC.innerHTML = s;
	//左端の"<"リンク
	l = "javascript: selDate(" + y + "," + (m - 1) + "," + d + ",\"M\");";
	tarTdL.innerHTML = "<div class='cellPointer' onclick='" + l + "'>　<br />　<br />　<br />＜<br />　<br />　<br />　<br /></div>";
	//右端の">"リンク
	l = "javascript: selDate(" + y + "," + (m + 1) + "," + d + ",\"M\");";
	tarTdR.innerHTML = "<div class='cellPointer' onclick='" + l + "'>　<br />　<br />　<br />＞<br />　<br />　<br />　<br /></div>";
	//VolIDのDB存在チェックと休日チェック
	if (calendarTarId.indexOf("Rk") >= 0) {
		s = "rk";
	} else if (calendarTarId.indexOf("Bk") >= 0) {
		s = "bk";
	} else if (calendarTarId.indexOf("Pm") >= 0) {
		s = "pm";
	} else if (calendarTarId.indexOf("Tm") >= 0) {
		s = "tm";
	} else {
		s = "xx";
	}
	assistCalendar(getStrDatetime(dL, "yyyyMMdd"), getStrDatetime(dW, "yyyyMMdd"), s, calendarTarId);
	
	tarDiv.style.display = "block";
}
function selDate(y, m, d, mode) {
//setTrace("selDate("+y+","+m+","+d+","+mode+")");
  var newDate;
  try {
  	newDate = new Date(y, m - 1, d);
  } catch (e) {
	  newDate = new Date();
	}
	setCalendarDate(newDate);
	if (mode == "D") {
		returnCalendar(calendarTarId);
	} else {
		newDate = getTempCalendar();
//		alert(newDate);
		showCalendarY(newDate);
		showCalendarM(newDate);
		showCalendarD(newDate);
	}
}
function resetCalendar(t) {
//setTrace("resetCalendar("+t+")");
	var newDate = new Date();

	if (t == 0) {
		newDate.setHours(0);
		newDate.setMinutes(0);
		newDate.setSeconds(0);
	}
	setCalendarDate(newDate);
	showCalendarY(newDate);
	showCalendarM(newDate);
	showCalendarD(newDate);
}
function getWeekdayName(t) {
	var tblWD = new Array("日","月","火","水","木","金","土");
	var w = t.getDay();
	return tblWD[w];
}
function getWideDec(n) {
	var arrM = new Array(
		"０","１","２","３","４","５","６", "７","８","９");
	var s;
	try {
		if (n < 10) {
			s = arrM[n];
		} else {
			s = "" + n;
		}
	} catch (e) {
		s = "" + n;
	}
	return s;
}
function getTempCalendar() {
//setTrace("getTempCalendar()");
	var y = parseInt(document.getElementById("hdnCalendarY").value, 10);
	var m = parseInt(document.getElementById("hdnCalendarM").value, 10);
	var d = parseInt(document.getElementById("hdnCalendarD").value, 10);
  var newDate = new Date(y, m - 1, d);
/*  newDate.setFullYear(y);
  newDate.setMonth(m);
  newDate.setDate(d);
alert("getTempCalendar(m)" + m);
  alert("getTempCalendar" + newDate);
  */
  return newDate;
}
function returnCalendar(id) {
//setTrace("returnCalendar("+ id + ")");
	var tar = document.getElementById("inp" + id);
	var chk = document.getElementById("chk" + id);
	var sel = document.getElementById("selKeyword");
	var chkT = document.getElementById("chkKeywordT");
	var chkP = document.getElementById("chkKeywordP");
	var chkH = document.getElementById("chkKeywordH");
	var chkD = document.getElementById("chkKeywordD");
	var str;
  var newDate = new Date();
  newDate = getTempCalendar();

	if (id.indexOf("ID") >= 0) {
		str = getStrDatetime(newDate, "yyMMdd");
	} else {
		str = getStrDatetime(newDate, "yyyy-MM-dd");
	}
	tar.value = str;
	if (chk != null) {
		chk.checked = true;
	}
	if (calendarTarId.indexOf("Keyword") >= 0) {
		sel[0].selected = true;
		chkT.checked = false;
		chkP.checked = false;
		chkH.checked = false;
		chkD.checked = true;
	}
	wipeCalendar();
}
