class ProcessRunsChannel < ApplicationCable::Channel
  before_subscribe :require_process_run

  def subscribed
    return if subscription_rejected?

    stream_for process_run
    transmit status: process_run.status
  end

  private

  def process_run
    @process_run ||= ProcessRun.find_by(id: params[:id])
  end

  def require_process_run
    reject unless process_run
  end
end
