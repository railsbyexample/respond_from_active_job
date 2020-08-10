# Respond from ActiveJob

Using `ActiveJob`, `ActionCable` and `StimulusJS`

## Motivation

Often you want to offload long running tasks to an asynchronous job but you also need to update the UI as soon as possible, without having the user refresh the whole page.

Rails supports spinning off tasks out of the box with `ActiveJob`, and also makes it easy to broadcast updates to the client with `ActionCable`. The core goal of this example is to demonstrate the use of those two together.

For completeness, we'll also use `Stimulus` to keep the front-end organized, and add some basic tests using `rspec`.

## Overview

This application is a single view that shows all the "process runs", that simulate long running tasks. You can click on "Start 10 processes" and 10 processes will be spun up, and their status will be updated in the UI as the jobs progress.

The long running "process runs" are achieved with a call to `sleep` with a random interval, this is just for illustration purposes. In production, you would get this delay from an actual task. You can see how these simulated delays work in the `ProcessRun` model.

## The gist

The job (`ProcessRunJob`) broadcasts the status changes using `ActionCable`:

```ruby
# app/jobs/process_run_job.rb

class ProcessRunJob < ApplicationJob
  # ...

  def perform
    # ...

    ProcessRunsChannel.broadcast_to process_run, status: process_run.status
  end
end
```

And the UI is updated, in this case using Stimulus. To prevent ordering issues, the UI checks the status using the `process_runs/show` endpoint, though this might be overkill. You can probably get away just using the payload in the broadcast:

```javascript
// app/javascript/controllers/process_run_row_controller.js
// ...

export default class extends Controller {
  // ...

  connectToChannel() {
    consumer.subscriptions.create({
      channel: 'ProcessRunsChannel',
      id: this.recordId
    }, {
      connected: () => {},
      disconnected: () => {},
      received: ({ status }) => { this.statusColTarget.innerText = status }
    });
  }
}
```

## Also noteworthy

The `ProcessRunsChannel` is very standard per the `ActionCable` guides, but it includes the safeguard of transmitting the current status upon each subscription, in case the status changes while the first response is in flight (sounds unlikely, but I have seen it in production):

```ruby
class ProcessRunsChannel < ApplicationCable::Channel
  # ...

  def subscribed
    return if subscription_rejected?

    stream_for process_run
    transmit finished: process_run.finished
  end

  #...
end
```

As mentioned before, this example is reasonably tested, don't forget to check out the `spec` directory, and write some tests for your production code!

## Contributing

Feel free to open a PR, Issue, or [contact me](https://perezperret.com), to suggest improvements or discuss any problems, errors or opinions.
