require 'rubygems'
require 'find'
require 'ffprober'
require 'json'
require 'pp'
require 'torrent-ruby'

module Scrape (base_dir)
	dir_ignore=[".AppleDouble",".AppleDB",".AppleDesktop",".DS_Store", ".localized"]

def Basic(base_dir)
	progress=0
	dir_array=[]
		Find.find(base_dir) { |dir_entry| 
			if dir_ignore.any? {|skip| dir_entry.include? skip} or !File.exist?(dir_entry) 
				Find.prune
			else
				filetype=File.ftype(dir_entry)
				case filetype
				when 'file','directory'
					list_entry = {"name" => dir_entry, "filetype"=>filetype,"filesize" => File.size(dir_entry),"creationdate" => File.ctime(dir_entry)}
				else 
					Find.prune
				end	
			end
			dir_array.push(list_entry)
			STDOUT.write "\rscanning file no. #{progress}" 
			progress += 1
		}
	return dir_array
end

def Mediaspecs(base_dir)
	progress=0
	dir_array=[]
	qualifier_ext=[".mkv",".avi",".mp4",".m4v",".mov",".flv",".ogg",".mpeg",".jpg",".mpg",".mp3"]
		Find.find(base_dir) { |dir_entry| 
			if dir_ignore.any? {|skip| dir_entry.include? skip} or !File.exist?(dir_entry) 
				Find.prune
			else
				filetype=File.ftype(dir_entry)
				case filetype
				when 'file'
					if qualifier_ext.include? File.extname(dir_entry) and !File.zero?(dir_entry)
						ffprobe = Ffprober::Parser.from_file(dir_entry)
					end
					list_entry = {"mediaspecs" => ffprobe.instance_variable_get(:@json)}
				else 
					Find.prune
				end	

			end
			dir_array.push(list_entry)
			STDOUT.write "\rscanning file no. #{progress}" 
			progress += 1
		}
	return dir_array
end

def Xxhash(base_dir)
end
