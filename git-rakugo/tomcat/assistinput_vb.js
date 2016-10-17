//*****************************************************************
//	入力項目の補正とクリア for BookDB Tool (viewbook)
//		1.00	05.1/31		本体から分離
//*****************************************************************
function assistInpDataV() {
	var i;
	var wkChk;
	//削除Checkbox全選択/解除
	wkChk = document.formBook.chkDelTitle.checked;
	for (i = 0; i < document.formBook.inpRows.value; i++) {
		document.formBook.chkDel[i].checked = wkChk;
	}
}

function clearInpDataV(strCtrl) {
// 入力文字列クリア
	if (strCtrl == "btnViewFC") {		//ブランク日付クリア
		document.formBook.inpViewF.value = "";
		document.formBook.inpViewT.value = "";
	}
}
