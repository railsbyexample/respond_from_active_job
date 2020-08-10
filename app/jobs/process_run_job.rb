class ProcessRunJob < ApplicationJob
  queue_as :default

  def perform(process_run)
    process_run.start
    process_run.run
  end
end
