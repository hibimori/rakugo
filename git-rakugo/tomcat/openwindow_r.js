//*****************************************************************
//	各種Windowの表示 for RakugoDB Tool
//		1.00	05.2/5		本体から分離
//*****************************************************************
var rtn;
var wkURL;
// カレンダのURLとパラメタ
var openCalendar = "inpcalendar.jsp";
// クロックのURLとパラメタ
var openClock = "inpclock.jsp";
// タイトルマスタメンテのURLとパラメタ
var openTitle = "maketitle.jsp";
var openTitlePar = "?inpTitle=&inpTitleSort=&inpModeTitle=GE&inpSub=&inpModeSub=GE&inpSubSort=&selCat=&inpSeq=&inpMemo=";
// プレイヤマスタメンテのURLとパラメタ
var openPlayer = "makeplayer.jsp";
var openPlayerPar = "?formSei=&formSeiSort=&formModeSei=GE&formModeMei=GE&formModeGroup=GE&formNameFlg=A&formMemo=";
// RakugoDBメンテのURLとパラメタ
var openRakugo = "makerakugo.jsp";
var openRakugoPar = "?inpTitleID=&inpTitle=&inpTitleSeq=&inpSubID=&inpSub=&selKeyword=GE&inpKeyword=&inpKeyword2=&selKeywordT=T&inpP1ID=&inpP1Sei=&inpP1Mei=&inpP2ID=&inpP2Sei=&inpP2Mei=&inpP3ID=&inpP3Sei=&inpP3Mei=&inpProgramID=&inpProgram=&inpSourceID=&selSource1=&selSource2=&inpSource=&inpRecDate=&inpRecTime=&inpRecLen=&selAttCat=&selAttMed=G&selAttCh=&selAttCo=&selAttNR=&inpMemo=&inpRnwDate=&formBtnType=btnIDSeq";
// 印刷用のURLとパラメタ
var openRakugoView = "viewrakugo.jsp";
var openRakugoViewPar = "?chkSeq=1&chkTitle=1&chkSub=1&chkTSeq=1&chkP1=1&chkP2=1&chkP3=1&chkPro=1&chkLen=1&chkDate=1";

var parYesToolbar = 'toolbar=yes,location=yes,resizable=yes,status=yes,menubar=yes,scrollbars=yes';
var parNoToolbar = 'toolbar=no,location=no,resizable=yes,status=yes,menubar=no,scrollbars=yes';
var parSize400 = 'toolbar=no,location=no,resizable=yes,status=yes,menubar=no,scrollbars=yes,height=400,width=400';


function openModWindow(tarID, tarSeq) {
/* マスタ更新用窓を開く */
wkURL = openRakugo + openRakugoPar;
wkURL = wkURL + "&inpID=" + tarID + "&inpSeq=" + tarSeq;
rtn = window.open(wkURL, '_blank', parNoToolbar);
}


function openViewWindow(tarID) {
/* マスタ印刷用窓を開く */
wkURL = openRakugoView + openRakugoViewPar;
wkURL = wkURL + "&inpID=" + tarID;
rtn = window.open(wkURL, '_blank', parNoToolbar);
}


function openSelWindow(tarID, tarSeq) {
/* 選択行を再検索する */
	document.formRakugo.inpID.value = tarID;
	document.formRakugo.inpSeq.value = tarSeq;
	sendQuery("btnIDSeq");
}


function openSearchWindow() {
/* 書名を以てnii.n検索を行なう */
	var strKwd = document.formBook.inpTitle.value.replace("  ","");
	strKwd = escape(strKwd);
	wkURL = openSearchURL.concat("#store=bk1&kwd=").concat(strKwd);
	rtn = window.open(wkURL, '_blank', parYesToolbar);
	wkURL = openSearchURL.concat("#store=ama&kwd=").concat(strKwd);
	rtn = window.open(wkURL, '_blank', parYesToolbar);
}


function openTitleWindow(tarInp) {
/* Title入力用窓を開く */
	wkURL = openTitle + openTitlePar + "&inpID=";
	if (tarInp.indexOf("inpTitle") >= 0) {
		wkURL = wkURL + document.formRakugo.inpTitleID.value;
		if (document.formRakugo.inpTitleID.value == "") {
			wkURL = wkURL + "&formBtnType=dummy";
		} else {
			wkURL = wkURL + "&formBtnType=btnID";
		}
		wkURL = wkURL + "&chkTT=1";
	}
	if (tarInp.indexOf("inpSub") >= 0) {
		wkURL = wkURL + document.formRakugo.inpSubID.value;
		if (document.formRakugo.inpSubID.value == "") {
			wkURL = wkURL + "&formBtnType=dummy";
		} else {
			wkURL = wkURL + "&formBtnType=btnID";
		}
		wkURL = wkURL + "&chkTS=1";
	}
	if (tarInp.indexOf("inpProgram") >= 0) {
		wkURL = wkURL + document.formRakugo.inpProgramID.value;
		if (document.formRakugo.inpProgramID.value == "") {
			wkURL = wkURL + "&formBtnType=dummy";
		} else {
			wkURL = wkURL + "&formBtnType=btnID";
		}
		wkURL = wkURL + "&chkTP=1";
	}
	if (tarInp.indexOf("inpSource") >= 0) {
		wkURL = wkURL + document.formRakugo.inpSourceID.value;
		if (document.formRakugo.inpSourceID.value == "") {
			wkURL = wkURL + "&formBtnType=dummy";
		} else {
			wkURL = wkURL + "&formBtnType=btnID";
		}
		wkURL = wkURL + "&chkTK=1";
	}
	wkURL = wkURL + "&tarCtrl=formRakugo." + tarInp;
	wkURL = wkURL + "&tarTitle=" + document.formRakugo.inpTitleID.value;
	wkURL = wkURL + "&tarSub=" + document.formRakugo.inpSubID.value;
	wkURL = wkURL + "&tarPro=" + document.formRakugo.inpProgramID.value;
	wkURL = wkURL + "&tarSou=" + document.formRakugo.inpSourceID.value;
	
	rtn = window.open(wkURL, '_blank', parNoToolbar);
}
function openPlayerWindow(tarInp) {
/* Player入力用窓を開く */
	wkURL = openPlayer + openPlayerPar + "&formID=";
	if (tarInp.indexOf("P1") >= 0) {
		wkURL = wkURL + document.formRakugo.inpP1ID.value;
		if (document.formRakugo.inpP1ID.value == "") {
			wkURL = wkURL + "&formBtnType=dummy";
		} else {
			wkURL = wkURL + "&formBtnType=btnID";
		}
		wkURL = wkURL + "&chkT1=1";
	}
	if (tarInp.indexOf("P2") >= 0) {
		wkURL = wkURL + document.formRakugo.inpP2ID.value;
		if (document.formRakugo.inpP2ID.value == "") {
			wkURL = wkURL + "&formBtnType=dummy";
		} else {
			wkURL = wkURL + "&formBtnType=btnID";
		}
		wkURL = wkURL + "&chkT2=1";
	}
	if (tarInp.indexOf("P3") >= 0) {
		wkURL = wkURL + document.formRakugo.inpP3ID.value;
		if (document.formRakugo.inpP3ID.value == "") {
			wkURL = wkURL + "&formBtnType=dummy";
		} else {
			wkURL = wkURL + "&formBtnType=btnID";
		}
		wkURL = wkURL + "&chkT3=1";
	}
	wkURL = wkURL + "&tarCtrl=formRakugo." + tarInp;
	wkURL = wkURL + "&tarP1=" + document.formRakugo.inpP1ID.value;
	wkURL = wkURL + "&tarP2=" + document.formRakugo.inpP2ID.value;
	wkURL = wkURL + "&tarP3=" + document.formRakugo.inpP3ID.value;
	
	rtn = window.open(wkURL, '_blank', parNoToolbar);
}


function openCalendarWindow(tarInp) {
/* ID/日付入力用窓を開く */
/*
wkURL = openCalendar + "?inpName=formRakugo." + tarInp;
if (tarInp == "inpID") {
	wkURL = wkURL + "&inpVal=" + document.formRakugo.inpID.value;
	wkURL = wkURL + "&calVal=" + document.formRakugo.inpID.value;
}
if (tarInp == "inpRecDate") {
	wkURL = wkURL + "&inpVal=" + document.formRakugo.inpRecDate.value;
	wkURL = wkURL + "&calVal=" + document.formRakugo.inpRecDate.value;
}
rtn = window.open(wkURL, '_blank', parSize400);
*/
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


function openClockWindow(tarInp) {
/* 時刻/時間入力用窓を開く */
/*
wkURL = openClock + "?inpName=formRakugo." + tarInp;
if (tarInp == "inpRecTime") {
	wkURL = wkURL + "&inpVal=" + document.formRakugo.inpRecTime.value;
	wkURL = wkURL + "&calVal=" + document.formRakugo.inpRecTime.value;
}
if (tarInp == "inpRecLen") {
	wkURL = wkURL + "&inpVal=" + document.formRakugo.inpRecLen.value;
	wkURL = wkURL + "&calVal=" + document.formRakugo.inpRecLen.value;
}
rtn = window.open(wkURL, '_blank', parSize400);
*/
	var ref = document.getElementById("inp" + tarInp);
	var arrTime = ref.value.split(/\D/g);
	var now = new Date();
	var	h = now.getHours();
	var	m = now.getMinutes();
	var	s = now.getSeconds();

	switch (arrTime.length) {
	case 0:
		break;
	case 1:
		if (tarInp.indexOf("Time") > 0) {
			h = parseInt(arrTime[0], 10);
			m = 0;
			s = 0;
		} else {
			h = 0;
			m = 0;
			s = parseInt(arrTime[0], 10);
		}
		break;
	case 2:
		if (tarInp.indexOf("Time") > 0) {
			h = parseInt(arrTime[0], 10);
			m = parseInt(arrTime[1], 10);
			s = 0;
		} else {
			h = 0;
			m = parseInt(arrTime[0], 10);
			s = parseInt(arrTime[1], 10);
		}
		break;
	default:
		h = parseInt(arrTime[0], 10);
		m = parseInt(arrTime[1], 10);
		s = parseInt(arrTime[2], 10);
	}
	if ((isNaN(h) == true) ||
	    (isNaN(m) == true) ||
	    (isNaN(s) == true)) {
	  makeClock(tarInp, "");
	} else {
		now.setHours(h);
		now.setMinutes(m);
		now.setSeconds(s);
		makeClock(tarInp, now);
	}
}
