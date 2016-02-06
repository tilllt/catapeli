Preparation 

Almost nothing is working yet. Under ./experimente there is the file glob.rb, which scans a directory for media files.
- Using the Find.find function it recurses through everything it can find.
- Everything apart from Directories and Files is skipped
- Files matching an extension are scraped for metadata by ffprober
- scrubdirectory function then returns an array of hashes and prints it out ... thats it.

Todo

- Make scrapers modular: in the first step just gather basic data like full file and pathname, file size and creation date.
- second step: run metadatascapers on it, which have to be configured for certain extenions.  like ffprobe for techspecs of mediafiles, maybe hash all the files with xxHash, extract data from .torrent files and so on.
- run the scrapers in their own thread?
- still keep only one json as the data file or make each scraper have their own data-file?
- how to know if a file is the same, even if it is renamed or moved xxHash will be quite time consuming to create for every file.


To see what it's doing:

I'd suggest you install RVM (Ruby Version Manager) - so we are on the same page regarding Ruby versions etc.
RVM can handle multiple Ruby versions and even switch to the needed version once it enters a directory containing the .ruby-version file.

Get it here
https://rvm.io/


And then:

- bundle install # in the catapeli directory
- cd experimente
- edit glob.rb and add your path here "listing = scrubdirectory('/my/path/here')"
- ruby glob.rb