namespace :daily_reports do
  desc 'Check for latest daily case updates and update database'

  task :update => :environment do
    Updater.call
  end
end
