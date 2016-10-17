/**
 *
 */
package jp.rakugo.nii;

import java.io.*;
import java.util.*;
import java.sql.*;

/**
 * @author nii
 *
 */
public class KanaMasterSelect implements Serializable {
//かなマスタ検索
	CommonRakugo cmR = new CommonRakugo();	//共通部品
	private ArrayList result;

	public KanaMasterSelect() {}		//コンストラクタ

	private ResultSet rs;
	private ResultSetMetaData rsmd;

	public void selectDB(String queryWhere, String queryOption) {
		try {
			//JSPで接続済みのConnectionを遣う。
			Statement sttSql = CommonRakugo.db.createStatement();
			CommonRakugo.db.setReadOnly(true);					/* 読み取り専用宣言 */

			StringBuffer q = new StringBuffer("SELECT ");
			if (queryOption.equals("")) {
				q.append("*");
			} else {
			//DISTINCT指定あり
				q.append(queryOption);
			}
			q.append(" FROM kana_m");
			if (! (queryWhere.equals(""))) {
			//WHERE句指定あり
				q.append(" ").append(queryWhere);
			}
			rs=sttSql.executeQuery(q.toString());
			result = new ArrayList();
			while (rs.next()) {
				KanaMaster rec = new KanaMaster();
				rec.inc_id = cmR.convertNullToZeroInt(rs.getInt("inc_id"));
				rec.letters = cmR.convertNullToString(rs.getString("letters"));
				rec.kana = cmR.convertNullToString(rs.getString("kana"));
				rec.cnt = cmR.convertNullToZeroInt(rs.getInt("cnt"));
				rec.memo = cmR.convertNullToString(rs.getString("memo"));
				rec.modify_date = rs.getTimestamp("modify_date");
				result.add(rec);
			}
			sttSql.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public int getResultCount() {
		return result.size();
	}
	public int getResultColumnCount() {
		try {
			rsmd = rs.getMetaData();
			return rsmd.getColumnCount();
		} catch (Exception e) {
			return 0;
		}
	}
	public int getResultColumnType(int i) {
		try {
			return rsmd.getColumnType(i);
		} catch (Exception e) {
			return 0;
		}
	}
	public int getIncId(int i) {
		KanaMaster rec = (KanaMaster)result.get(i);
		return rec.inc_id;
	}
	public String getLetters(int i) {
		KanaMaster rec = (KanaMaster)result.get(i);
		return rec.letters;
	}
	public String getKana(int i) {
		KanaMaster rec = (KanaMaster)result.get(i);
		return rec.kana;
	}
	public int getCnt(int i) {
		KanaMaster rec = (KanaMaster)result.get(i);
		return rec.cnt;
	}
	public String getMemo(int i) {
		KanaMaster rec = (KanaMaster)result.get(i);
		return rec.memo;
	}
	public Timestamp getModifyDate(int i) {
		KanaMaster rec = (KanaMaster)result.get(i);
		return rec.modify_date;
	}
}
