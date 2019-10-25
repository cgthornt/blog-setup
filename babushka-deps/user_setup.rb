# The idea is we want a normal user that isn't running as root where we can put pur code.
# Since it's just me using this, we can re-use root's SSH keys 

USER = 'christopher-test'

dep 'user exists' do
  met? { shell?("getent passwd #{USER}") }

  meet {
    shell!("useradd -m #{USER} -d /home/#{USER}", sudo: true)
    shell!("usermod -aG sudo #{USER}", sudo: true)
  }
end

dep 'user has ssh key' do
  requires 'user exists'

  met? { shell?("test -f /home/#{USER}/.ssh/authorized_keys") }
  meet {
    shell!("mkdir -p /home/#{USER}/.ssh", sudo: true)
    shell!("cp /root/.ssh/authorized_keys /home/#{USER}/.ssh", sudo: true)
  }
end

dep 'user has www dir' do
  requires 'user exists'

  met? { shell?("test -d /home/#{USER}/www") }
  meet {
    shell!("mkdir -p /home/#{USER}/www", sudo: true)
    shell!("chown #{USER}:#{USER} /home/#{USER}/www", sudo: true)
  }
end
