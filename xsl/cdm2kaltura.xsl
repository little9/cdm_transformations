<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>


    <!-- The following parameters can be changed to modify the transformation. -->
    
    <!-- Choose whether to add or update. Change to "true" to add new files to Kaltura. -->
    <xsl:param name="add">true</xsl:param>     

    <!-- Choose the appropriate repository prefix for files names and IDs. -->
    <xsl:param name="prefix">chc</xsl:param>
    
    <!-- "1" for video, "2" for audio. -->
    <xsl:param name="mediaType">1</xsl:param>
    
    <!-- Set the name of the channel. -->
    <xsl:param name="channelName">&#91;PROCESSING&#93; Luis J. Botifoll Oral History Project</xsl:param>
    
    <!-- Set the ID of the account to be associated with the collection. Currently set to Bryanna's account. -->
    <xsl:param name="userId">C00116178</xsl:param>
    
    <!-- ID for custom metadata schema associated with Kaltura collection. Currently set to global schema. -->
    <xsl:param name="metadataProfileId">2548141</xsl:param>
    
    <!-- Name for host of special events/presentations. Used of CHC Lectures & Presentations. -->
    <xsl:param name="hostName">University of Miami Libraries. Cuban Heritage Collection</xsl:param> 
    
    <!-- Name of the contributing repository. As of April 2014, the possible values are:
    
    University Archives
    University Special Collections
    Cuban Heritage Collection
    Department Archives
    Scholarly Communications
    Other
    
    -->
    <xsl:param name="repository">Cuban Heritage Collection</xsl:param> 
    
    <!-- Change to "true" to display value of "Date Created" taken from CDM (usually equivalent to date of ingest). -->
    <xsl:param name="showPubDate">false</xsl:param>
    
    <!-- Change to "false" to hide value of "Publication Place" taken from CDM. -->
    <xsl:param name="showPubPlace">true</xsl:param>

    <!-- Rights statement for CHC media. -->
    <xsl:param name="rightsStatementCHC">Copyright to these materials lies with the University of Miami. They may not be reproduced, retransmitted, published, distributed, or broadcast without the permission of the Cuban Heritage Collection. For information about obtaining copies or to request permission to publish any part of this interview, please contact the Cuban Heritage Collection at chc@miami.edu.</xsl:param>
    
    <!-- Rights statement for Special Collections media. -->
    <xsl:param name="rightsStatementASM"/>


    <!-- Jazz out templates to add new items. -->
    <xsl:param name="jazzOutTemplate">false</xsl:param>

    <!-- Assign a title to the templates; if no title, default title will be digital ID. -->
    <xsl:param name="jazzOutTitle">This is a test title</xsl:param>
    
    <!-- Base object ID for jazzing out templates. -->
    <xsl:param name="jazzOutObjID">5212000108</xsl:param>
    

    <!--*****************************************-->
    <!-- These parameters should not be changed. -->
    <xsl:param name="i">1</xsl:param>
    <xsl:param name="increment">1</xsl:param>

    <xsl:variable name="vUpper" select="'AÁÀBCDEÉÈFGHIÍJKLMNÑOÓPQRSTUÚÜVWXYZ'"/>
    <xsl:variable name="vLower" select="'aáàbcdeéèfghiíjklmnñoópqrstuúüvwxyz'"/>
    <xsl:variable name="quote">"</xsl:variable>

    <xsl:variable name="numFiles">
        <xsl:for-each select="/collection/compoundObject/objectRecord">
            <xsl:value-of select="number(substring-before(field[@name='physicaldescription'][.!=''],' '))"
            />
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="/">                
        <xsl:for-each select="/collection">
            <xsl:if test="child::node()/name()='compoundObject'">
                <xsl:for-each select="compoundObject/objectRecord">                    
                    <xsl:variable name="num"
                        select="number(substring-before(field[@name='physicaldescription'][.!=''],' '))"/>
                    <xsl:result-document href="{concat('filesToIngest/',$prefix,identifier,'.xml')}"
                        indent="yes" method="xml" encoding="UTF-8">
                        <mrss xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                            <channel>
                                <xsl:call-template name="partMaker">
                                    <xsl:with-param name="i" select="number($i)"/>
                                    <xsl:with-param name="increment" select="number($increment)"/>
                                    <xsl:with-param name="numFiles" select="number($num)"/>
                                </xsl:call-template>
                            </channel>
                        </mrss>
                    </xsl:result-document>                                  
                </xsl:for-each>                            
            </xsl:if>
            <xsl:if test="child::node()/name()='singleItem'">
                <xsl:for-each select="singleItem">
                    <xsl:variable name="num"
                        select="number(substring-before(field[@name='physicaldescription'][.!=''],' '))"/>
                    <xsl:result-document href="{concat('filesToIngest/',$prefix,substring(field[@name='digitalid'],4),'.xml')}"
                        indent="yes" method="xml" encoding="UTF-8">
                        <mrss xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                            <channel>
                                <xsl:call-template name="partMaker">
                                    <xsl:with-param name="i" select="number($i)"/>
                                    <xsl:with-param name="increment" select="number($increment)"/>
                                    <xsl:with-param name="numFiles" select="number($num)"/>
                                    <xsl:with-param name="digID" select="substring(field[@name='digitalid'],4)"/>
                                </xsl:call-template>
                            </channel>
                        </mrss>
                    </xsl:result-document>   
                </xsl:for-each>
            </xsl:if>                        
        </xsl:for-each>
        <xsl:choose>
            <xsl:when test="count(//objectRecord)&gt;0">
                <xsl:value-of select="count(//objectRecord)"/>
                <xsl:text> objects processed!</xsl:text>
            </xsl:when>
            <xsl:when test="count(//singleItem)&gt;0">
                <xsl:value-of select="count(//singleItem)"/>
                <xsl:text> items processed!</xsl:text>                
            </xsl:when>
        </xsl:choose>      
        <xsl:if test="$jazzOutTemplate='true'">
            <xsl:variable name="num" select="23"/>               
            <xsl:result-document href="{concat('templatesToIngest/',$prefix,$jazzOutObjID,'.xml')}"
                indent="yes" method="xml" encoding="UTF-8">
                <mrss xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                    <channel>
                        <xsl:call-template name="templateMaker">
                            <xsl:with-param name="i" select="number($i)"/>
                            <xsl:with-param name="increment" select="number($increment)"/>
                            <xsl:with-param name="numFiles" select="number($num)"/>                            
                        </xsl:call-template>
                    </channel>
                </mrss>
            </xsl:result-document>
            <xsl:value-of select="$num"/>
            <xsl:text> template records generated!</xsl:text>
            <xsl:text></xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template name="partMaker">
        <xsl:param name="i"/>
        <xsl:param name="increment"/>
        <xsl:param name="numFiles"/>
        <xsl:param name="digID"/>
        <xsl:variable name="testPassed">
            <xsl:if test="$i != $numFiles + 1">
                <xsl:text>true</xsl:text>
            </xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$testPassed='true'">
                <item>
                    <action>
                        <xsl:choose>
                            <xsl:when test="$add='true'">
                                <xsl:text>add</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>update</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </action>
                    <xsl:if test="$add='true'">
                        <type>1</type>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="$digID!=''">
                            <referenceId>
                                <xsl:for-each select="$digID">
                                    <xsl:value-of select="concat($prefix,.)"/>
                                </xsl:for-each>
                            </referenceId>        
                        </xsl:when>
                        <xsl:otherwise>
                            <referenceId>
                                <xsl:for-each select="identifier">
                                    <xsl:value-of
                                        select="if (string-length(string($i))&gt;1)
                                        then concat($prefix,.,'00',$i,'001')
                                        else (concat($prefix,.,'000',$i,'001'))"
                                    />
                                </xsl:for-each>
                            </referenceId>
                        </xsl:otherwise>
                    </xsl:choose>                                        
                    <userId>
                        <xsl:value-of select="$userId"/>
                    </userId>
                    <name>
                        <xsl:value-of select="field[@name='title']"/>
                        <xsl:if test="$numFiles&gt;1">
                            <xsl:text>: </xsl:text>
                            <xsl:text>Part </xsl:text>
                            <xsl:value-of select="$i"/>
                            <xsl:text> of </xsl:text>
                            <xsl:value-of select="$numFiles"/>
                        </xsl:if>
                    </name>
                    <description>
                        <xsl:value-of
                            select="normalize-space(concat(field[@name='summary'],' ',field[@name='note']))"
                        />
                    </description>                    
                    <tags>
                        <xsl:for-each select="field[@name='subjects'][.!='']|field[@name='subject'][.!='']">
                            <xsl:choose>
                                <xsl:when test="contains(.,';')">
                                    <xsl:for-each select="tokenize(.,';')">
                                        <tag>
                                            <xsl:choose>
                                                <xsl:when
                                                    test="matches(substring-after(.,','),'-*[0-9]{4}-*')">
                                                    <xsl:analyze-string select="." regex="(-*[0-9]{{4}}-*)">
                                                        <xsl:non-matching-substring>
                                                            <xsl:value-of
                                                                select="normalize-space(concat(normalize-space(substring-before(substring-after(.,','),',')),' ',normalize-space(substring-before(.,','))))"
                                                            />
                                                        </xsl:non-matching-substring>
                                                    </xsl:analyze-string>
                                                    <xsl:text> (</xsl:text>
                                                    <xsl:analyze-string select="." regex="(-*[0-9]{{4}}-*)">
                                                        <xsl:matching-substring>
                                                            <xsl:value-of select="."/>
                                                        </xsl:matching-substring>
                                                    </xsl:analyze-string>
                                                    <xsl:text>)</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:choose>
                                                        <xsl:when test="contains(.,',') and not(contains(.,'('))">
                                                            <xsl:value-of
                                                                select="concat(normalize-space(substring-after(.,',')),' ',normalize-space(substring-before(.,',')))"
                                                            />
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="normalize-space(.)"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </tag>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <tag>
                                        <xsl:choose>
                                            <xsl:when
                                                test="matches(substring-after(.,','),'-*[0-9]{4}-*')">
                                                <xsl:analyze-string select="." regex="(-*[0-9]{{4}}-*)">
                                                    <xsl:non-matching-substring>
                                                        <xsl:value-of
                                                            select="normalize-space(concat(normalize-space(substring-before(substring-after(.,','),',')),' ',normalize-space(substring-before(.,','))))"
                                                        />
                                                    </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                                <xsl:text> (</xsl:text>
                                                <xsl:analyze-string select="." regex="(-*[0-9]{{4}}-*)">
                                                    <xsl:matching-substring>
                                                        <xsl:value-of select="."/>
                                                    </xsl:matching-substring>
                                                </xsl:analyze-string>
                                                <xsl:text>)</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:choose>
                                                    <xsl:when test="contains(.,',')">
                                                        <xsl:value-of
                                                            select="concat(normalize-space(substring-after(.,',')),' ',normalize-space(substring-before(.,',')))"
                                                        />
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="normalize-space(.)"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </tag>
                                </xsl:otherwise>
                            </xsl:choose>                                
                        </xsl:for-each>
                    </tags>                    
                    <categories>
                        <category>
                            <xsl:text>Mediaspace&gt;site&gt;channels&gt;</xsl:text>
                            <xsl:value-of select="$channelName"/>
                        </category>
                    </categories>
                    <media>
                        <mediaType>
                            <xsl:value-of select="$mediaType"/>
                        </mediaType>
                    </media>                                       
                    <xsl:if test="$add='true'">
                        <contentAssets>
                            <content>
                                <dropFolderFileContentResource>
                                    <xsl:attribute name="filePath">
                                        <xsl:choose>
                                            <xsl:when test="$digID!=''">                                                
                                                <xsl:for-each select="field[@name='archive']">
                                                    <xsl:value-of select="if (contains(.,'-'))
                                                                  then concat(substring-before(.,'-'),'-2.mp4')
                                                                  else (concat($prefix,substring(.,4)))"/>                                                    
                                                </xsl:for-each>                                                        
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:for-each
                                                    select="identifier">
                                                    <xsl:value-of
                                                        select="if (string-length(string($i))&gt;1)
                                                        then concat($prefix,.,'00',$i,'002','.mp4')
                                                        else (concat($prefix,.,'000',$i,'002','.mp4'))"/>
                                                </xsl:for-each>
                                            </xsl:otherwise>
                                        </xsl:choose>                                        
                                    </xsl:attribute>
                                </dropFolderFileContentResource>
                            </content>
                        </contentAssets>
                    </xsl:if>                    
                    <customDataItems>
                        <customData metadataProfileId="{$metadataProfileId}">
                            <xmlData>
                                <metadata>
                                    <DigitalCollectionsLink>
                                        <xsl:text>&lt;a href="</xsl:text>
                                        <xsl:value-of select="field[@name='referenceurl']"/>
                                        <xsl:text>"&gt;University of Miami Digital Collections&lt;/a&gt;</xsl:text>
                                    </DigitalCollectionsLink>
                                    <xsl:if test="$numFiles&gt;1">
                                        <PartNumber>
                                            <xsl:value-of select="$i"/>
                                            <xsl:text> of </xsl:text>
                                            <xsl:value-of select="$numFiles"/>
                                        </PartNumber>
                                    </xsl:if>
                                    <xsl:for-each
                                        select="field[@name='creator'][.!=''] | field[@name='interviewer'][.!=''] | field[@name='speakers'][.!=''] | field[@name='interviewee'][.!=''] | field[@name='director'][.!=''] | field[@name='producer'][.!=''] | field[@name='photographer'][.!='']">                                                                               
                                        <xsl:variable name="nameVal" select="@name"/>                                    
                                        <xsl:choose>
                                            <xsl:when test="@name='speakers'">
                                                <xsl:choose>
                                                    <xsl:when test="contains(.,';')">
                                                        <xsl:for-each select="tokenize(.,';')">
                                                            <Creator>
                                                                <xsl:value-of
                                                                    select="concat(normalize-space(.),' (speaker)')"/>
                                                            </Creator>
                                                        </xsl:for-each>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <Creator>
                                                            <xsl:value-of
                                                                select="concat(normalize-space(.),' (speaker)')"/>
                                                        </Creator>
                                                    </xsl:otherwise>
                                                </xsl:choose>                                                  
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:choose>
                                                    <xsl:when test="contains(.,'; ')">
                                                        <xsl:for-each select="tokenize(.,';')">
                                                            <Creator>
                                                                <xsl:value-of select="normalize-space(.)"/>
                                                                <xsl:if test="$nameVal!='creator'">
                                                                    <xsl:value-of
                                                                        select="concat(' (',normalize-space($nameVal),')')"/>
                                                                        <!-- concat(translate(substring(@name,1,1),$vLower,$vUpper),substring(@name,2)) -->
                                                                </xsl:if>
                                                            </Creator>
                                                        </xsl:for-each>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <Creator>
                                                            <xsl:value-of select="normalize-space(.)"/>
                                                            <xsl:if test="$nameVal!='creator'">
                                                                <xsl:value-of
                                                                    select="concat(' (',normalize-space($nameVal),')')"/>                                                            
                                                            </xsl:if>
                                                        </Creator>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:otherwise>
                                        </xsl:choose>                                        
                                    </xsl:for-each>                                   
                                    <xsl:for-each
                                        select="field[@name='contributor'][.!=''] | field[@name='contributors'][.!=''] | field[@name='videographer'][.!=''] | field[@name='transcriber'][.!=''] | field[@name='cast'][.!='']">
                                        <xsl:variable name="nameVal" select="@name"/>                                        
                                        <xsl:choose>
                                            <xsl:when test="contains(.,';')">
                                                <xsl:for-each select="tokenize(.,';')">
                                                    <Contributor>
                                                        <xsl:value-of select="normalize-space(.)"/>
                                                        <xsl:if test="$nameVal!='contributor' and $nameVal!='contributors'">
                                                            <xsl:value-of
                                                                select="concat(' (',normalize-space($nameVal),')')"/>
                                                                <!-- concat(translate(substring(@name,1,1),$vLower,$vUpper),substring(@name,2)) -->
                                                        </xsl:if>
                                                    </Contributor>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <Contributor>
                                                    <xsl:value-of select="normalize-space(.)"/>
                                                    <xsl:if test="$nameVal!='contributor' and $nameVal!='contributors'">
                                                        <xsl:value-of
                                                            select="concat(' (',normalize-space($nameVal),')')"/>
                                                        <!-- concat(translate(substring(@name,1,1),$vLower,$vUpper),substring(@name,2)) -->
                                                    </xsl:if>
                                                </Contributor>
                                            </xsl:otherwise>
                                        </xsl:choose>  
                                    </xsl:for-each>
                                    <xsl:for-each select="field[@name='host'][.!='']">
                                        <xsl:variable name="nameVal" select="@name"/>
                                        <xsl:choose>
                                            <xsl:when test="contains(.,';')">
                                                <xsl:for-each select="tokenize(.,';')">
                                                    <Contributor>
                                                        <xsl:value-of
                                                            select="concat(normalize-space($hostName),' (',normalize-space($nameVal),')')"/>
                                                        <!-- concat(translate(substring(@name,1,1),$vLower,$vUpper),substring(@name,2)) -->
                                                    </Contributor>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <Contributor>
                                                    <xsl:value-of
                                                        select="concat(normalize-space($hostName),' (',normalize-space($nameVal),')')"/>
                                                </Contributor>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>                                    
                                    <xsl:for-each select="field[@name='genre']">
                                        <xsl:choose>
                                            <xsl:when test="contains(.,';')">
                                                <xsl:for-each select="tokenize(.,';')">
                                                    <Genre>
                                                        <xsl:choose>
                                                            <xsl:when test="string-length(translate(substring(normalize-space(.),1,1),$vLower,''))=0">                                                                
                                                                <xsl:value-of select="concat(translate(substring(normalize-space(.),1,1),$vLower,$vUpper),substring(normalize-space(.),2))"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="normalize-space(.)"/>            
                                                            </xsl:otherwise>
                                                        </xsl:choose>                                                        
                                                    </Genre>            
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <Genre>
                                                    <xsl:value-of select="normalize-space(.)"/>
                                                </Genre>
                                            </xsl:otherwise>
                                        </xsl:choose>                                        
                                    </xsl:for-each>
                                    <xsl:for-each select="tokenize(field[@name='language'][.!=''],';')">
                                        <!-- Match Kaltura controlled list. -->
                                        <Language>
                                            <xsl:if test=". = 'aar'">
                                                <xsl:text>Afar</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'abk'">
                                                <xsl:text>Abkhaz</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ace'">
                                                <xsl:text>Achinese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ach'">
                                                <xsl:text>Acoli</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ada'">
                                                <xsl:text>Adangme</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ady'">
                                                <xsl:text>Adygei</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'afa'">
                                                <xsl:text>Afroasiatic (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'afh'">
                                                <xsl:text>Afrihili (Artxsl:ificial language)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'afr'">
                                                <xsl:text>Afrikaans</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'aka'">
                                                <xsl:text>Akan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'akk'">
                                                <xsl:text>Akkadian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'alb'">
                                                <xsl:text>Albanian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ale'">
                                                <xsl:text>Aleut</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'alg'">
                                                <xsl:text>Algonquian (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'amh'">
                                                <xsl:text>Amharic</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ang'">
                                                <xsl:text>English, Old (ca. 450-1100)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'anp'">
                                                <xsl:text>Angika</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'apa'">
                                                <xsl:text>Apache languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ara'">
                                                <xsl:text>Arabic</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'arc'">
                                                <xsl:text>Aramaic</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'arg'">
                                                <xsl:text>Aragonese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'arm'">
                                                <xsl:text>Armenian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'arn'">
                                                <xsl:text>Mapuche</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'arp'">
                                                <xsl:text>Arapaho</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'art'">
                                                <xsl:text>Artxsl:ificial (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'arw'">
                                                <xsl:text>Arawak</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'asm'">
                                                <xsl:text>Assamese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ast'">
                                                <xsl:text>Bable</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ath'">
                                                <xsl:text>Athapascan (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'aus'">
                                                <xsl:text>Australian languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ava'">
                                                <xsl:text>Avaric</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ave'">
                                                <xsl:text>Avestan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'awa'">
                                                <xsl:text>Awadhi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'aym'">
                                                <xsl:text>Aymara</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'aze'">
                                                <xsl:text>Azerbaijani</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bai'">
                                                <xsl:text>Bamileke languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bak'">
                                                <xsl:text>Bashkir</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bal'">
                                                <xsl:text>Baluchi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bam'">
                                                <xsl:text>Bambara</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ban'">
                                                <xsl:text>Balinese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'baq'">
                                                <xsl:text>Basque</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bas'">
                                                <xsl:text>Basa</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bat'">
                                                <xsl:text>Baltic (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bej'">
                                                <xsl:text>Beja</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bel'">
                                                <xsl:text>Belarusian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bem'">
                                                <xsl:text>Bemba</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ben'">
                                                <xsl:text>Bengali</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ber'">
                                                <xsl:text>Berber (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bho'">
                                                <xsl:text>Bhojpuri</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bih'">
                                                <xsl:text>Bihari (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bik'">
                                                <xsl:text>Bikol</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bin'">
                                                <xsl:text>Edo</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bis'">
                                                <xsl:text>Bislama</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bla'">
                                                <xsl:text>Siksika</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bnt'">
                                                <xsl:text>Bantu (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bod'">
                                                <xsl:text>Tibetan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bos'">
                                                <xsl:text>Bosnian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bra'">
                                                <xsl:text>Braj</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bre'">
                                                <xsl:text>Breton</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'btk'">
                                                <xsl:text>Batak</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bua'">
                                                <xsl:text>Buriat</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bug'">
                                                <xsl:text>Bugis</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bul'">
                                                <xsl:text>Bulgarian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'bur'">
                                                <xsl:text>Burmese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'byn'">
                                                <xsl:text>Bilin</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cad'">
                                                <xsl:text>Caddo</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cai'">
                                                <xsl:text>Central American Indian (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'car'">
                                                <xsl:text>Carib</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cat'">
                                                <xsl:text>Catalan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cau'">
                                                <xsl:text>Caucasian (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ceb'">
                                                <xsl:text>Cebuano</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cel'">
                                                <xsl:text>Celtic (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ces'">
                                                <xsl:text>Czech</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cha'">
                                                <xsl:text>Chamorro</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'chb'">
                                                <xsl:text>Chibcha</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'che'">
                                                <xsl:text>Chechen</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'chg'">
                                                <xsl:text>Chagatai</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'chi'">
                                                <xsl:text>Chinese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'chk'">
                                                <xsl:text>Chuukese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'chm'">
                                                <xsl:text>Mari</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'chn'">
                                                <xsl:text>Chinook jargon</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cho'">
                                                <xsl:text>Choctaw</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'chp'">
                                                <xsl:text>Chipewyan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'chr'">
                                                <xsl:text>Cherokee</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'chu'">
                                                <xsl:text>Church Slavic</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'chv'">
                                                <xsl:text>Chuvash</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'chy'">
                                                <xsl:text>Cheyenne</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cmc'">
                                                <xsl:text>Chamic languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cop'">
                                                <xsl:text>Coptic</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cor'">
                                                <xsl:text>Cornish</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cos'">
                                                <xsl:text>Corsican</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cpe'">
                                                <xsl:text>Creoles and Pidgins, English-based (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cpf'">
                                                <xsl:text>Creoles and Pidgins, French-based (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cpp'">
                                                <xsl:text>Creoles and Pidgins, Portuguese-based (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cre'">
                                                <xsl:text>Cree</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'crh'">
                                                <xsl:text>Crimean Tatar</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'crp'">
                                                <xsl:text>Creoles and Pidgins (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'csb'">
                                                <xsl:text>Kashubian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cus'">
                                                <xsl:text>Cushitic (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cym'">
                                                <xsl:text>Welsh</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'cze'">
                                                <xsl:text>Czech</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'dak'">
                                                <xsl:text>Dakota</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'dan'">
                                                <xsl:text>Danish</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'dar'">
                                                <xsl:text>Dargwa</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'day'">
                                                <xsl:text>Dayak</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'del'">
                                                <xsl:text>Delaware</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'den'">
                                                <xsl:text>Slavey</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'deu'">
                                                <xsl:text>German</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'dgr'">
                                                <xsl:text>Dogrib</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'din'">
                                                <xsl:text>Dinka</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'div'">
                                                <xsl:text>Divehi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'doi'">
                                                <xsl:text>Dogri</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'dra'">
                                                <xsl:text>Dravidian (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'dsb'">
                                                <xsl:text>Lower Sorbian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'dua'">
                                                <xsl:text>Duala</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'dum'">
                                                <xsl:text>Dutch, Middle (ca. 1050-1350)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'dut'">
                                                <xsl:text>Dutch</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'dyu'">
                                                <xsl:text>Dyula</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'dzo'">
                                                <xsl:text>Dzongkha</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'efi'">
                                                <xsl:text>Efik</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'egy'">
                                                <xsl:text>Egyptian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'eka'">
                                                <xsl:text>Ekajuk</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ell'">
                                                <xsl:text>Greek, Modern (1453-)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'elx'">
                                                <xsl:text>Elamite</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'eng'">
                                                <xsl:text>English</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'enm'">
                                                <xsl:text>English, Middle (1100-1500)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'epo'">
                                                <xsl:text>Esperanto</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'est'">
                                                <xsl:text>Estonian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'eus'">
                                                <xsl:text>Basque</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ewe'">
                                                <xsl:text>Ewe</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ewo'">
                                                <xsl:text>Ewondo</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'fan'">
                                                <xsl:text>Fang</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'fao'">
                                                <xsl:text>Faroese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'fas'">
                                                <xsl:text>Persian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'fat'">
                                                <xsl:text>Fanti</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'fij'">
                                                <xsl:text>Fijian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'fil'">
                                                <xsl:text>Filipino</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'fin'">
                                                <xsl:text>Finnish</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'fiu'">
                                                <xsl:text>Finno-Ugrian (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'fon'">
                                                <xsl:text>Fon</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'fra'">
                                                <xsl:text>French</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'fre'">
                                                <xsl:text>French</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'frm'">
                                                <xsl:text>French, Middle (ca. 1300-1600)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'fro'">
                                                <xsl:text>French, Old (ca. 842-1300)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'fry'">
                                                <xsl:text>Frisian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ful'">
                                                <xsl:text>Fula</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'fur'">
                                                <xsl:text>Friulian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'gaa'">
                                                <xsl:text>Gã</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'gay'">
                                                <xsl:text>Gayo</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'gba'">
                                                <xsl:text>Gbaya</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'gem'">
                                                <xsl:text>Germanic (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'geo'">
                                                <xsl:text>Georgian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ger'">
                                                <xsl:text>German</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'gez'">
                                                <xsl:text>Ethiopic</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'gil'">
                                                <xsl:text>Gilbertese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'gla'">
                                                <xsl:text>Scottish Gaelic</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'gle'">
                                                <xsl:text>Irish</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'glg'">
                                                <xsl:text>Galician</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'glv'">
                                                <xsl:text>Manx</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'gmh'">
                                                <xsl:text>German, Middle High (ca. 1050-1500)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'goh'">
                                                <xsl:text>German, Old High (ca. 750-1050)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'gon'">
                                                <xsl:text>Gondi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'gor'">
                                                <xsl:text>Gorontalo</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'got'">
                                                <xsl:text>Gothic</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'grb'">
                                                <xsl:text>Grebo</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'grc'">
                                                <xsl:text>Greek, Ancient (to 1453)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'gre'">
                                                <xsl:text>Greek, Modern (1453-)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'grn'">
                                                <xsl:text>Guarani</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'gsw'">
                                                <xsl:text>Swiss German</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'guj'">
                                                <xsl:text>Gujarati</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'gwi'">
                                                <xsl:text>Gwich'in</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'hai'">
                                                <xsl:text>Haida</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'hat'">
                                                <xsl:text>Haitian French Creole</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'hau'">
                                                <xsl:text>Hausa</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'haw'">
                                                <xsl:text>Hawaiian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'heb'">
                                                <xsl:text>Hebrew</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'her'">
                                                <xsl:text>Herero</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'hil'">
                                                <xsl:text>Hiligaynon</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'him'">
                                                <xsl:text>Western Pahari languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'hin'">
                                                <xsl:text>Hindi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'hit'">
                                                <xsl:text>Hittite</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'hmn'">
                                                <xsl:text>Hmong</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'hmo'">
                                                <xsl:text>Hiri Motu</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'hrv'">
                                                <xsl:text>Croatian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'hsb'">
                                                <xsl:text>Upper Sorbian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'hun'">
                                                <xsl:text>Hungarian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'hup'">
                                                <xsl:text>Hupa</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'hye'">
                                                <xsl:text>Armenian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'iba'">
                                                <xsl:text>Iban</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ibo'">
                                                <xsl:text>Igbo</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ice'">
                                                <xsl:text>Icelandic</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ido'">
                                                <xsl:text>Ido</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'iii'">
                                                <xsl:text>Sichuan Yi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ijo'">
                                                <xsl:text>Ijo</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'iku'">
                                                <xsl:text>Inuktitut</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ile'">
                                                <xsl:text>Interlingue</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ilo'">
                                                <xsl:text>Iloko</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ina'">
                                                <xsl:text>Interlingua (International Auxiliary Language Association)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'inc'">
                                                <xsl:text>Indic (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ind'">
                                                <xsl:text>Indonesian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ine'">
                                                <xsl:text>Indo-European (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'inh'">
                                                <xsl:text>Ingush</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ipk'">
                                                <xsl:text>Inupiaq</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ira'">
                                                <xsl:text>Iranian (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'iro'">
                                                <xsl:text>Iroquoian (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'isl'">
                                                <xsl:text>Icelandic</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ita'">
                                                <xsl:text>Italian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'jav'">
                                                <xsl:text>Javanese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'jbo'">
                                                <xsl:text>Lojban (Artxsl:ificial language)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'jpn'">
                                                <xsl:text>Japanese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'jpr'">
                                                <xsl:text>Judeo-Persian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'jrb'">
                                                <xsl:text>Judeo-Arabic</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kaa'">
                                                <xsl:text>Kara-Kalpak</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kab'">
                                                <xsl:text>Kabyle</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kac'">
                                                <xsl:text>Kachin</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kal'">
                                                <xsl:text>Kalâtdlisut</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kam'">
                                                <xsl:text>Kamba</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kan'">
                                                <xsl:text>Kannada</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kar'">
                                                <xsl:text>Karen languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kas'">
                                                <xsl:text>Kashmiri</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kat'">
                                                <xsl:text>Georgian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kau'">
                                                <xsl:text>Kanuri</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kaw'">
                                                <xsl:text>Kawi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kaz'">
                                                <xsl:text>Kazakh</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kbd'">
                                                <xsl:text>Kabardian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kha'">
                                                <xsl:text>Khasi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'khi'">
                                                <xsl:text>Khoisan (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'khm'">
                                                <xsl:text>Khmer</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kho'">
                                                <xsl:text>Khotanese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kik'">
                                                <xsl:text>Kikuyu</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kin'">
                                                <xsl:text>Kinyarwanda</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kir'">
                                                <xsl:text>Kyrgyz</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kmb'">
                                                <xsl:text>Kimbundu</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kok'">
                                                <xsl:text>Konkani</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kom'">
                                                <xsl:text>Komi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kon'">
                                                <xsl:text>Kongo</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kor'">
                                                <xsl:text>Korean</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kos'">
                                                <xsl:text>Kosraean</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kpe'">
                                                <xsl:text>Kpelle</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'krc'">
                                                <xsl:text>Karachay-Balkar</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kro'">
                                                <xsl:text>Kru (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kru'">
                                                <xsl:text>Kurukh</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kua'">
                                                <xsl:text>Kuanyama</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kum'">
                                                <xsl:text>Kumyk</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kur'">
                                                <xsl:text>Kurdish</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'kut'">
                                                <xsl:text>Kootenai</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lad'">
                                                <xsl:text>Ladino</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lah'">
                                                <xsl:text>Lahndā</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lam'">
                                                <xsl:text>Lamba (Zambia and Congo)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lao'">
                                                <xsl:text>Lao</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lat'">
                                                <xsl:text>Latin</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lav'">
                                                <xsl:text>Latvian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lez'">
                                                <xsl:text>Lezgian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lim'">
                                                <xsl:text>Limburgish</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lin'">
                                                <xsl:text>Lingala</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lit'">
                                                <xsl:text>Lithuanian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lol'">
                                                <xsl:text>Mongo-Nkundu</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'loz'">
                                                <xsl:text>Lozi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ltz'">
                                                <xsl:text>Luxembourgish</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lua'">
                                                <xsl:text>Luba-Lulua</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lub'">
                                                <xsl:text>Luba-Katanga</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lug'">
                                                <xsl:text>Ganda</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lui'">
                                                <xsl:text>Luiseño</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lun'">
                                                <xsl:text>Lunda</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'luo'">
                                                <xsl:text>Luo (Kenya and Tanzania)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'lus'">
                                                <xsl:text>Lushai</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mac'">
                                                <xsl:text>Macedonian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mad'">
                                                <xsl:text>Madurese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mag'">
                                                <xsl:text>Magahi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mah'">
                                                <xsl:text>Marshallese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mai'">
                                                <xsl:text>Maithili</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mak'">
                                                <xsl:text>Makasar</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mal'">
                                                <xsl:text>Malayalam</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'man'">
                                                <xsl:text>Mandingo</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mao'">
                                                <xsl:text>Maori</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'map'">
                                                <xsl:text>Austronesian (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mar'">
                                                <xsl:text>Marathi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mas'">
                                                <xsl:text>Maasai</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'may'">
                                                <xsl:text>Malay</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mdf'">
                                                <xsl:text>Moksha</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mdr'">
                                                <xsl:text>Mandar</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'men'">
                                                <xsl:text>Mende</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mga'">
                                                <xsl:text>Irish, Middle (ca. 1100-1550)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mic'">
                                                <xsl:text>Micmac</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'min'">
                                                <xsl:text>Minangkabau</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mis'">
                                                <xsl:text>Miscellaneous languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mkd'">
                                                <xsl:text>Macedonian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mkh'">
                                                <xsl:text>Mon-Khmer (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mlg'">
                                                <xsl:text>Malagasy</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mlt'">
                                                <xsl:text>Maltese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mnc'">
                                                <xsl:text>Manchu</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mni'">
                                                <xsl:text>Manipuri</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mno'">
                                                <xsl:text>Manobo languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'moh'">
                                                <xsl:text>Mohawk</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mol'">
                                                <xsl:text>Moldovan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mon'">
                                                <xsl:text>Mongolian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mos'">
                                                <xsl:text>Mooré</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mri'">
                                                <xsl:text>Maori</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'msa'">
                                                <xsl:text>Malay</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mul'">
                                                <xsl:text>Multiple languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mun'">
                                                <xsl:text>Munda (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mus'">
                                                <xsl:text>Creek</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mwl'">
                                                <xsl:text>Mirandese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mwr'">
                                                <xsl:text>Marwari</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'mya'">
                                                <xsl:text>Burmese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'myn'">
                                                <xsl:text>Mayan languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'myv'">
                                                <xsl:text>Erzya</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nah'">
                                                <xsl:text>Nahuatl</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nai'">
                                                <xsl:text>North American Indian (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nap'">
                                                <xsl:text>Neapolitan Italian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nau'">
                                                <xsl:text>Nauru</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nav'">
                                                <xsl:text>Navajo</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nbl'">
                                                <xsl:text>Ndebele (South Africa)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nde'">
                                                <xsl:text>Ndebele (Zimbabwe)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ndo'">
                                                <xsl:text>Ndonga</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nds'">
                                                <xsl:text>Low German</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nep'">
                                                <xsl:text>Nepali</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'new'">
                                                <xsl:text>Newari</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nia'">
                                                <xsl:text>Nias</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nic'">
                                                <xsl:text>Niger-Kordofanian (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'niu'">
                                                <xsl:text>Niuean</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nld'">
                                                <xsl:text>Dutch; Flemish</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nno'">
                                                <xsl:text>Norwegian (Nynorsk)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nob'">
                                                <xsl:text>Norwegian (Bokmål)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nog'">
                                                <xsl:text>Nogai</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'non'">
                                                <xsl:text>Old Norse</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nor'">
                                                <xsl:text>Norwegian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nso'">
                                                <xsl:text>Northern Sotho</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nub'">
                                                <xsl:text>Nubian languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nwc'">
                                                <xsl:text>Newari, Old</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nya'">
                                                <xsl:text>Nyanja</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nym'">
                                                <xsl:text>Nyamwezi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nyn'">
                                                <xsl:text>Nyankole</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nyo'">
                                                <xsl:text>Nyoro</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'nzi'">
                                                <xsl:text>Nzima</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'oci'">
                                                <xsl:text>Occitan (post-1500)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'oji'">
                                                <xsl:text>Ojibwa</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ori'">
                                                <xsl:text>Oriya</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'orm'">
                                                <xsl:text>Oromo</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'osa'">
                                                <xsl:text>Osage</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'oss'">
                                                <xsl:text>Ossetic</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ota'">
                                                <xsl:text>Turkish, Ottoman</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'oto'">
                                                <xsl:text>Otomian languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'paa'">
                                                <xsl:text>Papuan (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'pag'">
                                                <xsl:text>Pangasinan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'pal'">
                                                <xsl:text>Pahlavi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'pam'">
                                                <xsl:text>Pampanga</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'pan'">
                                                <xsl:text>Panjabi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'pap'">
                                                <xsl:text>Papiamento</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'pau'">
                                                <xsl:text>Palauan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'peo'">
                                                <xsl:text>Old Persian (ca. 600-400 B.C.)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'per'">
                                                <xsl:text>Persian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'phi'">
                                                <xsl:text>Philippine (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'phn'">
                                                <xsl:text>Phoenician</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'pli'">
                                                <xsl:text>Pali</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'pol'">
                                                <xsl:text>Polish</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'pon'">
                                                <xsl:text>Pohnpeian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'por'">
                                                <xsl:text>Portuguese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'pra'">
                                                <xsl:text>Prakrit languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'pro'">
                                                <xsl:text>Provençal (to 1500)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'pus'">
                                                <xsl:text>Pushto</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'que'">
                                                <xsl:text>Quechua</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'raj'">
                                                <xsl:text>Rajasthani</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'rap'">
                                                <xsl:text>Rapanui</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'rar'">
                                                <xsl:text>Rarotongan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'roa'">
                                                <xsl:text>Romance (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'roh'">
                                                <xsl:text>Raeto-Romance</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'rom'">
                                                <xsl:text>Romani</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ron'">
                                                <xsl:text>Romanian; Moldavian; Moldovan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'rum'">
                                                <xsl:text>Romanian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'run'">
                                                <xsl:text>Rundi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'rus'">
                                                <xsl:text>Russian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sad'">
                                                <xsl:text>Sandawe</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sag'">
                                                <xsl:text>Sango (Ubangi Creole)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sah'">
                                                <xsl:text>Yakut</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sai'">
                                                <xsl:text>South American Indian (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sal'">
                                                <xsl:text>Salishan languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sam'">
                                                <xsl:text>Samaritan Aramaic</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'san'">
                                                <xsl:text>Sanskrit</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sas'">
                                                <xsl:text>Sasak</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sat'">
                                                <xsl:text>Santali</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'scc'">
                                                <xsl:text>Serbian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'scn'">
                                                <xsl:text>Sicilian Italian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sco'">
                                                <xsl:text>Scots</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'scr'">
                                                <xsl:text>Croatian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sel'">
                                                <xsl:text>Selkup</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sem'">
                                                <xsl:text>Semitic (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sga'">
                                                <xsl:text>Irish, Old (to 1100)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sgn'">
                                                <xsl:text>Sign languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'shn'">
                                                <xsl:text>Shan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sid'">
                                                <xsl:text>Sidamo</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sin'">
                                                <xsl:text>Sinhalese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sio'">
                                                <xsl:text>Siouan (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sit'">
                                                <xsl:text>Sino-Tibetan (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sla'">
                                                <xsl:text>Slavic (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'slk'">
                                                <xsl:text>Slovak</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'slo'">
                                                <xsl:text>Slovak</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'slv'">
                                                <xsl:text>Slovenian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sma'">
                                                <xsl:text>Southern Sami</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sme'">
                                                <xsl:text>Northern Sami</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'smi'">
                                                <xsl:text>Sami</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'smj'">
                                                <xsl:text>Lule Sami</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'smn'">
                                                <xsl:text>Inari Sami</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'smo'">
                                                <xsl:text>Samoan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sms'">
                                                <xsl:text>Skolt Sami</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sna'">
                                                <xsl:text>Shona</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'snd'">
                                                <xsl:text>Sindhi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'snk'">
                                                <xsl:text>Soninke</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sog'">
                                                <xsl:text>Sogdian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'som'">
                                                <xsl:text>Somali</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'son'">
                                                <xsl:text>Songhai</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sot'">
                                                <xsl:text>Sotho</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'spa'">
                                                <xsl:text>Spanish</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'srd'">
                                                <xsl:text>Sardinian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'srn'">
                                                <xsl:text>Sranan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'srp'">
                                                <xsl:text>Serbian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'srr'">
                                                <xsl:text>Serer</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ssa'">
                                                <xsl:text>Nilo-Saharan (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ssw'">
                                                <xsl:text>Swazi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'suk'">
                                                <xsl:text>Sukuma</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sun'">
                                                <xsl:text>Sundanese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sus'">
                                                <xsl:text>Susu</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'sux'">
                                                <xsl:text>Sumerian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'swa'">
                                                <xsl:text>Swahili</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'swe'">
                                                <xsl:text>Swedish</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'syr'">
                                                <xsl:text>Syriac, Modern</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tah'">
                                                <xsl:text>Tahitian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tai'">
                                                <xsl:text>Tai (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tam'">
                                                <xsl:text>Tamil</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tat'">
                                                <xsl:text>Tatar</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tel'">
                                                <xsl:text>Telugu</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tem'">
                                                <xsl:text>Temne</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ter'">
                                                <xsl:text>Terena</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tet'">
                                                <xsl:text>Tetum</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tgk'">
                                                <xsl:text>Tajik</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tgl'">
                                                <xsl:text>Tagalog</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tha'">
                                                <xsl:text>Thai</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tib'">
                                                <xsl:text>Tibetan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tig'">
                                                <xsl:text>Tigré</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tir'">
                                                <xsl:text>Tigrinya</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tiv'">
                                                <xsl:text>Tiv</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tkl'">
                                                <xsl:text>Tokelauan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tlh'">
                                                <xsl:text>Klingon (Artxsl:ificial language)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tli'">
                                                <xsl:text>Tlingit</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tmh'">
                                                <xsl:text>Tamashek</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tog'">
                                                <xsl:text>Tonga (Nyasa)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ton'">
                                                <xsl:text>Tongan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tpi'">
                                                <xsl:text>Tok Pisin</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tsi'">
                                                <xsl:text>Tsimshian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tsn'">
                                                <xsl:text>Tswana</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tso'">
                                                <xsl:text>Tsonga</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tuk'">
                                                <xsl:text>Turkmen</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tum'">
                                                <xsl:text>Tumbuka</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tup'">
                                                <xsl:text>Tupi languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tur'">
                                                <xsl:text>Turkish</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tut'">
                                                <xsl:text>Altaic (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tvl'">
                                                <xsl:text>Tuvaluan</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'twi'">
                                                <xsl:text>Twi</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'tyv'">
                                                <xsl:text>Tuvinian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'udm'">
                                                <xsl:text>Udmurt</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'uga'">
                                                <xsl:text>Ugaritic</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'uig'">
                                                <xsl:text>Uighur</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ukr'">
                                                <xsl:text>Ukrainian</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'umb'">
                                                <xsl:text>Umbundu</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'und'">
                                                <xsl:text>Undetermined</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'urd'">
                                                <xsl:text>Urdu</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'uzb'">
                                                <xsl:text>Uzbek</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'vai'">
                                                <xsl:text>Vai</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ven'">
                                                <xsl:text>Venda</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'vie'">
                                                <xsl:text>Vietnamese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'vol'">
                                                <xsl:text>Volapük</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'vot'">
                                                <xsl:text>Votic</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'wak'">
                                                <xsl:text>Wakashan languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'wal'">
                                                <xsl:text>Wolayta</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'war'">
                                                <xsl:text>Waray</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'was'">
                                                <xsl:text>Washoe</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'wel'">
                                                <xsl:text>Welsh</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'wen'">
                                                <xsl:text>Sorbian (Other)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'wln'">
                                                <xsl:text>Walloon</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'wol'">
                                                <xsl:text>Wolof</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'xal'">
                                                <xsl:text>Oirat</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'xho'">
                                                <xsl:text>Xhosa</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'yao'">
                                                <xsl:text>Yao (Africa)</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'yap'">
                                                <xsl:text>Yapese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'yid'">
                                                <xsl:text>Yiddish</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'yor'">
                                                <xsl:text>Yoruba</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'ypk'">
                                                <xsl:text>Yupik languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'zap'">
                                                <xsl:text>Zapotec</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'zen'">
                                                <xsl:text>Zenaga</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'zha'">
                                                <xsl:text>Zhuang</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'zho'">
                                                <xsl:text>Chinese</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'znd'">
                                                <xsl:text>Zande languages</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'zul'">
                                                <xsl:text>Zulu</xsl:text>
                                            </xsl:if>
                                            <xsl:if test=". = 'zun'">
                                                <xsl:text>Zuni</xsl:text>
                                            </xsl:if>
                                        </Language>
                                    </xsl:for-each>
                                    
                                    <xsl:for-each
                                        select="field[@name='interviewdate'][.!=''] | field[@name='date'][.!='']">
                                        <xsl:choose>
                                            <xsl:when test="contains(.,';')">
                                                <xsl:for-each select="tokenize(.,';')">                                                    
                                                    <CreationDate>
                                                        <xsl:variable name="date"
                                                            select="concat(normalize-space(.),'T12:00:00.00')"/>
                                                        <xsl:value-of
                                                            select="( xs:dateTime($date) - xs:dateTime('1970-01-01T00:00:00') )
                                                            div
                                                            xs:dayTimeDuration('PT1S')"
                                                        />
                                                    </CreationDate>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>                                    
                                                <CreationDate>
                                                    <xsl:variable name="date"
                                                        select="concat(normalize-space(.),'T12:00:00.00')"/>
                                                    <xsl:value-of
                                                        select="( xs:dateTime($date) - xs:dateTime('1970-01-01T00:00:00') )
                                                        div
                                                        xs:dayTimeDuration('PT1S')"
                                                    />
                                                </CreationDate>                                                                                    
                                            </xsl:otherwise>
                                        </xsl:choose>                                        
                                    </xsl:for-each>
                                    
                                    <xsl:for-each select="field[@name='approximatecreationdate'][.!=''] | field[@name='timeperiod'][.!=''] | field[@name='coveragetemporal'][.!='']">
                                        <xsl:choose>
                                            <xsl:when test="contains(.,';')">
                                                <xsl:for-each select="tokenize(.,';')">
                                                    <ApproximateCreationDate>
                                                        <xsl:value-of select="normalize-space(.)"/>
                                                    </ApproximateCreationDate>
                                                </xsl:for-each>                                                                                    
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <ApproximateCreationDate>
                                                    <xsl:value-of select="normalize-space(.)"/>
                                                </ApproximateCreationDate>
                                            </xsl:otherwise>
                                        </xsl:choose>                                        
                                    </xsl:for-each>                                    
                                    <xsl:for-each select="field[@name='interviewlocation'][.!='']">
                                        <xsl:choose>
                                            <xsl:when test="contains(.,';')">
                                                <xsl:for-each select="tokenize(.,';')">
                                                    <CreationPlace>
                                                        <xsl:value-of select="normalize-space(.)"/>
                                                    </CreationPlace>            
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <CreationPlace>
                                                    <xsl:value-of select="normalize-space(.)"/>
                                                </CreationPlace>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>           
                                    <xsl:if test="$showPubDate='true'">
                                        <xsl:for-each select="field[@name='datecreated'][.!='']">
                                            <xsl:choose>
                                                <xsl:when test="contains(.,';')">
                                                    <xsl:for-each select="tokenize(.,';')">
                                                        <PublicationDate>
                                                            <xsl:variable name="date"
                                                                select="concat(normalize-space(.),'T04:00:00.00')"/>
                                                            <xsl:value-of
                                                                select="( xs:dateTime($date) - xs:dateTime('1970-01-01T00:00:00') )
                                                                div
                                                                xs:dayTimeDuration('PT1S')"
                                                            />
                                                        </PublicationDate>            
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <PublicationDate>
                                                        <xsl:variable name="date"
                                                            select="concat(normalize-space(.),'T04:00:00.00')"/>
                                                        <xsl:value-of
                                                            select="( xs:dateTime($date) - xs:dateTime('1970-01-01T00:00:00') )
                                                            div
                                                            xs:dayTimeDuration('PT1S')"
                                                        />
                                                    </PublicationDate>
                                                </xsl:otherwise>
                                            </xsl:choose>                                        
                                        </xsl:for-each>                                    
                                        <xsl:for-each select="field[@name='approximatepublicationdate'][.!='']">
                                            <xsl:choose>
                                                <xsl:when test="contains(.,';')">
                                                    <xsl:for-each select="tokenize(.,';')">
                                                        <ApproximatePublicationDate>
                                                            <xsl:value-of select="normalize-space(.)"/>
                                                        </ApproximatePublicationDate>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <ApproximatePublicationDate>
                                                        <xsl:value-of select="normalize-space(.)"/>
                                                    </ApproximatePublicationDate>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>       
                                    </xsl:if>
                                    <xsl:if test="$showPubPlace='true'">
                                        <xsl:for-each select="field[@name='publicationplace'][.!='']">
                                            <xsl:choose>
                                                <xsl:when test="contains(.,';')">
                                                    <xsl:for-each select="tokenize(.,';')">
                                                        <PublicationPlace>
                                                            <xsl:value-of select="normalize-space(.)"/>
                                                        </PublicationPlace>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <PublicationPlace>
                                                        <xsl:value-of select="normalize-space(.)"/>
                                                    </PublicationPlace>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>        
                                    </xsl:if>
                                    <ContributingUnit>
                                        <xsl:text>University of Miami Libraries</xsl:text>
                                    </ContributingUnit>
                                    <Repository>                                        
                                        <xsl:value-of select="$repository"/>                                                                                                                       
                                    </Repository>
                                    <xsl:if test="field[@name='sponsor'][.!='']">
                                        <Sponsor>
                                            <xsl:value-of select="field[@name='sponsor']"/>
                                        </Sponsor>
                                    </xsl:if>
                                    <RightsStatement>
                                        <xsl:choose>
                                            <xsl:when test="$prefix='chc'">
                                                <xsl:value-of select="$rightsStatementCHC"/>        
                                            </xsl:when>
                                            <xsl:when test="$prefix='asm'">
                                                <xsl:value-of select="$rightsStatementASM"/>
                                            </xsl:when>
                                        </xsl:choose>                                                                                
                                    </RightsStatement>                                        
                                    <xsl:for-each select="field[@name='type'][.!='']">
                                        <xsl:choose>
                                            <xsl:when test="contains(.,';')">
                                                <xsl:for-each select="tokenize(.,';')">
                                                    <ContentType>
                                                        <xsl:choose>
                                                            <xsl:when
                                                                test=".='MovingImage'">
                                                                <xsl:text>Moving Image</xsl:text>
                                                            </xsl:when>
                                                            <xsl:when test=".='StillImage'">
                                                                <xsl:text>Still Image</xsl:text>        
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="normalize-space(.)"/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </ContentType>    
                                                </xsl:for-each>                                                        
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <ContentType>
                                                    <xsl:choose>
                                                        <xsl:when
                                                            test=".='MovingImage'">
                                                            <xsl:text>Moving Image</xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test=".='StillImage'">
                                                            <xsl:text>Still Image</xsl:text>        
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="normalize-space(.)"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </ContentType>
                                            </xsl:otherwise>
                                        </xsl:choose>                                                
                                    </xsl:for-each>                                    
                                    <xsl:choose>
                                        <xsl:when test="$digID!=''">
                                            <xsl:for-each select="field[@name='originalformat'][.!=''] | field[@name='tapeformat'][.!='']">
                                                <OriginalFormat>                                                
                                                    <xsl:value-of select="normalize-space(.)"/>                                                 
                                                </OriginalFormat>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:for-each
                                                select="../objectRecord/pageRecord/following-sibling::field[@name='source'][.!=''] | ../objectRecord/pageRecord/following-sibling::field[@name='originalsource'][.!='']">
                                                <OriginalFormat>                                                    
                                                    <xsl:value-of select="normalize-space(.)"/>                                                    
                                                </OriginalFormat>        
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>                                                                                                                                                
                                    <LocalIdentifier>
                                        <xsl:choose>
                                            <xsl:when test="$digID!=''">                                                
                                                <xsl:for-each select="$digID">
                                                    <xsl:value-of select="concat($prefix,.)"/>
                                                </xsl:for-each>                                                        
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:for-each select="identifier">
                                                    <xsl:value-of
                                                        select="if (string-length(string($i))&gt;1)
                                                        then concat($prefix,.,'00',$i,'001')
                                                        else (concat($prefix,.,'000',$i,'001'))"
                                                    />
                                                </xsl:for-each>
                                            </xsl:otherwise>
                                        </xsl:choose>                                        
                                    </LocalIdentifier>
                                </metadata>
                            </xmlData>
                        </customData>
                    </customDataItems>
                </item>
                <xsl:call-template name="partMaker">
                    <xsl:with-param name="i" select="number($i) + number($increment)"/>
                    <xsl:with-param name="increment" select="number($increment)"/>
                    <xsl:with-param name="numFiles" select="number($numFiles)"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="templateMaker">
        <xsl:param name="i"/>
        <xsl:param name="increment"/>
        <xsl:param name="numFiles"/>
        
        <xsl:variable name="testPassed">
            <xsl:if test="$i != $numFiles + 1">
                <xsl:text>true</xsl:text>
            </xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$testPassed='true'">       
                <item>
                    <action>add</action>
                    <type>1</type>
                    <referenceId>
                        <xsl:value-of
                            select="if (string-length(string($i))&gt;1)
                            then concat($prefix,$jazzOutObjID,'00',$i,'001')
                            else (concat($prefix,$jazzOutObjID,'000',$i,'001'))"
                        />                                
                    </referenceId>
                    <userId>C00116178</userId>
                    <name>
                        <xsl:choose>
                            <xsl:when test="$jazzOutTitle!=''">
                                <xsl:value-of select="$jazzOutTitle"/>                                        
                                <xsl:if test="$numFiles&gt;1">
                                    <xsl:text>: </xsl:text>
                                    <xsl:text>Part </xsl:text>
                                    <xsl:value-of select="$i"/>
                                    <xsl:text> of </xsl:text>
                                    <xsl:value-of select="$numFiles"/>
                                </xsl:if>                                        
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="if (string-length(string($i))&gt;1)
                                    then concat($prefix,$jazzOutObjID,'00',$i,'001')
                                    else (concat($prefix,$jazzOutObjID,'000',$i,'001'))"
                                />
                                <xsl:if test="$numFiles&gt;1">
                                    <xsl:text>: </xsl:text>
                                    <xsl:text>Part </xsl:text>
                                    <xsl:value-of select="$i"/>
                                    <xsl:text> of </xsl:text>
                                    <xsl:value-of select="$numFiles"/>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </name>
                    <description/>
                    <tags>
                        <tag/>            
                    </tags>
                    <categories>
                        <category>
                            <xsl:text>Mediaspace&gt;site&gt;channels&gt;</xsl:text>
                            <xsl:value-of select="$channelName"/>
                        </category>
                    </categories>
                    <media>
                        <mediaType>1</mediaType>
                    </media>
                    <xsl:if test="$add='true'">
                        <contentAssets>
                            <content>
                                <dropFolderFileContentResource>
                                    <xsl:attribute name="filePath">                                                                                                    
                                        <xsl:value-of
                                            select="if (string-length(string($i))&gt;1)
                                            then concat($prefix,$jazzOutObjID,'00',$i,'002','.mp4')
                                            else (concat($prefix,$jazzOutObjID,'000',$i,'002','.mp4'))"/>                                                                                                                                            
                                    </xsl:attribute>
                                </dropFolderFileContentResource>
                            </content>
                        </contentAssets>
                    </xsl:if>
                    <customDataItems>
                        <customData metadataProfileId="2548141">
                            <xmlData>
                                <metadata>
                                    <xsl:if test="$numFiles&gt;1">
                                        <PartNumber>
                                            <xsl:value-of select="$i"/>
                                            <xsl:text> of </xsl:text>
                                            <xsl:value-of select="$numFiles"/>
                                        </PartNumber>
                                    </xsl:if>
                                    <LocalIdentifier>
                                        <xsl:value-of
                                            select="if (string-length(string($i))&gt;1)
                                            then concat($prefix,$jazzOutObjID,'00',$i,'001')
                                            else (concat($prefix,$jazzOutObjID,'000',$i,'001'))"
                                        />
                                    </LocalIdentifier>                                            
                                </metadata>                                       
                            </xmlData>
                        </customData>
                    </customDataItems>
                </item>
                <xsl:call-template name="templateMaker">
                    <xsl:with-param name="i" select="number($i) + number($increment)"/>
                    <xsl:with-param name="increment" select="number($increment)"/>
                    <xsl:with-param name="numFiles" select="number($numFiles)"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
