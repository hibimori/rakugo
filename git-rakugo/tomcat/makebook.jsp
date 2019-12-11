<%@ page buffer="128kb" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,java.text.*" %>
<!--
	2019-12-11 明細部［採用］にstoreSin追加
	2019-08-25 消費税10％対応
	-->
<jsp:useBean id="bkS" class="jp.rakugo.nii.BookTableSelect" scope="page" />
<jsp:useBean id="bkU" class="jp.rakugo.nii.BookTableUpdate" scope="page" />
<jsp:useBean id="bwU" class="jp.rakugo.nii.BookWorkTableUpdate" scope="page" />
<jsp:useBean id="tmS" class="jp.rakugo.nii.TitleMasterSelect" scope="page" />
<jsp:useBean id="pmS" class="jp.rakugo.nii.PlayerMasterSelect" scope="page" />
<jsp:useBean id="cmF" class="jp.rakugo.nii.CommonForm" scope="page" />
<jsp:useBean id="cmR" class="jp.rakugo.nii.CommonRakugo" scope="page" />
<html lang="ja">
<head>
<title>書籍DB管理</title>
<link rel="stylesheet" type="text/css" href="makerakugo.css">
<script language="JavaScript" src="assistinput.js"></script>
<script language="JavaScript" src="assistinput_mb.js"></script>
<script language="JavaScript" src="openwindow_b.js"></script>
<script language="JavaScript" src="inpcalendar.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
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
	if (strMsg != "") {								//更新系は確認Dialogを出す。
		if (confirm(strMsg) == true) {
			//［削除］なら入力チェックを無視して何でも消せる。
			if (strMsg.indexOf("Delete") < 0) {
				//IDの入力チェック
				if ((document.formBook.inpID.value.length != 6   ) ||
				    (isNaN(document.formBook.inpID.value) == true)) {
					alert("ID is wrong.");
					goFlg = false;
				}
				//Seqの入力チェック
				while (document.formBook.inpSeq.value.length < 3) {
					document.formBook.inpSeq.value = "0" + document.formBook.inpSeq.value;
				}
				if ((isNaN(document.formBook.inpSeq.value) == true ) ||
		//		    (document.formBook.inpSeq.value        == "000") ||
				    (document.formBook.inpSeq.value        >  "999")) {
					alert("Seq is wrong.");
					goFlg = false;
				}
			}
		} else {
			goFlg = false;
		}
	}
	if (goFlg == true) {
		document.formBook.formBtnType.value = tarType;
		document.formBook.method = "post";
		document.formBook.action = "makebook.jsp";
		document.formBook.submit();
	}
}
// -->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<%
	//キャラクタ_セット宣言
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
//				case '&':
//					stB.append("&amp;");
//					break;
				case '"':
					stB.append("&quot;");
					break;
				case '―':
					stB.append("&mdash;");
					break;
				case '\n':
					stB.append("<br />");
					break;
				case '\r':
					stB.append("");
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
<%!
	//いろいろフォーマット宣言
	SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat dateFmtE = new SimpleDateFormat("yyyy.M/d(E) H:mm:ss");
	SimpleDateFormat dateFmtS = new SimpleDateFormat("yy.M/d(E)");
	SimpleDateFormat dateFmtID = new SimpleDateFormat("yyMMdd");
	DecimalFormat decFmt1p2 = new DecimalFormat("0.00");
	DecimalFormat decFmt2 = new DecimalFormat("00");
	DecimalFormat decFmt3 = new DecimalFormat("000");
	DecimalFormat decFmt6 = new DecimalFormat("000000");
	DateFormat datePs = DateFormat.getDateInstance();

	String sch_id;
	String break_id = "";	/* Break用ID退避エリア */
	String sch_seq;
	String sch_title;
	String sch_titleSeq;
	String sch_titleSeqC;
	String sch_titleSort;
	String sch_player1ID;
	String sch_player1;
	String sch_player2ID;
	String sch_player2;
	String sch_player3ID;
	String sch_player3;
	String sch_player1Sin;
	String sch_player2Sin;
	String sch_player3Sin;
	String sch_player4;
	String sch_sourceID;
	String sch_source;
	String sch_isbn;
	String sch_getDate;
	String sch_getDateC;
	String sch_getYet;
	String sch_urlA;
	String sch_imgA;
	String sch_urlB;
	String sch_imgB;
	String sch_urlC;
	String sch_imgC;
	String sch_urlE;
	String sch_imgE;
	String sch_imgS;
	String sch_storeS;
	String sch_media;
	String sch_cur;
	String sch_price;
	String sch_priceZ = "";
	String sch_priceZ10 = "";
	String sch_memo;
	String sch_modDate = "";
%>
<%
/* 本日日付を生成 */
	Calendar parToday = Calendar.getInstance();
	String nowDate = dateFmt.format(parToday.getTime());

	String sch_comName = cmR.getComputerName(request.getRequestURL().toString());
/* Formの検索条件を退避 */
	sch_id = cmR.convertNullToString(request.getParameter("inpID"));	/* ID */
	break_id = "";												/* Break用ID退避エリア */
	sch_seq = cmR.convertNullToString(request.getParameter("inpSeq"));			/* SEQ */
	sch_title = cmR.convertNullToString(request.getParameter("inpTitle"));	/* 書名 */
	sch_titleSeq = cmR.convertNullToString(request.getParameter("inpTitleSeq"));			/* タイトルの連番 */
	sch_titleSeqC = cmR.convertNullToString(request.getParameter("chkTitleSeq"));			/* Chkタイトル連番 */
	sch_titleSort = cmR.convertNullToString(request.getParameter("inpTitleSort"));	/* 書名かな */
	sch_player1ID = cmR.convertNullToString(request.getParameter("inpP1ID"));			/* 著者１ID */
	sch_player1 = cmR.convertNullToString(request.getParameter("inpP1"));			/* 著者１ */
	sch_player2ID = cmR.convertNullToString(request.getParameter("inpP2ID"));			/* 著者２ID */
	sch_player2 = cmR.convertNullToString(request.getParameter("inpP2"));			/* 著者２ */
	sch_player3ID = cmR.convertNullToString(request.getParameter("inpP3ID"));			/* 著者３ID */
	sch_player3 = cmR.convertNullToString(request.getParameter("inpP3"));			/* 著者３ */
	sch_player1Sin = cmR.convertNullToString(request.getParameter("selP1"));	/* 著者１役割 */
	sch_player2Sin = cmR.convertNullToString(request.getParameter("selP2"));	/* 著者２役割 */
	sch_player3Sin = cmR.convertNullToString(request.getParameter("selP3"));	/* 著者３役割 */
	sch_player4 = cmR.convertNullToString(request.getParameter("chkP4"));			/* 著者ほかチェック */
	if (!(sch_player4.equals("1"))) { sch_player4 = "0"; }
	sch_sourceID = cmR.convertNullToString(request.getParameter("inpSourceID"));		/* 出版社ID */
	sch_source = cmR.convertNullToString(request.getParameter("inpSource"));				/* 出版社名 */
	sch_isbn = cmR.convertNullToString(request.getParameter("inpISBN"));				/* ISBN */
	sch_getDate = cmR.convertNullToString(request.getParameter("inpGetDate"));		/* 購入日 */
	sch_getDateC = cmR.convertNullToString(request.getParameter("chkGetDate"));	/* Chk購入日 */
	if (sch_getDateC.equals("")) {
		sch_getDateC = "0";
	}
	if (sch_getDateC.equals("0")) {
		sch_getDate = "";
	}
	sch_getYet = cmR.convertNullToString(request.getParameter("chkGetYet"));	/* 未購入サイン */
	if (sch_getYet.equals("")) {
		sch_getYet = "0";
	}
	sch_cur = cmR.convertNullToString(request.getParameter("selCurrency"));			/* 通貨 */
	sch_price = cmR.convertNullToString(request.getParameter("inpPrice"));			/* 購入額 */
	if ((sch_cur.equals("EUR")) ||
	    (sch_cur.equals("USD"))    ) {
	    try {
	    	sch_price = decFmt1p2.format(Float.parseFloat(
					cmR.convertNullToString(request.getParameter("inpPrice"))));
        } catch(Exception e) {
	    	sch_price = "";
	    }
	}

	sch_urlA = cmR.convertNullToString(request.getParameter("inpURLA"));			/* amazon URL */
	sch_imgA = cmR.convertNullToString(request.getParameter("inpImgA"));			/* amazon Img */
	sch_urlB = cmR.convertNullToString(request.getParameter("inpURLB"));			/* bk1    URL */
	sch_imgB = cmR.convertNullToString(request.getParameter("inpImgB"));			/* bk1    Img */
	sch_urlC = cmR.convertNullToString(request.getParameter("inpURLC"));			/* その他 URL */
	sch_imgC = cmR.convertNullToString(request.getParameter("inpImgC"));			/* その他 Img */
	sch_urlE = cmR.convertNullToString(request.getParameter("inpURLE"));			/* 電子本 URL */
	sch_imgE = cmR.convertNullToString(request.getParameter("inpImgE"));			/* 電子本 Img */
	sch_imgS = cmR.convertNullToString(request.getParameter("selImg"));				/* 書影セレクタ */
	sch_storeS = cmR.convertNullToString(request.getParameter("selStore"));				/* 書店セレクタ */
	sch_media = cmR.convertNullToString(request.getParameter("selAttMed"));				/* 媒体セレクタ */
	sch_memo = cmR.convertNullToString(request.getParameter("inpMemo"));			/* メモ */
	sch_modDate = "";											/* 更新日 */

String sch_btn = cmR.convertNullToString(request.getParameter("formBtnType"));		/* 押下ボタン種 */
String parKeyword = cmR.convertNullToString(request.getParameter("inpKeyword"));	/* 文字列検索Word */
String parKeywordM = cmR.convertNullToString(request.getParameter("selKeyword"));		/* 文字列検索モード */
if (parKeywordM.length() == 0) { parKeywordM = "GE"; }
//ring parKeywordT = cmR.convertNullToString(request.getParameter("selKeywordT"));	/* 文字列検索種 */
//if (parKeywordT.equals("")) { parKeywordT = "T"; }
//文字列検索対象範囲
String parKeywordT = cmR.convertNullToString(request.getParameter("chkKeywordT"));
parKeywordT += cmR.convertNullToString(request.getParameter("chkKeywordP"));
parKeywordT += cmR.convertNullToString(request.getParameter("chkKeywordH"));
parKeywordT += cmR.convertNullToString(request.getParameter("chkKeywordD"));
if (parKeywordT.length() == 0) { parKeywordT = "T"; }
//    out.println(parKeywordT);
String parKeywordW = "";												/* where句ワークエリア */
StringBuffer sBfTitleBar = new StringBuffer("");    /* タイトルバー ワークエリア */
String strTitle = "BookDB: ";
String strCo[];		/* Combo要素選択用ワーク */

//ring parSelect = "select * from book_t";
String parDistinct = "DISTINCT vol_id,seq,title,title_seq,title_seq_sin,"
                   + "title_sort,author1_id,author2_id,author3_id,author1_sin,"
                   + "author2_sin,author3_sin,author4_sin,publish_id,isbn,"
                   + "price,cur_sin,url_a,img_a,url_b,"
                   + "img_b,url_c,img_c,url_e,img_e,"
                   + "img_sin,store_sin,media_sin,memo,get_date,"
                   + "get_date_flg,get_yet_flg,modify_date";
String parSelectW = "ORDER BY title_sort,title_seq DESC,vol_id,seq";

/* DB更新項目充足 */
//購入日の補正（"yyyy-MM-dd"に補完）
sch_getDate = cmR.fixDateFormat(sch_getDate);
if ((sch_getDateC.equals("1")) && (sch_getDate.equals(""))) {
	sch_getDate = nowDate;
}
int idx = 0;
int idx2 = 0;
int i;
%>
<%
//DB Bundle
	cmR.connectJdbc6();
//	Connection db = cmR.getJdbc();

/* Query組み立て */
	/* 初期画面または押下ボタン不明なら Dummy空読み */
	StringBuffer query = new StringBuffer();
	StringBuffer query2;			//名称取得用Query退避エリア
	StringBuffer query3;
//	StringBuffer query4;
	StringBuffer dbMsg = new StringBuffer();
	boolean useMainDB = true;	//book_t(true) or book_w(false)対象Flg
	/* [検索]ボタンで… */
	//ID単位の［検索］（そのSeqは全件）
	if (sch_btn.equals("btnID")) {
		query = new StringBuffer();
		if (sch_id.equals("")) {
			/* IDが空ならDummy検索(0件) */
			query.append("WHERE vol_id = 'dummy' ORDER BY vol_id, seq");
		} else {	/* 空ぢゃなきゃそのVolID全件 */
			query.append("WHERE vol_id = '").append(sch_id).append("'");
		}
	}
	//ID+Seqの［検索］（そのVolID内）
	if (sch_btn.equals("btnIDSeq")) {
		query = new StringBuffer();
		if (sch_id.equals("")) {
			//IDが空なら全VolID対象
			if (!(sch_seq.equals(""))) {
				//IDが空でSeqありならVolID全件のうちそのSeq検索
				query.append("WHERE seq = '").append(sch_seq).append("'");
			}
		} else {
			//IDが空ぢゃなきゃそのVolID検索
			query.append("WHERE vol_id = '").append(sch_id).append("'");
			if (!(sch_seq.equals(""))) {
				//Seqありなら完全一致検索
				query.append(" AND seq = '").append(sch_seq).append("'");
			}
		}
		query.append(" ORDER BY vol_id, seq");
	}
	//ID+Seqの検索
	if (sch_btn.equals("btnIDSeqFirst")) {
		query = new StringBuffer();
		if (sch_id.equals("")) {
			//IDが空なら１件目のVolIDのSeq１件目
			query.append("WHERE vol_id > '' AND seq > ''");
		} else {
			// 空ぢゃなきゃそのVolIDのSeq１件目
			query.append("WHERE vol_id = '").append(sch_id).append("'");
		}
		query.append(" ORDER BY vol_id, seq limit 0,1");	// Seqは１件目
	}
	/* [次検索]なら大なり検索 */
	//ID単位の検索（次のVolIDのSeq全件検索。後のrs.next()ループでVolIDブレイクしたら終わり）
	if (sch_btn.equals("btnIDNext")) {
		query = new StringBuffer();
		query.append("WHERE vol_id > '");
		query.append(sch_id).append("' ORDER BY vol_id, seq");
	}
	//ID+Seqの検索
	if (sch_btn.equals("btnIDSeqNext")) {
		query = new StringBuffer();
		if (sch_id.equals("")) {				// IDが空なら１件目のVolID検索
			query.append("WHERE vol_id > ''");
		} else {								// 空ぢゃなきゃそのVolID検索
			query.append("WHERE vol_id = '");
			query.append(sch_id).append("' AND seq > '").append(sch_seq).append("'");
		}
		query.append(" ORDER BY vol_id, seq LIMIT 0,1");	// Seqは１件目
	}
	/* [前検索]なら小なり検索して逆順ソートの１件目を採る */
	//ID単位の検索（小さいVolIDのSeq全件検索。後のrs.next()ループでVolIDブレイクしたら終わり）
	if (sch_btn.equals("btnIDPrev")) {
		query = new StringBuffer();
		if (sch_id.equals("")) {				// IDが空ならきょうのVolID検索
			query.append("WHERE vol_id <= '").append(dateFmtID.format(parToday.getTime()));
		} else {
			query.append("WHERE vol_id < '").append(sch_id);
		}
		query.append("' ORDER BY vol_id DESC, seq");
	}
	//ID+Seqの検索
	if (sch_btn.equals("btnIDSeqPrev")) {
		query = new StringBuffer();
		if (sch_id.equals("")) {				// IDが空なら最後のVolID検索
			query.append("WHERE vol_id <= '").append(dateFmtID.format(parToday.getTime()));
			query.append("' ORDER BY vol_id DESC, seq");
		} else {								// 空ぢゃなきゃそのVolID検索
			query.append("WHERE vol_id = '");
			query.append(sch_id).append("' AND seq < '").append(sch_seq).append("'");
			query.append(" ORDER BY vol_id, seq DESC LIMIT 0,1");	// Seqは１件目
		}
	}
%>
<%
    /* 文字列[検索]で検索 */
    if (sch_btn.equals("btnKeyword")) {
        query = new StringBuffer();
        if (parKeyword.length() == 0) {
            //検索文字列が""なら空振りするよう条件をEQに強制リセット
            parKeywordM = "EQ";
            parKeyword = "no keyword";
        }
        //検索文字列にLIKE用"%"を付加
        if (parKeywordM.equals("EQ")) {
            parKeywordW = escapeString(parKeyword);
        } else if (parKeywordM.equals("GE")) {
            parKeywordW = escapeString(parKeyword) + "%";
        } else {
            parKeywordW = "%" + escapeString(parKeyword) + "%";
        }
        sBfTitleBar.append(strTitle + parKeywordW);
        if (parKeywordT.indexOf("D") >= 0) {
            //購入日で検索
            if (parKeyword.length() == 0) {
                // 購入日が空なら本日付検索
                parKeyword = nowDate;
            }
            sBfTitleBar = new StringBuffer();
            sBfTitleBar.append(strTitle);
            Calendar calGetDate1 = Calendar.getInstance();
            Calendar calGetDate2 = Calendar.getInstance();
            if (parKeywordM.equals("EQ")) {
                query.append("WHERE get_date = '").append(parKeyword);
                sBfTitleBar.append(parKeyword);
            } else if (parKeywordM.equals("GE")) {
                try {
                    calGetDate1.set(Calendar.YEAR, Integer.parseInt(parKeyword.substring(0,4), 10));
                    calGetDate1.set(Calendar.MONTH, Integer.parseInt(parKeyword.substring(5,7), 10) - 1);
                    calGetDate1.set(Calendar.DATE, Integer.parseInt(parKeyword.substring(8,10), 10));
                    calGetDate2.set(Calendar.YEAR, Integer.parseInt(parKeyword.substring(0,4), 10));
                    calGetDate2.set(Calendar.MONTH, Integer.parseInt(parKeyword.substring(5,7), 10) - 1);
                    calGetDate2.set(Calendar.DATE, Integer.parseInt(parKeyword.substring(8,10), 10));
                    calGetDate2.add(Calendar.YEAR, +1);
                    parKeywordW = dateFmt.format(calGetDate1.getTime());
                    query.append("WHERE get_date >= '").append(parKeywordW);
                    sBfTitleBar.append(parKeyword);
                    parKeywordW = dateFmt.format(calGetDate2.getTime());
                    query.append("' AND get_date < '").append(parKeywordW);
                    sBfTitleBar.append(" < ").append(parKeywordW);
                } catch(Exception e) {
                    query.append("WHERE get_date = '").append(parKeyword);
                    sBfTitleBar.append(parKeyword);
                }
            } else {
                try {
                    calGetDate1.set(Calendar.YEAR, Integer.parseInt(parKeyword.substring(0,4), 10));
                    calGetDate1.set(Calendar.MONTH, 0);
                    calGetDate1.set(Calendar.DATE, 1);
                    calGetDate2.set(Calendar.YEAR, Integer.parseInt(parKeyword.substring(0,4), 10));
                    calGetDate2.set(Calendar.MONTH, 11);
                    calGetDate2.set(Calendar.DATE, 31);
                    parKeywordW = dateFmt.format(calGetDate1.getTime());
                    query.append("WHERE get_date >= '").append(parKeywordW);
                    sBfTitleBar.append(parKeywordW).append(" <= ").append(parKeyword);
                    parKeywordW = dateFmt.format(calGetDate2.getTime());
                    query.append("' AND get_date <= '").append(parKeywordW);
                    sBfTitleBar.append(" <= ").append(parKeywordW);
                } catch(Exception e) {
                    query.append("WHERE get_date = '").append(parKeyword);
                    sBfTitleBar.append(parKeyword);
                }
            }
            query.append("' ORDER BY title_sort, title_seq DESC, vol_id, seq");
        } else if (parKeywordT.equals("T")) {
            //書名のみの検索
            if (parKeywordM.equals("EQ")) {
                query.append("WHERE title = '").append(parKeywordW).append("'");
                query.append(" OR title_sort = '").append(parKeywordW).append("'");
            } else {
                query.append(" WHERE title LIKE '").append(parKeywordW).append("'");
                query.append(" OR title_sort LIKE '").append(parKeywordW).append("'");
            }
            query.append(" ORDER BY title_sort, title_seq DESC, vol_id, seq");
        } else {
            //書名・著者・出版者の複合検索
            //book_wを全件削除
            bwU.deleteRec("", -1);
            useMainDB = false;      //後段でワークTableを読ませる。
            //検索モードを検知
            String wKeyword = parKeywordT;
            String wkItem = "";
            String wkMode = "";
            query3 = new StringBuffer();
            for (int k = 0; k < 3; k++) {
//                  out.println(wKeyword);
                if (wKeyword.indexOf("T") >= 0) {
                    //タイトルでBookDB直読み
                    query3 = new StringBuffer();
                    if (parKeywordM.equals("EQ")) {
                        query3.append("WHERE title = '").append(parKeywordW).append("'");
                        query3.append(" OR title_sort = '").append(parKeywordW).append("'");
                    } else {
                        query3.append(" WHERE title LIKE '").append(parKeywordW).append("'");
                        query3.append(" OR title_sort LIKE '").append(parKeywordW).append("'");
                    }
                    wKeyword = wKeyword.replace("T", "");
                    idx = 1;
                    wkMode = "T";
                } else if (wKeyword.indexOf("P") >= 0) {
                    //演者名でPlayerマスタ読み
                    query = new StringBuffer();
                    if (parKeywordM.equals("EQ")) {
                        query.append("WHERE first_name = '").append(parKeywordW).append("'");
                        query.append(" OR last_name = '").append(parKeywordW).append("'");
                        query.append(" OR family_name = '").append(parKeywordW).append("'");
                        query.append(" OR full_name = '").append(parKeywordW).append("'");
                        query.append(" OR first_sort = '").append(parKeywordW).append("'");
                        query.append(" OR last_sort = '").append(parKeywordW).append("'");
                        query.append(" OR family_sort = '").append(parKeywordW).append("'");
                    } else {
                        query.append("WHERE first_name LIKE '").append(parKeywordW).append("'");
                        query.append(" OR last_name LIKE '").append(parKeywordW).append("'");
                        query.append(" OR family_name LIKE '").append(parKeywordW).append("'");
                        query.append(" OR full_name LIKE '").append(parKeywordW).append("'");
                        query.append(" OR first_sort LIKE '").append(parKeywordW).append("'");
                        query.append(" OR last_sort LIKE '").append(parKeywordW).append("'");
                        query.append(" OR family_sort LIKE '").append(parKeywordW).append("'");
                    }
                    wKeyword = wKeyword.replace("P", "");
                    pmS.selectDB(query.toString(), "");
                    idx = pmS.getResultCount();
                    wkMode = "P";
                } else if (wKeyword.indexOf("H") >= 0) {
                    //出版社でTitleマスタ読み
                    query = new StringBuffer();
                    if (parKeywordM.equals("EQ")) {
                        query.append("WHERE title = '").append(parKeywordW).append("'");
                        query.append(" OR subtitle = '").append(parKeywordW).append("'");
                        query.append(" OR title_sort = '").append(parKeywordW).append("'");
                        query.append(" OR subtitle_sort = '").append(parKeywordW).append("'");
                    } else {
                        query.append("WHERE title LIKE '").append(parKeywordW).append("'");
                        query.append(" OR subtitle LIKE '").append(parKeywordW).append("'");
                        query.append(" OR title_sort LIKE '").append(parKeywordW).append("'");
                        query.append(" OR subtitle_sort LIKE '").append(parKeywordW).append("'");
                    }
                    wKeyword = wKeyword.replace("H", "");
                    tmS.selectDB(query.toString(), "");
                    idx = tmS.getResultCount();
                    wkMode = "H";
                }
                for (int j = 0; j < idx; j++) {
                    if (wkMode.equals("T")) {
                        bkS.selectDB(query3.toString(), "");
                    } else if (wkMode.equals("P")) {
                        wkItem = pmS.getId(j);
                        query3 = new StringBuffer();
                        query3.append("WHERE author1_id = '").append(wkItem);
                        query3.append("' OR author2_id = '").append(wkItem);
                        query3.append("' OR author3_id = '").append(wkItem);
                        query3.append("'");
                        bkS.selectDB(query3.toString(), "");
                    } else if (wkMode.equals("H")) {
                        wkItem = tmS.getId(j);
                        query3 = new StringBuffer();
                        query3.append("WHERE publish_id = '").append(wkItem);
                        query3.append("'");
                        bkS.selectDB(query3.toString(), "");
                    }
                    for (i = 0; i < bkS.getResultCount(); i++) {
                        //book_t検索結果をbook_wに複写
                        bwU.initRec();	//book_w Rec編集エリアクリア
                        //book_tの項目待避
                        bwU.setVolId(bkS.getVolId(i));
                        try {
                            bwU.setSeq(bkS.getSeq(i));
                        } catch (Exception e) {
                            bwU.setSeq(0);
                        }
                        bwU.setTitle(bkS.getTitle(i));
                        try {
                            bwU.setTitleSeq(bkS.getTitleSeq(i));
                        } catch (Exception e) {
                            bwU.setTitleSeq(0);
                        }
                        bwU.setTitleSeqSin(bkS.getTitleSeqSin(i));
                        bwU.setTitleSort(bkS.getTitleSort(i));
                        bwU.setAuthor1Id(bkS.getAuthor1Id(i));
                        bwU.setAuthor2Id(bkS.getAuthor2Id(i));
                        bwU.setAuthor3Id(bkS.getAuthor3Id(i));
                        bwU.setAuthor1Sin(bkS.getAuthor1Sin(i));
                        bwU.setAuthor2Sin(bkS.getAuthor2Sin(i));
                        bwU.setAuthor3Sin(bkS.getAuthor3Sin(i));
                        bwU.setAuthor4Sin(bkS.getAuthor4Sin(i));
                        bwU.setPublishId(bkS.getPublishId(i));
                        bwU.setIsbn(bkS.getIsbn(i));
                        try {
                            bwU.setPrice(bkS.getPrice(i));
                        } catch (Exception e) {
                            bwU.setPrice(0);
                        }
                        bwU.setCurSin(bkS.getCurSin(i));
                        bwU.setUrlA(bkS.getUrlA(i));
                        bwU.setUrlB(bkS.getUrlB(i));
                        bwU.setUrlC(bkS.getUrlC(i));
                        bwU.setImgA(bkS.getImgA(i));
                        bwU.setImgB(bkS.getImgB(i));
                        bwU.setImgC(bkS.getImgC(i));
                        bwU.setUrlE(bkS.getUrlE(i));
                        bwU.setImgE(bkS.getImgE(i));
                        try {
                            bwU.setGetDate(bkS.getGetDate(i));
                        } catch (Exception e) {
                            bwU.setGetDate(null);
                        }
                        bwU.setGetDateFlg(bkS.getGetDateFlg(i));
                        bwU.setImgSin(bkS.getImgSin(i));
                        bwU.setStoreSin(bkS.getStoreSin(i));
                        bwU.setMediaSin(bkS.getMediaSin(i));
                        bwU.setMemo(escapeString(bkS.getMemo(i)));
                        bwU.setGetYetFlg(bkS.getGetYetFlg(i));
                        try {
                            bwU.setModifyDate(bkS.getModifyDate(i));
                        } catch (Exception e) {
                            bwU.setModifyDate(null);
                        }
                        //ワークTABLEに格納
                        bwU.insertRec();
                    }
                }
            }
            query =  new StringBuffer();
        }
    }
    //out.print(query.toString());
%>
<%
	/* [更新][追加]なら更新して再検索 */
	if ((sch_btn.equals("btnMod")) ||
	    (sch_btn.equals("btnAdd"))) {
	  try {
			bkU.initRec();	//book_t Rec編集エリアクリア
			bkU.setVolId(sch_id);
			bkU.setSeq(Integer.parseInt(sch_seq));
			bkU.setTitle(escapeString(sch_title));
			try {
				bkU.setTitleSeq(Integer.parseInt(sch_titleSeq));
			} catch (Exception e) {
				bkU.setTitleSeq(0);
			}
			bkU.setTitleSeqSin(sch_titleSeqC);
			bkU.setTitleSort(escapeString(sch_titleSort));
			bkU.setAuthor1Id(sch_player1ID);
			bkU.setAuthor2Id(sch_player2ID);
			bkU.setAuthor3Id(sch_player3ID);
			bkU.setAuthor1Sin(sch_player1Sin);
			bkU.setAuthor2Sin(sch_player2Sin);
			bkU.setAuthor3Sin(sch_player3Sin);
			bkU.setAuthor4Sin(sch_player4);
			bkU.setPublishId(sch_sourceID);
			bkU.setIsbn(sch_isbn);
			try {
				bkU.setPrice(Float.parseFloat(sch_price));
			} catch (Exception e) {
				bkU.setPrice(0);
			}
//			bkU.setCurSin(cmR.convertCurLetter(sch_cur, "$U"));
			bkU.setCurSin(sch_cur);
			bkU.setUrlA(escapeString(sch_urlA));
			bkU.setUrlB(escapeString(sch_urlB));
			bkU.setUrlC(escapeString(sch_urlC));
			bkU.setImgA(escapeString(sch_imgA));
			bkU.setImgB(escapeString(sch_imgB));
			bkU.setImgC(escapeString(sch_imgC));
			bkU.setUrlE(escapeString(sch_urlE));
			bkU.setImgE(escapeString(sch_imgE));
			try {
				sch_getDate = cmR.fixDateFormat(sch_getDate);
				sch_getDate = sch_getDate.replace("-", "/");	//parseの書式に変換
				bkU.setGetDate(datePs.parse(sch_getDate));
			} catch (Exception e) {
				bkU.setGetDate(datePs.parse("0000/00/00"));
			}
			bkU.setGetDateFlg(sch_getDateC);
			bkU.setImgSin(sch_imgS);
			bkU.setStoreSin(sch_storeS);
			bkU.setMediaSin(sch_media);
			bkU.setMemo(escapeString(sch_memo));
			bkU.setGetYetFlg(sch_getYet);

			if (sch_btn.equals("btnAdd")) {
				if (bkU.insertRec() < 1) {
					dbMsg.append("Insert Error!");
				}
			} else {
				if (bkU.updateRec() < 1) {
					dbMsg.append("Update Error!");
				}
			}
		} catch (Exception e) {
			dbMsg.append("Insert/Update Parameter Error!");
		}
	  query = new StringBuffer();
	  query.append("WHERE vol_id = '");
	  query.append(sch_id).append("' AND seq = '").append(sch_seq).append("'");
	}
	/* [削除]なら更新して再検索 */
	if (sch_btn.equals("btnDel")) {
		try {
			if (bkU.deleteRec(sch_id, Integer.parseInt(sch_seq)) < 1) {
				dbMsg.append("Delete Error!");
			}
		} catch (Exception e) {
			dbMsg.append("Delete Parameter Error!");
		}
	  query = new StringBuffer();
	  query.append("WHERE vol_id = '");
	  query.append(sch_id).append("' AND seq = '").append(sch_seq).append("'");
	}
	//もしqueryが空ならシス日以下で読む（≓最新）。
	if (query.toString().length() == 0) {
		query = new StringBuffer();
		query.append("WHERE vol_id = 'Dummy'");
	}

%>
<%
	/* DBを読む */
	if (useMainDB == true) {
		//book_t 条件よみ
		bkS.selectDB(query.toString(), "");
//		bkS.selectWK(parSelectW, parDistinct);
	} else {
		//book_w 全件よみ
		bkS.selectWK(parSelectW, parDistinct);
	}
%>
<%
	//ヘッダ用に１件だけ抽出
	try {
	if (bkS.getResultCount() > 0) {
		//項目待避
		sch_id = bkS.getVolId(0);
		break_id = sch_id;							// Break用にID退避
		try {
			sch_seq = decFmt3.format(bkS.getSeq(0));
		} catch (Exception e) {
			sch_seq = "000";
		}
		sch_title = bkS.getTitle(0);
		try {
			sch_titleSeq = decFmt3.format(bkS.getTitleSeq(0));
			if (sch_titleSeq.equals("000")) { sch_titleSeq = ""; }
		} catch (Exception e) {
			sch_titleSeq = "";
		}
		sch_titleSeqC = bkS.getTitleSeqSin(0);
		sch_titleSort = bkS.getTitleSort(0);
		sch_player1ID = bkS.getAuthor1Id(0);
		sch_player2ID = bkS.getAuthor2Id(0);
		sch_player3ID = bkS.getAuthor3Id(0);
		sch_player1Sin = bkS.getAuthor1Sin(0);
		sch_player2Sin = bkS.getAuthor2Sin(0);
		sch_player3Sin = bkS.getAuthor3Sin(0);
		sch_player4 = bkS.getAuthor4Sin(0);
		sch_isbn = bkS.getIsbn(0);
//		sch_cur = cmR.convertCurLetter(bkS.getCurSin(0), "U$");
		sch_cur = bkS.getCurSin(0);
		if (sch_cur.length() == 0) {
			sch_price = "";
			sch_priceZ = "";
			sch_priceZ10 = "";
		} else {
			try {
				sch_price = cmR.fixCurFormat(bkS.getPrice(0), sch_cur);
				sch_priceZ = cmR.fixCurFormat((float)(bkS.getPrice(0) * 1.08), sch_cur);
				sch_priceZ10 = cmR.fixCurFormat((float)(bkS.getPrice(0) * 1.10), sch_cur);
			} catch (Exception e) {
				sch_price = "exp";
                sch_priceZ = "";
				sch_priceZ10 = "";
			}
		}
		sch_sourceID = bkS.getPublishId(0);
		sch_getDateC = bkS.getGetDateFlg(0);
		if (sch_getDateC.equals("1")) {
			try {
				sch_getDate = dateFmt.format(bkS.getGetDate(0));
			} catch (Exception e) {
				sch_getDate = "";
				sch_getDateC = "0";
			}
		} else {
			sch_getDate = "";
			sch_getDateC = "0";
		}
		sch_getYet = bkS.getGetYetFlg(0);
		if (sch_getYet.equals("")) {
			sch_getYet = "0";
		}
		sch_urlA = bkS.getUrlA(0);
		sch_urlB = bkS.getUrlB(0);
		sch_urlC = bkS.getUrlC(0);
		sch_imgA = bkS.getImgA(0);
		sch_imgB = bkS.getImgB(0);
		sch_imgC = bkS.getImgC(0);
		sch_urlE = bkS.getUrlE(0);
		sch_imgE = bkS.getImgE(0);
		sch_imgS = bkS.getImgSin(0);
		sch_storeS = bkS.getStoreSin(0);
		sch_media = bkS.getMediaSin(0);
		sch_memo = bkS.getMemo(0);
		try {
			sch_modDate = dateFmtE.format(bkS.getModifyDate(0));
		} catch (Exception e) {
			sch_modDate = "";
		}
		//ID+Seq の検索なら明細部にID下全件を表示するため query リセット。
		if (sch_btn.indexOf("IDSeq") >= 0) {
			query = new StringBuffer();
			query.append("WHERE vol_id = '").append(sch_id).append("'");
		}
	}
	if (sBfTitleBar.toString().equals("")) {
		sBfTitleBar.append(strTitle).append(sch_id);
		if (sch_btn.indexOf("Seq") >= 0) {
			sBfTitleBar.append("/").append(sch_seq);
		}
	}
	} catch (Exception e) {
		//		alert("bkS.getResultCount() is null");
		//out.println("bkS.getResultCount() is null");
	}
%>
<form name="formBook">
<table border="0" width="100%">
	<tr><td width="50%">
		<h2>BookDB管理</h2>
	</td>
	<td align="center" id="AjaxState">
	</td>
	<td>
		<input align="right" name="outRow" type="text" readonly>
	</td>
	<td align="right">
		<%= sch_comName %>
	</td>
	</tr>
</table>
<div id="divDebug"></div>
<hr>
<div id="divCalendar" class="div1"></div>
<table border="1" id="tblId">
<!-- VolID制御列 -->
	<tr align="center" valign="middle">
		<th bgcolor="#cccccc" width="80" id="thBkID">
			<input type="button" onclick="javascript:openCalendarWindow('BkID')"
				name="btnID" value="VolumeID">
		</th>
		<td>
			<input size="7" type="text" maxlength="6"
 				id="inpBkID"
				name="inpID" value="<%= sch_id %>"></td>
		<td>
			<input type="button" name="btnIDEqual" onclick="javascript:sendQuery('btnID')"
				value="検索">
		</td>
		<td>
			<input type="button" name="btnIDPrev" onclick="javascript:sendQuery('btnIDPrev')"
				value="前">
		</td>
		<td>
			<input type="button" name="btnIDNext" onclick="javascript:sendQuery('btnIDNext')"
				value="次">
		</td>
		<th bgcolor="#cccccc" rowspan="2">検<br>索</th>
		<!--td bgcolor="#cccccc">書名/姓</td-->
		<td align="left">
			<input size="40" type="text" maxlength="255"
				id="inpBkKeyword"
				name="inpKeyword" value="<%= parKeyword %>">
		</td>
		<td>
		<%
			out.println(cmF.makeSelectOption("selKeyword", "selKeyword", parKeywordM));
		%>
		</td>
		<td>
			<input type="button" name="btnKeyword"
				onclick="javascript: sendQuery('btnKeyword')" value="検索">
		</td>
	</tr>
<!-- VolSeq制御列 -->
	<tr align="center" valign="middle">
		<th bgcolor="#cccccc">SEQ</th>
		<td class="fontSmall">
			<a href="javascript: addSeq(-1,'id')">▽</a>
			<input size="4" type="text" maxlength="3" name="inpSeq" value="<%= sch_seq %>">
			<a href="javascript: addSeq(1,'id')">△</a>
		</td>
		<td>
			<input type="button" name="btnIDSeq"
				onclick="javascript:sendQuery('btnIDSeq')" value="検索">
		</td>
		<td>
			<input type="button" name="btnIDSeqPrev"
				onclick="javascript:sendQuery('btnIDSeqPrev')" value="前">
		</td>
		<td>
			<input type="button" name="btnIDSeqNext"
				onclick="javascript:sendQuery('btnIDSeqNext')" value="次">
		</td>
		<td class="fontSmall" id="thBkKeyword">
		<%
			strCo = new String[10];
			if (parKeywordT.indexOf("T") >= 0) { strCo[0] = "checked"; }
			if (parKeywordT.indexOf("P") >= 0) { strCo[1] = "checked"; }
			if (parKeywordT.indexOf("H") >= 0) { strCo[2] = "checked"; }
			if (parKeywordT.indexOf("D") >= 0) { strCo[3] = "checked"; }
//			out.print(parKeywordT);
		%>
			<input type="checkbox" name="chkKeywordT" value="T"
				 onclick="javascript:setChkKeyword('T');" <%= strCo[0] %> id="chkKeywordT">書名
			<input type="checkbox" name="chkKeywordP" value="P"
				 onclick="javascript:setChkKeyword('P');" <%= strCo[1] %> id="chkKeywordP">著者
			<input type="checkbox" name="chkKeywordH" value="H"
				 onclick="javascript:setChkKeyword('H');" <%= strCo[2] %> id="chkKeywordH">出版社
			<input type="checkbox" name="chkKeywordD" value="D"
                 onclick="javascript:setChkKeyword('D');" <%= strCo[3] %> id="chkKeywordD">購入日
		</td>
		<td align="center">
			<input type="button" onclick="javascript:openCalendarWindow('BkKeyword')"
				name="btnKeywordD" value="購入日">
		</td>
		<td>
			<input type="button" name="btnKeywordClear"
				onclick="javascript: clearInpData('Keyword')" value="クリア">
		</td>
    </tr>
</table>
<table border="1">
<!-- タイトル制御列 -->
	<tr>
		<th bgcolor="#cccccc" width="80">書名</th>
		<td>
			<input size="70" type="text" maxlength="255" name="inpTitle"
			 value="<%= sch_title  %>"
			 id='title' onblur="javascript: assistKana(this, 'bk')";>
		</td>
		<td align="center">
			<!-- input type="button" name="btnABSearch"
				onclick="javascript: openSearchWindow()"
				value="AB検索"	-->
			<input type="button" name="btnABSearch"
				onclick="javascript: searchAB()"
				value="AB検索">
		</td>
		<td align="center">
			<input type="button" name="btnTitleClear"
				onclick="javascript: clearInpData('Title')" value="クリア">
		</td>
	</tr>
<!-- 書名かな制御列 -->
	<tr>
		<%
			strCo[4] = "";
			if (sch_titleSeqC.equals("1")) { strCo[4] = "checked"; }
		%>
		<th bgcolor="#cccccc">書名かな</th>
		<td>
			<input size="63" type="text" maxlength="255" name="inpTitleSort"
			 value="<%= sch_titleSort %>"
			 id='titleSort' onblur="javascript: assistKana(this, 'bk')";>
			<input type="button" name="btnTitleSort" value="再"
				id="btnTitleSort" onclick="javascript: assistKana(this, 'xx')">
			<div id="titleSortWork"></div>
		</td>
		<td align="center" class="fontSmall">
			<a href="javascript: addSeq(-1,'title')">▽</a>
            <input size="4" type="text" maxlength="3" name="inpTitleSeq"
                id="titleSeq" value="<%= sch_titleSeq %>">
			<a href="javascript: addSeq(1,'title')">△</a>
			<input type="checkbox" name="chkTitleSeq" value="1" <%= strCo[4] %>>
		</td>
		<td align="center">
			<input type="button" name="btnTitleClear"
				onclick="javascript: clearInpData('TitleSort')" value="クリア">
		</td>
	</tr>
</table>
<table border="1">
<!-- 演者１制御列 -->
	<tr>
		<%
			//演者マスタDBから姓名１取得
			if (sch_player1ID.equals("")) {
				sch_player1 = "";
			} else {
				query2 = new StringBuffer();
				query2.append("WHERE id = '").append(sch_player1ID).append("'");
				pmS.selectDB(query2.toString(), "");	//JavaBeans
				if (pmS.getResultCount() > 0) {
					sch_player1 = pmS.getFullName(0);
				} else {
					sch_player1 = "";
				}
			}
		//演者マスタDBから姓名２取得
		if (sch_player2ID.equals("")) {
				sch_player2 = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_player2ID).append("'");
			pmS.selectDB(query2.toString(), "");	//JavaBeans
			if (pmS.getResultCount() > 0) {
				sch_player2 = pmS.getFullName(0);
			} else {
				sch_player2 = "";
			}
		}
		//演者マスタDBから姓名３取得
		if (sch_player3ID.equals("")) {
				sch_player3 = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_player3ID).append("'");
			pmS.selectDB(query2.toString(), "");	//JavaBeans
			if (pmS.getResultCount() > 0) {
				sch_player3 = pmS.getFullName(0);
			} else {
				sch_player3 = "";
			}
		}
		//ほか著者チェックの設定
		if (sch_player4.equals("1")) { strCo[5] = "checked"; }
		//未所有チェックの設定
		if (sch_getYet.equals("1")) {
			strCo[6] = "bgcolor='red'";
			strCo[7] = "checked";
		}
		%>
		<th bgcolor="#cccccc" width="80px">
			<input type="button" name="btnP1ID"
				onclick="javascript: openPlayerWindow('inpP1ID')" value="著者1">
		</th>
		<td>
			<input size="7" type="text" maxlength="6" name="inpP1ID"
				value="<%= sch_player1ID %>">
			<input size="24" type="text" name="inpP1"
				id="author1" value="<%= sch_player1 %>">
		<%
			out.println(cmF.makePlayerPart("selP1", "", sch_player1Sin));
		%>
		</td>
		<!--td align="center">
			<input type="button" name="btnP1Clear"
				onclick="javascript: clearInpData('P1')" value="クリア">
		</td-->
		<th bgcolor="#cccccc">
			<input type="button" name="btnP3ID"
				onclick="javascript: openPlayerWindow('inpP3ID')" value="著者3">
		</th>
		<td colspan="3">
			<input size="5" type="text" maxlength="6" name="inpP3ID"
				value="<%= sch_player3ID %>">
			<input size="15" type="text" name="inpP3"
				value="<%= sch_player3 %>">
		<%
			out.println(cmF.makePlayerPart("selP3", "", sch_player3Sin));
		%>
			他<input type="checkbox" name="chkP4" value="1" <%= strCo[5] %>>
			<!--input type="button" name="btnP3Clear"
				onclick="javascript: clearInpData('P3')" value="クリア"-->
		</td>
	</tr>
<!-- 演者２制御列 -->
	<tr>
		<th bgcolor="#cccccc">
			<input type="button" name="btnP2ID"
				onclick="javascript: openPlayerWindow('inpP2ID')" value="著者2">
		</th>
		<td>
			<input size="7" type="text" maxlength="6" name="inpP2ID"
				value="<%= sch_player2ID %>">
			<input size="24" type="text" name="inpP2"
				value="<%= sch_player2 %>">
		<%
			out.println(cmF.makePlayerPart("selP2", "", sch_player2Sin));
		%>
		</td>
		<!--td align="center">
			<input type="button" name="btnP2Clear"
				onclick="javascript: clearInpData('P2')" value="クリア">
		</td-->
		<%
			//購入日チェックの設定
			if (sch_getDateC.equals("1")) { strCo[8] = "checked"; }
		%>
		<th bgcolor="#cccccc" id="thGetDate">
			<input type="button" name="btnGetDate"
				onclick="javascript:openCalendarWindow('GetDate')" value="購入日">
		</th>
		<td>
			<input type="checkbox"
				id="chkGetDate"
				name="chkGetDate"
				onclick="javascript: clearInpData('getDate')" value="1" <%= strCo[8] %>>
			<input size="8" type="text" maxlength="10"
				id="inpGetDate"
				name="inpGetDate" value="<%= sch_getDate %>">
		</td>
		<td class="divCenter" style="background-color:skyblue;">
		<%
			//媒体セレクタの設定
			out.println(cmF.makeMedia("selAttMed", "", sch_media));
		%>
		</td>
		<td <%= strCo[6] %> class="divRight">未所有
			<input type="checkbox" name="chkGetYet" value="1" <%= strCo[7] %>>
		</td>
	</tr>
<!-- 出版社とISBN制御列 -->
	<tr>
		<%
		//タイトル_マスタDBから局名取得
			query2 = new StringBuffer();
			query2.append("WHERE id = '");
			query2.append(sch_sourceID).append("'");
			tmS.selectDB(query2.toString(), "");
			try {
				if (tmS.getResultCount() > 0) {
					sch_source = tmS.getTitle(0);
				} else {
					sch_source = "";
				}
			} catch (Exception e) {
				//out.println("tms.getResultCount() is null");
			}
		%>
		<th bgcolor="#cccccc">
			<input type="button" name="btnSourceID"
				onclick="javascript: openTitleWindow('inpSourceID')" value="出版社">
		</th>
		<td>
			<input size="7" type="text" maxlength="6" name="inpSourceID"
				value="<%= sch_sourceID %>">
			<input size="22" type="text" name="inpSource"
				value="<%= sch_source %>">
			<input type="button" name="btnSourceClear"
				onclick="javascript: clearInpData('Source')" value="クリア">
		</td>
		<th bgcolor="#cccccc">購入額</th>
		<td colspan="3">
			<!--
			<input size="2" type="text" maxlength="3" id="inpCur" class="divCenter"
				name="inpCur" value="<%= sch_cur %>">
			-->
		<%
			//通貨セレクタの設定
			out.println(cmF.makeCurrency("selCurrency", "", sch_cur));
		%>
			<input size="5" type="text" maxlength="16" class="divRight" id="inpPrice"
				name="inpPrice" value="<%= sch_price %>">
			<input type="button" name="btnPrice10"
				onclick="javascript: calInpData('price',1.1)" value="10%">
			<input size="5" type="text" class="divRight" id="barePrice10"
				name="barePrice10" value="<%= sch_priceZ10 %>" readonly>
			<input type="button" name="btnPrice8"
				onclick="javascript: calInpData('price',1.08)" value="8%">
			<input size="5" type="text" class="divRight" id="barePrice"
				name="barePrice" value="<%= sch_priceZ %>" readonly>
		</td>
	</tr>
</table>
<table border="1">
<!-- bk1URL制御列 -->
	<tr>
		<td colspan="4">
			<div id="divB" style="display:none;">
				<iframe id='ifrB' src=''>loading...</iframe>
			</div>
			<div id="divF" style="display:none;">
				<iframe id='ifrF' src=''>loading...</iframe>
			<!--
				<object id='objF' name='objF' data='' type='application/xml'></object>
			-->
			<input type="hidden" id="btnF" value="">
			</div>
		</td>
	</tr>
	<tr>
		<th bgcolor="#cccccc" rowspan="2" width="80">bk1</th>
		<td>
			<input size="84" type="text" name="inpURLB"
				id="urlB" value="<%= sch_urlB %>">
		</td>
		<td align="center">
			<input type="button" id="btnB"
				onclick="javascript: openIfr('bk1')" value="Open">
		</td>
		<td align="center" rowspan="2">
			<%
				if (sch_urlB.equals("")) {
					out.println("-");
				} else {
					out.println("<a href='" + sch_urlB + "' target='_blank'>");
					if (sch_imgB.equals("")) {
						out.println("□");
					} else {
						out.println("<img src='" + sch_imgB + "' height='40px' border='0' />");
					}
				}
			%>
		</td>
	</tr>
	<tr>
		<td>
			<input size="76" type="text" name="inpImgB" value="<%= sch_imgB %>">
			<input type="button" name="btnHmv" onclick="javascript: chgHmvImg();" value="HMV">
		</td>
		<td align="center">
			<input type="button" name="btnURLBClear"
				onclick="javascript: clearInpData('URLB')" value="クリア">
		</td>
	</tr>
<!-- amazonURL制御列 -->
	<tr>
		<td colspan="4">
			<div id="divA" style="display:none;">
				<iframe id='ifrA' src=''>loading...</iframe>
			</div>
		</td>
	</tr>
	<tr>
		<th bgcolor="#cccccc" rowspan="2" width="80">amazon</th>
		<td>
			<input size="68" type="text" name="inpURLA"
				id="urlA" value="<%= sch_urlA %>">
			<input size="14" type="text" maxlength="32" name="inpISBN"
				value="<%= sch_isbn %>">
		</td>
		<td align="center">
			<input type="button" id="btnA"
				onclick="javascript: openIfr('ama')" value="Open">
		</td>
		<td align="center" rowspan="2">
			<%
				if (sch_urlA.equals("")) {
					out.println("-");
				} else {
					out.println("<a href='" + sch_urlA + "' target='_blank'>");
					if (sch_imgA.equals("")) {
						out.println("□");
					} else {
						out.println("<img src='" + sch_imgA + "' height='40px' border='0' />");
					}
				}
			%>
		</td>
	</tr>
	<tr>
		<td>
			<input size="75" type="text" name="inpImgA" value="<%= sch_imgA %>">
			<input type="button" name="btnASIN" value="ASIN"
				onclick="javascript: putASIN();">
		</td>
		<td align="center">
			<input type="button" name="btnURLAClear"
				onclick="javascript: clearInpData('URLA')" value="クリア">
		</td>
	</tr>
<!-- 電子本URL制御列 -->
	<tr>
		<td colspan="4">
			<div id="divE" style="display:none;">
				<iframe id='ifrE' src=''>loading...</iframe>
			</div>
		</td>
	</tr>
	<tr>
		<th bgcolor="#cccccc" rowspan="2" width="80">eBook</th>
		<td>
			<input size="84" type="text" name="inpURLE"
				id="urlE" value="<%= sch_urlE %>">
		</td>
		<td align="center">
			<input type="button" id="btnE"
				onclick="javascript: openIfr('ebk')" value="Open">
		</td>
		<td align="center" rowspan="2">
			<%
				if (sch_urlE.equals("")) {
					out.println("-");
				} else {
					out.println("<a href='" + sch_urlE + "' target='_blank'>");
					if (sch_imgE.equals("")) {
						out.println("□");
					} else {
						out.println("<img src='" + sch_imgE + "' height='40px' border='0' />");
					}
				}
			%>
		</td>
	</tr>
	<tr>
		<td>
			<input size="69" type="text" name="inpImgE" value="<%= sch_imgE %>">
		<%
			//ストアセレクタの設定
			out.println(cmF.makeStore("selStore", "", sch_storeS));
		%>
		</td>
		<td align="center">
			<input type="button" name="btnURLEClear"
				onclick="javascript: clearInpData('URLE','1')" value="クリア">
		</td>
	</tr>
<!-- その他URL制御列 -->
	<tr>
		<td colspan="4">
			<div id="divC" style="display:none;">
				<iframe id='ifrC' src=''>loading...</iframe>
			</div>
		</td>
	</tr>
	<tr>
		<th bgcolor="#cccccc" rowspan="2" width="80">その他</th>
		<td>
			<input size="84" type="text" name="inpURLC"
				id="urlC" value="<%= sch_urlC %>">
		</td>
		<td align="center">
			<input type="button" id="btnC"
				onclick="javascript: openIfr('oth')" value="Open">
		</td>
		<td align="center" rowspan="2">
			<%
				if (sch_urlC.equals("")) {
					out.println("-");
				} else {
					out.println("<a href='" + sch_urlC + "' target='_blank'>");
					if (sch_imgC.equals("")) {
						out.println("□");
					} else {
						out.println("<img src='" + sch_imgC + "' height='40px' border='0' />");
					}
				}
			%>
		</td>
	</tr>
	<tr>
		<td>
			<input size="73" type="text" name="inpImgC" value="<%= sch_imgC %>">
		<%
			//書影セレクタの設定
			out.println(cmF.makeAssociate("selImg", "", sch_imgS));
		%>
		</td>
		<td align="center">
			<input type="button" name="btnURLCClear"
				onclick="javascript: clearInpData('URLC')" value="クリア">
		</td>
	</tr>
</table>
<table border="1">
<!-- Memo -->
	<tr>
		<th bgcolor="#cccccc" rowspan="2" width="80">Memo</th>
		<td colspan="5" rowspan="2">
			<textarea name="inpMemo" cols="72" rows="4"
				class="fontSmall"><%= sch_memo %></textarea>
		</td>
		<td align="center">
					<input type="button" name="btnMemo" value="クリア"
				onclick="javascript:clearInpData('memo')">
		</td>
<!--		<td align="left" colspan="4" rowspan="3">
			<textarea cols="48" name="inpMemo" rows="4">
				<%= sch_memo %>
			</textarea>
		</td>	-->
	</tr>
	<tr valign="middle">
		<!-- td colspan="5" class="fontSmall"><%= sch_memo %></td-->
		<td class="divRight"><%= sch_memo.length() %></td>
	</tr>
<!-- 更新日表示列 -->
	<tr>
		<th bgcolor="#cccccc">更新日</th>
		<td><%= sch_modDate %></td>
<!-- 操作ボタン制御列 -->
		<td align="center">
			<input type="Button"
				onclick="javascript:assistInpData(), sendQuery('btnMod')"
				name="btnModTitle" value="更新">
		</td>
		<td align="center">
			<input type="Button"
				onclick="javascript:assistInpData(), sendQuery('btnAdd')"
				name="btnModTitle" value="追加">
		</td>
		<td align="center">
			<input type="Button"
				onclick="javascript:sendQuery('btnDel')" name="btnModTitle" value="削除">
		</td>
		<td align="center">
			<input type="button" name="btnInsID"
				onclick="javascript:openViewWindow('<%= sch_id %>','<%= sch_seq %>')"
					value="書影")>
		</td>
		<td align="center">
			<input type="Button"
				onclick="javascript:copyInpData()" name="btnCpyTitle" value="複写">
		</td>
	</tr>
</table>
<input name="formBtnType" type="hidden" value="<%= sch_btn %>">
<input name="inpTitleBar" type="hidden" value="<%= sBfTitleBar.toString() %>">
</form>
<hr>
<form name="formList">
	<input name="inpModID" type="hidden" value="">
	<table border="0">
		<tr align="center" bgcolor="silver">
			<th></th>
			<th></th>
			<th></th>
			<th>書名</th>
			<th>出版社</th>
			<th colspan="4">URL/image</th>
			<th>採用/媒体</th>
			<th>購入日</th>
		</tr>
		<tr align="center" bgcolor="silver">
			<th>No.</th>
			<th>ID</th>
			<th>SEQ</th>
			<th>著者名</th>
			<th>ISBN</th>
			<th>bk1</th>
			<th>ama</th>
			<th>eBk</th>
			<th>oth</th>
			<th>購入額</th>
			<th>更新日</th>
		</tr>
<%
	int row = 0;
	String strLine1 = "bgcolor=white";
	String strLine2 = "bgcolor=lavender";
	String clsLine = "";
	/* 当該ID下のSeqを全件明細に表示するため読みなおす。 */
//	out.println("<br />"+ sch_btn + ","+ query.toString() + ","+ bkS.getResultCount());
	if (useMainDB == true) {
		//book_t 条件よみ
		bkS.selectDB(query.toString(), "");
	} else {
		//book_w 全件よみ
		bkS.selectWK(parSelectW, parDistinct);
	}
	try {
	for (i = 0; i < bkS.getResultCount(); i++) {
		row = row + 1;
		if (clsLine.equals(strLine1) == true) {
			clsLine = strLine2;
		} else {
			clsLine = strLine1;
		}
		sch_id = bkS.getVolId(i);
		try {
			sch_seq = decFmt3.format(bkS.getSeq(i));
		} catch (Exception e) {
			sch_seq = "000";
		}
		sch_title = bkS.getTitle(i);
		try {
			sch_titleSeq = String.valueOf(bkS.getTitleSeq(i));
			if (sch_titleSeq.equals("0")) { sch_titleSeq = ""; }
		} catch (Exception e) {
			sch_titleSeq = "";
		}
		sch_titleSeqC = bkS.getTitleSeqSin(i);
		sch_titleSort = bkS.getTitleSort(i);
		sch_player1ID = bkS.getAuthor1Id(i);
		sch_player2ID = bkS.getAuthor2Id(i);
		sch_player3ID = bkS.getAuthor3Id(i);
		sch_player1Sin = bkS.getAuthor1Sin(i);
		sch_player2Sin = bkS.getAuthor2Sin(i);
		sch_player3Sin = bkS.getAuthor3Sin(i);
		sch_player4 = bkS.getAuthor4Sin(i);
		sch_isbn = bkS.getIsbn(i);
		sch_cur = bkS.getCurSin(i);
//		sch_cur = cmR.convertCurLetter(bkS.getCurSin(i), "U$");
		if (sch_cur.length() == 0) {
			sch_price = "-";
			strCo[9] = "divCenter";
		} else {
			try {
				sch_price = sch_cur.concat(cmR.fixCurFormat(bkS.getPrice(i), sch_cur));
				strCo[9] = "divRight";
			} catch (Exception e) {
				sch_price = "-";
				strCo[9] = "divCenter";
			}
		}
		sch_sourceID = bkS.getPublishId(i);
		sch_getDateC = bkS.getGetDateFlg(i);
		if (sch_getDateC.equals("1")) {
			try {
				sch_getDate = dateFmtS.format(bkS.getGetDate(i));
			} catch (Exception e) {
				sch_getDate = "";
				sch_getDateC = "0";
			}
		} else {
			sch_getDate = "";
			sch_getDateC = "0";
		}
		sch_getYet = bkS.getGetYetFlg(i);
		if (sch_getYet.equals("")) {
			sch_getYet = "0";
		}
		sch_urlA = bkS.getUrlA(i);
		sch_urlB = bkS.getUrlB(i);
		sch_urlC = bkS.getUrlC(i);
		sch_imgA = bkS.getImgA(i);
		sch_imgB = bkS.getImgB(i);
		sch_imgC = bkS.getImgC(i);
		sch_urlE = bkS.getUrlE(i);
		sch_imgE = bkS.getImgE(i);
		sch_imgS = bkS.getImgSin(i);
		sch_storeS = bkS.getStoreSin(i);
		sch_media = bkS.getMediaSin(i);
		sch_memo = bkS.getMemo(i);
		try {
			sch_modDate = dateFmtS.format(bkS.getModifyDate(i));
		} catch (Exception e) {
			sch_modDate = "";
		}
		//URL付加
		sch_title = cmR.addUri(sch_title, sch_urlC);
		//タイトルマスタDBから出版社名取得
		if (sch_sourceID.equals("")) {
			sch_source = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_sourceID).append("'");
			tmS.selectDB(query2.toString(), "");
			if (tmS.getResultCount() > 0) {
				sch_source = tmS.getTitle(0);
				sch_source = cmR.addUri(sch_source, tmS.getUri(0));
			} else {
				sch_source = "";
			}
		}
		//Seq整形
		if (sch_titleSeqC.equals("1")) {
			sch_title = sch_title + "(" + sch_titleSeq + ")";
		}
		//演者マスタDBから姓名１取得
		if (sch_player1ID.equals("")) {
			sch_player1 = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_player1ID).append("'");
			pmS.selectDB(query2.toString(), "");	//JavaBeans
			if (pmS.getResultCount() > 0) {
				sch_player1 = pmS.getFullName(0);
				sch_player1 = cmR.addUri(sch_player1, pmS.getUri(0));
			} else {
				sch_player1 = "";
			}
		}
		//演者マスタDBから姓名２取得
		if (sch_player2ID.equals("")) {
			sch_player2 = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_player2ID).append("'");
			pmS.selectDB(query2.toString(), "");	//JavaBeans
			if (pmS.getResultCount() > 0) {
				sch_player2 = pmS.getFullName(0);
				sch_player2 = cmR.addUri(sch_player2, pmS.getUri(0));
			} else {
				sch_player2 = "";
			}
		}
		//演者マスタDBから姓名３取得
		if (sch_player3ID.equals("")) {
			sch_player3 = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_player3ID).append("'");
			pmS.selectDB(query2.toString(), "");	//JavaBeans
			if (pmS.getResultCount() > 0) {
				sch_player3 = pmS.getFullName(0);
				sch_player3 = cmR.addUri(sch_player3, pmS.getUri(0));
			} else {
				sch_player3 = "";
			}
		}
		//連名化
		sch_player1 = cmR.concatNames(
			sch_player1, cmF.getPlayerPart(sch_player1Sin),
			sch_player2, cmF.getPlayerPart(sch_player2Sin),
			sch_player3, cmF.getPlayerPart(sch_player3Sin),
			sch_player4, "・");
		//URL編集
		if (sch_urlA.equals("")) {
			if (sch_imgA.equals("")) {
				sch_urlA = "-";
			} else {
				sch_urlA = "<img alt='ama' border='0' height='48' src='";
				sch_urlA += sch_imgA + "'>";
			}
		} else {
			sch_urlA = "<a href='" + sch_urlA + "' target='_blank'>";
			if (sch_imgA.equals("")) {
				sch_urlA += "ama</a>";
			} else {
				sch_urlA += "<img alt='ama' border='0' height='48' src='";
				sch_urlA += sch_imgA + "'></a>";
			}
		}
		if (sch_urlB.equals("")) {
			if (sch_imgB.equals("")) {
				sch_urlB = "-";
			} else {
				sch_urlB = "<img alt='bk1' border='0' height='48' src='";
				sch_urlB += sch_imgB + "'>";
			}
		} else {
			sch_urlB = "<a href='" + sch_urlB + "' target='_blank'>";
			if (sch_imgB.equals("")) {
				sch_urlB += "bk1</a>";
			} else {
				sch_urlB += "<img alt='bk1' border='0' height='48' src='";
				sch_urlB += sch_imgB + "'></a>";
			}
		}
		if (sch_urlE.equals("")) {
			if (sch_imgE.equals("")) {
				sch_urlE = "-";
			} else {
				sch_urlE = "<img alt='eBook' border='0' height='48' src='";
				sch_urlE += sch_imgE + "'>";
			}
		} else {
			sch_urlE = "<a href='" + sch_urlE + "' target='_blank'>";
			if (sch_imgE.equals("")) {
				sch_urlE += "eBook</a>";
			} else {
				sch_urlE += "<img alt='eBook' border='0' height='48' src='";
				sch_urlE += sch_imgE + "'></a>";
			}
		}
		if (sch_urlC.equals("")) {
			if (sch_imgC.equals("")) {
				sch_urlC = "-";
			} else {
				sch_urlC = "<img alt='oth' border='0' height='48' src='";
				sch_urlC += sch_imgC + "'>";
			}
		} else {
			sch_urlC = "<a href='" + sch_urlC + "' target='_blank'>";
			if (sch_imgC.equals("")) {
				sch_urlC += "oth</a>";
			} else {
				sch_urlC += "<img alt='oth' border='0' height='48' src='";
				sch_urlC += sch_imgC + "'></a>";
			}
		}
		//媒体サイン取得
		try {
			sch_media = cmF.getMedia(sch_media);
			sch_storeS = cmF.getStore(sch_storeS);
		} catch (Exception e) {
			sch_media = "?";
			sch_storeS = "?";
		}
		if (sch_storeS.length() > 0) {
			sch_media = sch_storeS.concat("/").concat(sch_media);
		}
		if (sch_imgS.length() > 0) {
			sch_media = sch_imgS.concat("/").concat(sch_media);
		}
		//ID+Seqの［次検索］［先頭検索］でIDブレイクしたら終わり
		if ((sch_btn.equals("btnIDPrev"))  ||
			(sch_btn.equals("btnIDNext"))) {
			if (!(break_id.equals(sch_id))) {
				row = row - 1;
				break;
			}
		}
%>
		<tr <%= clsLine %>>
			<td align="right"><%= row %></td>
 			<td align="center"><%= sch_id %></td>
			<td align="center"><%= sch_seq %></td>
			<td><%= sch_title %></td>
			<td><%= sch_source %></td>
			<td align="center" rowspan="2" valign="center"><%= sch_urlB %></td>
			<td align="center" rowspan="2" valign="center"><%= sch_urlA %></td>
			<td align="center" rowspan="2" valign="center"><%= sch_urlE %></td>
			<td align="center" rowspan="2" valign="center"><%= sch_urlC %></td>
			<td align="center"><%= sch_media %></td>
			<td><%= sch_getDate %></td>
		</tr>
		<tr <%= clsLine %>>
			<td align="center">
				<input type="button" name="btnModID"
					onclick="javascript:openModWindow('<%= sch_id %>',
						'<%= sch_seq %>')" value="Edit")>
			</td>
			<td align="center">
				<input type="button" name="btnIDLine"
					onclick="javascript:openSelWindow('<%= sch_id %>',
						'<%= sch_seq %>')" value="Select")>
			</td>
			<td align="center">
				<input type="button" name="btnInsID"
					onclick="javascript:openViewWindow('<%= sch_id %>',
						'<%= sch_seq %>')" value="書影")>
			</td>
			<td><%= sch_player1 %></td>	<!--３名連結済み-->
			<td><%= sch_isbn %></td>
			<td class="<%= strCo[9] %>"><%= sch_price %></td>
		 	<td><%= sch_modDate %></td>
		</tr>
		<%
			if (!(sch_memo.equals(""))) {
				out.print("<tr valign='top'");
				out.print(clsLine);
				out.print("><td></td><th align='right'>memo:</th>");
				out.print("<td colspan='9' valign='top' class='fontSmall'>");
				out.print(sch_memo);
				out.print("</td></tr>");
			}
	}
	} catch (Exception e) {
		//out.println("bkS.getResultCount() is null");
	}
	cmR.closeJdbc();
%>
</table>
<br>
<%= row %>件
<div align="center">
<input type="button" name="btnClose" value="Close" onclick="javascript: window.close();">
</div>
</form>
<script language="JavaScript" type="text/javascript">
<!--
	document.title = document.formBook.inpTitleBar.value;
	document.formBook.outRow.value = <%= row %> + "件";
	if (<%= row %> == 0) {
		document.formBook.outRow.value = "no record!";
	}
	document.formBook.outRow.size = document.formBook.outRow.value.length + 1;
	if (document.formBook.inpID.value == "") {
		document.formBook.chkGetDate.checked = true;
	}
	if ("<%= dbMsg.toString() %>" != "") {
		document.getElementById("AjaxState").innerHTML =
			"<font color='red'>" + "<%= dbMsg.toString() %>" + "</font>";
	}
// -->
</script>
</body>
</html>