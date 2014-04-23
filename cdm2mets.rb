#!/usr/bin/env ruby

# Runs a shell command
def process(command)
  io = IO.popen(command) 
  output = io.read.encode('UTF-8')
  io.close 
  return output
end

# Write a file
def file_out(id, extension, content)
  output = File.open("out/" + id + extension, "w+")
  output << content 
  output.close 
end


# Finds the newest ContentDM tsv file on the archive server
def find_cdm_tsv(collection_id, username)
  find_command = "ssh #{username}@archive.library.miami.edu find /masters/production/cdm_metadata/ -name '*#{collection_id}*.txt' | sort | tail -1"
  file_name = process(find_command)

  contents_command = "ssh #{username}@archive.library.miami.edu cat " + file_name
  tsv_contents = process(contents_command)

  puts tsv_contents

  file_out(collection_id, ".tsv.txt", tsv_contents)

end


# Write the ContentDM xml from the tsv
def cdm_xml_out(xml, collection_id) 

  file_out(collection_id, ".cdm.xml", xml)

end

def create_fits()
# Create the fits data
end


# Write the fits xml file listing
def fits_xml_out(xml, collection_id) 

  file_out(collection_id, ".fits.xml", xml)
  

end

# Write the METS xml
def mets_xml_out(xml, collection_id) 

  file_out(collection_id, ".mets.xml", xml)
  

end


def create_mets(arguments)

  # Command line arguments
  
  fitspath = arguments[0]
  collection_id = arguments[1] 
  username = arguments[2] 

  find_cdm_tsv(collection_id, username)

  # The commands that do the transformations 
  transform_tsv_command = "java -jar saxon9pe.jar -xsl:xsl/tsv2xml4cdm.xsl -s:xsl/tsv2xml4cdm.xsl cdmFilePath=../out/#{collection_id}.tsv.txt"
  fits_list_command = "java -jar saxon9pe.jar -xsl:xsl/fileListGenerator.xsl -s:xsl/fileListGenerator.xsl fitsPath=../#{fitspath}"
  cdm_to_mets_command = "java -jar saxon9pe.jar -xsl:xsl/cdm2mets.xsl -s:xsl/cdm2mets.xsl fitsPath=../out/#{collection_id}.fits.xml pCdmPath=../#{collection_id}.cdm.xml"


  # Run the transformations and output to files 
  puts cdm_xml = process(transform_tsv_command)
  cdm_xml_out(cdm_xml, collection_id)

  puts fits_list_xml = process(fits_list_command) 
  fits_xml_out(fits_list_xml, collection_id)

  puts cdm_to_mets = process(cdm_to_mets_command) 
  mets_xml_out(cdm_to_mets, collection_id)

end

create_mets(ARGV) 
