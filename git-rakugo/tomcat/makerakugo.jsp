<%@ page buffer="128kb" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	import="java.io.*,java.util.*,java.util.regex.*,java.sql.*,java.text.*" %>
<jsp:useBean id="rkS" class="jp.rakugo.nii.RakugoTableSelect" scope="page" />
<jsp:useBean id="rkU" class="jp.rakugo.nii.RakugoTableUpdate" scope="page" />
<jsp:useBean id="rwU" class="jp.rakugo.nii.RakugoWorkTableUpdate" scope="page" />
<jsp:useBean id="tmS" class="jp.rakugo.nii.TitleMasterSelect" scope="page" />
<jsp:useBean id="pmS" class="jp.rakugo.nii.PlayerMasterSelect" scope="page" />
<jsp:useBean id="cmF" class="jp.rakugo.nii.CommonForm" scope="page" />
<jsp:useBean id="cmR" class="jp.rakugo.nii.CommonRakugo" scope="page" />
<html lang="ja">
<head>
<title>落語DB管理</title>
<link rel="stylesheet" type="text/css" href="makerakugo.css">
<script language="JavaScript" src="assistinput.js"></script>
<script language="JavaScript" src="openwindow_r.js"></script>
<script language="JavaScript" src="assistinput_mr.js"></script>
<script language="JavaScript" src="inpcalendar.js"></script>
<script language="JavaScript" src="inpclock.js"></script>
<script language="JavaScript">
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
				if ((document.formRakugo.inpID.value.length != 6   ) ||
				    (isNaN(document.formRakugo.inpID.value) == true)) {
					alert("ID is wrong.");
					goFlg = false;
				}
				//Seqの入力チェック
				while (document.formRakugo.inpSeq.value.length < 3) {
					document.formRakugo.inpSeq.value = "0" + document.formRakugo.inpSeq.value;
				}
				if ((isNaN(document.formRakugo.inpSeq.value) == true ) ||
				    (document.formRakugo.inpSeq.value        == "000") ||
				    (document.formRakugo.inpSeq.value        >  "255")) {
					alert("Seq is wrong.");
					goFlg = false;
				}
			}
		} else {
			goFlg = false;
		}
	}
	if (goFlg == true) {
		document.formRakugo.formBtnType.value = tarType;
		document.formRakugo.method = "post";
		document.formRakugo.action = "makerakugo.jsp";
		document.formRakugo.submit();
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
				case '&':
					stB.append("&amp;");
					break;
				case '"':
					stB.append("&quot;");
					break;
				case '―':
					stB.append("&mdash;");
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
<%
	//いろいろフォーマット宣言
	SimpleDateFormat timeFmt = new SimpleDateFormat("HH:mm:ss");
	SimpleDateFormat timeFmt5 = new SimpleDateFormat("H:mm:ss");
	SimpleDateFormat timeFmtS = new SimpleDateFormat("H:mm");
	SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat dateFmtE = new SimpleDateFormat("yyyy.M/d(E) H:mm:ss");
	SimpleDateFormat dateFmtS = new SimpleDateFormat("yy.M/d(E)");
	SimpleDateFormat dateFmtID = new SimpleDateFormat("yyMMdd");
	DecimalFormat decFmt3 = new DecimalFormat("000");
	DecimalFormat decFmt2 = new DecimalFormat("00");
	DecimalFormat decFmt6 = new DecimalFormat("000000");
	DateFormat datePs = DateFormat.getDateInstance();
	DateFormat timePs = DateFormat.getTimeInstance();

//コンピュータ名取得
	String sch_comName = cmR.getComputerName(request.getRequestURL().toString());
/* Formの検索条件を退避 */
String sch_id = cmR.convertNullToString(request.getParameter("inpID"));							/* ID */
String break_id = "";																					/* Break用ID退避エリア */
String sch_seq = cmR.convertNullToString(request.getParameter("inpSeq"));							/* SEQ */
String sch_titleID = cmR.convertNullToString(request.getParameter("inpTitleID"));					/* タイトルID */
String sch_title = cmR.convertNullToString(request.getParameter("inpTitle"));					/* タイトル */
String sch_titleSeq = cmR.convertNullToString(request.getParameter("inpTitleSeq"));			/* タイトルの連番 */
String sch_strTitleSeqSin = cmR.convertNullToString(request.getParameter("chkStrTitleSeqSin"));			/* Seq文字の括弧有無 */
String sch_strTitleSeq = cmR.convertNullToString(request.getParameter("inpStrTitleSeq"));			/* Seq文字 */

String sch_subID = cmR.convertNullToString(request.getParameter("inpSubID"));				/* サブタイトルID */
String sch_sub = cmR.convertNullToString(request.getParameter("inpSub"));				/* サブタイトル */
String sch_player1ID = cmR.convertNullToString(request.getParameter("inpP1ID"));			/* プレイヤ１ID */
String sch_player1 = cmR.convertNullToString(request.getParameter("inpP1"));
String sch_player2ID = cmR.convertNullToString(request.getParameter("inpP2ID"));			/* プレイヤ２ID */
String sch_player2 = cmR.convertNullToString(request.getParameter("inpP2"));
String sch_player3ID = cmR.convertNullToString(request.getParameter("inpP3ID"));			/* プレイヤ３ID */
String sch_player3 = cmR.convertNullToString(request.getParameter("inpP3"));
String sch_player1Sin = cmR.convertNullToString(request.getParameter("selP1"));	/* 著者１役割 */
String sch_player2Sin = cmR.convertNullToString(request.getParameter("selP2"));	/* 著者２役割 */
String sch_player3Sin = cmR.convertNullToString(request.getParameter("selP3"));	/* 著者３役割 */
String sch_player4 = cmR.convertNullToString(request.getParameter("chkP4"));			/* プレイヤ４サイン */
if (!(sch_player4.equals("1"))) {
	sch_player4 = "0";
}
String sch_programID = cmR.convertNullToString(request.getParameter("inpProgramID"));			/* 番組ID */
String sch_program = cmR.convertNullToString(request.getParameter("inpProgram"));			/* 番組 */
String sch_sourceID = cmR.convertNullToString(request.getParameter("inpSourceID"));						/* 局名ID */
String sch_source = cmR.convertNullToString(request.getParameter("inpSource"));						/* 局名 */
String sch_sourceS1 = cmR.convertNullToString(request.getParameter("selSource1"));		/* 局名モード1 */
String sch_sourceS2 = cmR.convertNullToString(request.getParameter("selSource2"));		/* 局名モード2 */
String sch_recDate = cmR.convertNullToString(request.getParameter("inpRecDate"));		/* 録画日 */
String sch_recDateC = cmR.convertNullToString(request.getParameter("chkRecDate"));		/* Chk録画日 */
	if (sch_recDateC.equals("")) {
		sch_recDateC = "0";
	}
	//録画日の補正（"yyyy-MM-dd"に補完）
	if (sch_recDateC.equals("0")) {
		sch_recDate = "";
	} else {
		sch_recDate = cmR.fixDateFormat(sch_recDate);
	}
	String sch_recTime = cmR.convertNullToString(request.getParameter("inpRecTime"));		/* 録画時 */
	String sch_recTimeC = cmR.convertNullToString(request.getParameter("chkRecTime"));		/* Chk録画時 */
	if (sch_recTimeC.equals("")) {
		sch_recTimeC = "0";
	}
	//録画時の補正（"H:mm"に補完）
	if (sch_recTimeC.equals("0")) {
		sch_recTime = "";
	} else {
		sch_recTime = cmR.fixTimeFormat(sch_recTime, "HM");
	}
	String sch_recLen = cmR.convertNullToString(request.getParameter("inpRecLen"));		/* 録画長 */
	String sch_recLenC = cmR.convertNullToString(request.getParameter("chkRecLen"));		/* Chk録画日 */
	if (sch_recLenC.equals("")) {
		sch_recLenC = "0";
	}
	//録画長の補正（"H:mm:ss"に補完）
	if (sch_recLenC.equals("0")) {
		sch_recLen = "";
	} else {
		sch_recLen = cmR.fixTimeFormat(sch_recLen, "HMS");
	}
String sch_AttCat = cmR.convertNullToString(request.getParameter("selAttCat"));					/* 属性 */
String sch_AttMed = cmR.convertNullToString(request.getParameter("selAttMed"));					/* 媒体 */
String sch_AttCh = cmR.convertNullToString(request.getParameter("selAttCh"));					/* ch */
String sch_AttCo = cmR.convertNullToString(request.getParameter("selAttCo"));					/* 複写 */
String sch_AttNR = cmR.convertNullToString(request.getParameter("selAttNR"));					/* NR */
String sch_memo = cmR.convertNullToString(request.getParameter("inpMemo"));					/* メモ */
String sch_modDate = "";																					/* 更新日 */
String sch_btn = cmR.convertNullToString(request.getParameter("formBtnType"));				/* 押下ボタン種 */
StringBuffer sch_strSortT;						/* ワークTableのふりがなエリア */
StringBuffer sch_strSortP;						/* ワークTableのふりがなエリア */
String parKeyword = cmR.convertNullToString(request.getParameter("inpKeyword"));				/* 文字列検索Word */
parKeyword = parKeyword.trim();
//String parKeyword2 = cmR.convertNullToString(request.getParameter("inpKeyword2"));				/* 文字列検索Word */
//parKeyword2 = parKeyword2.trim();
String parKeywordM = cmR.convertNullToString(request.getParameter("selKeyword"));				/* 文字列検索モード */
String parKeywordT = cmR.convertNullToString(request.getParameter("rdoKeyword"));
if (parKeywordT.length() == 0) {
	parKeywordT = "T";
}
String parKeywordW = "";												/* where句ワークエリア */
//String parKeywordW2 = "";												/* where句ワークエリア2 */
String strTitleBar = "落語管理DB: ";	/* タイトルバー */
StringBuffer sBfTitleBar = new StringBuffer("");	/* タイトルバー ワークエリア */
String strCo[] = new String[1];		/* Combo要素選択用ワーク */
%>
<%
/* 本日日付を生成 */
	Calendar parToday = Calendar.getInstance();
	String nowDate = dateFmt.format(parToday.getTime());

	String parDistinct = "DISTINCT vol_id,seq,title_id,title_seq,"
		+ "str_title_seq,str_title_seq_sin,subtitle_id,"
		+ "program_id,player1_id,player2_id,player3_id,"
		+ "player1_sin,player2_sin,player3_sin,player4_sin,source_id,"
		+ "sortT,sortP,"
		+ "rec_length,rec_length_flg,rec_date,rec_date_flg,rec_time,rec_time_flg,"
		+ "category_sin,media_sin,sur_sin,nr_sin,copy_sin,memo,modify_date";
	String parSelectW = "ORDER BY sortT,sortP,vol_id,seq";
//JDBC接続
	cmR.connectJdbc6();
//	Connection db = cmR.getJdbc();
%>
<%
/* Query組み立て */
	/* 初期画面または押下ボタン不明なら Dummy空読み */
	StringBuffer query = new StringBuffer();
	StringBuffer query2;			//名称取得用Query退避エリア
	StringBuffer query3;
	StringBuffer query4;
	StringBuffer dbMsg = new StringBuffer();
	boolean useMainDB = true;	//rakugo_t(true) or rakugo_w(false)対象Flg
	int idx;
	int i;
	/* [検索]ボタンで… */
	//ID単位の［検索］（そのSeqは全件）
	if (sch_btn.equals("btnID")) {
		if (sch_id.equals("")) {
			/* IDが空ならDummy検索(0件) */
			query.append("WHERE vol_id = 'dummy'");
		} else {																	/* 空ぢゃなきゃそのVolID全件 */
			query.append("WHERE vol_id = '").append(sch_id).append("'");
		}
		query.append(" ORDER BY vol_id, seq");
	}
	//ID+Seqの［検索］（そのVolID内）
	if (sch_btn.equals("btnIDSeq")) {
		if (sch_id.equals("")) {
			//IDが空ならDummy検索
			query.append("WHERE vol_id = 'dummy'");
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
	/* [先頭検索] 
	//ID単位の検索（先頭VolIDのSeq全件。後のrs.next()ループでVolIDブレイクしたら終わり）
	if (sch_btn.equals("btnIDFirst")) {		
      query.append(parSelect).append(" order by vol_id, seq");
	}
	//ID+Seqの検索
	if (sch_btn.equals("btnIDSeqFirst")) {
		if (sch_id.equals("")) {
			//IDが空なら１件目のVolIDのSeq１件目
      query.append(parSelect).append(" where vol_id > '' and seq > ''");		
		} else {
			// 空ぢゃなきゃそのVolIDのSeq１件目
	    query.append(parSelect).append(" where vol_id = '").append(sch_id).append("'");
		}
    query.append(" order by vol_id, seq limit 0,1");	// Seqは１件目
  }
  	*/
	/* [次検索]なら大なり検索 */
	//ID単位の検索（次のVolIDのSeq全件検索。後のrs.next()ループでVolIDブレイクしたら終わり）
	if (sch_btn.equals("btnIDNext")) {
      query.append("WHERE vol_id > '").append(sch_id);
      query.append("' ORDER BY vol_id, seq");
	}
	//ID+Seqの検索
	if (sch_btn.equals("btnIDSeqNext")) {
		if (sch_id.equals("")) {
      query.append("WHERE vol_id > ''");		// IDが空なら１件目のVolID検索
		} else {												// 空ぢゃなきゃそのVolID検索
	    query.append("WHERE vol_id = '").append(sch_id);
	    query.append("' AND seq > '").append(sch_seq).append("'");
		}
    query.append(" ORDER BY vol_id, seq LIMIT 0,1");	// Seqは１件目
  }
	/* [前検索]なら小なり検索して逆順ソートの１件目を採る */
	//ID単位の検索（小さいVolIDのSeq全件検索。後のrs.next()ループでVolIDブレイクしたら終わり）
	if (sch_btn.equals("btnIDPrev")) {
		if (sch_id.equals("")) {
			query.append("WHERE vol_id <= '").append(dateFmtID.format(parToday.getTime()));
		} else {
			query.append("WHERE vol_id < '").append(sch_id);
		}
      query.append("' ORDER BY vol_id DESC, seq");
	}
	//ID+Seqの検索
	if (sch_btn.equals("btnIDSeqPrev")) {
		if (sch_id.equals("")) {
			query.append("WHERE vol_id <= '").append(dateFmtID.format(parToday.getTime()));
			query.append("' ORDER BY vol_id DESC, seq");
		} else {											// 空ぢゃなきゃそのVolID検索
		    query.append("WHERE vol_id = '").append(sch_id);
		    query.append("' AND seq < '").append(sch_seq).append("'");
		    query.append(" ORDER BY vol_id, seq DESC LIMIT 0,1");	// Seqは１件目
		}
  }
//  out.println(query.toString());
%>
<%
	/* 文字列[検索]で検索 */
	if (sch_btn.equals("btnKeyword")) {
		//検索文字列が両方""なら空振りするよう条件をEQに強制リセット
		if (parKeyword.length() == 0) {
			parKeywordM = "EQ";
			parKeyword = "no keyword";
		}
		if (parKeywordM.equals("EQ")) {
			parKeywordW = escapeString(parKeyword);
//	parKeywordW2 = escapeString(parKeyword2);
		} else if (parKeywordM.equals("GE")) {
			parKeywordW = escapeString(parKeyword) + "%";
//	parKeywordW2 = escapeString(parKeyword2) + "%";
		} else {
			parKeywordW = "%" + escapeString(parKeyword) + "%";
//	parKeywordW2 = "%" + escapeString(parKeyword2) + "%";
		}
		//次画面のタイトルバー設定
		sBfTitleBar.append(strTitleBar);
/*if (parKeyword.equals("")) {
			sBfTitleBar.append(parKeywordW2);
		} else {
			if (parKeyword2.equals("")) {
*/		sBfTitleBar.append(parKeywordW);
/*	} else {
				sBfTitleBar.append(parKeywordW).append("+").append(parKeywordW2);
			}
		}
*/
		String tarItem = "";
		String tarMode = " LIKE '";
		/*
		if (parKeywordT.indexOf("S") >= 0) {
			tarItem = "_sort";
		}
		*/
		if (parKeywordM.equals("EQ")) {
			tarMode = " = '";
		}
		//タイトルとサブタイトルを検索
		if (parKeywordT.equals("T")) {
/*			if (parKeyword.equals("")) {
				query.append("WHERE subtitle").append(tarItem);
				query.append(tarMode);
				query.append(parKeywordW2).append("'");
			} else {
*/
			query.append("WHERE title").append(tarMode).append(parKeywordW).append("'");
			query.append(" OR subtitle").append(tarMode).append(parKeywordW).append("'");
			query.append(" OR title_sort").append(tarMode).append(parKeywordW).append("'");
			query.append(" OR subtitle_sort").append(tarMode).append(parKeywordW).append("'");
/*				if (parKeyword2.equals("")) {
					query.append(" OR subtitle").append(tarItem);
					query.append(tarMode);
					query.append(parKeywordW).append("'");
				} else {
					query.append(" AND subtitle").append(tarItem);
					query.append(tarMode);
					query.append(parKeywordW2).append("'");
				}
			}
*/
			query.append(" ORDER BY title_sort, subtitle_sort, id");
		}
		//プレイヤを検索
		/*
		if (parKeywordT.indexOf("S") >= 0) {
			tarItem = "_sort";
		} else {
			tarItem = "_name";
		}
		*/
		if (parKeywordT.equals("P")) {
//	if (parKeyword.equals("")) {
			query.append("WHERE first_name").append(tarMode).append(parKeywordW).append("'");
			query.append(" OR last_name").append(tarMode).append(parKeywordW).append("'");
			query.append(" OR family_name").append(tarMode).append(parKeywordW).append("'");
			query.append(" OR full_name").append(tarMode).append(parKeywordW).append("'");
			query.append(" OR first_sort").append(tarMode).append(parKeywordW).append("'");
			query.append(" OR last_sort").append(tarMode).append(parKeywordW).append("'");
			query.append(" OR family_sort").append(tarMode).append(parKeywordW).append("'");
/*			} else {
				query.append("WHERE last").append(tarItem);
				query.append(tarMode);
				query.append(parKeywordW).append("'");
				if (parKeyword2.equals("")) {
					query.append(" OR family").append(tarItem);
					query.append(tarMode);
					query.append(parKeywordW).append("'");
				} else {
					query.append(" AND first").append(tarItem);
					query.append(tarMode);
					query.append(parKeywordW2).append("'");
				}
			}
			*/
			query.append(" ORDER BY last_sort, first_sort, family_sort, id");
		}
%>
<%
		//まづワークTABLEをクリア
		rwU.initRec();
		rwU.deleteRec("", -1);
		//取り敢えずタイトル/プレイヤマスタを検索する。
		if (parKeywordT.equals("T")) {
			tmS.selectDB(query.toString(), "");
			idx = tmS.getResultCount();
		} else {
			pmS.selectDB(query.toString(), "");
			idx = pmS.getResultCount();
		}
		for (int j = 0; j < idx; j++) {
			//タイトル・プレイヤ マスタのIDで落語DBを検索
			query3 = new StringBuffer();
			if (parKeywordT.equals("T")) {
				tarItem = tmS.getId(j);
				query3.append("WHERE title_id = '").append(tarItem);
				query3.append("' OR subtitle_id = '").append(tarItem);
				query3.append("' OR program_id = '").append(tarItem);
				query3.append("'");
			} else {
				tarItem = pmS.getId(j);
				query3.append("WHERE player1_id = '").append(tarItem);
				query3.append("' OR player2_id = '").append(tarItem);
				query3.append("' OR player3_id = '").append(tarItem);
				query3.append("'");
			}
			rkS.selectDB(query3.toString(), "");
			for (i = 0; i < rkS.getResultCount(); i++) {
				rwU.initRec();
				rwU.setVolId(rkS.getVolId(i));
				rwU.setSeq(rkS.getSeq(i));
				rwU.setTitleId(rkS.getTitleId(i));
				rwU.setTitleSeq(rkS.getTitleSeq(i));
				rwU.setStrTitleSeq(rkS.getStrTitleSeq(i));
				rwU.setStrTitleSeqSin(rkS.getStrTitleSeqSin(i));
				rwU.setSubtitleId(rkS.getSubtitleId(i));
				rwU.setPlayer1Id(rkS.getPlayer1Id(i));
				rwU.setPlayer2Id(rkS.getPlayer2Id(i));
				rwU.setPlayer3Id(rkS.getPlayer3Id(i));
				rwU.setPlayer1Sin(rkS.getPlayer1Sin(i));
				rwU.setPlayer2Sin(rkS.getPlayer2Sin(i));
				rwU.setPlayer3Sin(rkS.getPlayer3Sin(i));
				rwU.setPlayer4Sin(rkS.getPlayer4Sin(i));
				rwU.setProgramId(rkS.getProgramId(i));
				rwU.setSourceId(rkS.getSourceId(i));
				rwU.setRecLengthFlg(rkS.getRecLengthFlg(i));
				rwU.setRecLength(rkS.getRecLength(i));
				rwU.setRecDateFlg(rkS.getRecDateFlg(i));
				rwU.setRecDate(rkS.getRecDate(i));
				rwU.setRecTimeFlg(rkS.getRecTimeFlg(i));
				rwU.setRecTime(rkS.getRecTime(i));
				rwU.setCategorySin(rkS.getCategorySin(i));
				rwU.setMediaSin(rkS.getMediaSin(i));
				rwU.setSurSin(rkS.getSurSin(i));
				rwU.setNrSin(rkS.getNrSin(i));
				rwU.setCopySin(rkS.getCopySin(i));
				rwU.setMemo(escapeString(rkS.getMemo(i)));
				rwU.setModifyDate(rkS.getModifyDate(i));
				if (parKeywordT.equals("T")) {
					tarItem = escapeString(tmS.getTitleSort(j));
					tarItem += escapeString(tmS.getSubtitleSort(j));
					rwU.setSortT(tarItem);
					rwU.setSortP("");
				} else {
					tarItem = escapeString(pmS.getLastSort(j));
					tarItem += escapeString(pmS.getFirstSort(j));
					tarItem += escapeString(pmS.getFamilySort(j));
					rwU.setSortT("");
					rwU.setSortP(tarItem);
				}
				//ワークTABLEに格納
				rwU.insertRec();
			}
		}
		query = new StringBuffer();
		query.append("ORDER BY sortT, sortP, vol_id, seq");
		useMainDB = false;
	}
%>
<%
	/* [更新][追加]なら更新して再検索 */
	if ((sch_btn.equals("btnMod")) ||
	    (sch_btn.equals("btnAdd"))) {
	  try {
			rkU.initRec();
			rkU.setVolId(sch_id);
			rkU.setSeq(Integer.parseInt(sch_seq));
			rkU.setTitleId(sch_titleID);
			try {
				rkU.setTitleSeq(Integer.parseInt(sch_titleSeq));
			} catch (Exception e) {
				rkU.setTitleSeq(0);
			}
			rkU.setStrTitleSeq(sch_strTitleSeq);
			rkU.setStrTitleSeqSin(sch_strTitleSeqSin);
			rkU.setSubtitleId(sch_subID);
			rkU.setPlayer1Id(sch_player1ID);
			rkU.setPlayer2Id(sch_player2ID);
			rkU.setPlayer3Id(sch_player3ID);
			rkU.setPlayer1Sin(sch_player1Sin);
			rkU.setPlayer2Sin(sch_player2Sin);
			rkU.setPlayer3Sin(sch_player3Sin);
			rkU.setPlayer4Sin(sch_player4);
			rkU.setProgramId(sch_programID);
			rkU.setSourceId(sch_sourceID);
			rkU.setRecLengthFlg(sch_recLenC);
			try {
				sch_recLen = cmR.fixTimeFormat(sch_recLen, "HMS");
				rkU.setRecLength(Time.valueOf(sch_recLen));
			} catch (Exception e) {
				rkU.setRecLength(Time.valueOf("00:00:00"));
			}
			rkU.setRecDateFlg(sch_recDateC);
			sch_recDate = cmR.fixDateFormat(sch_recDate);
			sch_recDate = sch_recDate.replace("-", "/");	//parseの書式に変換
			try {
				rkU.setRecDate(datePs.parse(sch_recDate));
			} catch (Exception e) {
				rkU.setRecDate(datePs.parse("1961/12/10"));
			}
			rkU.setRecTimeFlg(sch_recTimeC);
			try {
				//"H:mm"→"HH:mm:ss"
				sch_recTime = cmR.fixTimeFormat(sch_recTime + ":00", "HMS");
				rkU.setRecTime(Time.valueOf(sch_recTime));
			} catch (Exception e) {
				rkU.setRecTime(Time.valueOf("00:00:00"));
			}
			rkU.setCategorySin(sch_AttCat);
			rkU.setMediaSin(sch_AttMed);
			rkU.setSurSin(sch_AttCh);
			rkU.setNrSin(sch_AttNR);
			rkU.setCopySin(sch_AttCo);
			rkU.setMemo(escapeString(sch_memo));

			if (sch_btn.equals("btnAdd")) {
				if (rkU.insertRec() < 1) {
					dbMsg.append("Insert Error!");
				}
			} else {
				if (rkU.updateRec() < 1) {
					dbMsg.append("Update Error!");
				}
			}
		} catch (Exception e) {
			dbMsg.append("Insert/Update Parameter Error!");
		}
		query = new StringBuffer();
		query.append("WHERE vol_id = '").append(sch_id);
		query.append("' AND seq = '").append(sch_seq).append("'");
	}
	/* [削除]なら更新して再検索 */
	if (sch_btn.equals("btnDel")) {
		try {
			if (rkU.deleteRec(sch_id, Integer.parseInt(sch_seq)) < 1) {
				dbMsg.append("Delete Error!");
			}
		} catch (Exception e) {
			dbMsg.append("Delete Parameter Error!");
		}
		query = new StringBuffer();
		query.append("WHERE vol_id = '").append(sch_id);
		query.append("' AND seq = '").append(sch_seq).append("'");
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
		//rakugo_t 条件よみ
		rkS.selectDB(query.toString(), "");
	} else {
		//rakugo_w 全件よみ
		rkS.selectWK(parSelectW, parDistinct);
	}

	try {

	 if (rkS.getResultCount() > 0) {
		i = 0;
		sch_id = rkS.getVolId(i);							/* ID */
		break_id = sch_id;							/* Break用にID退避 */
		try {
			sch_seq = decFmt3.format(rkS.getSeq(i));			/* Seq */
		} catch (Exception e) {
			sch_seq = "";
		}
		sch_titleID = rkS.getTitleId(i);					/* タイトルID */
		try {
			if (rkS.getTitleSeq(i) == 0) {
				sch_titleSeq = "";
			} else {
				sch_titleSeq = decFmt3.format(rkS.getTitleSeq(i));
			}
		} catch (Exception e) {
			sch_titleSeq = "";
		}
		sch_strTitleSeq = rkS.getStrTitleSeq(i);
		sch_strTitleSeqSin = rkS.getStrTitleSeqSin(i);
		sch_subID = rkS.getSubtitleId(i);			/* サブタイトルID */
		sch_player1ID = rkS.getPlayer1Id(i);
		sch_player2ID = rkS.getPlayer2Id(i);
		sch_player3ID = rkS.getPlayer3Id(i);
		sch_player1Sin = rkS.getPlayer1Sin(i);
		sch_player2Sin = rkS.getPlayer2Sin(i);
		sch_player3Sin = rkS.getPlayer3Sin(i);
		sch_player4 = rkS.getPlayer4Sin(i);
		sch_programID = rkS.getProgramId(i);	/* 番組ID */
		sch_sourceID = rkS.getSourceId(i);	/* 局ID */
		sch_recLenC = rkS.getRecLengthFlg(i);
		if (sch_recLenC.equals("1")) {
			try {		//録画長（ヘッダではHourも出す）
				sch_recLen = timeFmt5.format(rkS.getRecLength(i));
//				sch_recLen = cmR.fixTimeFormat(sch_recLen, "HMS");
			} catch (Exception e) {
				sch_recLen = "";
				sch_recLenC = "0";
			}
		} else {
			sch_recLen = "";
			sch_recLenC = "0";
		}
		sch_recDateC = rkS.getRecDateFlg(i);
		if (sch_recDateC.equals("1")) {
			try {							/* 録画日 */
				sch_recDate = dateFmt.format(rkS.getRecDate(i));
			} catch (Exception e) {
				sch_recDate = "";
				sch_recDateC = "0";
			}
		} else {
			sch_recDate = "";
			sch_recDateC = "0";
		}
		sch_recTimeC = rkS.getRecTimeFlg(i);
		if (sch_recTimeC.equals("1")) {
			try {		//録画時 "H:mm"
				sch_recTime = timeFmtS.format(rkS.getRecTime(i));
			} catch (Exception e) {
				sch_recTime = "";
				sch_recTimeC = "0";
			}
		} else {
			sch_recTime = "";
			sch_recTimeC = "0";
		}
		sch_AttCat = rkS.getCategorySin(i);		/* 属性 */
		sch_AttMed = rkS.getMediaSin(i);			/* 媒体 */
		sch_AttCh = rkS.getSurSin(i);				/* サラウンド */
		sch_AttNR = rkS.getNrSin(i);				/* NR */
		sch_AttCo = rkS.getCopySin(i);			/* コピー */
		sch_memo = rkS.getMemo(i);					/* メモ */
		try {
			sch_modDate = dateFmtE.format(rkS.getModifyDate(i));	/* 更新日 */
		} catch (Exception e) {
			sch_modDate = "";
		}
		//ID+Seq の検索なら明細部にID下全件を表示するため query リセット。
		if (sch_btn.indexOf("IDSeq") >= 0) {
			query = new StringBuffer();
			query.append("WHERE vol_id = '").append(sch_id).append("'");
		}
	 }
	} catch (Exception e) {
		out.println("Catch Exception");
	}
	if (sBfTitleBar.toString().equals("")) {
		sBfTitleBar.append(strTitleBar).append(sch_id);
		if (sch_btn.indexOf("Seq") >= 0) {
			sBfTitleBar.append("/").append(sch_seq);
		}
	}
%>
<form name="formRakugo">
<table border="0" width="100%">
	<tr>
	<td width="50%">
		<h1>落語DB管理</h1>
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
      <th bgcolor="#cccccc" width="96" id="thRkID">
  			<!--input type="button" onclick="javascript:openCalendarWindow('ID')" name="btnID" value="VolumeID"-->
  			<input type="button" onclick="javascript:openCalendarWindow('RkID')" name="btnID" value="VolumeID">
  		</th>
      <td>
  			<input size="7" type="text" maxlength="6"
  				id="inpRkID"
  				name="inpID" value="<%= sch_id %>">
  		</td>
      <td><input type="button" name="btnIDEqual" onclick="javascript:sendQuery('btnID')" value="検索"></td>
      <td><input type="button" name="btnIDPrev" onclick="javascript:sendQuery('btnIDPrev')" value="前"></td>
      <td><input type="button" name="btnIDNext" onclick="javascript:sendQuery('btnIDNext')" value="次"></td>
      <!-- td><input type="button" name="btnIDFirst" onclick="javascript:sendQuery('btnIDFirst')" value="先頭"></td -->
      <th bgcolor="#cccccc" rowspan="2">検<br>索</th>
      <!--td bgcolor="#cccccc">Title/姓</td-->
      <td>
  			<input size="12" type="text" maxlength="255" name="inpKeyword" value="<%= parKeyword %>">
  		</td>
      <td align="left">
			<%
				//検索条件セレクタ
				out.println(cmF.makeSelectOption("selKeyword", "", parKeywordM));
			%>
			</td>
      <td align="center">
      	<input type="button" name="btnKeyword"
      		onclick="javascript: sendQuery('btnKeyword')" value="検索">
      </td>
    </tr>
<!-- VolSeq制御列 -->
    <tr align="center" valign="middle">
      <th bgcolor="#cccccc">SEQ</th>
      <td><a href="javascript: addSeq(-1,'id')">▽</a><input size="4" type="text" maxlength="3" name="inpSeq" value="<%= sch_seq %>"><a href="javascript: addSeq(1,'id')">△</a></td>
      <td><input type="button" name="btnIDSeq" onclick="javascript:sendQuery('btnIDSeq')" value="検索"></td>
      <td><input type="button" name="btnIDSeqPrev" onclick="javascript:sendQuery('btnIDSeqPrev')" value="前"></td>
      <td><input type="button" name="btnIDSeqNext" onclick="javascript:sendQuery('btnIDSeqNext')" value="次"></td>
      <!-- td><input type="button" name="btnIDSeqFirst" onclick="javascript:sendQuery('btnIDSeqFirst')" value="先頭"></td -->
      <!--td align="left" bgcolor="#cccccc">Sub/名</td-->
      <!--td><input size="12" type="text" maxlength="255" name="inpKeyword2"
       value="<!--%= parKeyword2 %>">
      </td-->
			<td align="left" colspan="2">
			<%
				//題副・かなセレクタ
//				out.println(cmF.makeSelectItemR("selKeywordT", "", parKeywordT));
				strCo = new String[2];
				if (parKeywordT.equals("T")) { strCo[0] = "checked"; }
				if (parKeywordT.equals("P")) { strCo[1] = "checked"; }
			%>
				<input type="radio" name="rdoKeyword" value="T" <%= strCo[0] %>>演題
				<input type="radio" name="rdoKeyword" value="P" <%= strCo[1] %>>演者
			</td>
			<td>
				<input type="button" name="btnKeywordClear" onclick="javascript: clearKeyword()" value="クリア">
			</td>
    </tr>
</table>
<table border="1">
<!-- タイトル制御列 -->
    <tr>
		<%
			//タイトル_マスタDBからタイトル取得
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
		%>
      <th bgcolor="#cccccc" width="96">
        <input type="button" name="btnTitleID" onclick="javascript: openTitleWindow('inpTitleID')" value="Title">
      </th>
		<td><input size="7" type="text" maxlength="6" name="inpTitleID" value="<%= sch_titleID %>"></td>
		<td><input size="60" type="text" maxlength="255" name="inpTitle" value="<%= sch_title %> <%= sch_sub %>" readonly></td>
		<td align="center" colspan="2">
			<a href="javascript: addSeq(-1,'title')">▽</a><input size="4" type="text" maxlength="3" name="inpTitleSeq" value="<%= sch_titleSeq %>"><a href="javascript: addSeq(1,'title')">△</a>
		</td>
    </tr>
<!-- サブタイトル制御列 -->
    <tr>
		<%
			//タイトル_マスタDBからサブタイトル取得
			if (sch_subID.equals("")) {
				sch_sub = "";
			} else {
				query2 = new StringBuffer();
				query2.append("WHERE id = '").append(sch_subID).append("'");
				tmS.selectDB(query2.toString(), "");
				if (tmS.getResultCount() > 0) {
					sch_sub = tmS.getSubtitle(0);
				} else {
					sch_sub = "";
				}
			}
		%>
      <th bgcolor="#cccccc"><input type="button" name="btnSubTitleID" onclick="javascript: openTitleWindow('inpSubID')" value="SubTitle"></th>
      <td><input size="7" type="text" maxlength="6" name="inpSubID" value="<%= sch_subID %>"></td>
      <td>
      	<input size="60" type="text" maxlength="255" name="inpSub" value="<%= sch_sub %>" readonly>
      </td>
		<td align="center" colspan="2"><input type="checkbox" name="chkStrTitleSeqSin" value="1"
			<%
				if (sch_strTitleSeqSin.equals("1")) {
					out.println(" checked ");
				}
			%>
		 /><input type="text" size="8" maxlength="8" name="inpStrTitleSeq" value="<%= sch_strTitleSeq %>" />
		</td>
    </tr>
<!-- 演者１制御列 -->
    <tr>
		<%
			//演者マスタDBから姓名取得
			if (sch_player1ID.equals("")) {
				sch_player1 = "";
			} else {
				query2 = new StringBuffer();
				query2.append("WHERE id = '").append(sch_player1ID).append("'");
				pmS.selectDB(query2.toString(), "");
				if (pmS.getResultCount() > 0) {
					sch_player1 = pmS.getFullName(0);
				} else {
					sch_player1 = "";
				}
			}
		%>
      <th bgcolor="#cccccc"><input type="button" name="btnP1ID" onclick="javascript: openPlayerWindow('inpP1ID')" value="Player1"></th>
      <td><input size="7" type="text" maxlength="6" name="inpP1ID" value="<%= sch_player1ID %>"></td>
      <td>
      	<input size="60" type="text" maxlength="255" name="inpP1" value="<%= sch_player1 %>" readonly>
      </td>
      <td>
			<%
				//演者役割セレクタ
				out.println(cmF.makePlayerPart("selP1", "", sch_player1Sin));
			%>
   		</td>
			<td align="center" valign="bottom" rowspan="3">
				他<br />
				<input name="chkP4" type="checkbox" value="1"
				<%
					if (sch_player4.equals("1")) {
						out.println(" checked");
					}
				%>
					>
			</td>
    </tr>
<!-- 演者２制御列 -->
    <tr>
		<%
			//演者マスタDBから姓名取得
			if (sch_player2ID.equals("")) {
				sch_player2 = "";
			} else {
				query2 = new StringBuffer();
				query2.append("WHERE id = '").append(sch_player2ID).append("'");
				pmS.selectDB(query2.toString(), "");
				if (pmS.getResultCount() > 0) {
					sch_player2 = pmS.getFullName(0);
				} else {
					sch_player2 = "";
				}
			}
		%>
      <th bgcolor="#cccccc"><input type="button" name="btnP2ID" onclick="javascript: openPlayerWindow('inpP2ID')" value="Player2"></th>
      <td><input size="7" type="text" maxlength="6" name="inpP2ID" value="<%= sch_player2ID %>"></td>
      <td>
      	<input size="60" type="text" maxlength="255" name="inpP2" value="<%= sch_player2 %>" readonly>
      </td>
      <td>
			<%
				//演者役割セレクタ
				out.println(cmF.makePlayerPart("selP2", "", sch_player2Sin));
			%>
      </td>
    </tr>
<!-- 演者３制御列 -->
    <tr>
		<%
			//演者マスタDBから姓名取得
			if (sch_player3ID.equals("")) {
				sch_player3 = "";
			} else {
				query2 = new StringBuffer();
				query2.append("WHERE id = '").append(sch_player3ID).append("'");
				pmS.selectDB(query2.toString(), "");
				if (pmS.getResultCount() > 0) {
					sch_player3 = pmS.getFullName(0);
				} else {
					sch_player3 = "";
				}
			}
		%>
			<th bgcolor="#cccccc">
				<input type="button" name="btnP3ID" onclick="javascript: openPlayerWindow('inpP3ID')" value="Player3">
			</th>
			<td>
				<input size="7" type="text" maxlength="6" name="inpP3ID" value="<%= sch_player3ID %>">
			</td>
			<td>
				<input size="60" type="text" maxlength="255" name="inpP3" value="<%= sch_player3 %>" readonly>
      </td>
      <td>
			<%
				//演者役割セレクタ
				out.println(cmF.makePlayerPart("selP3", "", sch_player3Sin));
			%>
			</td>
		</tr>
<!-- プログラム制御列 -->
		<tr>
		<%
			//タイトル_マスタDBからプログラム名取得
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
		%>
      <th bgcolor="#cccccc"><input type="button" name="btnProgramID" onclick="javascript: openTitleWindow('inpProgramID')" value="Program"></th>
      <td><input size="7" type="text" maxlength="6" name="inpProgramID" value="<%= sch_programID %>"></td>
		  <td colspan="3">
		  	<input size="72" type="text" maxlength="255" name="inpProgram" value="<%= sch_program %>" readonly>
		  </td>
    </td>
		</tr>
<!-- 放送局制御列 -->
    <tr>
      <th bgcolor="#cccccc"><input type="button" name="btnSourceID" onclick="javascript: openTitleWindow('inpSourceID')" value="BBS"></th>
      <td><input size="7" type="text" maxlength="6" name="inpSourceID" value="<%= sch_sourceID %>"></td>
      <td colspan="3">
		<%
			//BBSセレクタ
			String wkBbs1 = cmF.makeBbs("selSource1", "selBbs1", sch_sourceID);
			String wkBbs2 = cmF.makeBbsBs("selSource2", "selBbs2", sch_sourceID);
			
			if ((cmF.getBbs(sch_sourceID).equals("")) &&
			    (cmF.getBbsBs(sch_sourceID).equals(""))) {
				//タイトル_マスタDBからタイトル取得
				query2 = new StringBuffer();
				query2.append("WHERE id = '").append(sch_sourceID).append("'");
				tmS.selectDB(query2.toString(), "");
				try {
				 if (tmS.getResultCount() > 0) {
					sch_source = tmS.getTitle(0);
				 } else {
					sch_source = "";
				 }
				} catch (Exception e) {
					sch_source = "";
				}

				sch_sourceS1 = "";
				sch_sourceS2 = "";
			} else {
				sch_source = "";
			}
			String wkBbs3 = "<input type='text' name='inpSource' size='38'";
			wkBbs3 += " id='inpSource' maxlength='255'";
			wkBbs3 += " value='" + sch_source + "' readonly>";
			if (sch_source.equals("")) {
				out.println(wkBbs1);
				out.println(wkBbs2);
				out.println(wkBbs3);
			} else {
				out.println(wkBbs3);
				out.println(wkBbs1);
				out.println(wkBbs2);
			}
		%>
			</td>
    </tr>
	</table>
<!-- 録画日時制御列 -->
	<div id="divClock" class="div1"></div>
	<table border="1" id="tblDate">
    <tr>
		<%
			strCo = new String[3];
			if (sch_recDateC.equals("1")) { strCo[0] = "checked"; }
			if (sch_recTimeC.equals("1")) { strCo[1] = "checked"; }
			if (sch_recLenC.equals("1")) { strCo[2] = "checked"; }
		%>
      <th bgcolor="#cccccc" width="96" id="thRecDate">
      	<input type="button" name="btnRecDate"
      		onclick="javascript:openCalendarWindow('RecDate')" value="記録日">
      </th>
      <td>
      	<input size="12" type="text" maxlength="10"
      		id="inpRecDate"
      		name="inpRecDate" value="<%= sch_recDate %>"><input type="checkbox"
      		id="chkRecDate"
      		name="chkRecDate" onclick="javascript: clearInpData('recDate')" value="1" <%= strCo[0] %>>
      </td>
      <th bgcolor="#cccccc" id="thRecTime">
      	<input type="button" name="btnRecTime" onclick="javascript:openClockWindow('RecTime')" value="記録時">
      </th>
			<td>
				<input size="6" type="text" maxlength="5"
					id="inpRecTime"
					name="inpRecTime" value="<%= sch_recTime %>"><input type="checkbox"
					id="chkRecTime"
				 	name="chkRecTime" onclick="javascript: clearInpData('recTime')" value="1" <%= strCo[1] %>>
			</td>
      <th bgcolor="#cccccc" id="thRecLen">
      	<input type="button" name="btnRecLen" onclick="javascript:openClockWindow('RecLen')" value="時間">
      </th>
			<td>
				<input size="9" type="text" maxlength="8"
					id="inpRecLen"
					name="inpRecLen" value="<%= sch_recLen %>"><input type="checkbox"
					id="chkRecLen"
					name="chkRecLen" onclick="javascript: clearInpData('recLen')" value="1" <%= strCo[2] %>>
			</td>
    </tr>
<!-- 属性制御列 -->
    <tr>
      <th bgcolor="#cccccc">属性</th>
      <td>
			<%
				//演題種別セレクタ
				out.println(cmF.makeField("selAttCat", "", sch_AttCat));
			%>
			</td><td id="inpRecTimePos">
			<%
				//媒体種別セレクタ
				out.println(cmF.makeMedia("selAttMed", "", sch_AttMed));
			%>
			</td><td>
			<%
				//チャンネル種別セレクタ
				out.println(cmF.makeSurround("selAttCh", "", sch_AttCh));
			%>
			</td><td>
			<%
				//コピー世代セレクタ
				out.println(cmF.makeGeneration("selAttCo", "", sch_AttCo));
			%>
			</td><td>
			<%
				//NoiseReductionセレクタ
				out.println(cmF.makeNR("selAttNR", "", sch_AttNR));
		%>
      </td>
    </tr>
<!-- メモ制御列 -->
    <tr>
      <th bgcolor="#cccccc">Memo</th>
      <td colspan="5">
      	<input size="72" type="text" maxlength="255" name="inpMemo" value="<%= sch_memo %>">
      </td>
    </tr>
<!-- 更新日表示列 -->
    <tr>
      <th bgcolor="#cccccc">更新日</th>
      <td colspan="2"><%= sch_modDate %></td>
<!-- 操作ボタン制御列 -->
      <td align="center">
      	<input type="Button" onclick="javascript:assistInpData(), sendQuery('btnMod')" name="btnModTitle" value="更新">
      </td>
      <td align="center">
      	<input type="Button" onclick="javascript:assistInpData(), sendQuery('btnAdd')" name="btnModTitle" value="追加">
      </td>
      <td align="center">
      	<input type="Button" onclick="javascript:sendQuery('btnDel')" name="btnModTitle" value="削除">
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
		<tr bgcolor=silver>
			<th>No.</th>
			<th>ID</th>
			<th>SEQ</th>
			<th>TITLE<br>PLAYER1</th>
			<th>PROGRAM<br>PLAYER2</th>
			<th>SOURCE<br>PLAYER3</th>
			<th>REC DATE<br>Att1t</th>
			<th>LENGTH<br>Att2</th>
			<th>MEMO<br>MOD DATE</th>
		</tr>
<%
	/* 明細用にまた読む。 */
	if (useMainDB == true) {
		//rakugo_t 条件よみ
		rkS.selectDB(query.toString(), "");
	} else {
		//rakugo_w 全件よみ
		rkS.selectWK(parSelectW, parDistinct);
	}
	int row = 0;
	String strLine1 = "bgcolor=white";
	String strLine2 = "bgcolor=lavender";
	String clsLine = "";
	
	try {
	
	for (i = 0; i < rkS.getResultCount(); i++) {
		row = row + 1;
		if (clsLine.equals(strLine1) == true) {
			clsLine = strLine2;
		} else {
			clsLine = strLine1;
		}
		sch_id = rkS.getVolId(i);							/* ID */
		try {
			sch_seq = decFmt3.format(rkS.getSeq(i));			/* Seq */
		} catch (Exception e) {
			sch_seq = "";
		}
		sch_titleID = rkS.getTitleId(i);					/* タイトルID */
		//タイトルマスタDBからタイトル取得
		if (sch_titleID.equals("")) {
			sch_title = "";
		} else {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_titleID).append("'");
			tmS.selectDB(query2.toString(), "");
			if (tmS.getResultCount() > 0) {
				sch_title = tmS.getTitle(0);
				if (! tmS.getSubtitle(0).equals("")) {
					sch_title += "（" + tmS.getSubtitle(0) + "）";
				}
			} else {
				sch_title = "";
			}
		}
		//タイトルにタイトルSeqを付加
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
		//タイトルSeq整形
		if (! sch_titleSeq.equals("")) {
			sch_title += sch_titleSeq;
		}
		//サブタイトル編集
		sch_subID = rkS.getTitleId(i);
		//タイトルマスタDBからサブタイトル取得
		if (! sch_subID.equals("")) {
			query2 = new StringBuffer();
			query2.append("WHERE id = '").append(sch_subID).append("'");
			tmS.selectDB(query2.toString(), "");
			if (tmS.getResultCount() > 0) {
				if (! tmS.getSubtitle(0).equals("")) {
					sch_title += "［" + tmS.getSubtitle(0) + "］";
				}
			}
		}
		sch_player1ID = rkS.getPlayer1Id(i);
		sch_player2ID = rkS.getPlayer2Id(i);
		sch_player3ID = rkS.getPlayer3Id(i);
		sch_player1Sin = rkS.getPlayer1Sin(i);
		sch_player2Sin = rkS.getPlayer2Sin(i);
		sch_player3Sin = rkS.getPlayer3Sin(i);
		sch_player4 = rkS.getPlayer4Sin(i);
		//演者マスタDBから姓名取得
		if (sch_player1ID.equals("")) {
			sch_player1 = "";
			sch_player1Sin = "";
		} else {
			try {
				query2 = new StringBuffer();
				query2.append("WHERE id = '").append(sch_player1ID).append("'");
				pmS.selectDB(query2.toString(), "");
				if (pmS.getResultCount() > 0) {
					sch_player1 = pmS.getFullName(0);
					sch_player1Sin = cmF.getPlayerPart(sch_player1Sin);
				} else {
					sch_player1 = "";
					sch_player1Sin = "";
				}
			} catch (Exception e) {
				sch_player1 = "";
				sch_player1Sin = "";
			}
		}
		if (sch_player2ID.equals("")) {
			sch_player2 = "";
			sch_player2Sin = "";
		} else {
			try {
				query2 = new StringBuffer();
				query2.append("WHERE id = '").append(sch_player2ID).append("'");
				pmS.selectDB(query2.toString(), "");
				if (pmS.getResultCount() > 0) {
					sch_player2 = pmS.getFullName(0);
					sch_player2Sin = cmF.getPlayerPart(sch_player2Sin);
				} else {
					sch_player2 = "";
					sch_player2Sin = "";
				}
			} catch (Exception e) {
				sch_player2 = "";
				sch_player2Sin = "";
			}
		}
		if (sch_player3ID.equals("")) {
			sch_player3 = "";
			sch_player3Sin = "";
		} else {
			try {
				query2 = new StringBuffer();
				query2.append("WHERE id = '").append(sch_player3ID).append("'");
				pmS.selectDB(query2.toString(), "");
				if (pmS.getResultCount() > 0) {
					sch_player3 = pmS.getFullName(0);
					sch_player3Sin = cmF.getPlayerPart(sch_player3Sin);
				} else {
					sch_player3 = "";
					sch_player3Sin = "";
				}
			} catch (Exception e) {
				sch_player3 = "";
				sch_player3Sin = "";
			}
		}
		//姓名ダミー連結
		sch_player1 = cmR.concatNames(sch_player1, sch_player1Sin,
			"", "", "", "", "0", "");
		sch_player2 = cmR.concatNames(sch_player2, sch_player2Sin,
			"", "", "", "", "0", "");
		sch_player3 = cmR.concatNames(sch_player3, sch_player3Sin,
			"", "", "", "", sch_player4, "");
		sch_programID = rkS.getProgramId(i);	/* 番組ID */
		//タイトルマスタDBからプログラム名取得
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
		sch_sourceID = rkS.getSourceId(i);	/* 局ID */
		//タイトルマスタDBから局名取得
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
		sch_recLenC = rkS.getRecLengthFlg(i);
		if (sch_recLenC.equals("1")) {
			try {		//録画長
				sch_recLen = timeFmt5.format(rkS.getRecLength(i));
				sch_recLen = cmR.fixTimeFormat(sch_recLen, "HMS");
			} catch (Exception e) {
				sch_recLen = "";
				sch_recLenC = "0";
			}
		} else {
			sch_recLen = "";
			sch_recLenC = "0";
		}
		sch_recDateC = rkS.getRecDateFlg(i);
		if (sch_recDateC.equals("1")) {
			try {		/* 録画日 */
				sch_recDate = dateFmtS.format(rkS.getRecDate(i));
			} catch (Exception e) {
				sch_recDate = "";
				sch_recDateC = "0";
			}
		} else {
			sch_recDate = "";
			sch_recDateC = "0";
		}
		sch_recTimeC = rkS.getRecTimeFlg(i);
		if (sch_recTimeC.equals("1")) {
			try {		//録画時 "H:mm"
				sch_recTime = timeFmtS.format(rkS.getRecTime(i));
			} catch (Exception e) {
				sch_recTime = "";
				sch_recTimeC = "0";
			}
		} else {
			sch_recTime = "";
			sch_recTimeC = "0";
		}
		if (sch_recTimeC.equals("1")) {
			sch_recDate += " " + sch_recTime;
		}
		sch_AttCat = rkS.getCategorySin(i);		/* 属性 */
		sch_AttCat = cmF.getField(sch_AttCat);
		sch_AttMed = rkS.getMediaSin(i);			/* 媒体 */
		sch_AttMed = cmF.getMedia(sch_AttMed);
		sch_AttCh = rkS.getSurSin(i);				/* サラウンド */
		sch_AttCh = cmF.getSurround(sch_AttCh);
		sch_AttNR = rkS.getNrSin(i);				/* NR */
		sch_AttNR = cmF.getNR(sch_AttNR);
		sch_AttCo = rkS.getCopySin(i);			/* コピー */
		sch_AttCo = cmF.getGeneration(sch_AttCo);
		if (! sch_AttCh.equals("")) {
			sch_AttCat += ", " + sch_AttCh;
		}
		if (! sch_AttNR.equals("")) {
			sch_AttMed += ", " + sch_AttNR;
		}
		if (! sch_AttCo.equals("")) {
			sch_AttMed += ", " + sch_AttCo;
		}
		sch_memo = rkS.getMemo(i);					/* メモ */
		try {
			sch_modDate = dateFmtS.format(rkS.getModifyDate(i));	/* 更新日 */
		} catch (Exception e) {
			sch_modDate = "";
		}
		//IDの［次検索］［先頭検索］でIDブレイクしたら終わり
		if ((sch_btn.equals("btnIDFirst")) ||
			  (sch_btn.equals("btnIDPrev"))  ||
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
			<td><%= sch_program %></td>
			<td><%= sch_source %></td>
			<td><%= sch_recDate %></td>
			<td><%= sch_recLen %></td>
			<td><%= sch_memo %></td>
		</tr>
		<tr <%= clsLine %>>
			<td><input type="button" name="btnModID" onclick="javascript:openModWindow('<%= sch_id %>','<%= sch_seq %>')" value="Edit")></td>
			<td><input type="button" name="btnIDLine" onclick="javascript:openSelWindow('<%= sch_id %>','<%= sch_seq %>')" value="Select")></td>
			<td><input type="button" name="btnShowID" onclick="javascript:openViewWindow('<%= sch_id %>')" value="View")></td>
			<td><%= sch_player1 %></td>
			<td><%= sch_player2 %></td>
			<td><%= sch_player3 %></td>
			<td><%= sch_AttCat %></td>
			<td><%= sch_AttMed %></td>
		 	<td><%= sch_modDate %></td>
		</tr>
<%
	}
	} catch (Exception e) {
		out.println("Catch Exception");
	}
//rs.close();
//rs2.close();
//  rs3.close();
//	rsIns.close();
//	rsMod.close();
//t.close();/
//t2.close();
//	st3.close();
//  db.close();
	//JDBC切断
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
    document.title = document.formRakugo.inpTitleBar.value;
    document.formRakugo.outRow.value = <%= row %> + "件";
    if (<%= row %> == 0) {
        document.formRakugo.outRow.value = "no record!";
    }
    document.formRakugo.outRow.size = document.formRakugo.outRow.value.length + 1;
    if ("<%= dbMsg.toString() %>" != "") {
        document.getElementById("AjaxState").innerHTML =
            "<font color='red'>" + "<%= dbMsg.toString() %>" + "</font>";
    }
    document.getElementById("selBbs1").onchange = new Function("javascript: resetSourceID(1)");
    document.getElementById("selBbs2").onchange = new Function("javascript: resetSourceID(2)");
// -->
</script>
</body>
</html>