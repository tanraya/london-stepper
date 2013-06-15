=begin
  Что сделать в этом пакете:
  - Узнать, нужно ли запускать отдельный инстанс на отдельное приложение
  - Сделать init скрипты
  - Похоже что при создании нового проекта нужно создавать для него отдельный init скрипт. Желательно,
    нужно держать этот init скрипт в приложении, а из /etc/init.d/ сделать линк на него.
  - Убедиться, что все инстансы стартуют при ребуте тачки

  Чтиво
  - http://www.andrehonsberg.com/article/running-multiple-sphinx-searchd-instances-for-multiple-websites-same-server-php-api
=end

package :sphinxsearch do
  description 'MySQL full text search engine'
  version '2.0.3-release'
  source "http://sphinxsearch.com/files/sphinx-2.0.3-release.tar.gz"

  requires :mysql_devel #:sphinxsearch_init_script

  verify do
    has_executable 'search'
    has_executable 'searchd'
  end
end

package :mysql_devel do
  apt 'libmysqlclient-dev'
end

# TODO Need complete it
=begin
package :sphinxsearch_init_script do
  description "SphinxSearch init script for Rails app."
  
  %w[sphinxsearch].each do |config_name|
    config_file = "/home/appname/shared/config/#{config_name}.conf" #TODO
    config_template = File.join(File.dirname(__FILE__), 'config', config_name)

    transfer config_template, config_file, :render => true do
      # Set proper permissions.
      # post :install, "chmod 0644 #{config_file}"
    end
    
    verify do
      has_file config_file
      file_contains config_file, `head -n 1 #{config_template}`
    end
  end
end
=end