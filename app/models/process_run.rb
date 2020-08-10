class ProcessRun < ApplicationRecord
  enum status: { created: 0, started: 1, completed: 2, failed: 3 }

  def start
    mock_delay
    update status: 'started'
  end

  def run
    mock_delay
    update status: %w[completed failed].sample
  end

  private

  def mock_delay
    sleep(rand(2..4)) unless Rails.env.test?
  end
end
