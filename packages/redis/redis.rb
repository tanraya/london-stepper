# Package is unstable and may not work properly.
package :redis do
  description 'Redis Database'
  
  apt 'redis-server'

  verify do
    has_executable 'redis-server'
  end
end
