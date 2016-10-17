<%@ page buffer="128kb" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="javax.xml.transform.*, javax.xml.transform.stream.*,
		java.net.*" %>
<jsp:useBean id="cmR" class="jp.rakugo.nii.CommonRakugo" scope="page" />

<%
	request.setCharacterEncoding("UTF-8");

	String AFF_URI = "http://ws.a20.jp/bin/aws";
	String AFF_PAR = "?prog=102&ui=41985&charset=UTF-8&keyword=";
	String kwd = cmR.convertNullToString(request.getParameter("kwd"));
	String xml = AFF_URI + AFF_PAR + kwd;
	String xsl = application.getRealPath("/affbook.xsl");
	out.println(xsl);
	StreamSource xmlSS = new StreamSource(xml);
	StreamSource xslSS = new StreamSource(xsl);
	StreamResult outSR = new StreamResult(out);
	TransformerFactory fac = TransformerFactory.newInstance();
	Transformer tran = fac.newTransformer(xslSS);
//	tran.transform(xmlSS, outSR);
%>
