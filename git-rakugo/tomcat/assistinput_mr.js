//*****************************************************************
//	入力項目の補正とクリア for RakugoDB Tool
//		1.10	2022-03-13	clearInpData()にmemo追加。
//		1.00	05.2/5		本体から分離
//*****************************************************************
function addSeq(idx, ctrl) {
//Seqの１up/down
	var wkSeq;
	var strSeq;
	if (ctrl == "id") {
		strSeq = document.formRakugo.inpSeq.value;
	} else {
		strSeq = document.formRakugo.inpTitleSeq.value;
	}
	if ((strSeq == "")	|| (isNaN(strSeq) == true)) {
		strSeq = "0";
	}
	wkSeq = parseInt(strSeq,10) + idx;
	if (ctrl == "id") {
		if (wkSeq < 1) {
			 strSeq = "999";
		} else if (wkSeq > 999) {
			 strSeq = "001";
		} else {
			strSeq = "000" + wkSeq;
			strSeq = strSeq.substring(strSeq.length - 3, strSeq.length);
		}
		document.formRakugo.inpSeq.value = strSeq;
	} else {
		if (wkSeq < 0) {
			 strSeq = "999";
		} else if ((wkSeq == 0) || (wkSeq > 999)) {
			 strSeq = "";
		} else {
			 strSeq = wkSeq;
		}
		document.formRakugo.inpTitleSeq.value = strSeq;
	}
}

function assistInpData() {
/* 更新時入力補正  */
	//ID・SEQ補正
	document.formRakugo.inpID.value = convWideNumToNum(document.formRakugo.inpID.value);
	document.formRakugo.inpSeq.value = convWideNumToNum(document.formRakugo.inpSeq.value);
	document.formRakugo.inpTitleSeq.value = convWideNumToNum(document.formRakugo.inpTitleSeq.value);
	//録画日chk補正
	if (document.formRakugo.inpRecDate.value == "") {
		document.formRakugo.chkRecDate.checked = false;
	} else {
		document.formRakugo.chkRecDate.checked = true;
		document.formRakugo.inpRecDate.value = convWideNumToNum(document.formRakugo.inpRecDate.value);
	}
	//録画時chk補正
	if (document.formRakugo.inpRecTime.value == "") {
		document.formRakugo.chkRecTime.checked = false;
	} else {
		document.formRakugo.chkRecTime.checked = true;
		document.formRakugo.inpRecTime.value = convWideNumToNum(document.formRakugo.inpRecTime.value);
	}
	
	//録画長chk補正
	if (document.formRakugo.inpRecLen.value == "") {
		document.formRakugo.chkRecLen.checked = false;
	} else {
		document.formRakugo.chkRecLen.checked = true;
		document.formRakugo.inpRecLen.value = convWideNumToNum(document.formRakugo.inpRecLen.value);
	}
}
function resetSourceID(tarSel) {
/* コンボ選択によるSourceIDのリセット */
    if (tarSel == "1") {
        document.formRakugo.selSource2.options[0].selected = true;
        document.formRakugo.inpSourceID.value = document.formRakugo.selSource1.options[document.formRakugo.selSource1.selectedIndex].value;
        document.formRakugo.inpSource.value = "";
    }
    if (tarSel == "2") {
        document.formRakugo.selSource1.options[0].selected = true;
        document.formRakugo.inpSourceID.value = document.formRakugo.selSource2.options[document.formRakugo.selSource2.selectedIndex].value;
        document.formRakugo.inpSource.value = "";
    }
}
function clearInpData(tarBtn) {
/* inp文字列クリア */
	if (tarBtn == "btnTitleClear") {
		document.formRakugo.inpTitle.value = "";
	}
	if (tarBtn == "btnSubClear") {
		document.formRakugo.inpSub.value = "";
	}
	if (tarBtn == "btnProgramClear") {
		document.formRakugo.inpProgram.value = "";
	}
	if (tarBtn == "recDate") {
		if (document.formRakugo.chkRecDate.checked == false) {
			document.formRakugo.inpRecDate.value = "";
		}
	}
	if (tarBtn == "recTime") {
		if (document.formRakugo.chkRecTime.checked == false) {
			document.formRakugo.inpRecTime.value = "";
		}
	}
	if (tarBtn == "recLen") {
		if (document.formRakugo.chkRecLen.checked == false) {
			document.formRakugo.inpRecLen.value = "";
		}
	}
    if (tarBtn == "memo") { //Memoクリア
        document.formRakugo.inpMemo.value = "";
    }
}
function clearKeyword() {
/* Keyword文字列クリア */
	document.formRakugo.inpKeyword.value = "";
	document.formRakugo.inpKeyword2.value = "";
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
