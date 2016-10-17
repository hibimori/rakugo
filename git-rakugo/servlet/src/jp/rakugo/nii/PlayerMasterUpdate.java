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
public class PlayerMasterUpdate implements Serializable {
//演者マスタ更新
	private PlayerMaster parRec;

	public PlayerMasterUpdate() {}		//コンストラクタ

	public int insertRec() {
		try {
			//JSPで接続済みのConnectionを遣う。
			Statement sttSql = CommonRakugo.db.createStatement();
			CommonRakugo.db.setReadOnly(false);

			StringBuffer q = new StringBuffer("INSERT INTO player_m SET ");
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

			StringBuffer q = new StringBuffer("UPDATE player_m SET ");
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

			StringBuffer q = new StringBuffer("DELETE FROM player_m");
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
		if (parRec.last_name != null) {
			stB.append(",last_name='").append(parRec.last_name).append("'");
		}
		if (parRec.first_name != null) {
			stB.append(",first_name='").append(parRec.first_name).append("'");
		}
		if (parRec.family_name != null) {
			stB.append(",family_name='").append(parRec.family_name).append("'");
		}
		if (parRec.last_sort != null) {
			stB.append(",last_sort='").append(parRec.last_sort).append("'");
		}
		if (parRec.first_sort != null) {
			stB.append(",first_sort='").append(parRec.first_sort).append("'");
		}
		if (parRec.family_sort != null) {
			stB.append(",family_sort='").append(parRec.family_sort).append("'");
		}
		if (parRec.full_name != null) {
			stB.append(",full_name='").append(parRec.full_name).append("'");
		}
		if (parRec.name_flg != null) {
			stB.append(",name_flg='").append(parRec.name_flg).append("'");
		}
		if (parRec.name_seq >= 0) {
			stB.append(",name_seq='").append(String.valueOf(parRec.name_seq)).append("'");
		}
		if (parRec.relate_id != null) {
			stB.append(",relate_id='").append(parRec.relate_id).append("'");
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
		parRec = new PlayerMaster();
		parRec.id = null;
		parRec.last_name = null;
		parRec.first_name = null;
		parRec.family_name = null;
		parRec.last_sort = null;
		parRec.first_sort = null;
		parRec.family_sort = null;
		parRec.full_name = null;
		parRec.name_flg = null;
		parRec.name_seq = -1;
		parRec.relate_id = null;
		parRec.uri = null;
		parRec.memo = null;
	}
	public void setId(String s) {
		parRec.id = s;
	}
	public void setLastName(String s) {
		parRec.last_name = s;
	}
	public void setFirstName(String s) {
		parRec.first_name = s;
	}
	public void setFamilyName(String s) {
		parRec.family_name = s;
	}
	public void setLastSort(String s) {
		parRec.last_sort = s;
	}
	public void setFirstSort(String s) {
		parRec.first_sort = s;
	}
	public void setFamilySort(String s) {
		parRec.family_sort = s;
	}
	public void setFullName(String s) {
		parRec.full_name = s;
	}
	public void setNameFlg(String s) {
		parRec.name_flg = s;
	}
	public void setNameSeq(int i) {
		parRec.name_seq = i;
	}
	public void setRelateId(String s) {
		parRec.relate_id = s;
	}
	public void setUri(String s) {
		parRec.uri = s;
	}
	public void setMemo(String s) {
		parRec.memo = s;
	}
}
