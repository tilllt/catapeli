require 'rubygems'
require 'find'
require 'ffprober'
require 'json'
require 'pp'
require 'digest'

class Scrape

def initialize(scrape_path, options={})
	defaults = {
		:dir_ignore => [".AppleDouble",".AppleDB",".AppleDesktop",".DS_Store", ".localized"]
	}
	options = defaults.merge(options)
    # Instance variables   
    @scrape_path = scrape_path  
	progress=0
	@json=[]
		Find.find(scrape_path) { |dir_entry| 
			if options[:dir_ignore].any? {|skip| dir_entry.include? skip} or !File.exist?(dir_entry) 
				Find.prune
			else
				filetype=File.ftype(dir_entry)
				case filetype
				when 'file','directory'
					list_entry = {"name" => dir_entry, "filetype"=>filetype,"filesize" => File.size(dir_entry),"creationdate" => File.ctime(dir_entry),"modificationdate" => File.mtime(dir_entry)}
				else 
					Find.prune
				end	
			end
			@json.push(list_entry)
			STDOUT.write "\rscanning file no. #{progress}" 
			progress += 1
		}
	return @json
end

def self.mediaspecs(scrape_path, options={})
	defaults = {
		:dir_ignore => [".AppleDouble",".AppleDB",".AppleDesktop",".DS_Store", ".localized"],
		:qualifier_ext => [".mkv",".avi",".mp4",".m4v",".mov",".flv",".ogg",".mpeg",".jpg",".mpg",".mp3"]
	}
	options = defaults.merge(options)
	@scrape_path = scrape_path
	progress=0
	@json=[]
		Find.find(@scrape_path) { |dir_entry| 
			p "scanning: "+dir_entry
			if options[:dir_ignore].any? {|skip| dir_entry.include? skip} or !File.exist?(dir_entry)
				Find.prune
				p "skipping: "+dir_entry
			else
				filetype=File.ftype(dir_entry)
				case filetype
				when 'file'
					p "scraping: "+dir_entry
					if options[:qualifier_ext].include? File.extname(dir_entry) and !File.zero?(dir_entry)
						ffprobe = Ffprober::Parser.from_file(dir_entry)
						list_entry = {"mediaspecs" => ffprobe.instance_variable_get(:@json)}
					end
				else 
					p "passing on non-file: "+dir_entry
					next
				end	
			end
			@json.push(list_entry)
			progress += 1
			STDOUT.write "\rscanning file no. #{progress}" 
		}
	return @json
end

def self.hashsum(scrape_path, options={})
	defaults = {
		:dir_ignore => [".AppleDouble",".AppleDB",".AppleDesktop",".DS_Store", ".localized"],
		:qualifier_ext => [".mkv",".avi",".mp4",".m4v",".mov",".flv",".ogg",".mpeg",".jpg",".mpg",".mp3"]
	}
	options = defaults.merge(options)
	@scrape_path = scrape_path
	progress=0
	@json=[]
	list_entry={}
		Find.find(@scrape_path) { |dir_entry| 
			p "scanning: "+dir_entry
			if options[:dir_ignore].any? {|skip| dir_entry.include? skip} or !File.exist?(dir_entry)
				Find.prune
				p "skipping: "+dir_entry
			else
				p "hashing: "+dir_entry
				if options[:qualifier_ext].include? File.extname(dir_entry) and !File.zero?(dir_entry)
					chunk_size=4096
					hashsum = Digest::SHA256.new
					open(dir_entry) do |s|
      					while chunk=s.read(chunk_size)
        					hashsum.update chunk
        				end
					list_entry = {"name" => dir_entry,"hashsum" => hashsum.hexdigest}
					end
				else 
					p "passing on: "+dir_entry
					next
				end	
			end
			@json.push(list_entry)
			progress += 1
			STDOUT.write "\rscanning file no. #{progress}" 
		}
	return @json
end


end