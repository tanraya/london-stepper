package :imagemagick do
  description 'imagemagick'
  
  apt 'imagemagick'
  
  verify do
    has_executable '/usr/bin/convert'
  end
end

package :libmagick_dev do
  description "Magic++ library, development files"

  apt 'libmagick++-dev'

  verify do
    has_apt 'libmagick++-dev'
  end
end