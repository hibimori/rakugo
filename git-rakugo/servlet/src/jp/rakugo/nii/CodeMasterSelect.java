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
public class CodeMasterSelect implements Serializable {
//演者マスタ検索
	CommonRakugo cmR = new CommonRakugo();	//共通部品
	private ArrayList result;

	public CodeMasterSelect() {}		//コンストラクタ

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
			q.append(" FROM code_m");
			if (! (queryWhere.equals(""))) {
			//WHERE句指定あり
				q.append(" ").append(queryWhere);
			}
			ResultSet rs=sttSql.executeQuery(q.toString());
			result = new ArrayList();
			while (rs.next()) {
				CodeMaster rec = new CodeMaster();
				rec.vol_id = cmR.convertNullToString(rs.getString("vol_id"));
				rec.seq = cmR.convertNullToZeroInt(rs.getInt("seq"));
				rec.code_0 = cmR.convertNullToString(rs.getString("code_0"));
				rec.code_1 = cmR.convertNullToString(rs.getString("code_1"));
				rec.code_2 = cmR.convertNullToString(rs.getString("code_2"));
				rec.code_3 = cmR.convertNullToString(rs.getString("code_3"));
				rec.int_0 = cmR.convertNullToZeroInt(rs.getInt("int_0"));
				rec.int_1 = cmR.convertNullToZeroInt(rs.getInt("int_1"));
				rec.int_2 = cmR.convertNullToZeroInt(rs.getInt("int_2"));
				rec.int_3 = cmR.convertNullToZeroInt(rs.getInt("int_3"));
				rec.datetime_0 = rs.getDate("datetime_0");
				rec.datetime_1 = rs.getDate("datetime_1");
				rec.datetime_2 = rs.getDate("datetime_2");
				rec.datetime_3 = rs.getDate("datetime_3");
				rec.value_0 = cmR.convertNullToString(rs.getString("value_0"));
				rec.value_1 = cmR.convertNullToString(rs.getString("value_1"));
				rec.value_2 = cmR.convertNullToString(rs.getString("value_2"));
				rec.value_3 = cmR.convertNullToString(rs.getString("value_3"));
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
	public String getVolId(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.vol_id;
	}
	public int getSeq(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.seq;
	}
	public String getCode0(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.code_0;
	}
	public String getCode1(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.code_1;
	}
	public String getCode2(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.code_2;
	}
	public String getCode3(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.code_3;
	}
	public int getInt0(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.int_0;
	}
	public int getInt1(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.int_1;
	}
	public int getInt2(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.int_2;
	}
	public int getInt3(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.int_3;
	}
	public java.util.Date getDatetime0(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.datetime_0;
	}
	public java.util.Date getDatetime1(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.datetime_1;
	}
	public java.util.Date getDatetime2(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.datetime_2;
	}
	public java.util.Date getDatetime3(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.datetime_3;
	}
	public String getValue0(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.value_0;
	}
	public String getValue1(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.value_1;
	}
	public String getValue2(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.value_2;
	}
	public String getValue3(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.value_3;
	}
	public String getMemo(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.memo;
	}
	public Timestamp getModifyDate(int i) {
		CodeMaster rec = (CodeMaster)result.get(i);
		return rec.modify_date;
	}
}
