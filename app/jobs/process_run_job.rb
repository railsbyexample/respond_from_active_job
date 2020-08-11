class ProcessRunJob < ApplicationJob
  queue_as :default

  def perform(process_run)
    process_run.start
    ProcessRunsChannel.broadcast_to process_run, status: process_run.status

    process_run.run
    ProcessRunsChannel.broadcast_to process_run, status: process_run.status
  end
end
