//*****************************************************************
//  入力項目の補正とクリア for BookDB Tool
//    1.40  11.11/12    電子本項目対応
//    1.30  11.7/27    bk1書影URIの bibimg ⇔ hmvimg 交換
//    1.20  07.1/5    ISBNの13桁化に伴いamazon Bibidから独立して編集
//    1.10  05.4/10    bk1リニューアルに伴うURL改訂に対応
//    1.00  05.1/31    本体から分離
//*****************************************************************
function assistInpData() {
  var i; var j; var posI;
  var wkText; var wkText2; var wkText3; var wkText4;
  var wkUri; var wkImg; var wkVol;
  var wkStore;
  var tblA; var wkISBN;
  //ID・SEQ補正
  document.formBook.inpID.value = convWideNumToNum(document.formBook.inpID.value);
  document.formBook.inpSeq.value = convWideNumToNum(document.formBook.inpSeq.value);
  document.formBook.inpTitleSeq.value = convWideNumToNum(document.formBook.inpTitleSeq.value);
  //タイトルふりがな補正
  wkText = document.formBook.inpTitle.value.toUpperCase();
  wkText2 = document.formBook.inpTitleSort.value;
  if (wkText2 == "") {
    document.formBook.inpTitleSort.value = convKataToHira(wkText);
  }
  //購入日chk補正
  if (document.formBook.inpGetDate.value != "") {
    document.formBook.chkGetDate.checked = true;
  }
  //ISBN補正（bk1の"ISBN：x-xx-xxxxxx-x"対策）
  wkText = document.formBook.inpISBN.value;
  wkText = wkText.replace(/-/g, "");
  posI = wkText.indexOf("ISBN：");
  if (posI >= 0) {
    wkText = wkText.substring(posI + 5, posI + 18);
  }
  document.formBook.inpISBN.value = wkText;
  alert("a");
  //bk1 URL補正
  var itemInfo = {
  	  get_store:	function(s) { return getItemStore(s); },
  	  get_item_id:	function(s, m) { return getItemId(s, m); },
  	  get_item_uri:	function(s, m) { return getItemUri(s, m); },
  	  get_item_img:	function(s, m) { return getItemImg(s, m); }
  };
  wkText = document.formBook.inpURLB.value;
  wkText2 = document.formBook.inpImgB.value;
  if (wkText.length === 0) {
  	  wkStore = "";
  	  wkUri = "";
  	  wkImg = "";
  } else {
	  wkStore = itemInfo.get_store(wkText);
	  wkVol = itemInfo.get_item_id(wkText, wkStore);
	  wkUri = itemInfo.get_item_uri(wkVol, wkStore);
	  wkImg = itemInfo.get_item_img(wkVol, wkStore);
  }
  if (wkUri != wkText) {
    if (confirm("Replace?\n\n" + wkText + "\n↓\n" + wkUri)) {
      document.formBook.inpURLB.value = wkUri;
    }
  }
  if ((wkImg != wkText2) {
    if (wkText2.length === 0) {
      document.formBook.inpImgB.value = wkImg;
    } else {
      if (confirm("Replace?\n\n" + wkText2 + "\n↓\n" + wkImg)) {
        document.formBook.inpImgB.value = wkImg;
      }
    }
  }
  //Amazon URL補正
  wkText = document.formBook.inpURLA.value;
  wkText2 = document.formBook.inpImgA.value;
  wkText3 = document.formBook.inpISBN.value;
  if (wkText.length === 0) {
  	  wkStore = "";
  	  wkUri = "";
  	  wkImg = "";
	  wkISBN = "";
  } else {
	  wkStore = itemInfo.get_store(wkText);
	  wkVol = itemInfo.get_item_id(wkText, wkStore);
	  wkUri = itemInfo.get_item_uri(wkVol, wkStore);
	  wkImg = itemInfo.get_item_img(wkVol, wkStore);
    //ISBNを生成
	  wkISBN = getISBN13(wkVol);
  }
  if (wkUri != wkText) {
    if (confirm("Replace?\n\n" + wkText + "\n↓\n" + wkUri)) {
      document.formBook.inpURLA.value = wkUri;
    }
  }
  if (wkImg != wkText2) {
    if (wkText2 == "") {
      document.formBook.inpImgA.value = wkImg;
    } else {
      if (confirm("Replace?\n\n" + wkText2 + "\n↓\n" + wkImg)) {
        document.formBook.inpImgA.value = wkImg;
      }
    }
  }
  if (wkISBN != wkText3) {
	  if (wkText3 == "") {
	  	  document.formBook.inpISBN.value = wkISBN;
	  } else if (wkText3 == wkVol) {
	  	//旧ISBN
	  } else {
	    if (wkISBN != wkText3) {
      	if (confirm("Replace?\n\n" + wkText3 + "\n↓\n" + wkISBN)) {
        	document.formBook.inpISBN.value = wkISBN;
        }
      }
    }
  }

  //ReaderStore URL補正
  wkText = document.formBook.inpURLE.value;
  wkText2 = document.formBook.inpImgE.value;
  if (wkText.length === 0) {
  	  wkStore = "";
  	  wkUri = "";
  	  wkImg = "";
  } else {
	  wkStore = itemInfo.get_store(wkText);
	  wkVol = itemInfo.get_item_id(wkText, wkStore);
	  wkUri = itemInfo.get_item_uri(wkVol, wkStore);
	  wkImg = itemInfo.get_item_img(wkVol, wkStore);
  }
  if (wkUri != wkText) {
    if (confirm("Replace?\n\n" + wkText + "\n↓\n" + wkUri)) {
      document.formBook.inpURLE.value = wkUri;
    }
  }
  if (wkImg != wkText2) {
    if (wkText2 == "") {
      document.formBook.inpImgE.value = wkImg;
    } else {
      if (confirm("Replace?\n\n" + wkText2 + "\n↓\n" + wkImg)) {
        document.formBook.inpImgE.value = wkImg;
      }
    }
  }
  //書影区分補正
  wkText = document.formBook.inpImgA.value;
  wkText2 = document.formBook.inpImgB.value;
  wkText3 = document.formBook.inpURLC.value;
  wkText4 = document.formBook.inpURLE.value;
  if ((wkText != "") && (wkText2 == "") && (wkText3 == "") && (wkText4 == "")) {
    document.formBook.selImg.value = "A";
  }
  if ((wkText == "") && (wkText2 != "") && (wkText3 == "") && (wkText4 == "")) {
    document.formBook.selImg.value = "B";
  }
  if ((wkText == "") && (wkText2 == "") && (wkText3 != "") && (wkText4 == "")) {
    document.formBook.selImg.value = "C";
  }
  if ((wkText == "") && (wkText2 == "") && (wkText3 == "") && (wkText4 != "")) {
    document.formBook.selImg.value = "E";
  }
  if ((wkText == "") && (wkText2 == "") && (wkText3 == "") && (wkText4 == "")) {
    document.formBook.selImg.value = "";
  }
  if ((wkText == "") && (document.formBook.selImg.value == "A")) {
    document.formBook.selImg.value = "B";
  }
  if ((wkText2 == "") && (document.formBook.selImg.value == "B")) {
    document.formBook.selImg.value = "A";
  }
  if ((wkText3 == "") && (document.formBook.selImg.value == "C")) {
    document.formBook.selImg.value = "B";
  }
  if ((wkText4 == "") && (document.formBook.selImg.value == "E")) {
    document.formBook.selImg.value = "C";
  }
  if ((wkText != "") && (wkText2 != "") && (wkText3 != "") && (wkText4 != "")
            && (document.formBook.selImg.value == "")) {
    document.formBook.selImg.value = "B";
  }
  //memo補正
  wkText = document.formBook.inpMemo.value;
  wkText = wkText.replace(/\"/g,"&quot;");
  document.formBook.inpMemo.value = wkText;
  //購入額補正
  wkText = document.formBook.inpCur.value.toUpperCase();
  wkText2 = document.formBook.inpPrice.value;
  wkText2 = convWideNumToNum(wkText2);
  if (wkText2.length == 0) {
  	  wkText = "";
  } else {
	  if (wkText.length == 0) {
	  	  wkText = "JP";
	  }
  }
  document.formBook.inpCur.value = wkText;
  document.formBook.inpPrice.value = wkText2;
}

function addSeq(idx, ctrl) {
//Seqの１up/down
  var wkSeq = 0;
  var strSeq;
  if (ctrl == "id") {
    strSeq = document.formBook.inpSeq.value;
  } else if (ctrl == "listVal") {
    strSeq = document.formBook.inpListVal.value;
  } else {
    strSeq = document.formBook.inpTitleSeq.value;
  }
  if ((strSeq == "")  || (isNaN(strSeq) == true)) {
    strSeq = "0";
  }
  wkSeq = parseInt(strSeq,10) + idx;

   if (wkSeq < 0) {
    strSeq = "999";
  } else {
    strSeq = "000" + wkSeq;
    strSeq = strSeq.substring(strSeq.length - 3, strSeq.length);
  }
  if (ctrl == "id") {
    document.formBook.inpSeq.value = strSeq;
  } else if (ctrl == "listVal") {
    document.formBook.inpListVal.value = strSeq;
  } else {
    if ((wkSeq == 0) || (wkSeq > 999)) {
      strSeq = "";
      document.formBook.chkTitleSeq.checked = false;
    } else if (wkSeq == 1) {
      document.formBook.chkTitleSeq.checked = true;
    }
    document.formBook.inpTitleSeq.value = strSeq;
  }
}

function clearInpData(strCtrl) {
/* 入力文字列クリア */
  if (strCtrl == "Keyword") {    //検索キーワード クリア
    document.formBook.inpKeyword.value = "";
    //document.formBook.inpKeyword2.value = "";
  }
  if (strCtrl == "Title") {    //書名クリア
    document.formBook.inpTitle.value = "";
    document.formBook.inpTitleSeq.value = "";
  }
  if (strCtrl == "TitleSort") {    //書名かなクリア
    document.formBook.inpTitleSort.value = "";
  }
  if (strCtrl == "P1") {      //著者１クリア
    document.formBook.inpP1ID.value = "";
    document.formBook.inpP1Sei.value = "";
    document.formBook.inpP1Mei.value = "";
  }
  if (strCtrl == "P2") {      //著者２クリア
    document.formBook.inpP2ID.value = "";
    document.formBook.inpP2Sei.value = "";
    document.formBook.inpP2Mei.value = "";
  }
  if (strCtrl == "P3") {      //著者３クリア
    document.formBook.inpP3ID.value = "";
    document.formBook.inpP3Sei.value = "";
    document.formBook.inpP3Mei.value = "";
  }
  if (strCtrl == "Source") {    //出版社クリア
    document.formBook.inpSourceID.value = "";
    document.formBook.inpSource.value = "";
  }
  if (strCtrl == "URLA") {    //amazonURLクリア
    document.formBook.inpURLA.value = "";
    document.formBook.inpImgA.value = "";
  }
  if (strCtrl == "URLB") {    //bk1URLクリア
    document.formBook.inpURLB.value = "";
    document.formBook.inpImgB.value = "";
  }
  if (strCtrl == "URLC") {    //その他URLクリア
    document.formBook.inpURLC.value = "";
    document.formBook.inpImgC.value = "";
  }
  if (strCtrl == "URLE") {    //電子本URLクリア
    document.formBook.inpURLE.value = "";
    document.formBook.inpImgE.value = "";
  }
  if (strCtrl == "memo") {    //Memoクリア
    document.formBook.inpMemo.value = "";
  }
  if (strCtrl == "getDate") {    //購入日クリア
    if (document.formBook.chkGetDate.checked == false) {
      document.formBook.inpGetDate.value = "";
    }
  }
  if (strCtrl == "price") {    //購入額クリア
    document.formBook.inpCur.value = "";
    document.formBook.inpPrice.value = "";
  }
}
function copyInpData() {
/* 現在データを複写して入力待ち */
  if ((document.formBook.inpSeq.value == "000") || (document.formBook.inpSeq.value == "")) {
    document.formBook.inpID.value = "";
    document.formBook.inpSeq.value = "000";
  } else {
    addSeq(1, "id");
  }
  if (document.formBook.inpTitleSeq.value != "") {
    addSeq(1, "title");
  }
  clearInpData("URLA");
  clearInpData("URLB");
//  clearInpData("URLC");
  clearInpData("memo");
//document.formBook.selImg[3].selected = true;
  document.formBook.inpISBN.value = "";
  document.formBook.inpGetDate.value = "";
  document.formBook.chkGetDate.checked = true;
}

function getItemStore(s) {
	if (s.indexOf(".bk1.") > 0) {
		if (s.indexOf("/a8.net/") > 0) {
			return "8";
		} else if (s.indexOf("/ad0.a20.jp/") > 0) {
			return "8";
		} else {
			return "B";
		}
	} else if (s.indexOf(".amazon.") > 0) {
		return "A";
	} else if (s.indexOf(".sony.") > 0) {
		return "R";
	} else if (s.indexOf("bookwalker.") > 0) {
		return "W";
	} else {
		return "?";
	}
}
function getItemId(s, m) {
  var str = s.replace(/[&=?]/g, "/");
  str = s.replace(/%2F/g, "/");
  var aryUri = str.split("/");
  var bibidReg;
  var i;

  if (m === "8") {
  	//A8.net
    for (i = 0; i < aryUri.length; i++) {
      if (aryUri[i] === "product") {
        //"product"の隣がID。
          return aryUri[i + 1];
      }
    }
  } else if (m === "B") {
  	//bk1
    for (i = 0; i < aryUri.length; i++) {
      if ((aryUri[i] === "product") || (aryUri[i] === "bibid")) {
        //"product"または"bibid"(旧bk1)の隣がID。
          return aryUri[i + 1];
      }
    }
  } else if (m === "A") {
  	//Amazon
    bibidReg = /[A-Z0-9]*/;
    for (i = 0; i < aryUri.length; i++) {
      if (aryUri[i].length === 10) {
        if (bibidReg.test(aryUri[i]) === true) {
        //最初の10桁英数字をASINと見なす。
          return aryUri[i];
        }
      }
    }
  } else if (m === "R") {
  	//ReaderStore
    bibidReg = /BT0000[0-9]+/;
    for (i = 0; i < aryUri.length; i++) {
      if (bibidReg.test(aryUri[i]) === true) {
          return aryUri[i];
      }
    }
  } else if (m === "W") {
    //BookWalker
    bibidReg = /^[a-z0-9]+-\d\d\d\d-\d\d\d\d-/;
    for (i = 0; i < aryUri.length; i++) {
      if (bibidReg.test(aryUri[i]) === true) {
        return aryUri[i];
	  }
    }
  }
  return "";
}

function getItemUri(s, m) {
	var aryStore = "8ABRW?";
	var i = aryStore.indexOf(m);
	var aryUri = ["http://px.a8.net/svt/ejp?a8mat=163J66+B1PKVM+10UY+HUSFL&a8ejpredirect=http%3A%2F%2Fwww.bk1.jp%2Fproduct%2F",
		"http://www.amazon.co.jp/exec/obidos/ASIN/",
		"http://www.bk1.jp/product/",
		"http://ebookstore.sony.jp/item/",
		"http://bookwalker.jp/pc/detail/",
		""];
	var aryUri2 = ["%3Fpartnerid%3D02a801",
		"/niin-22",
		"",
		"",
		"",
		""];
	return aryUri[i] + s + aryUri2[i];
}

function getItemImg(s, m) {
	var aryStore = "8ABHRW?";
	var aryUri = ["http://img.bk1.jp/bibimg/",
		"http://images-jp.amazon.com/images/P/",
		"http://img.bk1.jp/bibimg/",
		"http://img.bk1.jp/hmvimg/",
		"http://ebookstore.sony.jp/photo/BT0000/",
		"http://bookwalker.jp/cc/thumbnailImage_",
		""];
	var aryUri2 = [".jpg",
		".09.MZZZZZZZ.jpg",
		".jpg",
		".jpg",
		"._tl.jpg",
		".jpg",
		""];
	var str;
	var i = aryStore.indexOf(m);
	if ((m === "8") || (m === "B")) {
		try {
		//bk1のIDが前ZEROなしに８桁ならHBMなのだ
			if (parseInt(s, 10) >= 10000000) {
				i = aryStore.indexOf("H");
			}
		} catch (e) {
		}
		return aryUri[i] + s.instring(0, 5) + "/" + s + aryUri2[i];
	}
	return aryUri[i] + s + aryUri2[i];
}

function getISBN13(s) {
/*
ISBNのチェックディジットを算出して末尾に付加/置換
  引数:
    s: 文字列（ASIN, 旧ISBN, ISBN）
  戻り値:
    13桁ISBN
    ただし以下のときは引数をそのまま返す。
    ・引数のLengthが 10, 12, 13 以外のとき
    （10: ASIN/旧ISBNを想定, 12: チェックディジットなしのISBN, 
      13: チェックディジット再計算）
    ・引数が半角数字以外のとき（13桁目を除く; "123456789012x"は可）
  参考:
    http://www.isbn-center.jp/whatsnew/kikaku.html#cf1
*/
  var isbn = "";
  var i; var x;
  var a = 0; var b = 0;
  switch (s.length) {
  case 10:
    isbn = "978" + s;
    break;
  case 12, 13:
    isbn = s;
    break;
  default:
    return s;
  }
  isbn = isbn.substring(0, 12);
  if (isbn.match(/[^\d+]/)) {
    return s;
  }
  for (i = 0; i < isbn.length; i++) {
    x = parseInt(isbn.substring(i, i + 1), 10);
    if (i % 2 == 0) {
      a += x;
    } else {
      b += x;
    }
  }
  x = (a + b * 3) % 10;
  if (x == 0) {
    isbn += "0";
  } else {
    isbn += (10 - x);
  }
  return isbn;
}

function putASIN() {
	var uri = document.formBook.inpURLA.value;
	if (uri == "") {
		uri = "";
	} else {
		uri = getASIN(uri);
	}
	document.formBook.inpISBN.value = uri;
}
function chgHmvImg() {
/*
	bk1⇔HMVで書影URIを交換する。
*/
	var str = document.formBook.inpImgB.value;
	if (str.indexOf(strBk1ImgPath) >= 0) {
		str = str.replace(strBk1ImgPath, strHmvImgPath);
	} else if (str.indexOf(strHmvImgPath) >= 0) {
		str = str.replace(strHmvImgPath, strBk1ImgPath);
	}
	document.formBook.inpImgB.value = str;
}
function convKataToHira(str) {
	var p;
	var s = str;
	var c;
	var tblKata = "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヰヱヲンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヴァィゥェォッャュョヮー";
	var tblHira = "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわゐゑをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽぶぁぃぅぇぉっゃゅょゎー";
    s = s.replace(/[,.，.、。・_！!？?　\'\"]/g, "");
    for (var i = 0; i < s.length; i++) {
      p = tblKata.indexOf(s.substring(i, i + 1));
      if (p >= 0) {
        s = s.replace(tblKata.substring(p, p + 1), tblHira.substring(p, p + 1));
      }
    }
    return s;
}
function convWideNumToNum(str) {
	var p;
	var s = str;
	var c;
	var tblNumW = "０１２３４５６７８９";
	var tblNum = "0123456789";
    s = s.replace(/[,.，.、。・_！!？?　\'\"]/g, "");
    for (var i = 0; i < s.length; i++) {
      p = tblNumW.indexOf(s.substring(i, i + 1));
      if (p >= 0) {
        s = s.replace(tblNumW.substring(p, p + 1), tblNum.substring(p, p + 1));
      }
    }
    return s;
}