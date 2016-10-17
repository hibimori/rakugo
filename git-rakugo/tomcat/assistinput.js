//*****************************************************************
//  項目入力支援（共通） for Rakugo, BookTable Tool
//    1.20  07.6/21		カレンダ日付相当のVolID検索を追加。
//    1.10  07.6/11		かなマスタしか読まないようにdbを"xx"に固定。
//    1.00  07.1/18		Ajax版
//*****************************************************************
var reqAjax = null;

function assistKana(obj, db) {
/*	更新系で［ふりがな］の補完
		AjaxでHttp通信
		被ふりがなIDが"xxx"のとき，ふりがなIDが"xxxSort"であること。
		Buttonによる強制ふりがなのとき，"btnXxxSort"であること。
*/
	var rtn;
	var str;
	var refID;
	var tarID;
	var p = obj.id.indexOf("Sort");
	var q = obj.id.indexOf("btn");
	
	if (p > 0) {
	//ふりがな欄でevent
		if (obj.id.indexOf("btn") == 0) {
			//buttonによる強制ふりがな（DB検索は空振りさせる）
			refID = obj.id.substring(0, p);
			refID = obj.id.substring(3, refID.length);
			refID = refID.toLowerCase();
			tarID = refID + "Sort";
			document.getElementById(tarID).value = "";
		} else {
			refID = obj.id.substring(0, p);
			tarID = obj.id;
		}
		str = document.getElementById(refID).value;
	} else {
	//被ふりがな欄でevent
		refID = obj.id;
		tarID = obj.id + "Sort";
		str = obj.value;
	}
  if (str == "") {
  //ふりがな元が""なら終了
  	return false;
  }
  if (document.getElementById(tarID).value != "") {
  //ふりがな欄に何か入ってれば終了
  	return false;
  }
  var param = "str=" + checkParam(str);
  param += "&id=" + tarID;
  param += "&db=" + "xx";		//rk, bk, pm, tmを読ませないようダミーのxxに固定
//  param += "&db=" + db;
  var uri = "hgsch";
 	setResponseMsg(0, 0);
  //DBからふりがな採取またはふりがな半生成
  httpRequest("POST", uri, true, handleResponseH, param);
}
function assistFullName(mode) {
/*	［姓名］の補完
		AjaxでHttp通信
*/
	var rtn;
	var last = document.getElementById("sei").value;
	var first = document.getElementById("mei").value;
	var group = document.getElementById("group").value;
	var full = document.getElementById("fullname").value;
	var sw = document.getElementById("nameOrder").value;
	
  if ((mode == "auto") && (full != "")) {
  //自動生成で姓名が設定済みなら終了
  	return false;
  }
	if ((last == "") && (first == "")) {
		if (group == "") {
		//すべて未入力なら終了
			return false;
		} else {
		//所属名のみなら姓に代入
			last = group;
		}
	}
  var param = "last=" + last;
  param += "&first=" + first;
  param += "&full=" + full;
  param += "&sw=" + sw;
  param += "&id=fullname";
  var uri = "fnset";
 	setResponseMsg(0, 0);
  //DBからふりがな採取またはふりがな半生成
  httpRequest("POST", uri, true, handleResponseF, param);
}
function storeKana(arrInp, arrKana) {
/*	［ふりがな］のかな以外の部分をかなマスタに登録する。
		AjaxでHttp通信
*/
	var i;
  var param = "";
  for (i = 0; i < arrInp.length; i++) {
  	param += "str" + i + "=" + arrInp[i];
  	param += "&kana" + i + "=" + arrKana[i];
  	param += "&";
  }
  param += "db=kn";
  param += "&mode=store";
  var uri = "hgstr";
 	setResponseMsg(0, 0);
  //かなマスタにふりがな登録
  httpRequest("POST", uri, true, handleResponseS, param);
}
function assistCalendar(lo, hi, db, col) {
//setTrace("assistCalendar(" + lo + ","+hi+","+db+")");
/*	カレンダ表示でDB既存のVolIDに相当する日付と
		休日のリストを取得する。
		AjaxでHttp通信
*/
  var param = "lo=" + lo;
  param += "&hi=" + hi;
  param += "&db=" + db;
  param += "&col=";
  if (col != null) {
  	param += col;
  }
  var uri = "clast";
 	setResponseMsg(0, 0);
  httpRequest("POST", uri, true, handleResponseC, param);
}


//event handler for XMLHttpRequest
function handleResponseH(){
	var root;
	var str;
	var id;
	var parts, strParts, lineParts;
	var partsKana, strPartsKana;
	var i, j;
	var tarDivWork;
  if(reqAjax.readyState == 4){
		if(reqAjax.status == 200){
			//ふりがなを親画面にセット
			root = reqAjax.responseXML.documentElement;
//			alert(reqAjax.responseText);
			str = root.getElementsByTagName("hurigana").item(0).childNodes[0].nodeValue;
			id = root.getElementsByTagName("id").item(0).childNodes[0].nodeValue;
      document.getElementById(id).value = str;

			parts = root.getElementsByTagName("part");
			lineParts = "";
			if (parts.length > 0) {
				lineParts = "<table border='0'><tbody>";
				for (i = 0; i < parts.length; i++) {
					strParts = parts.item(i).getElementsByTagName("pstr").item(0).childNodes[0].nodeValue;
					partsKana = parts.item(i).getElementsByTagName("pkana");
					if (partsKana.length > 0) {
						strPartsKana = partsKana.item(0).childNodes[0].nodeValue;
					} else {
						strPartsKana = "";
					}
					lineParts += "<tr><td align='right'>" + strParts;
					lineParts += "<input type='hidden' id='" + id + "Work" + i;
					lineParts += "' value='" + strParts + "'>:</td>";
					lineParts += "<td><input id='" + id + "WorkKana" + i;
					lineParts += "' size='24' type='text' value='";
					if ((strParts >= "あ") && (strParts < "ア")) {
						lineParts += strParts;
					} else if (strPartsKana != "") {
						lineParts += strPartsKana;
					}
					lineParts += "'></td>";
					//ふりがな候補（既登録）がふたつ以上あったらselectを出す。
					if (partsKana.length > 1) {
						lineParts += "<td><select id='sel" + id + i;
						lineParts += "' onchange='javascript: setPartsKana(\"" + id;
						lineParts += "\", " + i + ")'>";
						for (j = 0; j < partsKana.length; j++) {
							strPartsKana = partsKana.item(j).childNodes[0].nodeValue;
							lineParts += "<option value='" + strPartsKana + "'>";
							lineParts += strPartsKana + "</option>";
						}
						lineParts += "</select></td>";
					}
					if (i == parts.length - 1) {
						lineParts += "<td><input type='button' value='連結' ";
						lineParts += "onclick='javascript: concatHurigana(\"";
						lineParts += id + "\")'></td>";
					}
					lineParts += "</tr>";
				}
				lineParts += "</tbody></table>";
			}
      tarDivWork = document.getElementById(id + "Work");
      tarDivWork.innerHTML = lineParts;
      //alert(lineParts);
      tarDivWork.style.backgroundColor = "lavender";

	   	setResponseMsg(reqAjax.readyState, reqAjax.status);
		} else {
	   	setResponseMsg(reqAjax.readyState, reqAjax.status);
    }
  } else {
//   	setResponseMsg(reqAjax.readyState, reqAjax.status);
  }
}
function handleResponseF(){
	var root;
	var str;
	var id;
  if(reqAjax.readyState == 4){
		if(reqAjax.status == 200){
			//姓名（middlenameつき）を親画面にセット
			root = reqAjax.responseXML.documentElement;
			str = root.getElementsByTagName("fullname").item(0).childNodes[0].nodeValue;
			id = root.getElementsByTagName("id").item(0).childNodes[0].nodeValue;
      document.getElementById(id).value = str;

	   	setResponseMsg(reqAjax.readyState, reqAjax.status);
		} else {
	   	setResponseMsg(reqAjax.readyState, reqAjax.status);
    }
  } else {
//   	setResponseMsg(reqAjax.readyState, reqAjax.status);
  }
}
function handleResponseS(){
  if(reqAjax.readyState == 4){
		if(reqAjax.status == 200){
			root = reqAjax.responseText;
//			alert(root);
	   	setResponseMsg(reqAjax.readyState, reqAjax.status);
		} else {
	   	setResponseMsg(reqAjax.readyState, reqAjax.status);
    }
  } else {
//   	setResponseMsg(reqAjax.readyState, reqAjax.status);
  }
}
function handleResponseC(){
//setTrace("handleResponseC()" + reqAjax.readyState+","+reqAjax.status);
	var root;
	var ids, hds, gds;
	var col, colName;
	var tarTd;
	var i, j;
  if(reqAjax.readyState == 4){
		if(reqAjax.status == 200){
			root = reqAjax.responseXML.documentElement;
//	alert(reqAjax.responseText);
			ids = root.getElementsByTagName("volId");
			hds = root.getElementsByTagName("holiday");
			gds = root.getElementsByTagName("getDate");
			col = root.getElementsByTagName("col");
			colName = col.item(0).childNodes[0].nodeValue;
			//DB既存IDのマークを日付に付加
			if (colName.indexOf("ID") >= 0) {
				for (i = 0; i < ids.length; i++) {
					id = ids.item(i).childNodes[0].nodeValue;
					tarTd = document.getElementById("tdD" + id);
					if (tarTd != null) {
						/*
						tarTd.style.fontSize = "90%";
						*/
						tarTd.style.fontStyle = "italic";
						tarTd.style.textDecoration = "line-through";
					}
				}
			}
			//休日なら当該tdの枠線を赤にする
			for (i = 0; i < hds.length; i++) {
				id = hds.item(i).childNodes[0].nodeValue;
				tarTd = document.getElementById("tdD" + id);
				if (tarTd != null) {
					if ((tarTd.className != "cellToday") &&
					    (tarTd.className != "cellHit") &&
					    (tarTd.className != "cellOutMonth")) {
//						tarTd.class = "cellTdSun";
						tarTd.style.backgroundColor = "mistyrose";
					}
					tarTd.style.borderColor = "red";
				}
			}
			//取得日当該tdの背景色変更
			if (colName.indexOf("Keyword") >= 0) {
				for (i = 0; i < gds.length; i++) {
					id = gds.item(i).childNodes[0].nodeValue;
					tarTd = document.getElementById("tdD" + id);
					if (tarTd != null) {
//						tarTd.style.backgroundColor = "cyan";
						tarTd.style.textDecoration = "overline underline";
					}
				}
			}
	   	setResponseMsg(reqAjax.readyState, reqAjax.status);
		} else {
	   	setResponseMsg(reqAjax.readyState, reqAjax.status);
    }
  } else {
//   	setResponseMsg(reqAjax.readyState, reqAjax.status);
  }
}


function httpRequest(reqType, uri, asynch, respHandle) {
//setTrace("httpRequest(" + reqType+","+uri+","+asynch+","+respHandle+")");
/*	XMLHttpRequestを生成する。
			reqType: "POST", "GET"
			uri: リクエスト先
			asynch: 同期，非同期
			respHandle: レスポンスを処理する関数
			argument[4]: （存在すれば）POSTする文字列
		生成に失敗したら false を返す。以外true。
*/
	if (window.XMLHttpRequest) {
		//Mozilla系
		reqAjax = new XMLHttpRequest();
	} else if (window.ActiveXObject) {
		//IE系１
		reqAjax = new ActiveXObject("Msxml2.XMLHTTP");
		if (! reqAjax) {
			//IE系２
			reqAjax = new ActiveXObject("Microsoft.XMLHTTP");
		}
	}

	if (reqAjax) {
		//requestオブジェクトをセットアップ
		if (reqType.toLowerCase() == "post") {
			var args = arguments[4];
			if (args != null && args.length > 0) {
				initReq(reqType, uri, asynch, respHandle, args);
			} else {
				alert("makeRequest; no POST argument4.");
			}
		} else {
			initReq(reqType, uri, asynch, respHandle);
		}
	} else {
			alert("no XMLHttpRequest!");
	}
}
function initReq(reqType, uri, bool, respHandle) {
//setTrace("initReq(" + reqType+","+uri+","+bool+","+respHandle+")");
//生成済みrequestをセットアップする。
	try {
		reqAjax.onreadystatechange = respHandle;
		reqAjax.open(reqType, uri, bool);
		if (reqType.toLowerCase() == "post") {
			reqAjax.setRequestHeader("Content-Type",
				"application/x-www-form-urlencoded; charset=UTF-8");
	//		alert(reqType + "," + uri + "," + bool + "," + respHandle);
			reqAjax.send(arguments[4]);
		} else {
			reqAjax.send(null);
		}
	} catch (errv) {
		alert("intReq Error!\n\n" + errv.message);
	}
}

function setResponseMsg(state, status){
	var statLine = document.getElementById("AjaxState");
	if (statLine != null) {
	  if(state == 4){
			if(status == 200){
	  	 	statLine.innerHTML = "";
			} else {
			   	statLine.innerHTML = "<font color='red'>Ajax失敗！</font>";
			   	statLine.innerHTML += "<br />readyState: " + state;
		  	 	statLine.innerHTML += "<br />status: " + status;
	    }
  	} else {
  		statLine.innerHTML = "<font color='blue'>Ajax通信中...</font>";
  	}
  }
}

function checkParam(str) {
/*
	被ふりがな文字列中のNG文字を全角化
	（結局は振り仮名がつかない）
*/
	var ngLetter = ["&", "?", "[", "]"];
	var rpLetter = ["＆", "？", "［", "］"];
	var i;
	var rtn = str;
	
	for (i = 0; i < ngLetter.length; i++) {
		while (rtn.indexOf(ngLetter[i]) >= 0) {
			rtn = rtn.replace(ngLetter[i], rpLetter[i]);
		}
	}
	return rtn;
}

function concatHurigana(id) {
/*
かな・かな以外に分けた入力欄の文字列を連結して
ふりがな欄へセット。
		被ふりがなIDが"xxx"のとき，ふりがなIDが"xxxSort"であること。
		ふりがなをかな・かな以外に分けたtableを入れたdivが"xxxSortWork"であること。
		かな・かな以外に分けた各inputのIDが"xxxSortWorkn"であること。
*/
	var tarInp = document.getElementById(id);
	var refInp, refKana;
	var arrInp = [];
	var arrKana = [];
	var hit = true;
	var i;
	var j = 0;
	tarInp.value = "";
	for (i = 0; i < 255; i++) {
		refInp = document.getElementById(id + "Work" + i);
		refKana = document.getElementById(id + "WorkKana" + i);
		if (refInp == null) {
			break;
		} else {
			tarInp.value += refKana.value;
			if (refInp.value < "あ" || refInp.value > "ん") {
				if (refKana.value != "") {
					arrInp[j] = refInp.value;
					arrKana[j] = refKana.value;
					j++
				}
			}
		}
	}
	storeKana(arrInp, arrKana);
}
function setPartsKana(id, i) {
/*
ドロップダウンリストで選択された振りがなを入力欄にセットする。
*/
	var refSel = document.getElementById("sel" + id + i);
	var tarKana = document.getElementById(id + "WorkKana" + i);
	tarKana.value = refSel[refSel.selectedIndex].value;
}