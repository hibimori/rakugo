/**
 *
 */
package jp.rakugo.nii;

import java.io.*;
import java.sql.*;
import java.text.*;

/**
 * @author nii
 *
 */
public class BookViewTableUpdate implements Serializable {
//書籍テイブル更新
	private BookTable parRec;

	public BookViewTableUpdate() {}		//コンストラクタ

	public int insertRec() {
		try {
			//JSPで接続済みのConnectionを遣う。
			Statement sttSql = CommonRakugo.db.createStatement();
			CommonRakugo.db.setReadOnly(false);

			StringBuffer q = new StringBuffer("INSERT INTO book_v SET ");
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

			StringBuffer q = new StringBuffer("UPDATE book_v SET ");
			q.append(makeParameter());
			q.append(" WHERE vol_id='").append(parRec.vol_id).append("'");
			q.append(" AND seq='").append(String.valueOf(parRec.seq)).append("'");
			int r =sttSql.executeUpdate(q.toString());
			sttSql.close();
			return r;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
	}
	public int deleteRec() {
		try {
			//JSPで接続済みのConnectionを遣う。
			Statement sttSql = CommonRakugo.db.createStatement();
			CommonRakugo.db.setReadOnly(false);

			StringBuffer q = new StringBuffer("DELETE FROM book_v");
			String s = makeDelParameter();
			if (! s.equals("")) {
				//項目指定なければ全件削除
				q.append(" WHERE ").append(s);
			}
			int r = sttSql.executeUpdate(q.toString());
			sttSql.close();
			return r;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
	}
	private String makeParameter() {
		StringBuffer stB = new StringBuffer("");

		if (parRec.inc_id >= 0) {
			if (! stB.toString().equals("")) { stB.append(","); }
			stB.append("inc_id='").append(String.valueOf(parRec.inc_id)).append("'");
		}
		if (parRec.vol_id != null) {
			if (! stB.toString().equals("")) { stB.append(","); }
			stB.append("vol_id='").append(parRec.vol_id).append("'");
		}
		if (parRec.seq >= 0) {
			if (! stB.toString().equals("")) { stB.append(","); }
			stB.append("seq='").append(String.valueOf(parRec.seq)).append("'");
		}
		if (parRec.title_sort != null) {
			if (! stB.toString().equals("")) { stB.append(","); }
			stB.append("title_sort='").append(parRec.title_sort).append("'");
		}
		if (parRec.title_seq >= 0) {
			if (! stB.toString().equals("")) { stB.append(","); }
			stB.append("title_seq='").append(String.valueOf(parRec.title_seq)).append("'");
		}
		return stB.toString();
	}
	private String makeDelParameter() {
		StringBuffer stB = new StringBuffer("");

		if (parRec.inc_id >= 0) {
			if (! stB.toString().equals("")) { stB.append(" AND "); }
			stB.append("inc_id='").append(String.valueOf(parRec.inc_id)).append("'");
		}
		if (parRec.vol_id != null) {
			if (! stB.toString().equals("")) { stB.append(" AND "); }
			stB.append("vol_id='").append(parRec.vol_id).append("'");
		}
		if (parRec.seq >= 0) {
			if (! stB.toString().equals("")) { stB.append(" AND "); }
			stB.append("seq='").append(String.valueOf(parRec.seq)).append("'");
		}
		if (parRec.modify_date != null) {
		//更新日（削除のみ）は"<"条件
			if (! stB.toString().equals("")) { stB.append(" AND "); }
			SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");
			stB.append("modify_date < '").append(dateFmt.format(parRec.modify_date)).append("'");
		}
		return stB.toString();
	}
	public void initRec() {
		parRec = new BookTable();
		parRec.inc_id = -1;
		parRec.vol_id = null;
		parRec.seq = -1;
		parRec.title_sort = null;
		parRec.title_seq = -1;
		parRec.modify_date = null;
	}
	public void setIncId(int i) {
		parRec.inc_id = i;
	}
	public void setVolId(String s) {
		parRec.vol_id = s;
	}
	public void setSeq(int i) {
		parRec.seq = i;
	}
	public void setTitleSort(String s) {
		parRec.title_sort = s;
	}
	public void setTitleSeq(int i) {
		parRec.title_seq = i;
	}
	public void setModifyDate(Timestamp d) {
		parRec.modify_date = d;
	}
}
