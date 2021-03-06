rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

split_config = YAML.load_file(rails_root + '/config/resque.yml')
Split.redis = split_config[rails_env]

Split.configure do |config|
  config.db_failover = true # handle redis errors gracefully
  config.db_failover_on_db_error = proc{|error| Rails.logger.error(error.message) }
  config.allow_multiple_experiments = true
  config.enabled = true
  config.robot_regex = /\b(Baidu|linkdex|bingbot|Gigabot|Googlebot|libwww-perl|lwp-trivial|msnbot|MJ12bot|SiteUptime|Slurp|WordPress|ZIBB|ZyBorg)\b/i
end