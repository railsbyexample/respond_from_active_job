class ProcessRunsController < ApplicationController
  def create
    10.times do
      process_run = ProcessRun.create!
      ProcessRunJob.perform_later process_run
    end

    redirect_to process_runs_url
  end

  def index
    @process_runs = ProcessRun.all.order(created_at: :desc).page(params[:page])
  end

  def show
    process_run = ProcessRun.find(params[:id])
    render json: { status: process_run.status }, status: :ok
  end
end
