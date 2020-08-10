require 'rails_helper'

RSpec.describe ProcessRunsChannel, type: :channel do
  let(:process_run) { create :process_run }

  it 'accepts a subscription for an existing `ProcessRun`' do
    subscribe id: process_run.id
    expect(subscription).to be_confirmed
  end

  it 'rejects a subscription for a deleted `ProcessRun`' do
    process_run.destroy
    subscribe id: process_run.id
    expect(subscription).to be_rejected
  end

  it 'opens  stream for the `ProcessRun`' do
    subscribe id: process_run.id

    expect(subscription)
      .to have_stream_from(described_class.broadcasting_for(process_run))
  end

  it 'notifies the `ProcessRun` finished before subscription' do
    process_run.update(status: 'started')

    subscribe id: process_run.id

    expect(transmissions.last[:status]).to eq('started')
  end
end
