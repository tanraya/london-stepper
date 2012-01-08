package :sphinx, :provides => :search do
  description 'MySQL full text search engine'
  version '2.0.3-release'
  source "http://sphinxsearch.com/files/sphinx-#{version}.tar.gz"

  verify do
    has_executable 'search'
    has_executable 'searchd'
  end
end