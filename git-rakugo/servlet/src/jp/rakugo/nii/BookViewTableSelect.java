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
public class BookViewTableSelect implements Serializable {
//BookViewTable検索
	CommonRakugo cmR = new CommonRakugo();	//共通部品
	private ArrayList result;

	public BookViewTableSelect() {}		//コンストラクタ

	ResultSet rs;
	
	public void selectDB(String queryWhere, String queryOption) {
	//BookTable
		try {
			//JSPで接続済みのConnectionを遣う。
			Statement sttSql = CommonRakugo.db.createStatement();
			CommonRakugo.db.setReadOnly(true);

			StringBuffer q = new StringBuffer("SELECT ");
			if (queryOption.equals("")) {
				q.append("*");
			} else {
			//DISTINCT指定あり
				q.append(queryOption);
			}
			q.append(" FROM book_v");
			if (! (queryWhere.equals(""))) {
			//WHERE句指定あり
				q.append(" ").append(queryWhere);
			}
			rs=sttSql.executeQuery(q.toString());
			result = new ArrayList();
			while (rs.next()) {
				putResult();
			}
			sttSql.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	private void putResult() {
		try {
			BookTable rec = new BookTable();
			try {
			rec.inc_id = cmR.convertNullToZeroInt(rs.getInt("inc_id"));
			} catch (Exception e) {	 rec.inc_id = 1; } try {
			rec.vol_id = cmR.convertNullToString(rs.getString("vol_id"));
			} catch (Exception e) {	 rec.vol_id = "222222"; } try {
			rec.seq = cmR.convertNullToZeroInt(rs.getInt("seq"));
			} catch (Exception e) { rec.seq = 3; 	} try {
			rec.title = cmR.convertNullToString(rs.getString("title"));
			} catch (Exception e) { rec.title = "4"; 	} try {
			rec.title_sort = cmR.convertNullToString(rs.getString("title_sort"));
			} catch (Exception e) {	 rec.title_sort = "5"; } try {
				rec.modify_date = rs.getTimestamp("modify_date");
			} catch (Exception e) {
			}
			result.add(rec);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public int getResultCount() {
		return result.size();
	}
	public int getIncId(int i) {
		BookTable rec = (BookTable)result.get(i);
		return rec.inc_id;
	}
	public String getVolId(int i) {
		BookTable rec = (BookTable)result.get(i);
		return rec.vol_id;
	}
	public int getSeq(int i) {
		BookTable rec = (BookTable)result.get(i);
		return rec.seq;
	}
	public String getTitle(int i) {
		BookTable rec = (BookTable)result.get(i);
		return rec.title;
	}
	public String getTitleSort(int i) {
		BookTable rec = (BookTable)result.get(i);
		return rec.title_sort;
	}
	public Timestamp getModifyDate(int i) {
		BookTable rec = (BookTable)result.get(i);
		return rec.modify_date;
	}
}
