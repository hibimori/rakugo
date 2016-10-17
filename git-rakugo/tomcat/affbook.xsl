<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="UTF-8" />

<xsl:template match="/">
<html>
<head>
	<title>Affiliate2.0</title>
</head>
<body>
	<table>
		<tr>
			<th bgcolor="silver" colspan="2">
				<a href="http://www.bidders.co.jp/a20/itemSearch.html" target="_blank">Affiliate2.0</a>
			</th>
		</tr>
		<tr>
			<td colspan='2'>
	<xsl:for-each select="ListingInfo/Request/Parameters/Parameter">
		<xsl:if test="@name[.='keyword']">
					<xsl:value-of select="@name" />: 
					<xsl:value-of select="@value" />
		</xsl:if>
	</xsl:for-each>
			</td>
		</tr>
		<tr>
	<xsl:for-each select="ListingInfo/Request/Parameters/Parameter">
		<xsl:if test="@name[.='ui']">
			<td>ui/prog: 
			<xsl:value-of select="@value" />
			</td>
		</xsl:if>
		<xsl:if test="@name[.='prog']">
			<td>/
			<xsl:value-of select="@value" />
			</td>
		</xsl:if>
	</xsl:for-each>
		</tr>
	</table>
	<xsl:value-of select="ListingInfo/TotalCount" />件
	<table border="1" width="100%">
		<tr bgcolor="silver">
			<th>ItemNo</th>
			<!--
			<th>bk1 No</th>
			-->
			<th>Title</th>
			<th>Author</th>
			<th>Publish</th>
			<th>Image</th>
		</tr>
		<xsl:for-each select="ListingInfo/ItemInfo" order-by="Tag3">
		<tr>
			<td align="center">
				<xsl:value-of select="ItemNo" />
			</td>
				<!--
			<xsl:for-each select="ImageUrl">
				<td align="center">
					<xsl:eval>getBk1Id(this.nodeTypedValue)</xsl:eval>
				</td>
			</xsl:for-each>
				-->
			<td>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="ItemUrl" />
					</xsl:attribute>
					<xsl:value-of select="ItemName" />
				</a>
			</td>
			<td><xsl:value-of select="Tag3" /></td>
			<td>
				<xsl:value-of select="Tag2" />
				<xsl:value-of select="Tag5" />
				<!--
				<xsl:choose>
				<xsl:when test="/tag5[.='']">
				</xsl:when>
				<xsl:otherwise>
					, <xsl:value-of select="Tag5" />
				</xsl:otherwise>
				</xsl:choose>
			-->
			</td>
			<td align="center">
				<img height="24" border="0">
					<xsl:attribute name="src">
						<xsl:value-of select="ImageUrl" />
					</xsl:attribute>
				</img>
			</td>
		</tr>
		<!--
		<tr>
			<td colspan="3" style="font-size: '80%'">
				<xsl:value-of select="ItemUrl" />
			</td>
			<td align="center" rowspan="2">
			</td>
		</tr>
		<tr>
			<td colspan="3">
			<font size="-1">
				<xsl:value-of select="ImageUrl" />
			</font>
			</td>
		</tr>
		-->
		</xsl:for-each>
	</table>
</body>
</html>
</xsl:template>
<!--
<xsl:script><![CDATA[
	function getBk1Id(uri) {
		var p = uri.indexOf("bookimages/") + 16;
		if (p > 0) {
			return uri.substring(p, p + 8);
		} else {
			return "";
		}
	}
]]></xsl:script>
-->
</xsl:stylesheet>