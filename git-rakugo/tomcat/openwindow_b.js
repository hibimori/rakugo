//*****************************************************************
//	各種Windowの表示 for BookDB Tool
//		1.21	2016.12/22	[AB検索]はURI欄が空白でも行なう。
//		1.20	2016.12/17	[AB検索]の結果表示をiFrameから別窓に変更。
//		1.10	12.5/26		bk1→honto移行対応
//		1.00	05.1/31		本体から分離
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
// BookDBメンテのURLとパラメタ
var openBook = "makebook.jsp";
var openBookPar = "?inpTitle=&inpTitleSort=&inpTitleSeq=&selKeyword=GE&inpKeysord=&selKeywordT=T&inpP1ID=&inpP1Sei=&inpP1Mei=&inpP2ID=&inpP2Sei=&inpP2Mei=&inpP3ID=&inpP3Sei=&inpP3Mei=&inpSourceID=&inpSource=&inpGetDate=&chkGetDate=&inpMemo=&inpRnwDate=&inpISBN=&inpURLA=&inpImgA=&inpURLB=&inpImgB=&inpURLC=&inpImgC=&selImg=B&formBtnType=btnIDSeq";
// 書影TableのURLとパラメタ
var openViewBook = "viewbook.jsp";
var openViewBook5 = "viewbook5.jsp";
// bk1/amazon検索用URL
//var openSearchURL = "http://www.asahi-net.or.jp/~SU2N-NI/suki/books/search.htm";
var openSearchURL = "searchbook.htm";
//amazon・bk1・Googleの検索用パラメタ（iframe用）
//affiliate2.0追加（07.6/8; iframeではなくdivに一覧を表示）
	var openIfrA = "http://www.amazon.co.jp/exec/obidos/external-search";
		openIfrA += "?mode=blended&tag=niin-22&encoding-string-jp=日本語";
		openIfrA += "&keyword=";
/*	var openIfrB = "http://www.bk1.co.jp/search/search.asp";
		openIfrB += "?partnerid=p-niin00148&srch=1&Sort=dd&submit.x=0&submit.y=0";
		openIfrB += "&kywd=";
	var openIfrB = "http://www.bk1.jp/books/searchResult/?partnerid=p-niin00148&keyword=";
		*/
	var openIfrB = "http://honto.jp/netstore/search_10";
	var openIfrC = "http://www.google.co.jp/search";
		openIfrC += "?hl=ja&ie=UTF-8";
		openIfrC += "&q=";
	var openIfrE = "http://www.google.co.jp/search";
		openIfrE += "?hl=ja&ie=UTF-8";
		openIfrE += "&q=";
	var openIfrER = "http://ebookstore.sony.jp/search/?q=";
	var openIfrF = "affbook.html";
		openIfrF += "?kwd=";

var parYesToolbar = 'toolbar=yes,location=yes,resizable=yes,status=yes,menubar=yes,scrollbars=yes';
var parNoToolbar = 'toolbar=no,location=no,resizable=yes,status=yes,menubar=no,scrollbars=yes';
var parSize400 = 'toolbar=no,location=no,resizable=yes,status=yes,menubar=no,scrollbars=yes,height=450,width=400';


function openModWindow(tarID, tarSeq) {
/* 別編集用窓を開く */
	wkURL = openBook + openBookPar;
	wkURL = wkURL + "&inpID=" + tarID + "&inpSeq=" + tarSeq;
	rtn = window.open(wkURL, '_blank', parNoToolbar);
}


function openViewWindow(tarID, tarSeq) {
/* 書影Table用窓を開く */
	wkURL = openViewBook5 + "?inpID=" + tarID + "&inpSeq=" + tarSeq + "&formBtnType=btnAdd";
	rtn = window.open(wkURL, 'viewBook', parNoToolbar);
}


function openSelWindow(tarID, tarSeq) {
/* 選択行を再検索する */
	document.formBook.inpID.value = tarID;
	document.formBook.inpSeq.value = tarSeq;
	sendQuery("btnIDSeq");
}


function openSearchWindow() {
/* 書名を以てnii.n検索を行なう */
	var strKwd = document.formBook.inpTitle.value.replace("  ","");
	strKwd = escape(strKwd);
	wkURL = openSearchURL.concat("#store=both&kwd=").concat(strKwd);
	rtn = window.open(wkURL, '_blank', parYesToolbar);
//	wkURL = openSearchURL.concat("#store=ama&kwd=").concat(strKwd);
//	rtn = window.open(wkURL, '_blank', parYesToolbar);
}


function openTitleWindow(tarInp) {
/* Title入力用窓を開く */
	wkURL = openTitle + openTitlePar + "&inpID=";
	if (tarInp.indexOf("inpSource") >= 0) {
		wkURL = wkURL + document.formBook.inpSourceID.value;
		if (document.formBook.inpSourceID.value == "") {
			wkURL = wkURL + "&formBtnType=dummy";
		} else {
			wkURL = wkURL + "&formBtnType=btnID";
		}
		wkURL = wkURL + "&chkTK=1";
	}
	wkURL = wkURL + "&tarCtrl=formBook." + tarInp;
	wkURL = wkURL + "&tarTitle=";
	wkURL = wkURL + "&tarSub=";
	wkURL = wkURL + "&tarPro=";
	wkURL = wkURL + "&tarSou=" + document.formBook.inpSourceID.value;

	rtn = window.open(wkURL, '_blank', parNoToolbar);
}   
function openPlayerWindow(tarInp) {
/* Author入力用窓を開く */
	wkURL = openPlayer + openPlayerPar + "&formID=";
	if (tarInp.indexOf("P1") >= 0) {
		wkURL = wkURL + document.formBook.inpP1ID.value;
		if (document.formBook.inpP1ID.value == "") {
			wkURL = wkURL + "&formBtnType=dummy";
		} else {
			wkURL = wkURL + "&formBtnType=btnID";
		}
		wkURL = wkURL + "&chkT1=1";
	}
	if (tarInp.indexOf("P2") >= 0) {
		wkURL = wkURL + document.formBook.inpP2ID.value;
		if (document.formBook.inpP2ID.value == "") {
			wkURL = wkURL + "&formBtnType=dummy";
		} else {
			wkURL = wkURL + "&formBtnType=btnID";
		}
		wkURL = wkURL + "&chkT2=1";
	}
	if (tarInp.indexOf("P3") >= 0) {
		wkURL = wkURL + document.formBook.inpP3ID.value;
		if (document.formBook.inpP3ID.value == "") {
			wkURL = wkURL + "&formBtnType=dummy";
		} else {
			wkURL = wkURL + "&formBtnType=btnID";
		}
		wkURL = wkURL + "&chkT3=1";
	}
	wkURL = wkURL + "&tarCtrl=formBook." + tarInp;
	wkURL = wkURL + "&tarP1=" + document.formBook.inpP1ID.value;
	wkURL = wkURL + "&tarP2=" + document.formBook.inpP2ID.value;
	wkURL = wkURL + "&tarP3=" + document.formBook.inpP3ID.value;

	rtn = window.open(wkURL, '_blank', parNoToolbar);
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

function searchAB() {
/*
	タイトル文字列によるbk1・amazon・Googleの検索結果を
	iframeに表示する。
	[AB検索]トリガ。
*/
	var title = document.getElementById("title").value;
	var author = document.getElementById("author1").value;
    var titleSeq = document.getElementById("titleSeq").value;
	var kwd = title;
    var seq;
    var rtn;
    try {
        if (titleSeq.length > 0) {
            kwd += " " + parseInt(titleSeq, 10);
        }
    } catch(e) {
    }
	if ((author != "") || (author != null)) {
		if ((author.substring(0, 1) < "A") ||
		    (author.substring(0, 1) > "z")) {
			kwd += " " + author;
		}
	}
	if (kwd != "") {
		/*
		setIfr("bk1", openIfrB + encodeURIComponent(kwd, true) + ".html", true);
		setIfr("ama", encodeURI(openIfrA) + encodeURIComponent(kwd, true), true);
		setIfr("oth", openIfrC + kwd, true);
		setIfr("ebk", openIfrE + kwd + " site:" + openIfrER, true);
		*/
//		setIfr("aff", openIfrF + encodeURIComponent(title, true), true);
		//iFrameはたいがいのブラウザが無効にするので別窓で開く
		openStore("bk1", kwd);
		openStore("ama", kwd);
		openStore("ebk", kwd);
		openStore("oth", kwd);
	}
}
function openIfr(tar) {
/*
	Uri文字列によるbk1・amazon・その他の検索結果を
	iframeに表示/消去する。
	[Open]トリガ。
	tar: 店種別; "bk1","ama","oth"
*/
	var mode = "";
	if (tar == "ama") {
		mode = "A";
	} else if (tar == "bk1") {
		mode = "B";
	} else if (tar == "oth") {
		mode = "C";
	} else if (tar == "ebk") {
		mode = "E";
	} else if (tar == "aff") {
		mode = "F";
	} else {
		return false;
	}
	var url = document.getElementById("url" + mode);
	var btn = document.getElementById("btn" + mode);

	var disp = true;
	if ((url.value == "") ||
	    (btn.value.indexOf("Close") >= 0)) {
			disp = false;
	}
	setIfr(tar, url.value, disp);
}
function setIfr(tar, kwd, disp) {
/*
	bk1・amazon・その他検索結果表示用
	iframeのプロパティを設定する。
	tar: 店種別; "bk1","ama","oth"
	kwd: iframe表示uri
	disp: iframe内包divのdisplay ON/OFF: true, false
*/
//alert(tar + "," + kwd + "," + disp);
	var mode;
	if (tar == "ama") {
		mode = "A";
	} else if (tar == "bk1") {
		mode = "B";
	} else if (tar == "ebk") {
		mode = "E";
	} else if (tar == "aff") {
		mode = "F";
	} else {
		mode = "C";
	}
	var div = document.getElementById("div" + mode);
	var divF = document.getElementById("divF");
	var ifr = document.getElementById("ifr" + mode);
	var ifrF = document.getElementById("ifrF");
	var btn;
	if (mode != "F") {
		btn = document.getElementById("btn" + mode);
	}
	if (disp == true) {
		ifr.src = kwd;
		ifr.height = "256px";
		ifr.width = "720px";
		ifr.scrolling = "yes";
		if (mode != "F") {
			btn.value = "↑Close";
		}
		div.style.display = "block";
	} else {
		ifr.src = "";
		if (mode != "F") {
			btn.value = "Open";
		}
		div.style.display = "none";
		if (mode == "B") {
			ifrF.src = "";
			divF.style.display = "none";
		}
	}
}
function openStore(tar, kwd) {
/*
	Uri文字列によるbk1・amazon・その他の検索結果を
	別窓に表示/消去する。
	tar: 店種別; "bk1","ama","oth","ebk"
*/
	var mode = "";
	var uri = "";
	if (tar == "ama") {
		mode = "A";
		uri = encodeURI(openIfrA) + encodeURIComponent(kwd, true);
	} else if (tar == "bk1") {
		mode = "B";
		uri = openIfrB + encodeURIComponent(kwd, true) + ".html";
	} else if (tar == "oth") {
		mode = "C";
		uri = openIfrC + encodeURIComponent(kwd, true);
	} else if (tar == "ebk") {
		mode = "E";
		uri = openIfrER + encodeURIComponent(kwd, true);
	} else {
		return false;
	}
//	if (document.getElementById("url" + mode).value == "") {
//		return true;
//	} else {
		if (window.confirm("Window.open " + tar + "?") == true) {
			rtn = window.open(uri, '_' + tar, parYesToolbar);
		}
//	}
}
