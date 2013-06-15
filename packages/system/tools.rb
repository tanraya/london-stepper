package :tools do
  description "Tools: Common tools needed by applications or for operations"

  requires :build_essential, :screen, :curl, :htop, :imagemagick, :rsync, :debconf_utils
end

package :build_essential do
  description 'build-essential'
  
  %w(sources.list).each do |sources_list|
    sources_list    = "/etc/apt/#{sources_list}"
    config_template = File.join(File.dirname(__FILE__), 'apt', "#{sources_list}")
    
    transfer config_template, sources_list, :render => true do
      pre :install, "mkdir -p #{File.dirname(sources_list)} && test -f #{sources_list} && rm #{sources_list}"
    end
    
    verify do
      has_file sources_list
      file_contains sources_list, `head -n 1 #{config_template}`
    end
  end

  apt 'build-essential' do
    pre :install, 'apt-get update && apt-get -y upgrade'
  end

  verify do
    has_apt 'build-essential'
  end
end

package :debconf_utils do
  description 'debconf-utils'
  
  apt 'debconf-utils'

  verify do
    has_executable 'debconf-get-selections'
  end
end

package :screen do
  description 'screen'
  
  apt 'screen'

  verify do
    has_executable 'screen'
  end
end

package :curl do
  description 'curl'
  
  apt 'curl'

  verify do
    has_executable 'curl'
  end
end

package :htop do
  description 'htop'
  
  apt 'htop'
  
  verify do
    has_executable 'htop'
  end
end

package :imagemagick do
  description 'imagemagick'
  requires :libmagick_dev
  
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

package :rsync do
  description 'rsync'

  apt 'rsync'

  verify do
    has_executable 'rsync'
  end
end