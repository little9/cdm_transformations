#!/usr/bin/env ruby

# Small script to create an XML file that is used by the cdm2mets stylesheet

def create_listing(folder)
  puts "<cdmFiles>"
  
  Dir.entries(folder).each do |file|
    if (file.start_with? '.') 

    else
      puts "<cdmFile filename='#{file}'>#{file}</cdmFile>\n"
    end
  end
  puts "</cdmFiles>"

end

folder = ARGV[0]
create_listing(folder)
