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
public class RakugoWorkTableUpdate implements Serializable {
//書籍ワークテイブル更新
	private RakugoTable parRec;
	private SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");
	private SimpleDateFormat dateFmtH = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private SimpleDateFormat timeFmt = new SimpleDateFormat("HH:mm:ss");

	public RakugoWorkTableUpdate() {}		//コンストラクタ

	public int insertRec() {
		try {
			//JSPで接続済みのConnectionを遣う。
			Statement sttSql = CommonRakugo.db.createStatement();
			CommonRakugo.db.setReadOnly(false);

			StringBuffer q = new StringBuffer("INSERT INTO rakugo_w SET ");
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

			StringBuffer q = new StringBuffer("UPDATE rakugo_w SET ");
			q.append(makeParameter());
			q.append(" WHERE vol_id='").append(parRec.vol_id).append("'");
			q.append(" AND seq='").append(String.valueOf(parRec.seq)).append("'");
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

			StringBuffer q = new StringBuffer("DELETE FROM rakugo_w");
			if ((! id.equals("")) &&
			    (seq < 0)) {
				//id, seq指定なければ全件削除
				q.append(" WHERE vol_id='").append(id).append("'");
				q.append(" AND seq='").append(seq).append("'");
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
		StringBuffer stB = new StringBuffer();
		String s;

		stB.append("vol_id='").append(parRec.vol_id).append("'");
		if (parRec.seq >= 0) {
			stB.append(",seq='").append(String.valueOf(parRec.seq)).append("'");
		}
		if (parRec.title_id != null) {
			stB.append(",title_id='").append(parRec.title_id).append("'");
		}
		if (parRec.title_seq >= 0) {
			stB.append(",title_seq='").append(String.valueOf(parRec.title_seq)).append("'");
		}
		if (parRec.str_title_seq != null) {
			stB.append(",str_title_seq='").append(parRec.str_title_seq).append("'");
		}
		if (parRec.str_title_seq_sin != null) {
			stB.append(",str_title_seq_sin='").append(parRec.str_title_seq_sin).append("'");
		}
		if (parRec.subtitle_id != null) {
			stB.append(",subtitle_id='").append(parRec.subtitle_id).append("'");
		}
		if (parRec.program_id != null) {
			stB.append(",program_id='").append(parRec.program_id).append("'");
		}
		if (parRec.player1_id != null) {
			stB.append(",player1_id='").append(parRec.player1_id).append("'");
		}
		if (parRec.player1_sin != null) {
			stB.append(",player1_sin='").append(parRec.player1_sin).append("'");
		}
		if (parRec.player2_id != null) {
			stB.append(",player2_id='").append(parRec.player2_id).append("'");
		}
		if (parRec.player2_sin != null) {
			stB.append(",player2_sin='").append(parRec.player2_sin).append("'");
		}
		if (parRec.player3_id != null) {
			stB.append(",player3_id='").append(parRec.player3_id).append("'");
		}
		if (parRec.player3_sin != null) {
			stB.append(",player3_sin='").append(parRec.player3_sin).append("'");
		}
		if (parRec.player4_sin != null) {
			stB.append(",player4_sin='").append(parRec.player4_sin).append("'");
		}
		if (parRec.source_id != null) {
			stB.append(",source_id='").append(parRec.source_id).append("'");
		}
		if (parRec.sortT != null) {
			stB.append(",sortT='").append(parRec.sortT).append("'");
		}
		if (parRec.sortP != null) {
			stB.append(",sortP='").append(parRec.sortP).append("'");
		}
		if (parRec.rec_length != null) {
			try {
				s = timeFmt.format(parRec.rec_length);
			} catch (Exception e) {
				s = "00:00:00";
			}
			stB.append(",rec_length='").append(s).append("'");
		}
		if (parRec.rec_length_flg != null) {
			stB.append(",rec_length_flg='").append(parRec.rec_length_flg).append("'");
		}
		if (parRec.rec_date != null) {
			try {
				s = dateFmt.format(parRec.rec_date);
			} catch (Exception e) {
				s = "0000-00-00";
			}
			stB.append(",rec_date='").append(s).append("'");
		}
		if (parRec.rec_date_flg != null) {
			stB.append(",rec_date_flg='").append(parRec.rec_date_flg).append("'");
		}
		if (parRec.rec_time != null) {
			try {
				s = timeFmt.format(parRec.rec_time);
			} catch (Exception e) {
				s = "00:00:00";
			}
			stB.append(",rec_time='").append(s).append("'");
		}
		if (parRec.rec_time_flg != null) {
			stB.append(",rec_time_flg='").append(parRec.rec_time_flg).append("'");
		}
		if (parRec.category_sin != null) {
			stB.append(",category_sin='").append(parRec.category_sin).append("'");
		}
		if (parRec.media_sin != null) {
			stB.append(",media_sin='").append(parRec.media_sin).append("'");
		}
		if (parRec.sur_sin != null) {
			stB.append(",sur_sin='").append(parRec.sur_sin).append("'");
		}
		if (parRec.nr_sin != null) {
			stB.append(",nr_sin='").append(parRec.nr_sin).append("'");
		}
		if (parRec.copy_sin != null) {
			stB.append(",copy_sin='").append(parRec.copy_sin).append("'");
		}
		if (parRec.memo != null) {
			stB.append(",memo='").append(parRec.memo).append("'");
		}
		if (parRec.modify_date != null) {
			try {
				s = dateFmtH.format(parRec.modify_date);
				stB.append(",modify_date='").append(s).append("'");
			} catch (Exception e) {
			}
		}
		return stB.toString();
	}
	public void initRec() {
		parRec = new RakugoTable();
		parRec.vol_id = null;
		parRec.seq = -1;
		parRec.title_id = null;
		parRec.title_seq = -1;
		parRec.str_title_seq = null;
		parRec.str_title_seq_sin = null;
		parRec.subtitle_id = null;
		parRec.program_id = null;
		parRec.player1_id = null;
		parRec.player1_sin = null;
		parRec.player2_id = null;
		parRec.player2_sin = null;
		parRec.player3_id = null;
		parRec.player3_sin = null;
		parRec.player4_sin = null;
		parRec.source_id = null;
		parRec.sortT = null;
		parRec.sortP = null;
		parRec.rec_length = null;
		parRec.rec_length_flg = null;
		parRec.rec_date = null;
		parRec.rec_date_flg = null;
		parRec.rec_time = null;
		parRec.rec_time_flg = null;
		parRec.category_sin = null;
		parRec.media_sin = null;
		parRec.sur_sin = null;
		parRec.nr_sin = null;
		parRec.copy_sin = null;
		parRec.memo = null;
		parRec.modify_date = null;
	}
	public void setVolId(String s) {
		parRec.vol_id = s;
	}
	public void setSeq(int i) {
		parRec.seq = i;
	}
	public void setTitleId(String s) {
		parRec.title_id = s;
	}
	public void setTitleSeq(int i) {
		parRec.title_seq = i;
	}
	public void setStrTitleSeq(String s) {
		parRec.str_title_seq = s;
	}
	public void setStrTitleSeqSin(String s) {
		parRec.str_title_seq_sin = s;
	}
	public void setSubtitleId(String s) {
		parRec.subtitle_id = s;
	}
	public void setProgramId(String s) {
		parRec.program_id = s;
	}
	public void setPlayer1Id(String s) {
		parRec.player1_id = s;
	}
	public void setPlayer1Sin(String s) {
		parRec.player1_sin = s;
	}
	public void setPlayer2Id(String s) {
		parRec.player2_id = s;
	}
	public void setPlayer2Sin(String s) {
		parRec.player2_sin = s;
	}
	public void setPlayer3Id(String s) {
		parRec.player3_id = s;
	}
	public void setPlayer3Sin(String s) {
		parRec.player3_sin = s;
	}
	public void setPlayer4Sin(String s) {
		parRec.player4_sin = s;
	}
	public void setSourceId(String s) {
		parRec.source_id = s;
	}
	public void setSortT(String s) {
		parRec.sortT = s;
	}
	public void setSortP(String s) {
		parRec.sortP = s;
	}
	public void setRecLength(Time t) {
		parRec.rec_length = t;
	}
	public void setRecLengthFlg(String s) {
		parRec.rec_length_flg = s;
	}
	public void setRecDate(java.util.Date d) {
		parRec.rec_date = d;
	}
	public void setRecDateFlg(String s) {
		parRec.rec_date_flg = s;
	}
	public void setRecTime(Time t) {
		parRec.rec_time = t;
	}
	public void setRecTimeFlg(String s) {
		parRec.rec_time_flg = s;
	}
	public void setCategorySin(String s) {
		parRec.category_sin = s;
	}
	public void setMediaSin(String s) {
		parRec.media_sin = s;
	}
	public void setSurSin(String s) {
		parRec.sur_sin = s;
	}
	public void setNrSin(String s) {
		parRec.nr_sin = s;
	}
	public void setCopySin(String s) {
		parRec.copy_sin = s;
	}
	public void setMemo(String s) {
		parRec.memo = s;
	}
	public void setModifyDate(Timestamp ts) {
		parRec.modify_date = ts;
	}
}
