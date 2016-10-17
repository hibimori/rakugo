/**
 *
 */
package jp.rakugo.nii;

import java.sql.*;

/**
 * @author nii
 *
 */
public class RakugoTable {		//rakugo_t, rakugo_w 共通
//	public int inc_id;			//ワークDBのみ
	public String vol_id;
	public int seq;
	public String title_id;
	public int title_seq;
	public String str_title_seq;
	public String str_title_seq_sin;
	public String subtitle_id;
	public String program_id;
	public String player1_id;
	public String player1_sin;
	public String player2_id;
	public String player2_sin;
	public String player3_id;
	public String player3_sin;
	public String player4_sin;
	public String source_id;
	public String sortT;		//ワークDBのみ
	public String sortP;		//ワークDBのみ
	public Time rec_length;	//DB上はTime
	public String rec_length_flg;
	public java.util.Date rec_date;
	public String rec_date_flg;
	public Time rec_time;		//DB上はTime
	public String rec_time_flg;
	public String category_sin;
	public String media_sin;
	public String sur_sin;
	public String nr_sin;
	public String copy_sin;
	public String memo;
	public Timestamp modify_date;
}
