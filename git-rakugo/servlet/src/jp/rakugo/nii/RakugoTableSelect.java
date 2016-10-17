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
public class RakugoTableSelect implements Serializable {
	CommonRakugo cmR = new CommonRakugo();	//共通部品
	private ArrayList result;

	public RakugoTableSelect() {}		//コンストラクタ

	ResultSet rs;

	public void selectDB(String queryWhere, String queryOption) {
		try {
			/*
			ResourceBundle rb=ResourceBundle.getBundle("rakugodb");
			Class.forName(rb.getString("jdbc"));
			Connection db=DriverManager.getConnection(rb.getString("con"));
			*/
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
			q.append(" FROM rakugo_t");
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
	public void selectWK(String queryWhere, String queryOption) {
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
			q.append(" FROM rakugo_w");
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
			RakugoTable rec = new RakugoTable();
			rec.vol_id = cmR.convertNullToString(rs.getString("vol_id"));
			rec.seq = cmR.convertNullToZeroInt(rs.getInt("seq"));
			rec.title_id = cmR.convertNullToString(rs.getString("title_id"));
			rec.title_seq = cmR.convertNullToZeroInt(rs.getInt("title_seq"));
			rec.str_title_seq = cmR.convertNullToString(rs.getString("str_title_seq"));
			rec.str_title_seq_sin = cmR.convertNullToString(rs.getString("str_title_seq_sin"));
			rec.subtitle_id = cmR.convertNullToString(rs.getString("subtitle_id"));
			rec.program_id = cmR.convertNullToString(rs.getString("program_id"));
			rec.player1_id = cmR.convertNullToString(rs.getString("player1_id"));
			rec.player1_sin = cmR.convertNullToString(rs.getString("player1_sin"));
			rec.player2_id = cmR.convertNullToString(rs.getString("player2_id"));
			rec.player2_sin = cmR.convertNullToString(rs.getString("player2_sin"));
			rec.player3_id = cmR.convertNullToString(rs.getString("player3_id"));
			rec.player3_sin = cmR.convertNullToString(rs.getString("player3_sin"));
			rec.player4_sin = cmR.convertNullToString(rs.getString("player4_sin"));
			rec.source_id = cmR.convertNullToString(rs.getString("source_id"));
			try {
				rec.rec_length = rs.getTime("rec_length");
			} catch (Exception e) {
			}
			rec.rec_length_flg = cmR.convertNullToString(rs.getString("rec_length_flg"));
			try {
				rec.rec_date = rs.getDate("rec_date");
			} catch (Exception e) {
			}
			rec.rec_date_flg = cmR.convertNullToString(rs.getString("rec_date_flg"));
			try {
				rec.rec_time = rs.getTime("rec_time");
			} catch (Exception e) {
			}
			rec.rec_time_flg = cmR.convertNullToString(rs.getString("rec_time_flg"));
			rec.category_sin = cmR.convertNullToString(rs.getString("category_sin"));
			rec.media_sin = cmR.convertNullToString(rs.getString("media_sin"));
			rec.sur_sin = cmR.convertNullToString(rs.getString("sur_sin"));
			rec.nr_sin = cmR.convertNullToString(rs.getString("nr_sin"));
			rec.copy_sin = cmR.convertNullToString(rs.getString("copy_sin"));
			rec.memo = cmR.convertNullToString(rs.getString("memo"));
			try {
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
	public String getVolId(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.vol_id;
	}
	public int getSeq(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.seq;
	}
	public String getTitleId(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.title_id;
	}
	public int getTitleSeq(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.title_seq;
	}
	public String getStrTitleSeq(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.str_title_seq;
	}
	public String getStrTitleSeqSin(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.str_title_seq_sin;
	}
	public String getSubtitleId(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.subtitle_id;
	}
	public String getProgramId(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.program_id;
	}
	public String getPlayer1Id(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.player1_id;
	}
	public String getPlayer1Sin(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.player1_sin;
	}
	public String getPlayer2Id(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.player2_id;
	}
	public String getPlayer2Sin(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.player2_sin;
	}
	public String getPlayer3Id(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.player3_id;
	}
	public String getPlayer3Sin(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.player3_sin;
	}
	public String getPlayer4Sin(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.player4_sin;
	}
	public String getSourceId(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.source_id;
	}
	public Time getRecLength(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.rec_length;
	}
	public String getRecLengthFlg(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.rec_length_flg;
	}
	public java.util.Date getRecDate(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.rec_date;
	}
	public String getRecDateFlg(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.rec_date_flg;
	}
	public Time getRecTime(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.rec_time;
	}
	public String getRecTimeFlg(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.rec_time_flg;
	}
	public String getCategorySin(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.category_sin;
	}
	public String getMediaSin(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.media_sin;
	}
	public String getSurSin(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.sur_sin;
	}
	public String getNrSin(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.nr_sin;
	}
	public String getCopySin(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.copy_sin;
	}
	public String getMemo(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.memo;
	}
	public Timestamp getModifyDate(int i) {
		RakugoTable rec = (RakugoTable)result.get(i);
		return rec.modify_date;
	}
}
