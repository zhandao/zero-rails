if Rails.env.development? || Rails.env.test?
  # This introduces the `table` statement
  extend Hirb::Console
end

define_method '❨╯°□°❩╯︵┻━┻' do
  'Calm down, yo.'
end

def sidekiq_status
  stats = Sidekiq::Stats.new
  stats.instance_variable_get('@stats').merge(queues: stats.queues)
end

def no_log_ar; ActiveRecord::Base.logger = nil end
