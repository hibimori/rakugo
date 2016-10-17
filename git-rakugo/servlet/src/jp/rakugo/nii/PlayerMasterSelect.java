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
public class PlayerMasterSelect implements Serializable {
//演者マスタ検索
	CommonRakugo cmR = new CommonRakugo();	//共通部品
	private ArrayList result;

	public PlayerMasterSelect() {}		//コンストラクタ

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
			q.append(" FROM player_m");
			if (! (queryWhere.equals(""))) {
			//WHERE句指定あり
				q.append(" ").append(queryWhere);
			}
			ResultSet rs=sttSql.executeQuery(q.toString());
			result = new ArrayList();
			while (rs.next()) {
				PlayerMaster rec = new PlayerMaster();
				rec.id = cmR.convertNullToString(rs.getString("id"));
				rec.last_name = cmR.convertNullToString(rs.getString("last_name"));
				rec.first_name = cmR.convertNullToString(rs.getString("first_name"));
				rec.family_name = cmR.convertNullToString(rs.getString("family_name"));
				rec.last_sort = cmR.convertNullToString(rs.getString("last_sort"));
				rec.first_sort = cmR.convertNullToString(rs.getString("first_sort"));
				rec.family_sort = cmR.convertNullToString(rs.getString("family_sort"));
				rec.full_name = cmR.convertNullToString(rs.getString("full_name"));
				rec.name_flg = cmR.convertNullToString(rs.getString("name_flg"));
				rec.name_seq = cmR.convertNullToZeroInt(rs.getInt("name_seq"));
				rec.relate_id = cmR.convertNullToString(rs.getString("relate_id"));
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
		PlayerMaster rec = (PlayerMaster)result.get(i);
		return rec.id;
	}
	public String getLastName(int i) {
		PlayerMaster rec = (PlayerMaster)result.get(i);
		return rec.last_name;
	}
	public String getFirstName(int i) {
		PlayerMaster rec = (PlayerMaster)result.get(i);
		return rec.first_name;
	}
	public String getFamilyName(int i) {
		PlayerMaster rec = (PlayerMaster)result.get(i);
		return rec.family_name;
	}
	public String getLastSort(int i) {
		PlayerMaster rec = (PlayerMaster)result.get(i);
		return rec.last_sort;
	}
	public String getFirstSort(int i) {
		PlayerMaster rec = (PlayerMaster)result.get(i);
		return rec.first_sort;
	}
	public String getFamilySort(int i) {
		PlayerMaster rec = (PlayerMaster)result.get(i);
		return rec.family_sort;
	}
	public String getFullName(int i) {
		PlayerMaster rec = (PlayerMaster)result.get(i);
		return rec.full_name;
	}
	public String getNameFlg(int i) {
		PlayerMaster rec = (PlayerMaster)result.get(i);
		return rec.name_flg;
	}
	public int getNameSeq(int i) {
		PlayerMaster rec = (PlayerMaster)result.get(i);
		return rec.name_seq;
	}
	public String getRelateId(int i) {
		PlayerMaster rec = (PlayerMaster)result.get(i);
		return rec.relate_id;
	}
	public String getUri(int i) {
		PlayerMaster rec = (PlayerMaster)result.get(i);
		return rec.uri;
	}
	public String getMemo(int i) {
		PlayerMaster rec = (PlayerMaster)result.get(i);
		return rec.memo;
	}
	public Timestamp getModifyDate(int i) {
		PlayerMaster rec = (PlayerMaster)result.get(i);
		return rec.modify_date;
	}
}
