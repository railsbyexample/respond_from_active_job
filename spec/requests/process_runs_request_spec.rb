require 'rails_helper'

RSpec.describe 'ProcessRuns', type: :request do
  describe 'POST /process_runs' do
    it 'returns http success' do
      post '/process_runs'
      expect(response).to redirect_to(process_runs_url)
    end

    it 'creates new `ProcessRun`s' do
      expect do
        post '/process_runs'
      end.to change(ProcessRun, :count).by(10)
    end
  end

  describe 'GET /process_runs' do
    it 'returns http success' do
      get '/process_runs'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /process_runs/:id' do
    let(:process_run) { create :process_run }

    it 'returns http success' do
      get "/process_runs/#{process_run.to_param}"
      expect(response).to have_http_status(:success)
    end

    it 'returns a json response with the export status' do
      get "/process_runs/#{process_run.to_param}"
      expect(JSON.parse(response.body))
        .to eq({ status: process_run.status }.as_json)
    end
  end
end
