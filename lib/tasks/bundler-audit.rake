if Rails.env.development? || Rails.env.test?
  require 'bundler/audit/cli'

  namespace :bundler do
    desc 'Updates the ruby-advisory-db and runs audit'
    task :audit do
      Bundler::Audit::CLI.start ['update']
      Bundler::Audit::CLI.start ['check']
    end
  end
end
