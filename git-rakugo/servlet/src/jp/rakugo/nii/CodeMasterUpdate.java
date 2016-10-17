/**
 *
 */
package jp.rakugo.nii;

import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;

/**
 * @author nii
 *
 */
public class CodeMasterUpdate implements Serializable {
//コードマスタ更新
	private CodeMaster parRec;
	private SimpleDateFormat dateFmtH = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	public CodeMasterUpdate() {}		//コンストラクタ

	public int insertRec() {
		try {
			//JSPで接続済みのConnectionを遣う。
			Statement sttSql = CommonRakugo.db.createStatement();
			CommonRakugo.db.setReadOnly(false);

			StringBuffer q = new StringBuffer("INSERT INTO code_m SET ");
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

			StringBuffer q = new StringBuffer("UPDATE code_m SET ");
			q.append(makeParameter());
			q.append(" WHERE vol_id='").append(parRec.vol_id).append("'");
			int r = sttSql.executeUpdate(q.toString());
			sttSql.close();
			return r;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
	}
	public int deleteRec(String id, int seq) {
		try {
			//JSPで接続済みのConnectionを遣う。
			Statement sttSql = CommonRakugo.db.createStatement();
			CommonRakugo.db.setReadOnly(false);

			StringBuffer q = new StringBuffer("DELETE FROM code_m");
			q.append(" WHERE vol_id='").append(id).append("'");
			q.append(" AND seq='").append(seq).append("'");
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

		if (parRec.vol_id != null) {
			stB.append("vol_id='").append(parRec.vol_id).append("'");
		}
		if (parRec.seq >= 0) {
			stB.append(",seq='").append(parRec.seq).append("'");
		}
		if (parRec.code_0 != null) {
			stB.append(",code_0='").append(parRec.code_0).append("'");
		}
		if (parRec.code_1 != null) {
			stB.append(",code_1='").append(parRec.code_1).append("'");
		}
		if (parRec.code_2 != null) {
			stB.append(",code_2='").append(parRec.code_2).append("'");
		}
		if (parRec.code_3 != null) {
			stB.append(",code_3='").append(parRec.code_3).append("'");
		}
		if (parRec.int_0 >= 0) {
			stB.append(",int_0='").append(String.valueOf(parRec.int_0)).append("'");
		}
		if (parRec.int_1 >= 0) {
			stB.append(",int_1='").append(String.valueOf(parRec.int_1)).append("'");
		}
		if (parRec.int_2 >= 0) {
			stB.append(",int_2='").append(String.valueOf(parRec.int_2)).append("'");
		}
		if (parRec.int_3 >= 0) {
			stB.append(",int_3='").append(String.valueOf(parRec.int_3)).append("'");
		}
		if (parRec.datetime_0 != null) {
			stB.append(",datetime_0='");
			try {
				stB.append(dateFmtH.format(parRec.datetime_0));
			} catch (Exception e) {
				stB.append("0000-00-00 00:00:00");
			}
			stB.append("'");
		}
		if (parRec.datetime_1 != null) {
			stB.append(",datetime_1='");
			try {
				stB.append(dateFmtH.format(parRec.datetime_1));
			} catch (Exception e) {
				stB.append("0000-00-00 00:00:00");
			}
			stB.append("'");
		}
		if (parRec.datetime_2 != null) {
			stB.append(",datetime_2='");
			try {
				stB.append(dateFmtH.format(parRec.datetime_2));
			} catch (Exception e) {
				stB.append("0000-00-00 00:00:00");
			}
			stB.append("'");
		}
		if (parRec.datetime_3 != null) {
			stB.append(",datetime_3='");
			try {
				stB.append(dateFmtH.format(parRec.datetime_3));
			} catch (Exception e) {
				stB.append("0000-00-00 00:00:00");
			}
			stB.append("'");
		}
		if (parRec.value_0 != null) {
			stB.append(",value_0='").append(parRec.value_0).append("'");
		}
		if (parRec.value_1 != null) {
			stB.append(",value_1='").append(parRec.value_1).append("'");
		}
		if (parRec.value_2 != null) {
			stB.append(",value_2='").append(parRec.value_2).append("'");
		}
		if (parRec.value_3 != null) {
			stB.append(",value_0='").append(parRec.value_3).append("'");
		}
		if (parRec.memo != null) {
			stB.append(",memo='").append(parRec.memo).append("'");
		}
		return stB.toString();
	}
	public void initRec() {
		parRec = new CodeMaster();
		parRec.vol_id = null;
		parRec.seq = -1;
		parRec.code_0 = null;
		parRec.code_1 = null;
		parRec.code_2 = null;
		parRec.code_3 = null;
		parRec.int_0 = -1;
		parRec.int_1 = -1;
		parRec.int_2 = -1;
		parRec.int_3 = -1;
		parRec.datetime_0 = null;
		parRec.datetime_1 = null;
		parRec.datetime_2 = null;
		parRec.datetime_3 = null;
		parRec.value_0 = null;
		parRec.value_1 = null;
		parRec.value_2 = null;
		parRec.value_3 = null;
		parRec.memo = null;
	}
	public void setVolId(String s) {
		parRec.vol_id = s;
	}
	public void setSeq(int i) {
		parRec.seq = i;
	}
	public void setCode0(String s) {
		parRec.code_0 = s;
	}
	public void setCode1(String s) {
		parRec.code_1 = s;
	}
	public void setCode2(String s) {
		parRec.code_2 = s;
	}
	public void setCode3(String s) {
		parRec.code_3 = s;
	}
	public void setInt0(int i) {
		parRec.int_0 = i;
	}
	public void setInt1(int i) {
		parRec.int_1 = i;
	}
	public void setInt2(int i) {
		parRec.int_2 = i;
	}
	public void setInt3(int i) {
		parRec.int_3 = i;
	}
	public void setDatetime0(java.util.Date d) {
		parRec.datetime_0 = d;
	}
	public void setDatetime1(java.util.Date d) {
		parRec.datetime_1 = d;
	}
	public void setDatetime2(java.util.Date d) {
		parRec.datetime_2 = d;
	}
	public void setDatetime3(java.util.Date d) {
		parRec.datetime_3 = d;
	}
	public void setValue0(String s) {
		parRec.value_0 = s;
	}
	public void setValue1(String s) {
		parRec.value_1 = s;
	}
	public void setValue2(String s) {
		parRec.value_2 = s;
	}
	public void setValue3(String s) {
		parRec.value_3 = s;
	}
	public void setMemo(String s) {
		parRec.memo = s;
	}
}
