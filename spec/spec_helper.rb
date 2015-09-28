$LOAD_PATH.unshift File.expand_path('lib')

require 'pry'
require 'grape/route_helpers'

support_files = Dir.glob('spec/support/*')
support_files.each { |f| require File.expand_path(f) }
