require 'fileutils'

meta :config do
  accepts_value_for :config_name
  accepts_value_for :destination

  template {
    def source_config
      File.join(__dir__, '..', 'config-files', config_name)
    end

    met? {
      if File.exists?(destination) && FileUtils.compare_file(source_config, destination)
        log_ok "#{destination} is up to date"
        true
      else
        log "#{destination} is outdated"
        false
      end
    }

    meet { shell!("cp #{source_config} #{destination}", sudo: true) }
  }

end