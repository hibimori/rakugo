/**
 *
 */
package jp.rakugo.nii;

import java.sql.*;

/**
 * @author nii
 *
 */
public class BookTable {
	public int inc_id;			//Work, ViewDBのみ
	public String vol_id;
	public int seq;
	public String title;
	public String title_sort;
	public int title_seq;
	public String title_seq_sin;
	public String author1_id;
	public String author1_sin;
	public String author2_id;
	public String author2_sin;
	public String author3_id;
	public String author3_sin;
	public String author4_sin;
	public String publish_id;
	public String isbn;
	public float price;
	public String cur_sin;
	public String url_a;
	public String img_a;
	public String url_b;
	public String img_b;
	public String url_c;
	public String img_c;
	public String url_e;
	public String img_e;
	public String img_sin;
	public String store_sin;
	public String media_sin;
	public String memo;
	public java.util.Date get_date;
	public String get_date_flg;
	public String get_yet_flg;
	public Timestamp modify_date;
}
