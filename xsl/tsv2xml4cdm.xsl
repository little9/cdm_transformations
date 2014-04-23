<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!--
        Copyright 2014 Timothy A. Thompson        
        CDM Transformations: https://github.com/Timathom/cdm_transformations
        Licensed under the Educational Community License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://opensource.org/licenses/ECL-2.0 http://www.osedu.org/licenses/ECL-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
    -->
    
    <!--
        tsv2xml4cdm.xsl takes TSV file exported from CONTENTdm and transforms it into custom XML that preserves field names and single-level compound object hierarchies.                                                           
    -->

    <!--
        
        Modified by James Little in April 2014 to work with a file passed as a paramter. Example:
        
        java -jar saxon9pe.jar -xsl:tsv2xml4cdm.xsl -s:tsv3xml4cdm.xsl cdmFilePath="file:///Users/jlittle/Desktop/chc9999_2014-04-18.txt"
        
    -->

    <!-- Create keys for building compound objects. -->
    <xsl:key name="objectKey" match="item" use="@id"/>
    <xsl:key name="itemKey" match="object" use="@id"/>
    
    <!-- The template that receives the file path parameter. -->
    
    <xsl:param name="cdmFilePath"></xsl:param>
    <xsl:param name="cdmCollectionId"></xsl:param>
   
    <xsl:template name="cdmFile">
    <cdmFiles>
        <cdmFile>
                <xsl:value-of select="$cdmFilePath"></xsl:value-of>
        </cdmFile>
        <xsl:apply-templates></xsl:apply-templates>
    </cdmFiles>
    </xsl:template>

    
    <!-- Main template that parses the TSV and creates structured XML. -->
    <xsl:template match="cdmFile" name="xmlFromTsv">
        <collection name="{.}">
            <xsl:variable name="text" select="unparsed-text($cdmFilePath,'UTF-8')"/>
            <xsl:variable name="header">
                <xsl:analyze-string select="$text" regex="(..*)">
                    <xsl:matching-substring>
                        <xsl:if test="position()=1">
                            <xsl:value-of select="replace(regex-group(1),'\t','|')"/>
                        </xsl:if>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>
            <xsl:variable name="headerTokens" select="tokenize($header,'\|')"/>
            <xsl:variable name="recordBody">
                <xsl:analyze-string select="$text" regex="(..*)">
                    <xsl:matching-substring>
                        <xsl:if test="not(position()=1)">
                            <!-- Begin creating the records. Assign column headers to field elements as @name attributes. -->
                            <record>
                                <xsl:analyze-string select="." regex="([^\t][^\t]*)\t?|\t">
                                    <xsl:matching-substring>
                                        <xsl:variable name="pos" select="position()"/>
                                        <xsl:variable name="headerToken"
                                            select="replace(normalize-space(lower-case($headerTokens[$pos])),' ','')"/>
                                        <field name="{$headerToken}">
                                            <xsl:value-of select="normalize-space(regex-group(1))"/>
                                        </field>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </record>
                        </xsl:if>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>

            <!-- Create a variable to split the records between compound and single. -->
            <xsl:variable name="recordSort">
                <xsl:for-each select="$recordBody/record">
                    <xsl:variable name="ID"
                        select="if (field[@name='objectid'][.!='']) 
                        then normalize-space(substring(field[@name='objectid'],4))
                        else (normalize-space(substring(field[@name='digitalid'],4,10)))"/>
                    <xsl:choose>
                        <!-- Single items. -->
                        <xsl:when
                            test="field[@name='digitalid']!='' or contains(field[@name='title'],'Watch the Video')">
                            <item id="{$ID}">
                                <identifier>
                                    <xsl:value-of select="$ID"/>
                                </identifier>
                                <xsl:sequence select="child::node()"/>
                            </item>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- Compound objects. -->
                            <object id="{$ID}">
                                <identifier>
                                    <xsl:value-of select="$ID"/>
                                </identifier>
                                <xsl:sequence select="child::node()"/>
                            </object>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>

            <!-- New variable to flesh out the structure in a second pass. -->
            <xsl:variable name="recordSort2">
                <xsl:for-each select="$recordSort">
                    <xsl:if test="item/key('itemKey',@id)">
                        <xsl:variable name="object" select="item/key('itemKey',@id)"/>
                        <xsl:for-each select="item/key('itemKey',@id)">
                            <!-- Compound objects. -->
                            <compoundObject>
                                <objectRecord>
                                    <xsl:sequence select="child::node()"/>
                                </objectRecord>
                                <xsl:for-each select="key('objectKey',@id)">                                    
                                    <pageRecord>
                                        <xsl:sequence select="child::node()"/>
                                    </pageRecord>
                                </xsl:for-each>
                            </compoundObject>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="item[not(key('itemKey',@id))]">
                        <xsl:for-each select="item[not(key('itemKey',@id))]">
                            <!-- Single items. -->
                            <singleItem>
                                <xsl:sequence select="child::node()"/>
                            </singleItem>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>

            <!-- Final variable to re-sort the records in order by object ID/digital ID. -->
            <xsl:for-each select="$recordSort2/compoundObject|$recordSort2/singleItem">
                <xsl:sort select="descendant-or-self::identifier[1]" order="ascending"
                    data-type="number"/>
                <xsl:sort
                    select="substring(descendant-or-self::field[@name='digitalid'][1][.!=''],4)"
                    order="ascending" data-type="number"/>
                <xsl:sequence select="."/>
            </xsl:for-each>

        </collection>
    </xsl:template>
</xsl:stylesheet>