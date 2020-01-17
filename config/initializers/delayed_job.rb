Delayed::Worker.raise_signal_exceptions = :term

# Do not destroy job when maximum number of attempts have been done, instead
# set the failed_at flag.
#
Delayed::Worker.destroy_failed_jobs = false

# Total of 16 hours between first and last attempt
#
#  Formula for trying again is 5 seconds + N ** 4
#
Delayed::Worker.max_attempts = 12

# We currently do not expect any job to exceed (or even be close to) 15 minutes.
#
Delayed::Worker.max_run_time = 15.minutes
