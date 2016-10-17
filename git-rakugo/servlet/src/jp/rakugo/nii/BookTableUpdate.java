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
public class BookTableUpdate implements Serializable {
//書籍テイブル更新
	private BookTable parRec;
	private SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");
	private SimpleDateFormat dateFmtH = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private DecimalFormat curFmt2 = new DecimalFormat("0.00");

	public BookTableUpdate() {}		//コンストラクタ

	public int insertRec() {
		try {
			//JSPで接続済みのConnectionを遣う。
			Statement sttSql = CommonRakugo.db.createStatement();
			CommonRakugo.db.setReadOnly(false);

			StringBuffer q = new StringBuffer("INSERT INTO book_t SET ");
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

			StringBuffer q = new StringBuffer("UPDATE book_t SET ");
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

			StringBuffer q = new StringBuffer("DELETE FROM book_t");
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
		String s;

		stB.append("vol_id='").append(parRec.vol_id).append("'");
		if (parRec.seq >= 0) {
			stB.append(",seq='").append(String.valueOf(parRec.seq)).append("'");
		}
		if (parRec.title != null) {
			stB.append(",title='").append(parRec.title).append("'");
		}
		if (parRec.title_seq >= 0) {
			stB.append(",title_seq='").append(String.valueOf(parRec.title_seq)).append("'");
		}
		if (parRec.title_seq_sin != null) {
			stB.append(",title_seq_sin='").append(parRec.title_seq_sin).append("'");
		}
		if (parRec.title_sort != null) {
			stB.append(",title_sort='").append(parRec.title_sort).append("'");
		}
		if (parRec.author1_id != null) {
			stB.append(",author1_id='").append(parRec.author1_id).append("'");
		}
		if (parRec.author1_sin != null) {
			stB.append(",author1_sin='").append(parRec.author1_sin).append("'");
		}
		if (parRec.author2_id != null) {
			stB.append(",author2_id='").append(parRec.author2_id).append("'");
		}
		if (parRec.author2_sin != null) {
			stB.append(",author2_sin='").append(parRec.author2_sin).append("'");
		}
		if (parRec.author3_id != null) {
			stB.append(",author3_id='").append(parRec.author3_id).append("'");
		}
		if (parRec.author3_sin != null) {
			stB.append(",author3_sin='").append(parRec.author3_sin).append("'");
		}
		if (parRec.author4_sin != null) {
			stB.append(",author4_sin='").append(parRec.author4_sin).append("'");
		}
		if (parRec.publish_id != null) {
			stB.append(",publish_id='").append(parRec.publish_id).append("'");
		}
		if (parRec.isbn != null) {
			stB.append(",isbn='").append(parRec.isbn).append("'");
		}
		if (parRec.price >= 0) {
			stB.append(",price='");
			try {
				stB.append(curFmt2.format(parRec.price));
			} catch (Exception e) {
				stB.append("0.00");
			}
			stB.append("'");
		}
		if (parRec.cur_sin != null) {
			stB.append(",cur_sin='").append(parRec.cur_sin).append("'");
		}
		if (parRec.url_a != null) {
			stB.append(",url_a='").append(parRec.url_a).append("'");
		}
		if (parRec.img_a != null) {
			stB.append(",img_a='").append(parRec.img_a).append("'");
		}
		if (parRec.url_b != null) {
			stB.append(",url_b='").append(parRec.url_b).append("'");
		}
		if (parRec.img_b != null) {
			stB.append(",img_b='").append(parRec.img_b).append("'");
		}
		if (parRec.url_c != null) {
			stB.append(",url_c='").append(parRec.url_c).append("'");
		}
		if (parRec.img_c != null) {
			stB.append(",img_c='").append(parRec.img_c).append("'");
		}
		if (parRec.url_e != null) {
			stB.append(",url_e='").append(parRec.url_e).append("'");
		}
		if (parRec.img_e != null) {
			stB.append(",img_e='").append(parRec.img_e).append("'");
		}
		if (parRec.store_sin != null) {
			stB.append(",store_sin='").append(parRec.store_sin).append("'");
		}
		if (parRec.get_date != null) {
			stB.append(",get_date='");
			try {
				stB.append(dateFmt.format(parRec.get_date));
			} catch (Exception e) {
				stB.append("0000-00-00");
			}
			stB.append("'");
		}
		if (parRec.get_date_flg != null) {
			stB.append(",get_date_flg='").append(parRec.get_date_flg).append("'");
		}
		if (parRec.img_sin != null) {
			stB.append(",img_sin='").append(parRec.img_sin).append("'");
		}
		if (parRec.media_sin != null) {
			stB.append(",media_sin='").append(parRec.media_sin).append("'");
		}
		if (parRec.memo != null) {
			stB.append(",memo='").append(parRec.memo).append("'");
		}
		if (parRec.get_yet_flg != null) {
			stB.append(",get_yet_flg='").append(parRec.get_yet_flg).append("'");
		}
		if (parRec.modify_date != null) {
			try {
				s = dateFmtH.format(parRec.modify_date);
				stB.append(",modify_date='");
				stB.append(s).append("'");
			} catch (Exception e) {
			}
		}
		return stB.toString();
	}
	public void initRec() {
		parRec = new BookTable();
		parRec.vol_id = null;
		parRec.seq = -1;
		parRec.title = null;
		parRec.title_seq = -1;
		parRec.title_seq_sin = null;
		parRec.title_sort = null;
		parRec.author1_id = null;
		parRec.author1_sin = null;
		parRec.author2_id = null;
		parRec.author2_sin = null;
		parRec.author3_id = null;
		parRec.author3_sin = null;
		parRec.author4_sin = null;
		parRec.publish_id = null;
		parRec.isbn = null;
		parRec.price = -1;
		parRec.cur_sin = null;
		parRec.url_a = null;
		parRec.img_a = null;
		parRec.url_b = null;
		parRec.img_b = null;
		parRec.url_c = null;
		parRec.img_c = null;
		parRec.url_e = null;
		parRec.img_e = null;
		parRec.store_sin = null;
		parRec.get_date = null;
		parRec.get_date_flg = null;
		parRec.img_sin = null;
		parRec.media_sin = null;
		parRec.memo = null;
		parRec.get_yet_flg = null;
		parRec.modify_date = null;
	}
	public void setVolId(String s) {
		parRec.vol_id = s;
	}
	public void setSeq(int i) {
		parRec.seq = i;
	}
	public void setTitle(String s) {
		parRec.title = s;
	}
	public void setTitleSeq(int i) {
		parRec.title_seq = i;
	}
	public void setTitleSeqSin(String s) {
		parRec.title_seq_sin = s;
	}
	public void setTitleSort(String s) {
		parRec.title_sort = s;
	}
	public void setAuthor1Id(String s) {
		parRec.author1_id = s;
	}
	public void setAuthor1Sin(String s) {
		parRec.author1_sin = s;
	}
	public void setAuthor2Id(String s) {
		parRec.author2_id = s;
	}
	public void setAuthor2Sin(String s) {
		parRec.author2_sin = s;
	}
	public void setAuthor3Id(String s) {
		parRec.author3_id = s;
	}
	public void setAuthor3Sin(String s) {
		parRec.author3_sin = s;
	}
	public void setAuthor4Sin(String s) {
		parRec.author4_sin = s;
	}
	public void setPublishId(String s) {
		parRec.publish_id = s;
	}
	public void setIsbn(String s) {
		parRec.isbn = s;
	}
	public void setPrice(float f) {
		parRec.price = f;
	}
	public void setCurSin(String s) {
		parRec.cur_sin = s;
	}
	public void setUrlA(String s) {
		parRec.url_a = s;
	}
	public void setImgA(String s) {
		parRec.img_a = s;
	}
	public void setUrlB(String s) {
		parRec.url_b = s;
	}
	public void setImgB(String s) {
		parRec.img_b = s;
	}
	public void setUrlC(String s) {
		parRec.url_c = s;
	}
	public void setImgC(String s) {
		parRec.img_c = s;
	}
	public void setUrlE(String s) {
		parRec.url_e = s;
	}
	public void setImgE(String s) {
		parRec.img_e = s;
	}
	public void setStoreSin(String s) {
		parRec.store_sin = s;
	}
	public void setGetDate(java.util.Date d) {
		parRec.get_date = d;
	}
	public void setGetDateFlg(String s) {
		parRec.get_date_flg = s;
	}
	public void setImgSin(String s) {
		parRec.img_sin = s;
	}
	public void setMediaSin(String s) {
		parRec.media_sin = s;
	}
	public void setMemo(String s) {
		parRec.memo = s;
	}
	public void setGetYetFlg(String s) {
		parRec.get_yet_flg = s;
	}
	public void setModifyDate(Timestamp t) {
		parRec.modify_date = t;
	}
}
