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
public class TitleMasterSelect implements Serializable {
//演題マスタ検索
	CommonRakugo cmR = new CommonRakugo();	//共通部品
	private ArrayList result;

	public TitleMasterSelect() {}		//コンストラクタ

	public void selectDB(String queryWhere, String queryOption) {
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
			q.append(" FROM title_m");
			if (! (queryWhere.equals(""))) {
			//WHERE句指定あり
				q.append(" ").append(queryWhere);
			}
			ResultSet rs=sttSql.executeQuery(q.toString());
			result = new ArrayList();
			while (rs.next()) {
				TitleMaster rec = new TitleMaster();
				rec.id = cmR.convertNullToString(rs.getString("id"));
				rec.title = cmR.convertNullToString(rs.getString("title"));
				rec.title_sort = cmR.convertNullToString(rs.getString("title_sort"));
				rec.subtitle = cmR.convertNullToString(rs.getString("subtitle"));
				rec.subtitle_sort = cmR.convertNullToString(rs.getString("subtitle_sort"));
				rec.category = cmR.convertNullToString(rs.getString("category"));
				rec.seq = cmR.convertNullToZeroInt(rs.getInt("seq"));
				rec.uri = cmR.convertNullToString(rs.getString("uri"));
				rec.memo = cmR.convertNullToString(rs.getString("memo"));
				rec.modify_date = rs.getTimestamp("modify_date");
				result.add(rec);
			}
			sttSql.close();
//			db.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public int getResultCount() {
		return result.size();
	}
	public String getId(int i) {
		TitleMaster rec = (TitleMaster)result.get(i);
		return rec.id;
	}
	public String getTitle(int i) {
		TitleMaster rec = (TitleMaster)result.get(i);
		return rec.title;
	}
	public String getTitleSort(int i) {
		TitleMaster rec = (TitleMaster)result.get(i);
		return rec.title_sort;
	}
	public String getSubtitle(int i) {
		TitleMaster rec = (TitleMaster)result.get(i);
		return rec.subtitle;
	}
	public String getSubtitleSort(int i) {
		TitleMaster rec = (TitleMaster)result.get(i);
		return rec.subtitle_sort;
	}
	public String getCategory(int i) {
		TitleMaster rec = (TitleMaster)result.get(i);
		return rec.category;
	}
	public int getSeq(int i) {
		TitleMaster rec = (TitleMaster)result.get(i);
		return rec.seq;
	}
	public String getUri(int i) {
		TitleMaster rec = (TitleMaster)result.get(i);
		return rec.uri;
	}
	public String getMemo(int i) {
		TitleMaster rec = (TitleMaster)result.get(i);
		return rec.memo;
	}
	public Timestamp getModifyDate(int i) {
		TitleMaster rec = (TitleMaster)result.get(i);
		return rec.modify_date;
	}
}
