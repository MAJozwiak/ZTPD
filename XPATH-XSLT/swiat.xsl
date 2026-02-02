<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">
  <xsl:template match='/'>
    <html>
      <head>
        <link href="swiat.css" rel="stylesheet" type="text/css"/>
      </head>
      <body>
        <table>
          <tr><th>Kraj</th><th>Stolica</th></tr>
          <xsl:apply-templates select="SWIAT/KONTYNENTY/KONTYNENT"/>
        </table>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="*">
    <tr>
      <td><xsl:value-of select="NAZWA"/></td>
      <td><xsl:value-of select="STOLICA"/></td>
    </tr>
  </xsl:template>
</xsl:stylesheet>