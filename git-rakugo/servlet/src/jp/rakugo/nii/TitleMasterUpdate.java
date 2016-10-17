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
public class TitleMasterUpdate implements Serializable {
//演題マスタ更新
	private TitleMaster parRec;

	public TitleMasterUpdate() {}		//コンストラクタ

	public int insertRec() {
		try {
			//JSPで接続済みのConnectionを遣う。
			Statement sttSql = CommonRakugo.db.createStatement();
			CommonRakugo.db.setReadOnly(false);

			StringBuffer q = new StringBuffer("INSERT INTO title_m SET ");
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

			StringBuffer q = new StringBuffer("UPDATE title_m SET ");
			q.append(makeParameter());
			q.append(" WHERE id='").append(parRec.id).append("'");
			int r = sttSql.executeUpdate(q.toString());
			sttSql.close();
			return r;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
	}
	public int deleteRec(String id) {
		try {
			//JSPで接続済みのConnectionを遣う。
			Statement sttSql = CommonRakugo.db.createStatement();
			CommonRakugo.db.setReadOnly(false);

			StringBuffer q = new StringBuffer("DELETE FROM title_m");
			q.append(" WHERE id='").append(id).append("'");
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

		stB.append("id='").append(parRec.id).append("'");
		if (parRec.title != null) {
			stB.append(",title='").append(parRec.title).append("'");
		}
		if (parRec.title_sort != null) {
			stB.append(",title_sort='").append(parRec.title_sort).append("'");
		}
		if (parRec.subtitle != null) {
			stB.append(",subtitle='").append(parRec.subtitle).append("'");
		}
		if (parRec.subtitle_sort != null) {
			stB.append(",subtitle_sort='").append(parRec.subtitle_sort).append("'");
		}
		if (parRec.category != null) {
			stB.append(",category='").append(parRec.category).append("'");
		}
		if (parRec.seq >= 0) {
			stB.append(",seq='").append(String.valueOf(parRec.seq)).append("'");
		}
		if (parRec.uri != null) {
			stB.append(",uri='").append(parRec.uri).append("'");
		}
		if (parRec.memo != null) {
			stB.append(",memo='").append(parRec.memo).append("'");
		}
		return stB.toString();
	}
	public void initRec() {
		parRec = new TitleMaster();
		parRec.id = null;
		parRec.title = null;
		parRec.title_sort = null;
		parRec.subtitle = null;
		parRec.subtitle_sort = null;
		parRec.category = null;
		parRec.seq = -1;
		parRec.uri = null;
		parRec.memo = null;
	}
	public void setId(String s) {
		parRec.id = s;
	}
	public void setTitle(String s) {
		parRec.title = s;
	}
	public void setTitleSort(String s) {
		parRec.title_sort = s;
	}
	public void setSubtitle(String s) {
		parRec.subtitle = s;
	}
	public void setSubtitleSort(String s) {
		parRec.subtitle_sort = s;
	}
	public void setCategory(String s) {
		parRec.category = s;
	}
	public void setSeq(int i) {
		parRec.seq = i;
	}
	public void setUri(String s) {
		parRec.uri = s;
	}
	public void setMemo(String s) {
		parRec.memo = s;
	}
}
