module Portal
  class JobScheduler

    #class_attribute :jobs

    attr_reader :date

    def self.schedule_job(run_on, &block)
      self.jobs ||= {}
      jobs[run_on] ||= []
      jobs[run_on] << block
    end

    def initialize(date)
      @date = date
    end

    def run_jobs
      Hash(jobs).each_pair do |run_on, jobs|
        if send"#{run_on}?"
          jobs.each(&:call)
        end
      end
    end

    def end_of_month?
      date == date.end_of_month
    end

  end
end

# Portal::JobScheduler.schedule_job :end_of_month do
#
# end
