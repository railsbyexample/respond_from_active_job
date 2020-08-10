require 'rails_helper'

RSpec.describe ProcessRunJob, type: :job do
  let(:process_run) { create :process_run }

  it 'changes the ProcessRun status to a random finished status' do
    described_class.perform_now(process_run)
    expect(process_run.reload.status).to eq('completed').or(eq('failed'))
  end
end
