/**
 *
 */
package jp.rakugo.nii;

import java.io.Serializable;
import java.util.HashMap;

/**
 * @author nii
 *
 */
public class CommonForm implements Serializable {
//JSP共通のForm部品を生成する。

	private HashMap hmSelectOption;
	private String[] SELECT_OPTION_CODE = {"EQ", "GE", "IN"};
	private String[] SELECT_OPTION_DATA =
		{"に等しい", "から始まる", "を含む"};

	public HashMap hmSelectItem;
	private String[] SELECT_ITEM_CODE = {"T", "TS", "P", "PS", "D"};
	private String[] SELECT_ITEM_DATA =
		{"書名/出版社","書名/出版社かな","姓/名","姓/名かな","日付"};

	public HashMap hmSelectItemR;
	private String[] SELECT_ITEM_R_CODE = {"T", "TS", "P", "PS"};
	private String[] SELECT_ITEM_R_DATA =
		{"題名/副題","題名/副題かな","姓/名","姓/名かな"};

	public HashMap hmSelectItemT;
	private String[] SELECT_ITEM_T_CODE = {"T", "TS"};
	private String[] SELECT_ITEM_T_DATA =
		{"演題・副題","かな"};

	public HashMap hmSelectItemP;
	private String[] SELECT_ITEM_P_CODE = {"P", "PS"};
	private String[] SELECT_ITEM_P_DATA =
		{"姓名・所属","姓/名・所属かな"};

	public HashMap hmTitleCategory;
	private String[] TITLE_CATEGORY_CODE = {"T", "P", "K"};
	private String[] TITLE_CATEGORY_DATA =
		{"Title/Subtitle","Program","Source"};

	public HashMap hmNameOrder;
	private String[] NAME_ORDER_CODE = {"A", "B"};
	private String[] NAME_ORDER_DATA =
		{"姓・名の順","名・姓の順"};

	private HashMap hmPlayerPart;
	private String[] PLAYER_PART_CODE =
		{"", "A", "B", "C", "D", "L",
		 "E","F","O",
		 "G","H","I",
		 "J","N","K","0",
		 "P","Q","R","S",
		 "W","X","Y","Z",
		 "T","M","U","V"};
	private String[] PLAYER_PART_DATA =
		{"","著","訳","編","原作","原案",
		 "監修","画","声",
		 "作詞","作曲","編曲",
		 "監督","脚本","脚色","構成",
		 "音楽","音響監督","作画監督","美術監督",
		 "撮影監督","総監督","色彩設計","編集",
		 "キャラデ","製作","制作","著作"};

	public HashMap hmAssociate;
	private String[] ASSOCIATE_CODE = {"B", "A", "E", "C", ""};
	private String[] ASSOCIATE_DATA =
		{"bk1", "amazon", "電子本", "その他", "なし"};

	public HashMap hmStore;
	private String[] STORE_CODE = 
		{"","R","A","W",
		 "M","I",
		 "J","O","G",
		 "K","Y","B","C"};
	private String[] STORE_DATA = 
		{"","ReaderStore","KindleStore","BookWalker",
		 "mora","iTunes",
		 "Jコミ","O'Reilly","GooglePlayBooks",
		 "楽天kobo","Yahoo","Baboo","その他"};

	private HashMap hmMedia;
	private String[] MEDIA_CODE =
		{"","H","S",
		"F","G","Q",
		"C","T","U",
		"I","J",
		"K","L","M","O",
		"P","N","R",
		"B","E","A","D"};
	private String[] MEDIA_DATA =
		{"","Book","eBook",
		"DVD","DVD-RW","Blu-ray",
		"CD","eMusic","HDD/SSD",
		"Software","Hardware",
		"Figure","Model","Goods","Supply",
		"Medicine","Food","Wear",
		"MD","Beta","CC","LD"};

	private HashMap hmBbs;
	private String[] BBS_CODE =
		{"","790101","790103","790117","790118",
		"790119","790120",
		"790104","790106","790108","790110",
		"790112","790113","790114"};
	private String[] BBS_DATA =
		{"","NHK総合","NHK教育","RCC中国放送","広島テレビ",
		"広島ホームテレビ","テレビ新広島",
		"日本テレビ","TBS","フジテレビ","テレビ朝日",
		"テレビ東京","テレビ神奈川","東京MX"};

	private HashMap hmBbsBs;
	private String[] BBS_BS_CODE =
		{"","790205","790207","790211","790209","790210","790213","790216",
		"790217","790218","790221","790222","790208",
		"790305","790301","790302","790315","790312",
		"790313","790314"};
	private String[] BBS_BS_DATA =
		{"","WoWoW","BS1","BS2","BShi","BS Premium","BS Japan","BS-TBS",
		"BSフジ","BS朝日","BS11","Twellv","HiVision",
		"St.GIGA","NHKラジオ第一","NHKラジオ第二","RCCラジオ","ニッポン放送",
		"TBSラジオ","文化放送"};

	private HashMap hmField;
	private String[] FIELD_CODE = {"R","M","D","E","S"};
	private String[] FIELD_DATA = {"落語","音楽","記録","演劇","その他"};

	private HashMap hmSurround;
	private String[] SURROUND_CODE = {"","M","S","B","5"};
	private String[] SURROUND_DATA =
		{"","Monaural","Stereo","Bilingal","5.1ch"};

	private HashMap hmGeneration;
	private String[] GENERATION_CODE = {"","M","C","P"};
	private String[] GENERATION_DATA = {"","Master","Copied","Product"};

	private HashMap hmNR;
	private String[] NR_CODE = {"","B","C"};
	private String[] NR_DATA = {"","Dolby B","Dolby C"};

	public HashMap hmBookView;
	private String[] BOOK_VIEW_CODE = {"0", "1", "2"};
	private String[] BOOK_VIEW_DATA = {"", "書影不要", "書影のみ"};

	public HashMap hmCurrency;
	private String[] CURRENCY_CODE = {"", "JPY", "USD", "EUR"};
	private String[] CURRENCY_DATA = {"", "￥", "＄", "€"};

	public CommonForm() {}	//コンストラクタ

	//TableSelect条件Selectの作成と取得
	public String makeSelectOption(String name, String id, String def) {
		hmSelectOption = new HashMap();
		return buildOptions(name, id, def,
			SELECT_OPTION_CODE, SELECT_OPTION_DATA, hmSelectOption);
	}
	public String getSelectOption(String key) {
		if (hmSelectOption.containsKey(key)) {
			return hmSelectOption.get(key).toString();
		} else {
			return "";
		}
	}

	//TableSelect対象項目の作成と取得
	public String makeSelectItem(String name, String id, String def) {
		hmSelectItem = new HashMap();
		return buildOptions(name, id, def,
			SELECT_ITEM_CODE, SELECT_ITEM_DATA, hmSelectItem);
	}
	public String getSelectItem(String key) {
		if (hmSelectItem.containsKey(key)) {
			return hmSelectItem.get(key).toString();
		} else {
			return "";
		}
	}

	//TableSelect（落語）対象項目の作成と取得
	public String makeSelectItemR(String name, String id, String def) {
		hmSelectItemR = new HashMap();
		return buildOptions(name, id, def,
			SELECT_ITEM_R_CODE, SELECT_ITEM_R_DATA, hmSelectItemR);
	}
	public String getSelectItemR(String key) {
		if (hmSelectItemR.containsKey(key)) {
			return hmSelectItemR.get(key).toString();
		} else {
			return "";
		}
	}

	//TableSelect（演題）対象項目の作成と取得
	public String makeSelectItemT(String name, String id, String def) {
		hmSelectItemT = new HashMap();
		return buildOptions(name, id, def,
			SELECT_ITEM_T_CODE, SELECT_ITEM_T_DATA, hmSelectItemT);
	}
	public String getSelectItemT(String key) {
		if (hmSelectItemT.containsKey(key)) {
			return hmSelectItemT.get(key).toString();
		} else {
			return "";
		}
	}

	//TableSelect（演者）対象項目の作成と取得
	public String makeSelectItemP(String name, String id, String def) {
		hmSelectItemP = new HashMap();
		return buildOptions(name, id, def,
			SELECT_ITEM_P_CODE, SELECT_ITEM_P_DATA, hmSelectItemP);
	}
	public String getSelectItemP(String key) {
		if (hmSelectItemP.containsKey(key)) {
			return hmSelectItemP.get(key).toString();
		} else {
			return "";
		}
	}

	//演題種類の作成と取得
	public String makeTitleCategory(String name, String id, String def) {
		hmTitleCategory = new HashMap();
		return buildOptions(name, id, def,
			TITLE_CATEGORY_CODE, TITLE_CATEGORY_DATA, hmTitleCategory);
	}
	public String getTitleCategory(String key) {
		if (hmTitleCategory.containsKey(key)) {
			return hmTitleCategory.get(key).toString();
		} else {
			return "";
		}
	}

	//演者姓名順
	public String makeNameOrder(String name, String id, String def) {
		hmNameOrder = new HashMap();
		return buildOptions(name, id, def,
			NAME_ORDER_CODE, NAME_ORDER_DATA, hmNameOrder);
	}
	public String getNameOrder(String key) {
		if (hmNameOrder.containsKey(key)) {
			return hmNameOrder.get(key).toString();
		} else {
			return "";
		}
	}

	//演者・著者役割の作成と取得
	public String makePlayerPart(String name, String id, String def) {
		hmPlayerPart = new HashMap();
		return buildOptions(name, id, def,
			PLAYER_PART_CODE, PLAYER_PART_DATA, hmPlayerPart);
	}
	public String getPlayerPart(String key) {
		if (hmPlayerPart.containsKey(key)) {
			return hmPlayerPart.get(key).toString();
		} else {
			return "";
		}
	}

	//bk1・amazonアソシエイトの作成と取得
	public String makeAssociate(String name, String id, String def) {
		hmAssociate = new HashMap();
		return buildOptions(name, id, def,
			ASSOCIATE_CODE, ASSOCIATE_DATA, hmAssociate);
	}
	public String getAssociate(String key) {
		if (hmAssociate.containsKey(key)) {
			return hmAssociate.get(key).toString();
		} else {
			return "";
		}
	}

	//書店の作成と取得
	public String makeStore(String name, String id, String def) {
		hmStore = new HashMap();
		return buildOptions(name, id, def,
			STORE_CODE, STORE_DATA, hmStore);
	}
	public String getStore(String key) {
		if (hmStore.containsKey(key)) {
			return hmStore.get(key).toString();
		} else {
			return "";
		}
	}

	//Mediaの作成と取得
	public String makeMedia(String name, String id, String def) {
		hmMedia = new HashMap();
		return buildOptions(name, id, def,
			MEDIA_CODE, MEDIA_DATA, hmMedia);
	}
	public String getMedia(String key) {
		if (hmMedia.containsKey(key)) {
			return hmMedia.get(key).toString();
		} else {
			return "";
		}
	}

	//放送局の作成と取得
	public String makeBbs(String name, String id, String def) {
		hmBbs = new HashMap();
		return buildOptions(name, id, def,
			BBS_CODE, BBS_DATA, hmBbs);
	}
	public String getBbs(String key) {
		if (hmBbs.containsKey(key)) {
			return hmBbs.get(key).toString();
		} else {
			return "";
		}
	}

	//放送局（衛星）の作成と取得
	public String makeBbsBs(String name, String id, String def) {
		hmBbsBs = new HashMap();
		return buildOptions(name, id, def,
			BBS_BS_CODE, BBS_BS_DATA, hmBbsBs);
	}
	public String getBbsBs(String key) {
		if (hmBbsBs.containsKey(key)) {
			return hmBbsBs.get(key).toString();
		} else {
			return "";
		}
	}

	//演題種別の作成と取得
	public String makeField(String name, String id, String def) {
		hmField = new HashMap();
		return buildOptions(name, id, def,
			FIELD_CODE, FIELD_DATA, hmField);
	}
	public String getField(String key) {
		if (hmField.containsKey(key)) {
			return hmField.get(key).toString();
		} else {
			return "";
		}
	}

	//チャンネル数の作成と取得
	public String makeSurround(String name, String id, String def) {
		hmSurround = new HashMap();
		return buildOptions(name, id, def,
			SURROUND_CODE, SURROUND_DATA, hmSurround);
	}
	public String getSurround(String key) {
		if (hmSurround.containsKey(key)) {
			return hmSurround.get(key).toString();
		} else {
			return "";
		}
	}

	//コピー世代の作成と取得
	public String makeGeneration(String name, String id, String def) {
		hmGeneration = new HashMap();
		return buildOptions(name, id, def,
			GENERATION_CODE, GENERATION_DATA, hmGeneration);
	}
	public String getGeneration(String key) {
		if (hmGeneration.containsKey(key)) {
			return hmGeneration.get(key).toString();
		} else {
			return "";
		}
	}

	//NoiseReductionの作成と取得
	public String makeNR(String name, String id, String def) {
		hmNR = new HashMap();
		return buildOptions(name, id, def,
			NR_CODE, NR_DATA, hmNR);
	}
	public String getNR(String key) {
		if (hmNR.containsKey(key)) {
			return hmNR.get(key).toString();
		} else {
			return "";
		}
	}

	//書影テイブル要否の作成と取得
	public String makeBookView(String name, String id, String def) {
		hmBookView = new HashMap();
		return buildOptions(name, id, def,
			BOOK_VIEW_CODE, BOOK_VIEW_DATA, hmBookView);
	}
	public String getBookView(String key) {
		if (hmBookView.containsKey(key)) {
			return hmBookView.get(key).toString();
		} else {
			return "";
		}
	}

	//通貨テイブル要否の作成と取得
	public String makeCurrency(String name, String id, String def) {
		hmCurrency = new HashMap();
		return buildOptions(name, id, def,
			CURRENCY_CODE, CURRENCY_DATA, hmCurrency);
	}
	public String getCurrency(String key) {
		if (hmCurrency.containsKey(key)) {
			return hmCurrency.get(key).toString();
		} else {
			return "";
		}
	}

	private String buildOptions(String name, String id, String def,
			String[] code, String[] data,
			HashMap hm) {
	//<select>タグとHashMapの作成
		StringBuffer stB = new StringBuffer("<select");
		if (! name.equals("")) {
			stB.append(" name='").append(name).append("'");
		}
		if (! id.equals("")) {
			stB.append(" id='").append(id).append("'");
		}
		stB.append(">");
		for (int i = 0; i < code.length; i++) {
			stB.append("<option value='").append(code[i]).append("'");
			if (code[i].equals(def)) {
				stB.append(" selected");
			}
			stB.append(">").append(data[i]).append("</option>");
			//HashMap
			hm.put(code[i], data[i]);
		}
		stB.append("</select>");
		return stB.toString();
	}
}
