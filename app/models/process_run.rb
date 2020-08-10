class ProcessRun < ApplicationRecord
  enum status: { created: 0, started: 1, completed: 2, failed: 3 }
end
