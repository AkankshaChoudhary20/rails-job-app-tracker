require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false

  config.action_controller.perform_caching = true

  config.require_master_key = false

  config.public_file_server.enabled = true

  config.assume_ssl = true
  config.force_ssl = true

  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  config.active_support.report_deprecations = false

  config.cache_store = :memory_store

  config.active_storage.service = :local

  config.action_mailer.perform_caching = false

  config.i18n.fallbacks = true

  config.active_record.dump_schema_after_migration = false

  config.active_record.attributes_for_inspect = [:id]

  config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
