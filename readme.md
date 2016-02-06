Preparation (follow suggestions here http://billpatrianakos.me/blog/2014/04/21/create-a-weather-app-with-sinatra-and-angularjs-part-1/)

# make home for catapeli
mkdir catapeli && cd catapeli

# install Ruby using RVM
rvm install 2.1 && rvm use 2.1

# create gemset for catapeli
rvm gemset create catapeli && rvm gemset use catapeli

# create and edit .ruby-version & .ruby-gemset for rvm

# create Gemfile
source 'http://rubygems.org'

gem 'json', '1.7.7'
gem 'rest-client', '1.6.7'
gem 'sinatra', '1.4.5'

group :development do
  gem 'rerun', '0.9.0'
  gem 'thin', '1.6.2'
end

# bundle install

# follow weather app tutorial until end

#  