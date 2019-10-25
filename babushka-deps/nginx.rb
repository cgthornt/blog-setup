require 'open3'

NGINX_VERSION = '1.16.1'

dep 'nginx-deps.lib' do
  installs {
    via :apt, %w[ libpcre3-dev ]
  }
end

dep 'nginx.src' do
  requires 'nginx-deps.lib'

  source "http://nginx.org/download/nginx-#{NGINX_VERSION}.tar.gz"

  prefix '/opt/nginx'

  met? { 
    if shell?('test -f /opt/nginx/sbin/nginx', sudo: true)
      result = shell('/opt/nginx/sbin/nginx -v 2>&1', sudo: true)
      log result
      result == "nginx version: nginx/#{NGINX_VERSION}"
    else
      false
    end
  }

  configure_args '--with-http_ssl_module --with-http_v2_module --with-http_gunzip_module --with-http_gzip_static_module'
end

dep 'nginx-boot.config' do
  config_name 'nginx-systemd.service'
  destination '/lib/systemd/system/nginx.service'
end

dep 'nginx-conf.config' do
  config_name 'nginx.conf'
  destination '/usr/local/conf/nginx.conf'
end

dep 'nginx systemd' do
  requires 'nginx-boot.config', 'nginx-conf.config'

  met? { shell?('systemctl list-unit-files | grep enabled | grep nginx.service', sudo: true) }
  meet {
    log 'Loading nginx to systemd'
    shell!('systemctl daemon-reload', sudo: true)
    shell!('systemctl enable nginx.service', sudo: true)
    shell!('systemctl start nginx.service', sudo: true) 
  }
end

dep 'nginx' do
  requires 'nginx.src', 'nginx systemd'

  met? { true }
  meet { }
end