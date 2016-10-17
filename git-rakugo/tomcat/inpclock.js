//*****************************************************************
//  時刻入力支援（共通） for Rakugo, BookTable Tool
//    (c) Copyright 2007; nii.n All Rights Reserved.
//    1.20  08.5/25		表示窓の数字クリックで１upに修正
//    1.10  07.6/21		[NOW]位置など修正
//    1.00  07.6/20		1stリリース
//*****************************************************************
function makeClock(id, t) {
/*
	時刻選択窓の作成
		id:	セットする部品のID。当該頁でユニークになるコト（String）
		t:	初期表示する時刻（Date）
*/
	var tarDiv = document.getElementById("divClock");
	var nowDatetime = new Date();
	if (t == "") {
		t = nowDatetime;
	}
	var clockLine = "";
	clockLine += id;
	clockLine += "<table class='table1'><tr>";
	clockLine += "<td class='cellHit' id='tdClockH' "
		+ "onmouseover='javascript: showClockHand(\"H\")'>";
	clockLine += "<div id='divClockH'></div>";
	clockLine += "<input type='hidden' id='hdnClockH' />";
	clockLine += "</td><td>:</td>";
	clockLine += "<td class='cellHit' id='tdClockM' "
		+ "onmouseover='javascript: showClockHand(\"M\")'>";
	clockLine += "<div id='divClockM'></div>";
	clockLine += "<input type='hidden' id='hdnClockM' />";
	clockLine += "</td><td>:</td>";
	clockLine += "<td class='cellHit' id='tdClockS' "
		+ "onmouseover='javascript: showClockHand(\"S\")'>";
	clockLine += "<div id='divClockS'></div>";
	clockLine += "<input type='hidden' id='hdnClockS' />";
	clockLine += "</td>";
	clockLine += "<td>";
	clockLine += "<input onclick='javascript: resetClock(0)'";
	clockLine += " type='button' value='ZERO' /><br />";
	clockLine += " <input onclick='javascript: resetClock(1)'";
	clockLine += " type='button' value='NOW' />";
	clockLine += "</td>";
	clockLine += "</tr></table>";
	clockLine += "<div id='divClockHand' class='div2'>";
	clockLine += "</div>";
	clockLine += "<div>";
	clockLine += getStrDatetime(nowDatetime, "yyyy.M/d(E) H:mm:ss");
	clockLine += "</div>";
	clockLine += "<div>";
	clockLine += "<input onclick='";
	clockLine += "javascript: returnClock(\"" + id + "\");'";
	clockLine += " type='button' value='OK' />";
	clockLine += " <input onclick='javascript: wipeClock()'";
	clockLine += " type='button' value='Cancel' />";
	clockLine += "</div>";
	tarDiv.innerHTML = clockLine;
	setClockTime(t);
	showClock(id);
}
function setClockTime(t) {
/*
	引数の時刻を時刻表示窓に表示
*/
	var hr = t.getHours();
	var mi = t.getMinutes();
	var se = t.getSeconds();
	
//	var par1 = "javascript: showClockHand";
	var par1 = "javascript: incHand(";
  document.getElementById("divClockH").innerHTML
  	= getLink(hr, par1 + hr + ",\"H\")", "");
  document.getElementById("divClockM").innerHTML
  	= getLink(getStrDec(mi, 2), par1 + mi + ",\"M\")", "");
  document.getElementById("divClockS").innerHTML
  	= getLink(getStrDec(se, 2), par1 + se + ",\"S\")", "");
/*
  document.getElementById("divClockH").innerHTML
  	= getLink(hr, par1 + "(\"H\")", "");
  document.getElementById("divClockM").innerHTML
  	= getLink(getStrDec(mi, 2), par1 + "(\"M\")", "");
  document.getElementById("divClockS").innerHTML
  	= getLink(getStrDec(se, 2), par1 + "(\"S\")", "");
*/
  document.getElementById("hdnClockH").value = hr;
  document.getElementById("hdnClockM").value = mi;
  document.getElementById("hdnClockS").value = se;
  
//  wipeClockHand();
}
function showClock(id) {
	var tarDiv = document.getElementById("divClock");
	var pPar = document.getElementById("tblDate");
	var pTar = document.getElementById("th" + id);
	tarDiv.style.top = (pPar.offsetTop + 24) + "px";
	tarDiv.style.left = pTar.offsetLeft + "px";
	tarDiv.style.display = "block";
}
function wipeClock() {
	var tarDiv = document.getElementById("divClock");
	tarDiv.style.display = "none";
}

function showClockHand(mode) {
	var c, r;
	var s = "";
	var i, p;
	var arrMde = ["H","M","S"];
	var arrCap = ["Hour","Minute","Second"];
	var arrInc = [1, 5, 5];
	var arrDec = [0, 5, 5];
	var tarDiv = document.getElementById("divClockHand");
	var now = new Date();
	now = getTempClock();
	var hh = now.getHours();
	var mm = now.getMinutes();
	var ss = now.getSeconds();

	for (i = 0; i < arrMde.length; i++) {
		if (arrMde[i] == mode) {
			p = i;
			break;
		}
	}
	if ((p == 0) && (hh > 11)) {
		i = 12;
	} else {
		i = 0;
	}
	//中央の時分秒リンク
	s += "<table class='table1'><caption style='caption-side: bottom;'>[";
	s += arrCap[p] + "]</caption>";

	for (r = 0; r < 2; r++) {
		s += "<tr>";
		for (c = 0; c < 6; c++) {
			s += "<td class='";
			switch (p) {
			case 0:
				if ((i == hh) || (i - 12 == hh) || (i + 12 == hh)) {
					s += "cellHit";
				} else {
					s += "cellTime";
				}
				break;
			case 1:
				if ((i <= mm) && (i + 5 > mm)) {
					s += "cellHit";
				} else {
					s += "cellTime";
				}
				break;
			case 2:
				if ((i <= ss) && (i + 5 > ss)) {
					s += "cellHit";
				} else {
					s += "cellTime";
				}
				break;
			default:
				s += "cellTime";
			}
			s += "'>";
			s += getLink(getStrDec(i, 2), "javascript: selHand(" + i + ", \""
				+ arrMde[p] + "\");", "");
			s += "</td>";
			i += arrInc[p];
		}
		s += "</tr>";
	}
	s += "</table>";
	tarDiv.innerHTML = s;
	tarDiv.style.display = "block";
}
function wipeClockHand() {
	var tarDiv = document.getElementById("divClockHand");
	tarDiv.style.display = "none";
}

function selHand(t, mode) {
  var newDate = new Date();
  newDate = getTempClock();
  var i;
//  var s = newDate.getSeconds();

	if (mode == "H") {
	  i = newDate.getHours();
		if (t == i) {
			if (t > 11) {
				i -= 12;
			} else {
				i += 12;
			}
		} else {
			i = t;
	  }
	  newDate.setHours(i);
	} else if (mode == "M") {
		i = newDate.getMinutes();
		if ((t <= i) && (t + 4 > i)) {
			i += 1;
		} else {
			i = t;
		}
	  newDate.setMinutes(i);
	} else {
		i = newDate.getSeconds();
		if ((t <= i) && (t + 4 > i)) {
			i += 1;
		} else {
			i = t;
		}
	  newDate.setSeconds(i);
	}
  setClockTime(newDate);
  showClockHand(mode);
}
function incHand(t, mode) {
  var newDate = new Date();
  newDate = getTempClock();
  var i;

	if (mode == "H") {
	  i = newDate.getHours() + 1;
	  newDate.setHours(i);
	} else if (mode == "M") {
		i = newDate.getMinutes() + 1;
	  newDate.setMinutes(i);
	} else {
		i = newDate.getSeconds() + 1;
	  newDate.setSeconds(i);
	}
  setClockTime(newDate);
  showClockHand(mode);
}
function resetClock(t) {
	var newDate = new Date();

	if (t == 0) {
		newDate.setHours(0);
		newDate.setMinutes(0);
		newDate.setSeconds(0);
	}
	setClockTime(newDate);
}
function getTempClock() {
  var newDate = new Date();
	var h = parseInt(document.getElementById("hdnClockH").value, 10);
	var m = parseInt(document.getElementById("hdnClockM").value, 10);
	var s = parseInt(document.getElementById("hdnClockS").value, 10);
  newDate.setHours(h);
  newDate.setMinutes(m);
  newDate.setSeconds(s);
  
  return newDate;
}
function returnClock(id) {
	var tar = document.getElementById("inp" + id);
	var chk = document.getElementById("chk" + id);
	var str;
  var newDate = new Date();
  newDate = getTempClock();

	if (id.indexOf("Time") > 0) {
		str = getStrDatetime(newDate, "H:mm");
	} else if (id.indexOf("Len") > 0) {
		str = getStrDatetime(newDate, "H:mm:ss");
	}
	tar.value = str;
	chk.checked = true;
	wipeClock();
}
