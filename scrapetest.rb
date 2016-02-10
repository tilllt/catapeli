require './lib/scrape'

test = Scrape.new('/Users/till/Downloads/movies/')
test.hashsum ('/Users/till/Downloads/movies/')
test.mediaspecs('/Users/till/Downloads/movies/')

pp test