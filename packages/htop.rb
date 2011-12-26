package :htop do
  description 'htop'
  
  apt 'htop'
  
  verify do
    has_executable 'htop'
  end
end