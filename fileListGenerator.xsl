<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="#all"
    version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!--
        Author: Timothy A. Thompson
        University of Miami Libraries
        Copyright 2013 University of Miami. Licensed under the Educational Community License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://opensource.org/licenses/ECL-2.0 http://www.osedu.org/licenses/ECL-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
    -->

    <!--
        fileListGenerator.xsl outputs an XML list of files in a directory. 
        Place this script in the directory with the files you want to create a list for. You can run it against any XML file. Save the output as collectionFileList.xml, or the like.           
    -->

    <xsl:template match="/">
        <cdmFiles>
            <xsl:for-each
                select="for $x in collection('.?select=*.txt;recurse=yes;on-error=ignore') return $x">
                <xsl:sort select="document-uri(.)"/>
                <cdmFile filename="{document-uri(.)}">
                    <xsl:value-of select="document-uri(.)"/>
                </cdmFile>
            </xsl:for-each>
        </cdmFiles>
    </xsl:template>

</xsl:stylesheet>
