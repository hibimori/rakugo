/**
 *
 */
package jp.rakugo.nii;

import java.io.*;
import java.sql.*;

/**
 * @author nii
 *
 */
public class KanaMasterUpdate implements Serializable {
//かなマスタ更新
	private KanaMaster parRec;

	public KanaMasterUpdate() {}		//コンストラクタ

	public int insertRec() {
		try {
			//JSPで接続済みのConnectionを遣う。
			Statement sttSql = CommonRakugo.db.createStatement();
			CommonRakugo.db.setReadOnly(false);

			StringBuffer q = new StringBuffer("INSERT INTO kana_m SET ");
			q.append(makeParameter());
			int r = sttSql.executeUpdate(q.toString());
			sttSql.close();
			return r;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
	}
	public int updateRec() {
		try {
			//JSPで接続済みのConnectionを遣う。
			Statement sttSql = CommonRakugo.db.createStatement();
			CommonRakugo.db.setReadOnly(false);

			StringBuffer q = new StringBuffer("UPDATE kana_m SET ");
			q.append(makeParameter());
			q.append(" WHERE letters='").append(parRec.letters).append("'");
			q.append(" AND kana='").append(parRec.kana).append("'");
			int r = sttSql.executeUpdate(q.toString());
			sttSql.close();
			return r;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
	}
	public int deleteRec(String letters, String kana) {
		try {
			//JSPで接続済みのConnectionを遣う。
			Statement sttSql = CommonRakugo.db.createStatement();
			CommonRakugo.db.setReadOnly(false);

			StringBuffer q = new StringBuffer("DELETE FROM kana_m");
			q.append(" WHERE letters='").append(letters).append("'");
			q.append(" AND kana='").append(kana).append("'");
			int r = sttSql.executeUpdate(q.toString());
			sttSql.close();
			return r;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
	}
	private String makeParameter() {
		StringBuffer stB = new StringBuffer();

		if (parRec.letters != null) {
			stB.append("letters='").append(parRec.letters).append("'");
		}
		if (parRec.kana != null) {
			stB.append(",kana='").append(parRec.kana).append("'");
		}
		if (parRec.cnt >= 0) {
			stB.append(",cnt='").append(String.valueOf(parRec.cnt)).append("'");
		}
		if (parRec.memo != null) {
			stB.append(",memo='").append(parRec.memo).append("'");
		}
		return stB.toString();
	}
	public void initRec() {
		parRec = new KanaMaster();
		parRec.letters = null;
		parRec.kana = null;
		parRec.cnt = -1;
		parRec.memo = null;
	}
	public void setLetters(String s) {
		parRec.letters = s;
	}
	public void setKana(String s) {
		parRec.kana = s;
	}
	public void setCnt(int i) {
		parRec.cnt = i;
	}
	public void setMemo(String s) {
		parRec.memo = s;
	}
}
