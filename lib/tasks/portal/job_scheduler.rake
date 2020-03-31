namespace :portal do
  task job_scheduler: :environment do
    Portal::JobScheduler.new(Date.today).run_jobs
  end
end
