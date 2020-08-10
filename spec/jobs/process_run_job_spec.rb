require 'rails_helper'

RSpec.describe ProcessRunJob, type: :job do
  let(:process_run) { create :process_run }

  it 'changes the ProcessRun status to a random finished status' do
    described_class.perform_now(process_run)
    expect(process_run.reload.status).to eq('completed').or(eq('failed'))
  end

  it 'broadcasts `ProcessRun#status` on completion' do
    expect do
      described_class.perform_now(process_run)
    end.to(
      have_broadcasted_to(ProcessRunsChannel.broadcasting_for(process_run))
        .with do |data|
          expect(data).to eq('status' => process_run.status)
        end
    )
  end
end
