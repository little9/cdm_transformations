#!/usr/bin/env ruby

# Command line arguments 
cdmfile = ARGV[0]
fitspath = ARGV[1]
collection_id = ARGV[2]

# Runs a shell command
def process(command)
  io = IO.popen(command) 
  output = io.read.encode('UTF-8')
  io.close 
  return output
end

# Write the ContentDM xml from the tsv
def cdm_xml_out(xml, collection_id) 

  output = File.open(collection_id + ".cdm.xml", "w+")
  output << xml
  output.close 

end

# Write the fits xml file listing
def fits_xml_out(xml, collection_id) 

  output = File.open(collection_id + ".fits.xml", "w+")
  output << xml
  output.close 

end

# Write the METS xml
def mets_xml_out(xml, collection_id) 

  output = File.open(collection_id + ".mets.xml", "w+")
  output << xml
  output.close 

end

# The commands that do the transformations 
transform_tsv_command = "java -jar saxon9pe.jar -xsl:xsl/tsv2xml4cdm.xsl -s:xsl/tsv2xml4cdm.xsl cdmFilePath=#{cdmfile}"
fits_list_command = "java -jar saxon9pe.jar -xsl:xsl/fileListGenerator.xsl -s:xsl/fileListGenerator.xsl fitsPath=#{fitspath}"
cdm_to_mets_command = "java -jar saxon9pe.jar -xsl:xsl/cdm2mets.xsl -s:xsl/cdm2mets.xsl fitsPath=../#{collection_id}.fits.xml pCdmPath=../#{collection_id}.cdm.xml"


# Run the transformations and output to files 
puts cdm_xml = process(transform_tsv_command)
cdm_xml_out(cdm_xml, collection_id)

puts fits_list_xml = process(fits_list_command) 
fits_xml_out(fits_list_xml, collection_id)

puts cdm_to_mets = process(cdm_to_mets_command) 
mets_xml_out(cdm_to_mets, collection_id)


