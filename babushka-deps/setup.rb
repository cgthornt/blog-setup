dep 'all the things' do
  requires 'user exists', 'user has ssh key', 'user has www dir'
  requires 'nginx.src', 'nginx-boot.config'

end