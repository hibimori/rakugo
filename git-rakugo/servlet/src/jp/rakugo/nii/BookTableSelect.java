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
public class BookTableSelect implements Serializable {
	//BookTable検索
		CommonRakugo cmR = new CommonRakugo();	//共通部品
		private ArrayList result;

		public BookTableSelect() {}		//コンストラクタ

		private ResultSet rs;
		private ResultSetMetaData rsmd;

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
				q.append(" FROM book_t");
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
		//BookWorkTable
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
				q.append(" FROM book_w");
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
				rec.vol_id = cmR.convertNullToString(rs.getString("vol_id"));
				rec.seq = cmR.convertNullToZeroInt(rs.getInt("seq"));
				rec.title = cmR.convertNullToString(rs.getString("title"));
				rec.title_sort = cmR.convertNullToString(rs.getString("title_sort"));
				rec.title_seq = cmR.convertNullToZeroInt(rs.getInt("title_seq"));
				rec.title_seq_sin = cmR.convertNullToString(rs.getString("title_seq_sin"));
				rec.author1_id = cmR.convertNullToString(rs.getString("author1_id"));
				rec.author1_sin = cmR.convertNullToString(rs.getString("author1_sin"));
				rec.author2_id = cmR.convertNullToString(rs.getString("author2_id"));
				rec.author2_sin = cmR.convertNullToString(rs.getString("author2_sin"));
				rec.author3_id = cmR.convertNullToString(rs.getString("author3_id"));
				rec.author3_sin = cmR.convertNullToString(rs.getString("author3_sin"));
				rec.author4_sin = cmR.convertNullToString(rs.getString("author4_sin"));
				rec.publish_id = cmR.convertNullToString(rs.getString("publish_id"));
				rec.isbn = cmR.convertNullToString(rs.getString("isbn"));
				rec.price = cmR.convertNullToZeroFloat(rs.getFloat("price"));
				rec.cur_sin = cmR.convertNullToString(rs.getString("cur_sin"));
				rec.url_a = cmR.convertNullToString(rs.getString("url_a"));
				rec.img_a = cmR.convertNullToString(rs.getString("img_a"));
				rec.url_b = cmR.convertNullToString(rs.getString("url_b"));
				rec.img_b = cmR.convertNullToString(rs.getString("img_b"));
				rec.url_c = cmR.convertNullToString(rs.getString("url_c"));
				rec.img_c = cmR.convertNullToString(rs.getString("img_c"));
				rec.url_e = cmR.convertNullToString(rs.getString("url_e"));
				rec.img_e = cmR.convertNullToString(rs.getString("img_e"));
				rec.img_sin = cmR.convertNullToString(rs.getString("img_sin"));
				rec.store_sin = cmR.convertNullToString(rs.getString("store_sin"));
				rec.media_sin = cmR.convertNullToString(rs.getString("media_sin"));
				rec.memo = cmR.convertNullToString(rs.getString("memo"));
				try {
					rec.get_date = rs.getDate("get_date");
				} catch (Exception e) {
				}
				rec.get_date_flg = cmR.convertNullToString(rs.getString("get_date_flg"));
				rec.get_yet_flg = cmR.convertNullToString(rs.getString("get_yet_flg"));
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
		public int getResultColumnCount() {
			try {
				rsmd = rs.getMetaData();
				return rsmd.getColumnCount();
			} catch (Exception e) {
				return 0;
			}
		}
		public int getResultColumnType(int i) {
			try {
				return rsmd.getColumnType(i);
			} catch (Exception e) {
				return 0;
			}
		}
		public String getStringData(int r, int c) {
			try {
				rs.absolute(r);
				return rs.getString(c);
			} catch (Exception e) {
				return "";
			}
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
		public int getTitleSeq(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.title_seq;
		}
		public String getTitleSeqSin(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.title_seq_sin;
		}
		public String getAuthor1Id(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.author1_id;
		}
		public String getAuthor1Sin(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.author1_sin;
		}
		public String getAuthor2Id(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.author2_id;
		}
		public String getAuthor2Sin(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.author2_sin;
		}
		public String getAuthor3Id(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.author3_id;
		}
		public String getAuthor3Sin(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.author3_sin;
		}
		public String getAuthor4Sin(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.author4_sin;
		}
		public String getPublishId(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.publish_id;
		}
		public String getIsbn(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.isbn;
		}
		public float getPrice(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.price;
		}
		public String getCurSin(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.cur_sin;
		}
		public String getUrlA(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.url_a;
		}
		public String getImgA(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.img_a;
		}
		public String getUrlB(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.url_b;
		}
		public String getImgB(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.img_b;
		}
		public String getUrlC(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.url_c;
		}
		public String getImgC(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.img_c;
		}
		public String getUrlE(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.url_e;
		}
		public String getImgE(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.img_e;
		}
		public String getStoreSin(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.store_sin;
		}
		public String getImgSin(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.img_sin;
		}
		public String getMediaSin(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.media_sin;
		}
		public String getMemo(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.memo;
		}
		public java.util.Date getGetDate(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.get_date;
		}
		public String getGetDateFlg(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.get_date_flg;
		}
		public String getGetYetFlg(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.get_yet_flg;
		}
		public Timestamp getModifyDate(int i) {
			BookTable rec = (BookTable)result.get(i);
			return rec.modify_date;
		}
	}
