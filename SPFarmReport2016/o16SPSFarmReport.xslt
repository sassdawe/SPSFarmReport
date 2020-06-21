<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
	<xsl:output doctype-public="HTML" method="html" encoding="utf-8" indent="yes" />
  <xsl:template match="/">
  
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
	<link rel="stylesheet" type="text/css" href="o16SPSFarmReportStyles.css" />

  <title>SPSFarmReport</title>

  <script type="text/javascript" language="javascript" defer="true" >

    <xsl:comment>
      function onClickTopNav(_value) {
      switch (_value) {
      case "GI":
      strHtml = "&lt;a id=\"GI\" class=\"active\"";
      strHtml += "onclick=\"onClickTopNav('GI')\" &gt;General Information&lt;/a&gt;";
      strHtml += "&lt;a id=\"Servers\" class=\"inactive\" onclick=\"onClickTopNav('Servers')\" &gt;Servers&lt;/a&gt;";
      strHtml += "&lt;a id=\"Features\" class=\"inactive\" onclick=\"onClickTopNav('Features')\" &gt;Features&lt;/a&gt;";

      strHtml += "&lt;a id=\"SA\" class=\"inactive\" onclick=\"onClickTopNav('SA')\" &gt;Service Applications&lt;/a&gt; ";
      strHtml += "&lt;a id=\"WA\" class=\"inactive\" onclick=\"onClickTopNav('WA')\" &gt;Web Applications&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD1\" class=\"inactive\" onclick=\"onClickTopNav('CD1')\" &gt;Content Databases&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD2\" class=\"inactive\" onclick=\"onClickTopNav('CD2')\" &gt;Content Deployment&lt;/a&gt;";
      strHtml += "&lt;a id=\"HA\" class=\"inactive\" onclick=\"onClickTopNav('HA')\" &gt;Health Analyzer&lt;/a&gt;";
      document.getElementById("_topnav").innerHTML = strHtml;
			GeneralSettings(1);
      break;
      case "Servers":
      var strHtml = "&lt;a id=\"GI\" class=\"inactive\"";
      strHtml += "onclick=\"onClickTopNav('GI')\" &gt;General Information&lt;/a&gt;";
      strHtml += "&lt;a id=\"Servers\" class=\"active\" onclick=\"onClickTopNav('Servers')\" &gt;Servers&lt;/a&gt;";
      strHtml += "&lt;a id=\"Features\" class=\"inactive\" onclick=\"onClickTopNav('Features')\" &gt;Features&lt;/a&gt;";

      strHtml += "&lt;a id=\"SA\" class=\"inactive\" onclick=\"onClickTopNav('SA')\" &gt;Service Applications&lt;/a&gt; ";
      strHtml += "&lt;a id=\"WA\" class=\"inactive\" onclick=\"onClickTopNav('WA')\" &gt;Web Applications&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD1\" class=\"inactive\" onclick=\"onClickTopNav('CD1')\" &gt;Content Databases&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD2\" class=\"inactive\" onclick=\"onClickTopNav('CD2')\" &gt;Content Deployment&lt;/a&gt;";
      strHtml += "&lt;a id=\"HA\" class=\"inactive\" onclick=\"onClickTopNav('HA')\" &gt;Health Analyzer&lt;/a&gt;";
      document.getElementById("_topnav").innerHTML = strHtml;
      ServersInfo(1);
      break;
      case "Features":
      var strHtml = "&lt;a id=\"GI\" class=\"inactive\"";
          strHtml += "onclick=\"onClickTopNav('GI')\" &gt;General Information&lt;/a&gt;";
      strHtml += "&lt;a id=\"Servers\" class=\"inactive\" onclick=\"onClickTopNav('Servers')\" &gt;Servers&lt;/a&gt;";
      strHtml += "&lt;a id=\"Features\" class=\"active\" onclick=\"onClickTopNav('Features')\" &gt;Features&lt;/a&gt;";

      strHtml += "&lt;a id=\"SA\" class=\"inactive\" onclick=\"onClickTopNav('SA')\" &gt;Service Applications&lt;/a&gt; ";
      strHtml += "&lt;a id=\"WA\" class=\"inactive\" onclick=\"onClickTopNav('WA')\" &gt;Web Applications&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD1\" class=\"inactive\" onclick=\"onClickTopNav('CD1')\" &gt;Content Databases&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD2\" class=\"inactive\" onclick=\"onClickTopNav('CD2')\" &gt;Content Deployment&lt;/a&gt;";
      strHtml += "&lt;a id=\"HA\" class=\"inactive\" onclick=\"onClickTopNav('HA')\" &gt;Health Analyzer&lt;/a&gt;";
      document.getElementById("_topnav").innerHTML = strHtml;
      Features();
      break;
      case "SA":
          var strHtml = "&lt;a id=\"GI\" class=\"inactive\"";
          strHtml += "onclick=\"onClickTopNav('GI')\" &gt;General Information&lt;/a&gt;";
      strHtml += "&lt;a id=\"Servers\" class=\"inactive\" onclick=\"onClickTopNav('Servers')\" &gt;Servers&lt;/a&gt;";
      strHtml += "&lt;a id=\"Features\" class=\"inactive\" onclick=\"onClickTopNav('Features')\" &gt;Features&lt;/a&gt;";

      strHtml += "&lt;a id=\"SA\" class=\"active\" onclick=\"onClickTopNav('SA')\" &gt;Service Applications&lt;/a&gt; ";
      strHtml += "&lt;a id=\"WA\" class=\"inactive\" onclick=\"onClickTopNav('WA')\" &gt;Web Applications&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD1\" class=\"inactive\" onclick=\"onClickTopNav('CD1')\" &gt;Content Databases&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD2\" class=\"inactive\" onclick=\"onClickTopNav('CD2')\" &gt;Content Deployment&lt;/a&gt;";
      strHtml += "&lt;a id=\"HA\" class=\"inactive\" onclick=\"onClickTopNav('HA')\" &gt;Health Analyzer&lt;/a&gt;";
      document.getElementById("_topnav").innerHTML = strHtml;
      ServiceApps(1);
      break;
      case "WA":
          var strHtml = "&lt;a id=\"GI\" class=\"inactive\"";
          strHtml += "onclick=\"onClickTopNav('GI')\" &gt;General Information&lt;/a&gt;";
      strHtml += "&lt;a id=\"Servers\" class=\"inactive\" onclick=\"onClickTopNav('Servers')\" &gt;Servers&lt;/a&gt;";
      strHtml += "&lt;a id=\"Features\" class=\"inactive\" onclick=\"onClickTopNav('Features')\" &gt;Features&lt;/a&gt;";

      strHtml += "&lt;a id=\"SA\" class=\"inactive\" onclick=\"onClickTopNav('SA')\" &gt;Service Applications&lt;/a&gt; ";
      strHtml += "&lt;a id=\"WA\" class=\"active\" onclick=\"onClickTopNav('WA')\" &gt;Web Applications&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD1\" class=\"inactive\" onclick=\"onClickTopNav('CD1')\" &gt;Content Databases&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD2\" class=\"inactive\" onclick=\"onClickTopNav('CD2')\" &gt;Content Deployment&lt;/a&gt;";
      strHtml += "&lt;a id=\"HA\" class=\"inactive\" onclick=\"onClickTopNav('HA')\" &gt;Health Analyzer&lt;/a&gt;";
      document.getElementById("_topnav").innerHTML = strHtml;
      WebApps(1);
      break;
      case "CD1":
          var strHtml = "&lt;a id=\"GI\" class=\"inactive\"";
          strHtml += "onclick=\"onClickTopNav('GI')\" &gt;General Information&lt;/a&gt;";
      strHtml += "&lt;a id=\"Servers\" class=\"inactive\" onclick=\"onClickTopNav('Servers')\" &gt;Servers&lt;/a&gt;";
      strHtml += "&lt;a id=\"Features\" class=\"inactive\" onclick=\"onClickTopNav('Features')\" &gt;Features&lt;/a&gt;";

      strHtml += "&lt;a id=\"SA\" class=\"inactive\" onclick=\"onClickTopNav('SA')\" &gt;Service Applications&lt;/a&gt; ";
      strHtml += "&lt;a id=\"WA\" class=\"inactive\" onclick=\"onClickTopNav('WA')\" &gt;Web Applications&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD1\" class=\"active\" onclick=\"onClickTopNav('CD1')\" &gt;Content Databases&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD2\" class=\"inactive\" onclick=\"onClickTopNav('CD2')\" &gt;Content Deployment&lt;/a&gt;";
      strHtml += "&lt;a id=\"HA\" class=\"inactive\" onclick=\"onClickTopNav('HA')\" &gt;Health Analyzer&lt;/a&gt;";
      document.getElementById("_topnav").innerHTML = strHtml;
      ContentDatabases();
      break;
      case "CD2":
          var strHtml = "&lt;a id=\"GI\" class=\"inactive\"";
          strHtml += "onclick=\"onClickTopNav('GI')\" &gt;General Information&lt;/a&gt;";
      strHtml += "&lt;a id=\"Servers\" class=\"inactive\" onclick=\"onClickTopNav('Servers')\" &gt;Servers&lt;/a&gt;";
      strHtml += "&lt;a id=\"Features\" class=\"inactive\" onclick=\"onClickTopNav('Features')\" &gt;Features&lt;/a&gt;";

      strHtml += "&lt;a id=\"SA\" class=\"inactive\" onclick=\"onClickTopNav('SA')\" &gt;Service Applications&lt;/a&gt; ";
      strHtml += "&lt;a id=\"WA\" class=\"inactive\" onclick=\"onClickTopNav('WA')\" &gt;Web Applications&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD1\" class=\"inactive\" onclick=\"onClickTopNav('CD1')\" &gt;Content Databases&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD2\" class=\"active\" onclick=\"onClickTopNav('CD2')\" &gt;Content Deployment&lt;/a&gt;";
      strHtml += "&lt;a id=\"HA\" class=\"inactive\" onclick=\"onClickTopNav('HA')\" &gt;Health Analyzer&lt;/a&gt;";
      document.getElementById("_topnav").innerHTML = strHtml;
      ContentDeployment(1);
      break;
      case "HA":
          var strHtml = "&lt;a id=\"GI\" class=\"inactive\"";
          strHtml += "onclick=\"onClickTopNav('GI')\" &gt;General Information&lt;/a&gt;";
      strHtml += "&lt;a id=\"Servers\" class=\"inactive\" onclick=\"onClickTopNav('Servers')\" &gt;Servers&lt;/a&gt;";
      strHtml += "&lt;a id=\"Features\" class=\"inactive\" onclick=\"onClickTopNav('Features')\" &gt;Features&lt;/a&gt;";

      strHtml += "&lt;a id=\"SA\" class=\"inactive\" onclick=\"onClickTopNav('SA')\" &gt;Service Applications&lt;/a&gt; ";
      strHtml += "&lt;a id=\"WA\" class=\"inactive\" onclick=\"onClickTopNav('WA')\" &gt;Web Applications&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD1\" class=\"inactive\" onclick=\"onClickTopNav('CD1')\" &gt;Content Databases&lt;/a&gt;";
      strHtml += "&lt;a id=\"CD2\" class=\"inactive\" onclick=\"onClickTopNav('CD2')\" &gt;Content Deployment&lt;/a&gt;";
      strHtml += "&lt;a id=\"HA\" class=\"active\" onclick=\"onClickTopNav('HA')\" &gt;Health Analyzer&lt;/a&gt;";
      document.getElementById("_topnav").innerHTML = strHtml;
      HealthAnalyzer(1);
      break;
      }
      }

      function onPageLoad() {
	  
	  var strHtml ="";	  

			if (! (window.navigator.userAgent.indexOf("Edge") > -1) )
			{
						strHtml ="&lt;p style=\"align-content:center;font:xx-large;font-size:20px;font-style:normal;font-family:Verdana;text-align:center\" &gt;&lt;strong&gt;This report is best viewed in Microsoft Edge !&lt;/strong&gt;&lt;/p&gt;";
						document.getElementById("content").innerHTML = strHtml;
			}
			
			strHtml ="";
      	  strHtml = "&lt;a id=\"GI\" class=\"inactive\" onclick=\"onClickTopNav('GI')\" &gt;General Information&lt;/a&gt;";
          strHtml += "&lt;a id=\"Servers\" class=\"inactive\" onclick=\"onClickTopNav('Servers')\" &gt;Servers&lt;/a&gt;";
          strHtml += "&lt;a id=\"Features\" class=\"inactive\" onclick=\"onClickTopNav('Features')\" &gt;Features&lt;/a&gt;";

          strHtml += "&lt;a id=\"SA\" class=\"inactive\" onclick=\"onClickTopNav('SA')\" &gt;Service Applications&lt;/a&gt; ";
          strHtml += "&lt;a id=\"WA\" class=\"inactive\" onclick=\"onClickTopNav('WA')\" &gt;Web Applications&lt;/a&gt;";
          strHtml += "&lt;a id=\"CD1\" class=\"inactive\" onclick=\"onClickTopNav('CD1')\" &gt;Content Databases&lt;/a&gt;";
          strHtml += "&lt;a id=\"CD2\" class=\"inactive\" onclick=\"onClickTopNav('CD2')\" &gt;Content Deployment&lt;/a&gt;";
          strHtml += "&lt;a id=\"HA\" class=\"inactive\" onclick=\"onClickTopNav('HA')\" &gt;Health Analyzer&lt;/a&gt;";
      document.getElementById("_topnav").innerHTML = strHtml;

      }


      function GeneralSettings(_offset)
      {
      var strHtml = "";
      switch (_offset)       {
      case 1:
          strHtml = "&lt;ul&gt;";
          strHtml += " &lt;li&gt;&lt;a&gt;&lt;/a&gt;&lt;/li&gt;";
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"GeneralSettings(1)\"&gt;General Settings&lt;/a&gt;&lt;/li&gt;"
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"GeneralSettings(2)\"&gt;Timer Jobs&lt;/a&gt;&lt;/li&gt;"
          strHtml += "&lt;/ul&gt;";
      break;
      case 2:
          strHtml = "&lt;ul&gt;";
          strHtml += " &lt;li&gt;&lt;a&gt;&lt;/a&gt;&lt;/li&gt;";
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"GeneralSettings(1)\"&gt;General Settings&lt;/a&gt;&lt;/li&gt;"
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"GeneralSettings(2)\"&gt;Timer Jobs&lt;/a&gt;&lt;/li&gt;"
          strHtml += "&lt;/ul&gt;";
      break;
      }

      document.getElementById("_sidenav").innerHTML = strHtml;
      strHtml = "";
      switch (_offset)       {
      case 1:
                strHtml = "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                strHtml += "&lt;tr&gt;&lt;th style=\"width:30%;\"&gt;Property&lt;/th&gt; &lt;th style=\"width:70%;\"&gt;Value&lt;/th&gt;&lt;/tr&gt;";
                <xsl:for-each select="Farm_Information/Farm_General_Settings">
                  <xsl:for-each select="*">
                    strHtml += "&lt;tr&gt;&lt;td&gt;";
                    strHtml +=  "<xsl:value-of select='local-name()'/> ";
                    strHtml += "&lt;/td&gt;&lt;td&gt;";
                    strHtml += " <xsl:value-of select='.'/> ";
                    strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                  </xsl:for-each>
                </xsl:for-each>
                strHtml += "&lt;/table&gt;";
                strHtml += " ";
      break;
      case 2:
            strHtml += "&lt;p&gt;&lt;/p&gt;";
            <xsl:for-each select="Farm_Information/Timer_Jobs/Job">
              strHtml += "&lt;details&gt;";
              strHtml += "&lt;summary&gt;"
              strHtml += "Job Title: "
              strHtml += "<xsl:value-of select='@Title'/>";
              strHtml += "&lt;/summary&gt;";
			strHtml += "&lt;div&gt;";
              strHtml += "&lt;p&gt;&lt;/p&gt;";
              strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
              strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";
              <xsl:for-each select="@*">
                strHtml+= "&lt;tr&gt;&lt;td&gt;";
                strHtml+= "<xsl:value-of select='local-name()'/>";
                strHtml += "&lt;/td&gt;&lt;td&gt;";
                strHtml += "<xsl:value-of select='normalize-space(.)'/>";
                strHtml += "&lt;/td&gt;&lt;/tr&gt;";
              </xsl:for-each>
              strHtml += "&lt;/table&gt;";
              strHtml += "&lt;p&gt;&lt;/p&gt;";
			  strHtml += "&lt;/div&gt;";
              strHtml += "&lt;/details&gt;";
            </xsl:for-each>
      break;
      }

      document.getElementById("content").innerHTML = strHtml;
      }

function ServersInfo(_offset)
{
      var Role = "";
      var Compliance = "";
      var strHtml = "&lt;ul&gt;";
      strHtml += " &lt;li&gt;&lt;a&gt;&lt;/a&gt;&lt;/li&gt;";
            switch (_offset)       {
              case 1:
                  strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"ServersInfo(1)\"&gt;Services On Server&lt;/a&gt;&lt;/li&gt;"
                  strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServersInfo(2)\"&gt;Installed Products&lt;/a&gt;&lt;/li&gt;"
                  strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServersInfo(3)\"&gt;Distributed Cache&lt;/a&gt;&lt;/li&gt;"
              break;
              case 2:
                  strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServersInfo(1)\"&gt;Services On Server&lt;/a&gt;&lt;/li&gt;"
                  strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"ServersInfo(2)\"&gt;Installed Products&lt;/a&gt;&lt;/li&gt;"
                  strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServersInfo(3)\"&gt;Distributed Cache&lt;/a&gt;&lt;/li&gt;"
              break;
              case 3:
                  strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServersInfo(1)\"&gt;Services On Server&lt;/a&gt;&lt;/li&gt;"
                  strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServersInfo(2)\"&gt;Installed Products&lt;/a&gt;&lt;/li&gt;"
                  strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"ServersInfo(3)\"&gt;Distributed Cache&lt;/a&gt;&lt;/li&gt;"
              break;
      }
      strHtml += "&lt;/ul&gt;";
      document.getElementById("_sidenav").innerHTML = strHtml;

      strHtml ="";
      switch (_offset)       {
        case 1:
            <xsl:for-each select="Farm_Information/Services_On_Servers/Server">
                strHtml += "&lt;p&gt;&lt;/p&gt;";
                strHtml += "&lt;details&gt;";
                strHtml += "&lt;summary&gt;"
                strHtml += "&lt;b>Server:&lt;/b> "
                strHtml += "<xsl:value-of select='@Name'/>, ";
                Role = "<xsl:value-of select='@Role'/>";

                strHtml += "   &lt;b&gt;MinRole:&lt;/b&gt; ";
                strHtml += "<xsl:value-of select='@Role'/>,";
                strHtml += "   &lt;b&gt;Compliance: &lt;/b&gt;";
                strHtml += "<xsl:value-of select='@Compliance'/>";


                strHtml += "&lt;/summary&gt;";
				strHtml += "&lt;div&gt;";
                strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                strHtml += "&lt;tr&gt;&lt;th&gt;Service(s)&lt;/th&gt;&lt;/tr&gt;";

                <xsl:for-each select="*">
                  strHtml += "&lt;tr&gt;&lt;td&gt;";
                  strHtml += " <xsl:value-of select='@Name'/> ";
                  strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                </xsl:for-each>
                strHtml += "&lt;/table&gt;";
                strHtml += "&lt;p&gt;&lt;/p&gt;";
				strHtml += "&lt;/div&gt;";
                strHtml += "&lt;/details&gt;";

            </xsl:for-each>
            document.getElementById("content").innerHTML = strHtml;
        break;
        case 2:
            <xsl:for-each select="Farm_Information/Installed_Products_on_Servers">
                <xsl:for-each select="Product">
                strHtml += "&lt;p&gt;&lt;/p&gt;";
                strHtml += "&lt;details&gt;";
                strHtml += "&lt;summary&gt;"
                strHtml += "Product: "
                strHtml += "<xsl:value-of select='@Name'/>";
                strHtml += "&lt;/summary&gt;";
				strHtml += "&lt;div&gt;";
                    <xsl:for-each select="Item">
                        strHtml += "&lt;details style='padding-left:20px'&gt;";
                        strHtml += "&lt;summary&gt;"
                        strHtml += "Item: "
                        strHtml += "<xsl:value-of select='@Name'/>";
                        strHtml += "&lt;/summary&gt;";
						strHtml += "&lt;div&gt;";

                        strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                        strHtml += "&lt;tr&gt;&lt;th&gt;Server&lt;/th&gt;&lt;th&gt;Build&lt;/th&gt;&lt;/tr&gt;";
                        <xsl:for-each select="Server">

                            strHtml += "&lt;tr&gt;&lt;td&gt;";
                            strHtml +=  "<xsl:value-of select='@Name'/> ";
                            strHtml += "&lt;/td&gt;&lt;td&gt;";
                            strHtml += " <xsl:value-of select='.'/> ";
                            strHtml += "&lt;/td&gt;&lt;/tr&gt;";

                        </xsl:for-each>
                        strHtml += "&lt;/table&gt;";
                        strHtml += "&lt;p&gt;&lt;/p&gt;";
                        strHtml += "&lt;/div&gt;";
						strHtml += "&lt;/details&gt;";
                  </xsl:for-each>
				                          strHtml += "&lt;p&gt;&lt;/p&gt;";
                        strHtml += "&lt;/div&gt;";
						strHtml += "&lt;/details&gt;";
                </xsl:for-each>
            </xsl:for-each>
            document.getElementById("content").innerHTML = strHtml;
      break;
      case 3:
           <xsl:for-each select="Farm_Information/Distributed_Cache">
              strHtml += "&lt;p&gt;&lt;/p&gt;";
              strHtml += "&lt;details&gt;";
              strHtml += "&lt;summary&gt;"
              strHtml += "Cache Containers"
              strHtml += "&lt;/summary&gt;";
			  strHtml += "&lt;div&gt;";
                <xsl:for-each select="Containers/*">
                strHtml += "&lt;p&gt;&lt;/p&gt;";
                strHtml += "&lt;details style='padding-left:20px'&gt;";
                strHtml += "&lt;summary&gt;"
                strHtml += "Container Name: "
                strHtml += "<xsl:value-of select='name(.)'/>";
                strHtml += "&lt;/summary&gt;";
				strHtml += "&lt;div&gt;";

                        strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                        strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Details&lt;/th&gt;&lt;/tr&gt;";
                        <xsl:for-each select="Property">

                            strHtml += "&lt;tr&gt;&lt;td&gt;";
                            strHtml +=  "<xsl:value-of select='@Name'/> ";
                            strHtml += "&lt;/td&gt;&lt;td&gt;";
                            strHtml += " <xsl:value-of select='.'/> ";
                            strHtml += "&lt;/td&gt;&lt;/tr&gt;";

                        </xsl:for-each>
                        strHtml += "&lt;/table&gt;";
                        strHtml += "&lt;p&gt;&lt;/p&gt;";
                        strHtml += "&lt;/div&gt;";
						strHtml += "&lt;/details&gt;";

                </xsl:for-each>
              strHtml += "&lt;p&gt;&lt;/p&gt;";
              strHtml += "&lt;/div&gt;";
			  strHtml += "&lt;/details&gt;";
            </xsl:for-each>

            <xsl:for-each select="Farm_Information/Distributed_Cache">
            strHtml += "&lt;p&gt;&lt;/p&gt;";
              strHtml += "&lt;details&gt;";
              strHtml += "&lt;summary&gt;"
              strHtml += "Cache Hosts"
              strHtml += "&lt;/summary&gt;";
			  strHtml += "&lt;div&gt;";
                <xsl:for-each select="Hosts/*">
                strHtml += "&lt;p&gt;&lt;/p&gt;";
                strHtml += "&lt;details style='padding-left:20px'&gt;";
                strHtml += "&lt;summary&gt;"
                strHtml += "Host Name: "
                strHtml += "<xsl:value-of select='name(.)'/>";
                strHtml += "&lt;/summary&gt;";
				strHtml += "&lt;div&gt;";

                        strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                        strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Details&lt;/th&gt;&lt;/tr&gt;";
                        <xsl:for-each select="Property">

                            strHtml += "&lt;tr&gt;&lt;td&gt;";
                            strHtml +=  "<xsl:value-of select='@Name'/> ";
                            strHtml += "&lt;/td&gt;&lt;td&gt;";
                            strHtml += " <xsl:value-of select='.'/> ";
                            strHtml += "&lt;/td&gt;&lt;/tr&gt;";

                        </xsl:for-each>
                        strHtml += "&lt;/table&gt;";
                        strHtml += "&lt;p&gt;&lt;/p&gt;";
                        strHtml += "&lt;/div&gt;";
						strHtml += "&lt;/details&gt;";

                </xsl:for-each>
              strHtml += "&lt;p&gt;&lt;/p&gt;";
              strHtml += "&lt;/details&gt;";
          </xsl:for-each>
            document.getElementById("content").innerHTML = strHtml;
      break;
    }
}

    function Features()
    {
      var tempStr = "";
      var strHtml = "&lt;ul&gt;";
          strHtml += " &lt;li&gt;&lt;a&gt;&lt;/a&gt;&lt;/li&gt;";
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"Features()\"&gt;Feature Information&lt;/a&gt;&lt;/li&gt;"
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"Solutions()\"&gt;Solutions&lt;/a&gt;&lt;/li&gt;"
      strHtml += "&lt;/ul&gt;";
        document.getElementById("_sidenav").innerHTML = strHtml;
        strHtml ="";
        <xsl:for-each select="Farm_Information/Features/Scope">

          strHtml += "&lt;p&gt;&lt;/p&gt;";
          strHtml += "&lt;details&gt;";
          strHtml += "&lt;summary&gt;"
          strHtml += "Scope: "
          strHtml += "<xsl:value-of select='@Level'/>";
          strHtml += "&lt;/summary&gt;";
		  strHtml += "&lt;div&gt;";
          strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
        strHtml += "&lt;tr&gt;&lt;th&gt;Feature ID&lt;/th&gt;&lt;th&gt;Name&lt;/th&gt;&lt;th&gt;Solution ID&lt;/th&gt;&lt;th&gt;IsActive&lt;/th&gt;&lt;/tr&gt;";

        <xsl:for-each select="*">
            strHtml += "&lt;tr&gt;&lt;td&gt;";
            strHtml += " <xsl:value-of select='@Id'/> ";
            strHtml += "&lt;/td&gt;&lt;td&gt;";
            <xsl:variable name="newtext" select="translate(@Name,'&quot;','')"/>
            strHtml += "<xsl:value-of select='$newtext' />";
            strHtml += "&lt;/td&gt;&lt;td&gt;";
            strHtml += " <xsl:value-of select='@SolutionId'/> ";
            strHtml += "&lt;/td&gt;&lt;td&gt;";
            strHtml += " <xsl:value-of select='@IsActive'/> ";
            strHtml += "&lt;/td&gt;&lt;/tr&gt;";
        </xsl:for-each>

                strHtml += "&lt;/table&gt;";
        strHtml += "&lt;p&gt;&lt;/p&gt;";
          strHtml += "&lt;/div&gt;";
		  strHtml += "&lt;/details&gt;";

        </xsl:for-each>
      document.getElementById("content").innerHTML = strHtml;
      }

      function Solutions()
      {
          var tempStr = "";
          var strHtml = "&lt;ul&gt;";
          strHtml += " &lt;li&gt;&lt;a&gt;&lt;/a&gt;&lt;/li&gt;";
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"Features()\"&gt;Feature Information&lt;/a&gt;&lt;/li&gt;"
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"Solutions()\"&gt;Solutions&lt;/a&gt;&lt;/li&gt;"
          strHtml += "&lt;/ul&gt;";
      document.getElementById("_sidenav").innerHTML = strHtml;
      strHtml = "&lt;p&gt;&lt;/p&gt;";
      strHtml +="No Solution Data";

      document.getElementById("content").innerHTML = strHtml;

      }

      function ServiceApps(offset)
      {
          var count = 1;
          var tempStr = "";

          var strHtml = "&lt;ul&gt;";
          strHtml += " &lt;li&gt;&lt;a&gt;&lt;/a&gt;&lt;/li&gt;";
          strHtml += "&lt;li&gt;";
          strHtml += "&lt;details style='padding-left:20px' open &gt;";
          strHtml += "&lt;summary&gt;"
            strHtml += "Service Apps";
            strHtml += "&lt;/summary&gt;";
			strHtml += "&lt;div&gt;";
        strHtml += "&lt;p /&gt;";

      <xsl:for-each select="Farm_Information/Service_Applications/Service_Application">
        strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServiceAppsData(" + count + ")\" &gt; ";
        tempStr = "<xsl:value-of select='@Type'/>";
        strHtml += tempStr;
        strHtml += "&lt;/a&gt;&lt;/li&gt;";
        count++;
      </xsl:for-each>
            strHtml +="&lt;/li&gt;"
      strHtml += "&lt;/div&gt;";
	  strHtml += "&lt;/details&gt;";
       switch (offset)       {
          case 1:
          strHtml += "&lt;p&gt;&lt;/p&gt;";
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServiceAppPools()\"&gt;Service App Pools&lt;/a&gt;&lt;/li&gt;"
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServiceAppPoolProxies()\"&gt;Service App Pool Proxies&lt;/a&gt;&lt;/li&gt;"
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServiceAppPoolProxyGroups()\"&gt;Service App Pool Proxy Groups&lt;/a&gt;&lt;/li&gt;"
          break;
          case 2:
          strHtml += "&lt;p&gt;&lt;/p&gt;";
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"ServiceAppPools()\"&gt;Service App Pools&lt;/a&gt;&lt;/li&gt;"
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServiceAppPoolProxies()\"&gt;Service App Pool Proxies&lt;/a&gt;&lt;/li&gt;"
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServiceAppPoolProxyGroups()\"&gt;Service App Pool Proxy Groups&lt;/a&gt;&lt;/li&gt;"
          break;
          case 3:
          strHtml += "&lt;p&gt;&lt;/p&gt;";
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServiceAppPools()\"&gt;Service App Pools&lt;/a&gt;&lt;/li&gt;"
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"ServiceAppPoolProxies()\"&gt;Service App Pool Proxies&lt;/a&gt;&lt;/li&gt;"
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServiceAppPoolProxyGroups()\"&gt;Service App Pool Proxy Groups&lt;/a&gt;&lt;/li&gt;"
          break;
          case 4:
          strHtml += "&lt;p&gt;&lt;/p&gt;";
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServiceAppPools()\"&gt;Service App Pools&lt;/a&gt;&lt;/li&gt;"
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"ServiceAppPoolProxies()\"&gt;Service App Pool Proxies&lt;/a&gt;&lt;/li&gt;"
          strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"ServiceAppPoolProxyGroups()\"&gt;Service App Pool Proxy Groups&lt;/a&gt;&lt;/li&gt;"
          break;
      }
      strHtml += "&lt;/ul&gt;";

      document.getElementById("_sidenav").innerHTML = strHtml;



      }

      function ServiceAppsData(_offset)
      {
          ServiceApps(1);
      var strHtml = "";
      var svcAppType ="";
      <xsl:variable name="xslOffset" select="count(Farm_Information/Service_Applications/Service_Application)" />
      var _tempOffset = 1;

        <xsl:for-each select="Farm_Information/Service_Applications/Service_Application">
        svcAppType = "<xsl:value-of select='@Type'/>";

        if(_tempOffset == _offset &amp;&amp; svcAppType != "Search Service Application")
        {

          strHtml += "&lt;p&gt;&lt;/p&gt;";
          strHtml += "&lt;details&gt;";
          strHtml += "&lt;summary&gt;"
          strHtml += "Type: "
          strHtml += svcAppType;
          strHtml += "&lt;/summary&gt;";
		  strHtml += "&lt;div&gt;";
          strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
          strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";

        <xsl:for-each select="*">
            strHtml += "&lt;tr&gt;&lt;td&gt;";
            strHtml += " <xsl:value-of select='@Name'/> ";
            strHtml += "&lt;/td&gt;&lt;td&gt;";
            strHtml += "<xsl:value-of select='normalize-space(.)'/>";

            strHtml += "&lt;/td&gt;&lt;/tr&gt;";
        </xsl:for-each>

                strHtml += "&lt;/table&gt;";
        strHtml += "&lt;p&gt;&lt;/p&gt;";
		strHtml += "&lt;/div&gt;";
          strHtml += "&lt;/details&gt;";
        }
          if(_tempOffset == _offset &amp;&amp; svcAppType == "Project Application Services")
          {
              <xsl:for-each select="*">
                <xsl:variable name="localName" select="local-name()"/>
                <xsl:variable name="sTagAT" select="'ProjectServer_Instances'"/>
                <xsl:variable name="sTagGI" select="'ProjectServer_General_Information'"/>
                <xsl:variable name="sTagCS" select="'ProjectServer_PCSSettings'"/>
                <xsl:choose>
                  <xsl:when test="contains($localName, $sTagAT)">
                    strHtml += "&lt;p&gt;&lt;/p&gt;";
                    strHtml += "&lt;details style='padding-left:20px'&gt;";
                    strHtml += "&lt;summary&gt;"
                    strHtml += "Type: "
                    strHtml += "<xsl:value-of select='$localName'/>";
                    strHtml += "&lt;/summary&gt;";
					strHtml += "&lt;div&gt;";
                    <xsl:for-each select="ProjectServer_Instance">
                      strHtml += "&lt;p&gt;&lt;/p&gt;";
                      strHtml += "&lt;details style='padding-left:20px'&gt;";
                      strHtml += "&lt;summary&gt;"
                      strHtml += "Project Web App Instance No: "
                      strHtml += "<xsl:value-of select="@Number"/>";
                      strHtml += "&lt;/summary&gt;";
					  strHtml += "&lt;div&gt;";
                      strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                      strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";
                      <xsl:for-each select="*">
                        strHtml += "&lt;tr&gt;&lt;td&gt;";
                        strHtml += " <xsl:value-of select='@Name'/> ";
                        strHtml += "&lt;/td&gt;&lt;td&gt;";
                        strHtml += "<xsl:value-of select='normalize-space(.)'/>";
                        strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                      </xsl:for-each>
                      strHtml += "&lt;/table&gt;";
                      strHtml += "&lt;p&gt;&lt;/p&gt;";
					  strHtml += "&lt;/div&gt;";
                      strHtml += "&lt;/details&gt;";
                    </xsl:for-each>
					strHtml += "&lt;/div&gt;";
                    strHtml += "&lt;/details&gt;";
                  </xsl:when>

                  <xsl:when test="contains($localName, $sTagGI)">
                    strHtml += "&lt;p&gt;&lt;/p&gt;";
                    strHtml += "&lt;details style='padding-left:20px'&gt;";
                    strHtml += "&lt;summary&gt;"
                    strHtml += "Type: "
                    strHtml += "<xsl:value-of select='$localName'/>";
                    strHtml += "&lt;/summary&gt;";
					strHtml += "&lt;div&gt;";

                    strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                    strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";
                    <xsl:for-each select="*">
                      strHtml += "&lt;tr&gt;&lt;td&gt;";
                      strHtml += " <xsl:value-of select='@Name'/> ";
                      strHtml += "&lt;/td&gt;&lt;td&gt;";
                      strHtml += "<xsl:value-of select='normalize-space(.)'/>";
                      strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                    </xsl:for-each>
                    strHtml += "&lt;/table&gt;";
                    strHtml += "&lt;p&gt;&lt;/p&gt;";
					strHtml += "&lt;/div&gt;";
                    strHtml += "&lt;/details&gt;";
                  </xsl:when>

                  <xsl:when test="contains($localName, $sTagCS)">
                    strHtml += "&lt;p&gt;&lt;/p&gt;";
                    strHtml += "&lt;details style='padding-left:20px'&gt;";
                    strHtml += "&lt;summary&gt;"
                    strHtml += "Type: "
                    strHtml += "<xsl:value-of select='$localName'/>";
                    strHtml += "&lt;/summary&gt;";
					strHtml += "&lt;div&gt;";
                    strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                    strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";

                      <xsl:for-each select="*">
                        strHtml += "&lt;tr&gt;&lt;td&gt;";
                        strHtml += "&lt;b&gt;TimeOut: &lt;/b&gt;&lt;/td&gt;&lt;td&gt;";
                        strHtml += " <xsl:value-of select='@TimeOut'/> ";
                        strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                        strHtml += "&lt;tr&gt;&lt;td&gt;";
                        strHtml += "&lt;b&gt;Worker Count: &lt;/b&gt;&lt;/td&gt;&lt;td&gt;";
                        strHtml += " <xsl:value-of select='@WorkerCount'/> ";
                        strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                        strHtml += "&lt;tr&gt;&lt;td&gt;";
                        strHtml += "&lt;b&gt;Request Time Limits: &lt;/b&gt;&lt;/td&gt;&lt;td&gt;";
                        strHtml += " <xsl:value-of select='@RequestTimeLimits'/> ";
                        strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                        strHtml += "&lt;tr&gt;&lt;td&gt;";
                        strHtml += "&lt;b&gt;Maximum Project Size: &lt;/b&gt;&lt;/td&gt;&lt;td&gt;";
                        strHtml += " <xsl:value-of select='@MaximumProjectSize'/> ";
                        strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                      </xsl:for-each>
                    strHtml += "&lt;/table&gt;";
					strHtml += "&lt;/div&gt;";
                    strHtml += "&lt;/details&gt;";
                  </xsl:when>

                </xsl:choose>
              </xsl:for-each>
                }
                 if(_tempOffset == _offset &amp;&amp; svcAppType == "Search Service Application")
                {
                      <xsl:for-each select="*">
                      <xsl:variable name="localName" select="local-name()"/>
                      <xsl:variable name="sTagAT" select="'Active_Topology'"/>
                      <xsl:variable name="sTagAC" select="'Admin_Component'"/>
                      <xsl:variable name="sTagLS" select="'Link_Stores'"/>
                      <xsl:variable name="sTagGI" select="'General_Information'"/>
                      <xsl:variable name="sTagCD" select="'Crawl_Databases'"/>
                      <xsl:variable name="sTagCR" select="'Crawl_Rules'"/>
                      <xsl:variable name="sTagQSS" select="'Query_and_Site_Settings'"/>
                      <xsl:variable name="sTagCS" select="'Content_Sources'"/>
                      <xsl:choose>
                    <xsl:when test="contains($localName, $sTagAT)">
                      strHtml += "&lt;p&gt;&lt;/p&gt;";
                      strHtml += "&lt;details style='padding-left:20px'&gt;";
                      strHtml += "&lt;summary&gt;"
                      strHtml += "Type: "
                      strHtml += "<xsl:value-of select='$localName'/>";
                      strHtml += "&lt;/summary&gt;";
					  strHtml += "&lt;div&gt;";
                       <xsl:for-each select="Component">
                          strHtml += "&lt;p&gt;&lt;/p&gt;";
                          strHtml += "&lt;details style='padding-left:20px'&gt;";
                          strHtml += "&lt;summary&gt;"
                          strHtml += "Name: "
                          strHtml += "<xsl:value-of select="@Name"/>";
                          strHtml += "&lt;/summary&gt;";
						  strHtml += "&lt;div&gt;";
                        strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                        strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";
                        <xsl:for-each select="*">
                            strHtml += "&lt;tr&gt;&lt;td&gt;";
                            strHtml += " <xsl:value-of select='@Name'/> ";
                            strHtml += "&lt;/td&gt;&lt;td&gt;";
                            strHtml += "<xsl:value-of select='normalize-space(.)'/>";
                            strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                        </xsl:for-each>
                            strHtml += "&lt;/table&gt;";
                            strHtml += "&lt;p&gt;&lt;/p&gt;";
							strHtml += "&lt;/div&gt;";
                            strHtml += "&lt;/details&gt;";
                      </xsl:for-each>
					  strHtml += "&lt;/div&gt;";
                    strHtml += "&lt;/details&gt;";
                      </xsl:when>

                      <xsl:when test="contains($localName, $sTagGI) or contains($localName, $sTagAC) or contains($localName, $sTagLS)">
                                              strHtml += "&lt;p&gt;&lt;/p&gt;";
                      strHtml += "&lt;details style='padding-left:20px'&gt;";
                      strHtml += "&lt;summary&gt;"
                      strHtml += "Type: "
                      strHtml += "<xsl:value-of select='$localName'/>";
                      strHtml += "&lt;/summary&gt;";
					  strHtml += "&lt;div&gt;";

                        strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                        strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";
                        <xsl:for-each select="*">
                            strHtml += "&lt;tr&gt;&lt;td&gt;";
                            strHtml += " <xsl:value-of select='@Name'/> ";
                            strHtml += "&lt;/td&gt;&lt;td&gt;";
                            strHtml += "<xsl:value-of select='normalize-space(.)'/>";
                            strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                        </xsl:for-each>
                            strHtml += "&lt;/table&gt;";
                            strHtml += "&lt;p&gt;&lt;/p&gt;";
							strHtml += "&lt;/div&gt;";
                    strHtml += "&lt;/details&gt;";
                        </xsl:when>


          <xsl:when test="contains($localName, $sTagCD)">
             strHtml += "&lt;p&gt;&lt;/p&gt;";
                      strHtml += "&lt;details style='padding-left:20px'&gt;";
                      strHtml += "&lt;summary&gt;"
                      strHtml += "Type: "
                      strHtml += "<xsl:value-of select='$localName'/>";
                      strHtml += "&lt;/summary&gt;";
					  strHtml += "&lt;div&gt;";
                       <xsl:for-each select="Database">
                          strHtml += "&lt;p&gt;&lt;/p&gt;";
                          strHtml += "&lt;details style='padding-left:20px'&gt;";
                          strHtml += "&lt;summary&gt;"
                          strHtml += "Name: "
                          strHtml += "<xsl:value-of select="@Id"/>";
                          strHtml += "&lt;/summary&gt;";
						  strHtml += "&lt;div&gt;";
                        strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                        strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";
                        <xsl:for-each select="*">
                            strHtml += "&lt;tr&gt;&lt;td&gt;";
                            strHtml += " <xsl:value-of select='@Name'/> ";
                            strHtml += "&lt;/td&gt;&lt;td&gt;";
                            strHtml += "<xsl:value-of select='normalize-space(.)'/>";
                            strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                        </xsl:for-each>
                            strHtml += "&lt;/table&gt;";
                            strHtml += "&lt;p&gt;&lt;/p&gt;";
							strHtml += "&lt;/div&gt;";
                            strHtml += "&lt;/details&gt;";
                      </xsl:for-each>
					strHtml += "&lt;/div&gt;";
                    strHtml += "&lt;/details&gt;";
                  </xsl:when>


                      <xsl:when test="contains($localName, $sTagCR)">
                        strHtml += "&lt;p&gt;&lt;/p&gt;";
                      strHtml += "&lt;details style='padding-left:20px'&gt;";
                      strHtml += "&lt;summary&gt;"
                      strHtml += "Type: "
                      strHtml += "<xsl:value-of select='$localName'/>";
                      strHtml += "&lt;/summary&gt;";
					  strHtml += "&lt;div&gt;";
                       <xsl:for-each select="Rule">
                          strHtml += "&lt;p&gt;&lt;/p&gt;";
                          strHtml += "&lt;details style='padding-left:20px'&gt;";
                          strHtml += "&lt;summary&gt;"
                          strHtml += "Name: "
                          strHtml += "<xsl:value-of select="@Name"/>";
                          strHtml += "&lt;/summary&gt;";
						  strHtml += "&lt;div&gt;";
                        strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                        strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";
                        <xsl:for-each select="*">
                            strHtml += "&lt;tr&gt;&lt;td&gt;";
                            strHtml += " <xsl:value-of select='@Name'/> ";
                            strHtml += "&lt;/td&gt;&lt;td&gt;";
                            strHtml += "<xsl:value-of select='normalize-space(.)'/>";
                            strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                        </xsl:for-each>
                            strHtml += "&lt;/table&gt;";
                            strHtml += "&lt;p&gt;&lt;/p&gt;";
							strHtml += "&lt;/div&gt;";
                            strHtml += "&lt;/details&gt;";
                      </xsl:for-each>
					strHtml += "&lt;/div&gt;";
                    strHtml += "&lt;/details&gt;";
                      </xsl:when>

                      <xsl:when test="contains($localName, $sTagQSS)">
                          <!-- Although the code is identical to Crawl_Component, we cannot reinitialize variables in XSL. -->
                      strHtml += "&lt;p&gt;&lt;/p&gt;";
                      strHtml += "&lt;details style='padding-left:20px'&gt;";
                      strHtml += "&lt;summary&gt;"
                      strHtml += "Type: "
                      strHtml += "<xsl:value-of select='$localName'/>";
                      strHtml += "&lt;/summary&gt;";
					  strHtml += "&lt;div&gt;";
                       <xsl:for-each select="Instance">
                          strHtml += "&lt;p&gt;&lt;/p&gt;";
                          strHtml += "&lt;details style='padding-left:20px'&gt;";
                          strHtml += "&lt;summary&gt;"
                          strHtml += "Name: "
                          strHtml += "<xsl:value-of select="@Id"/>";
                          strHtml += "&lt;/summary&gt;";
						  strHtml += "&lt;div&gt;";
                        strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                        strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";
                        <xsl:for-each select="*">
                            strHtml += "&lt;tr&gt;&lt;td&gt;";
                            strHtml += " <xsl:value-of select='@Name'/> ";
                            strHtml += "&lt;/td&gt;&lt;td&gt;";
                            strHtml += "<xsl:value-of select='normalize-space(.)'/>";
                            strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                        </xsl:for-each>
                            strHtml += "&lt;/table&gt;";
                            strHtml += "&lt;p&gt;&lt;/p&gt;";
							strHtml += "&lt;/div&gt;";
                            strHtml += "&lt;/details&gt;";
                      </xsl:for-each>
					strHtml += "&lt;/div&gt;";
                    strHtml += "&lt;/details&gt;";
                      </xsl:when>

                      <xsl:when test="contains($localName, $sTagCS)">
                          <!-- Although the code is identical to Crawl_Component, we cannot reinitialize variables in XSL. -->
                      strHtml += "&lt;p&gt;&lt;/p&gt;";
                      strHtml += "&lt;details style='padding-left:20px'&gt;";
                      strHtml += "&lt;summary&gt;"
                      strHtml += "Type: "
                      strHtml += "<xsl:value-of select='$localName'/>";
                      strHtml += "&lt;/summary&gt;";
					  strHtml += "&lt;div&gt;";
                       <xsl:for-each select="Content_Source">
                          strHtml += "&lt;p&gt;&lt;/p&gt;";
                          strHtml += "&lt;details style='padding-left:20px'&gt;";
                          strHtml += "&lt;summary&gt;"
                          strHtml += "ID: "
                          strHtml += "<xsl:value-of select="@Id"/>";
                          strHtml += "&lt;/summary&gt;";
						  strHtml += "&lt;div&gt;";
                        strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                        strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";
                        <xsl:for-each select="*">
                            strHtml += "&lt;tr&gt;&lt;td&gt;";
                            strHtml += " <xsl:value-of select='@Name'/> ";
                            strHtml += "&lt;/td&gt;&lt;td&gt;";
                            strHtml += "<xsl:value-of select='normalize-space(.)'/>";
                            strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                        </xsl:for-each>
                            strHtml += "&lt;/table&gt;";
                            strHtml += "&lt;p&gt;&lt;/p&gt;";
							strHtml += "&lt;/div&gt;";
                            strHtml += "&lt;/details&gt;";
                      </xsl:for-each>
					strHtml += "&lt;/div&gt;";
                    strHtml += "&lt;/details&gt;";
                      </xsl:when>

                        </xsl:choose>
                        </xsl:for-each>
        }

      _tempOffset++;
    </xsl:for-each>
                document.getElementById("content").innerHTML = strHtml;

      }

      function ServiceAppPools()
      {
      ServiceApps(2)
          var svcAppType = "";
          var strHtml = "";
          <xsl:for-each select="Farm_Information/Service_Application_Pools/Application_Pool">
            svcAppType = "<xsl:value-of select='@Id'/>";

              strHtml += "&lt;p&gt;&lt;/p&gt;";
              strHtml += "&lt;details&gt;";
              strHtml += "&lt;summary&gt;"
              strHtml += "App Pool Id: "
              strHtml += svcAppType;
              strHtml += "&lt;/summary&gt;";
			  strHtml += "&lt;div&gt;";
              strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
              strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";

            <xsl:for-each select="*">
                strHtml += "&lt;tr&gt;&lt;td&gt;";
                strHtml += " <xsl:value-of select='@Name'/> ";
                strHtml += "&lt;/td&gt;&lt;td&gt;";
                strHtml += "<xsl:value-of select='normalize-space(.)'/>";

                strHtml += "&lt;/td&gt;&lt;/tr&gt;";
            </xsl:for-each>

                    strHtml += "&lt;/table&gt;";
            strHtml += "&lt;p&gt;&lt;/p&gt;";
			strHtml += "&lt;/div&gt;";
              strHtml += "&lt;/details&gt;";
              </xsl:for-each>
        document.getElementById("content").innerHTML = strHtml;
      }

      function ServiceAppPoolProxies()
      {
      ServiceApps(3)
                var svcAppType = "";
          var strHtml = "";
          <xsl:for-each select="Farm_Information/Service_Application_Proxies/Proxy">
            svcAppType = "<xsl:value-of select='@TypeName'/>";

              strHtml += "&lt;p&gt;&lt;/p&gt;";
              strHtml += "&lt;details&gt;";
              strHtml += "&lt;summary&gt;"
              strHtml += "Type: "
              strHtml += svcAppType;
              strHtml += "&lt;/summary&gt;";
			  strHtml += "&lt;div&gt;";
              strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
              strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";

            <xsl:for-each select="*">
                strHtml += "&lt;tr&gt;&lt;td&gt;";
                strHtml += " <xsl:value-of select='@Name'/> ";
                strHtml += "&lt;/td&gt;&lt;td&gt;";
                strHtml += "<xsl:value-of select='normalize-space(.)'/>";

                strHtml += "&lt;/td&gt;&lt;/tr&gt;";
            </xsl:for-each>

                    strHtml += "&lt;/table&gt;";
            strHtml += "&lt;p&gt;&lt;/p&gt;";
			strHtml += "&lt;/div&gt;";
              strHtml += "&lt;/details&gt;";
              </xsl:for-each>
        document.getElementById("content").innerHTML = strHtml;
      }

      function ServiceAppPoolProxyGroups()
      {
      ServiceApps(4)
                      var svcAppType = "";
          var strHtml = "";
          <xsl:for-each select="Farm_Information/Service_Application_Proxy_Groups">
                          <xsl:for-each select="Proxy_Group">
            svcAppType = "<xsl:value-of select='@Id'/>";

              strHtml += "&lt;p&gt;&lt;/p&gt;";
              strHtml += "&lt;details&gt;";
              strHtml += "&lt;summary&gt;"
              strHtml += "Group Id: "
              strHtml += svcAppType;
              strHtml += "&lt;/summary&gt;";
			  strHtml += "&lt;div&gt;";
              strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
              strHtml += "&lt;tr&gt;&lt;th&gt;"
              strHtml += "Friendly Name: ";
              strHtml += "<xsl:value-of select='@FriendlyName'/>";
              strHtml += "&lt;/th&gt;&lt;th&gt;";
              strHtml += "Associated Proxies&lt;/th&gt;&lt;/tr&gt;";

            <xsl:for-each select="Objects/*">
                strHtml += "&lt;tr&gt;&lt;td&gt;";
                strHtml += "&lt;/td&gt;&lt;td&gt;";
                strHtml += "<xsl:value-of select='normalize-space(.)'/>";
                strHtml += "&lt;p /&gt;";
                strHtml += "&lt;/td&gt;&lt;/tr&gt;";
            </xsl:for-each>

                    strHtml += "&lt;/table&gt;";
            strHtml += "&lt;p&gt;&lt;/p&gt;";
			strHtml += "&lt;/div&gt;";
              strHtml += "&lt;/details&gt;";
            </xsl:for-each>
            </xsl:for-each>
        document.getElementById("content").innerHTML = strHtml;
      }

    function WebApps(_offset)
    {
        var strHtml = "&lt;ul&gt;";
        strHtml += " &lt;li&gt;&lt;a&gt;&lt;/a&gt;&lt;/li&gt;";
      switch (_offset)       {
              case 1:
                  strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"WebApps(" + 1 +")\"&gt;Apps&lt;/a&gt;&lt;/li&gt;";
                    strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"WebApps(" + 2 +")\"&gt;AAMs&lt;/a&gt;&lt;/li&gt;";
              break;
              case 2:
                strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"WebApps(" + 1 +")\"&gt;Apps&lt;/a&gt;&lt;/li&gt;";
                strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"WebApps(" + 2 +")\"&gt;AAMs&lt;/a&gt;&lt;/li&gt;";
              break;
      }
      strHtml += "&lt;/ul&gt;";
      document.getElementById("_sidenav").innerHTML = strHtml;

      strHtml ="";
      switch (_offset)       {
      case 1:
        <xsl:for-each select="Farm_Information/Web_Applications">
          <xsl:for-each select="Web_Application">
            strHtml += "&lt;p&gt;&lt;/p&gt;";
            strHtml += "&lt;details&gt;";
            strHtml += "&lt;summary&gt;"
            strHtml += "<xsl:value-of select='@Name'/>";
            strHtml += "&lt;/summary&gt;";
			strHtml += "&lt;div&gt;";
                strHtml += "&lt;table&gt;";
                strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";
                  <xsl:for-each select="Associated_Applicaion_Pool">
                    strHtml += "&lt;tr&gt;&lt;td&gt;Associated Application Pool Name&lt;/td&gt;&lt;td&gt;";
                    strHtml += "<xsl:value-of select='@Name'/>";
                    strHtml += "&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td&gt;Associated Application Pool Identity&lt;/td&gt;&lt;td&gt;";
                    strHtml += "<xsl:value-of select='@Identity'/>";
                    strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                  </xsl:for-each>
                  <xsl:for-each select="Associated_Service_Application_Proxy_Group">
                    strHtml += "&lt;tr&gt;&lt;td&gt;Associated Application Pool Group&lt;/td&gt;&lt;td&gt;";
                    strHtml += "<xsl:value-of select='@Name'/>";
                    strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                  </xsl:for-each>
                    strHtml += "&lt;tr&gt;&lt;td&gt;Content Databases&lt;/td&gt;&lt;td&gt;";
                      <xsl:for-each select="Content_Databases/*">
                        strHtml += "&lt;p style='margin:0;'&gt;";
                        strHtml += "<xsl:value-of select='@Name'/>";
                        strHtml += "&lt;/p&gt;";
                      </xsl:for-each>
                        strHtml += "&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;";
						strHtml += "&lt;/div&gt;";
            strHtml += "&lt;/details&gt;";
          </xsl:for-each>
        </xsl:for-each>
      document.getElementById("content").innerHTML = strHtml;
      break;
      case 2:
            <xsl:for-each select="Farm_Information/Alternate_Access_Mappings">
              <xsl:for-each select="Web_Application">
                strHtml += "&lt;p&gt;&lt;/p&gt;";
                strHtml += "&lt;details&gt;";
                strHtml += "&lt;summary&gt;"
                strHtml += "<xsl:value-of select='@Name'/>";
                strHtml += "&lt;/summary&gt;";
				strHtml += "&lt;div&gt;";
                  <xsl:for-each select="*">
                    <xsl:choose>
                      <xsl:when test="./*">
                        strHtml += "&lt;p&gt;&lt;/p&gt;";
                        strHtml += "&lt;details style='padding-left:20px'&gt;";
                        strHtml += "&lt;summary&gt;"
                        strHtml += "<xsl:value-of select='local-name()'/>" + " Zone";
                        strHtml += "&lt;/summary&gt;";
						strHtml += "&lt;div&gt;";
                            strHtml += "&lt;table&gt;";
                            strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th &gt;Value&lt;/th&gt;&lt;/tr&gt;";
                              <xsl:for-each select="*">
                                strHtml+= "&lt;tr&gt;&lt;td&gt;";
                                strHtml+= "<xsl:value-of select='local-name()'/>";
                                strHtml += "&lt;/td&gt;&lt;td&gt;";
                                strHtml += "<xsl:value-of select='.'/>";
                                strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                              </xsl:for-each>
                        strHtml += "&lt;/table&gt;";
						strHtml += "&lt;/div&gt;";
                        strHtml += "&lt;/details&gt;";
                      </xsl:when>
                    </xsl:choose>
                  </xsl:for-each>
				  strHtml += "&lt;/div&gt;";
                strHtml += "&lt;/details&gt;";
              </xsl:for-each>
            </xsl:for-each>
      document.getElementById("content").innerHTML = strHtml;
      break;
      }
      }

      function ContentDatabases()
      {
            var cdName = "";
            var strHtml = "&lt;ul&gt;";
            strHtml += " &lt;li&gt;&lt;a&gt;&lt;/a&gt;&lt;/li&gt;";
            strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"ContentDatabases()\"&gt;Content Databases&lt;/a&gt;&lt;/li&gt;";
            strHtml += "&lt;/ul&gt;";
            document.getElementById("_sidenav").innerHTML = strHtml;
            strHtml = "";

      <xsl:for-each select="Farm_Information/Content_Databases/*">
              cdName = "<xsl:value-of select='@Name'/>";

              strHtml += "&lt;p&gt;&lt;/p&gt;";
              strHtml += "&lt;details&gt;";
              strHtml += "&lt;summary&gt;"
              strHtml += "Database Name: "
              strHtml += cdName;
              strHtml += "&lt;/summary&gt;";
			  strHtml += "&lt;div&gt;";
              strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
              strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";
              <xsl:for-each select="*">
                strHtml+= "&lt;tr&gt;&lt;td&gt;";
                strHtml+= "<xsl:value-of select='name(.)'/>";
                strHtml += "&lt;/td&gt;&lt;td&gt;";
                strHtml += "<xsl:value-of select='.'/>";
                strHtml += "&lt;/td&gt;&lt;/tr&gt;";
              </xsl:for-each>

              strHtml += "&lt;/table&gt;";
              strHtml += "&lt;p&gt;&lt;/p&gt;";
			  strHtml += "&lt;/div&gt;";
              strHtml += "&lt;/details&gt;";
            </xsl:for-each>
      document.getElementById("content").innerHTML = strHtml;

      }
      function ContentDeployment(_offset)
      {
            var strHtml = "&lt;ul&gt;";
            strHtml += " &lt;li&gt;&lt;a&gt;&lt;/a&gt;&lt;/li&gt;";
            switch (_offset)       {
            case 1:
                strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"ContentDeployment(" + 1 +")\"&gt;General Information&lt;/a&gt;&lt;/li&gt;";
            break;
            case 2:
                strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"ContentDeployment(" + 2 +")\"&gt;Paths and Jobs&lt;/a&gt;&lt;/li&gt;";
            break;
            }
            strHtml += "&lt;/ul&gt;";
      document.getElementById("_sidenav").innerHTML = strHtml;
      strHtml ="";

                strHtml += "&lt;p&gt;&lt;/p&gt;";
                strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";
                <xsl:for-each select="Farm_Information/Content_Deployment/General_Information/*">
                  strHtml+= "&lt;tr&gt;&lt;td&gt;";
                  strHtml+= "<xsl:value-of select='@Name'/>";
                  strHtml += "&lt;/td&gt;&lt;td&gt;";
                  strHtml += "<xsl:value-of select='.'/>";
                  strHtml += "&lt;/td&gt;&lt;/tr&gt;";
                </xsl:for-each>
                strHtml += "&lt;/table&gt;";
                strHtml += "&lt;p&gt;&lt;/p&gt;";
      document.getElementById("content").innerHTML = strHtml;
      }

      function HealthAnalyzer(_offset)
      {
            var strHtml = "&lt;ul&gt;";
            strHtml += " &lt;li&gt;&lt;a&gt;&lt;/a&gt;&lt;/li&gt;";
            switch (_offset)       {
            case 1:
                strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"HealthAnalyzer(" + 1 +")\"&gt;Errors&lt;/a&gt;&lt;/li&gt;";
                strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"HealthAnalyzer(" + 2 +")\"&gt;Warnings&lt;/a&gt;&lt;/li&gt;";
            break;
            case 2:
                      strHtml += "&lt;li&gt;&lt;a &lt;a class=\"inactive\" onclick=\"HealthAnalyzer(" + 1 +")\"&gt;Errors&lt;/a&gt;&lt;/li&gt;";
                      strHtml += "&lt;li&gt;&lt;a &lt;a class=\"active\" onclick=\"HealthAnalyzer(" + 2 +")\"&gt;Warnings&lt;/a&gt;&lt;/li&gt;";
            break;
      }
      strHtml += "&lt;/ul&gt;";
      document.getElementById("_sidenav").innerHTML = strHtml;
      strHtml ="";

      switch (_offset)       {
      case 1:
      strHtml += "&lt;p&gt;&lt;/p&gt;";
      <xsl:for-each select="Farm_Information/Health_Analyzer_Reports/Type[@Name='Errors']/Item">
                strHtml += "&lt;details&gt;";
                strHtml += "&lt;summary&gt;"
        strHtml += "Error : "
        strHtml += "<xsl:value-of select='@Title'/>";
        strHtml += "&lt;/summary&gt;";
		strHtml += "&lt;div&gt;";
                strHtml += "&lt;p&gt;&lt;/p&gt;";
                strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
                strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";
                <xsl:for-each select="@*">
                  strHtml+= "&lt;tr&gt;&lt;td&gt;";
                  strHtml+= "<xsl:value-of select='local-name()'/>";
                  strHtml += "&lt;/td&gt;&lt;td&gt;";
                  strHtml += "<xsl:value-of select='normalize-space(.)'/>";
                  strHtml += "&lt;/td&gt;&lt;/tr&gt;";
              </xsl:for-each>
                strHtml += "&lt;/table&gt;";
                strHtml += "&lt;p&gt;&lt;/p&gt;";
				strHtml += "&lt;/div&gt;";
                strHtml += "&lt;/details&gt;";
      </xsl:for-each>

      break;
      case 2:
      strHtml += "&lt;p&gt;&lt;/p&gt;";
      <xsl:for-each select="Farm_Information/Health_Analyzer_Reports/Type[@Name='Warnings']/Item">
        strHtml += "&lt;details&gt;";
        strHtml += "&lt;summary&gt;"
        strHtml += "Warning : "
        strHtml += "<xsl:value-of select='@Title'/>";
        strHtml += "&lt;/summary&gt;";
		strHtml += "&lt;div&gt;";
        strHtml += "&lt;p&gt;&lt;/p&gt;";
        strHtml += "&lt;p&gt;&lt;/p&gt;&lt;table&gt;";
        strHtml += "&lt;tr&gt;&lt;th&gt;Property&lt;/th&gt;&lt;th&gt;Value&lt;/th&gt;&lt;/tr&gt;";
        <xsl:for-each select="@*">
          strHtml+= "&lt;tr&gt;&lt;td&gt;";
          strHtml+= "<xsl:value-of select='local-name()'/>";
          strHtml += "&lt;/td&gt;&lt;td&gt;";
          strHtml += "<xsl:value-of select='normalize-space(.)'/>";
          strHtml += "&lt;/td&gt;&lt;/tr&gt;";
        </xsl:for-each>
        strHtml += "&lt;/table&gt;";
        strHtml += "&lt;p&gt;&lt;/p&gt;";
		strHtml += "&lt;/div&gt;";
        strHtml += "&lt;/details&gt;";
      </xsl:for-each>
      break;
      }
        document.getElementById("content").innerHTML = strHtml;
      }


    </xsl:comment>



  </script>

</head>

<body onLoad="onPageLoad()">
    <p style="align-content:center;font:xx-large;font-size:50px;font-style:normal;font-family:Verdana;text-align:center" ><strong>SPSFarmReport</strong></p>
    <div class="topnav" id="_topnav"> <p></p></div>
<div  class="_sidenav" id="_sidenav"><p></p> </div>
<div id="content" style="position:absolute;left:20%;">

</div>

<script>
// Details shim for Edge
'use strict';

(function() {
  var supportsDetails = 'open' in document.createElement('details');

  if (!supportsDetails) {
    registerEvents();
    setUpDetailsA11yAttributes();
  }

  function setUpDetailsA11yAttributes() {
    var allDetails = Array.from(document.querySelectorAll('details'));

    for (var details of allDetails) {
      details.setAttribute('role', 'group');
      var summary = details.querySelector('summary');
      summary.setAttribute('role', 'button');
      summary.setAttribute('tabindex', '0');
    }
  }

  function registerEvents() {
    document.addEventListener('click', function (e) {
      onActivation(e);
    });

    document.addEventListener('keydown', function (e) {

      if (e.keyCode === 32 || e.keyCode === 13) {
        onActivation(e);
      }
    });
  }

  function onActivation(e) {
    var summary = findSummary(e.target);

    if (!summary) {
      return;
    }

    e.preventDefault();

    var details = summary.parentElement;
    toggleDetails(details, summary);
  }

  function toggleDetails(details, summary) {

    if (details.hasAttribute('open')) {
      details.removeAttribute('open');
      summary.setAttribute('aria-expanded', 'false');
    } else {
      details.setAttribute('open', '');
      summary.setAttribute('aria-expanded', 'true');
    }

    details.dispatchEvent(new Event('toggle'));
  }

  function findSummary(element) {
    if (element.localName === 'summary') {
      return element;
    }

    if (element.parentElement) {
      return findSummary(element.parentElement);
    }

    return null;
  }
})();
</script>
</body>
</html>

  </xsl:template>
</xsl:stylesheet>