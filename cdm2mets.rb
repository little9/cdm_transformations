#!/usr/bin/env ruby

def process(command)
  io = IO.popen(command) 
  output = io.read.encode('UTF-8')
  io.close 
  return output
end

cdmfile = ARGV[0]

transform_command = "java -jar saxon9pe.jar -xsl:tsv2xml4cdm.xsl -s:tsv2xml4cdm.xsl cdmFilePath=#{cdmfile}"

puts process(transform_command)
