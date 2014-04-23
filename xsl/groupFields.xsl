<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!--
        Author: Timothy A. Thompson
        University of Miami Libraries
        Copyright 2014 University of Miami. Licensed under the Educational Community License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://opensource.org/licenses/ECL-2.0 http://www.osedu.org/licenses/ECL-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
    -->
    
    <!--
        groupFields.xsl takes the output of tsv2xml4cdm.xsl and fields field labels by collection title.                   
    -->
    
    <xsl:output method="text" encoding="UTF-8"/>
           
    <xsl:template match="/">
        <xsl:for-each-group select="collections/collection/record" group-by="field/@name">
            <xsl:sort select="current-grouping-key()"/>
            <xsl:value-of select="position()"/>
            <xsl:text>. </xsl:text>
            <xsl:value-of select="current-grouping-key()"/>
            <xsl:text>&#10;</xsl:text>
            <xsl:for-each-group select="current-group()/field[@name='collection'][.!='']|current-group()/field[@name='collectiontitle'][.!='']" group-by=".">
                <xsl:value-of select="current-grouping-key()"/>
                <xsl:text>&#10;</xsl:text>
            </xsl:for-each-group>                 
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each-group>
    </xsl:template>
    
</xsl:stylesheet>