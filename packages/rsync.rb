package :rsync do
  description 'rsync'

  apt 'rsync'

  verify do
    has_executable 'rsync'
  end
end