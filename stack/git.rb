package :git, :provides => :scm do
  description 'Git Version Control System'
  apt %w( git-core )
  
  verify do
    has_executable 'git'
  end
end