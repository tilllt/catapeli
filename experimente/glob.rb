require 'rubygems'
require 'find'
require 'ffprober'
require 'json'
require 'pp'

def scrubdirectory(base_dir)
	progress=0
	dir_array=[]
	dir_ignore=[".AppleDouble",".AppleDB",".AppleDesktop",".DS_Store", ".localized"]
	movie_ext=[".mkv",".avi",".mp4",".m4v",".mov",".flv",".ogg",".mpeg",".jpg",".mpg",".mp3"]
		Find.find(base_dir) { |dir_entry| 

			filetype=File.ftype(dir_entry)
			if dir_ignore.any? {|skip| dir_entry.include? skip} or !File.exist?(dir_entry) 
				Find.prune
			else
				case filetype
				when 'file'
					if movie_ext.include? File.extname(dir_entry) and !File.zero?(dir_entry)
						ffprobe = Ffprober::Parser.from_file(dir_entry)
					end
					list_entry = {"name" => dir_entry, "filetype"=>filetype,"filesize" => File.size(dir_entry),"creationdate" => File.ctime(dir_entry),"mediaspecs" => ffprobe.instance_variable_get(:@json)}
				when 'directory'
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

listing = scrubdirectory('/Users/till/Downloads/movies')
#listing = scrubdirectory('/Volumes/Downloads')

pp listing

listing.each do |item|
	p "#{item["filetype"]} #{item["name"]}"
end
