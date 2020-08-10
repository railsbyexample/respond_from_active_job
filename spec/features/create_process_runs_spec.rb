require 'rails_helper'

RSpec.feature 'CreateProcessRuns', type: :feature do
  it 'creates the processes' do
    visit process_runs_url

    click_on 'Start 10 processes'

    expect(page).to have_content('created', count: 10)
  end

  it 'runs the processes' do
    visit process_runs_url

    perform_enqueued_jobs do
      click_on 'Start 10 processes'
    end

    expect(page).to have_content(/completed|failed/, count: 10)
  end
end
