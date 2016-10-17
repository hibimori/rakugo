<%@ page contentType="application/octet-stream; charset=UTF-8"
	import="java.sql.*, java.text.*" %>
<jsp:useBean id="bkS" class="jp.rakugo.nii.BookTableSelect" scope="page" />
<jsp:useBean id="rkS" class="jp.rakugo.nii.RakugoTableSelect" scope="page" />
<jsp:useBean id="tmS" class="jp.rakugo.nii.TitleMasterSelect" scope="page" />
<jsp:useBean id="pmS" class="jp.rakugo.nii.PlayerMasterSelect" scope="page" />
<jsp:useBean id="cmR" class="jp.rakugo.nii.CommonRakugo" scope="page" />
<%!
public String escapeString(String strEsc) {
//',",\ をescapeする
	StringBuffer sbfResult = new StringBuffer();
	for (int iEsc=0; iEsc<strEsc.length(); iEsc++) {
		switch(strEsc.charAt(iEsc)) {
		case '\'':
		case '@':
		case '<':
		case '>':
			sbfResult.append("\\").append(strEsc.charAt(iEsc));
			break;
		case '"':
			sbfResult.append("&quot;");
			break;
		case '―':
			sbfResult.append("&mdash;");
			break;
		default:
			sbfResult.append(strEsc.charAt(iEsc));
			break;
		}
	}
	return sbfResult.toString().trim();
}
%>
<%
	//汎用カウンタ
	int i = 0;
	int j = 0;
	String parDb = cmR.convertNullToString(request.getParameter("db"));

	SimpleDateFormat dateFmt = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat dateFmtH = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat timeFmt = new SimpleDateFormat("HH:mm:ss");
	DecimalFormat decFmt = new DecimalFormat("0");

//DB Bundle
	cmR.connectJdbc6();
	Connection db = cmR.getJdbc();
	Statement st = db.createStatement();
	ResultSet rs;
	ResultSetMetaData rsmd;
	StringBuffer query = new StringBuffer();
%>
<%
// Query組み立て */
//	if (parDb.equals("book_t")) {
		response.setHeader("Content-Disposition",
			"attachment; filename=" + parDb + ".dat");
		query.append("SELECT * FROM ").append(parDb);
		rs = st.executeQuery(query.toString());
		rsmd = rs.getMetaData();
		j = rsmd.getColumnCount();
		try {
			while (rs.next()) {
				for (i = 1; i <= j; i++) {
					try {
						switch (rsmd.getColumnType(i)) {
						case java.sql.Types.TIMESTAMP:
							out.print(dateFmtH.format(rs.getTimestamp(i)));
							break;
						case java.sql.Types.DATE:
							out.print(dateFmt.format(rs.getDate(i)));
							break;
						case java.sql.Types.TIME:
							out.print(timeFmt.format(rs.getTime(i)));
							break;
						case java.sql.Types.INTEGER:
							out.print(decFmt.format(rs.getInt(i)));
							break;
						case java.sql.Types.TINYINT:
							out.print(decFmt.format(rs.getInt(i)));
							break;
						default:
							out.print(rs.getString(i));
						}
					} catch (Exception e) {
						out.print("");
					}
					if (i < j) {
						out.print("\t");
					}
				}
			out.println("\n");
			}
		} catch (Exception e) {
			out.println("DAMEDAKORYA!");
		}
//	}
	out.close();
	cmR.closeJdbc();
%>
