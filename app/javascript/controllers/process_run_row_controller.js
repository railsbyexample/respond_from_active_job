import { Controller } from "stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = [ 'statusCol' ]

  connect() {
    console.log('Stimulus component connected...')
    this.recordId = this.element.dataset['recordId']

    this.connectToChannel()
  }

  connectToChannel() {
    consumer.subscriptions.create({
      channel: 'ProcessRunsChannel',
      id: this.recordId
    }, {
      connected: () => { console.log('ActionCable connected...') },
      disconnected: () => {},
      received: this.handleChannelReceived.bind(this)
    });
  }

  handleChannelReceived(data) {
    if (data.status != 'started') {
      console.log('Broadcast received...')

      fetch(`process_runs/${this.recordId}`)
      .then(response => response.json())
      .then(data => {
        this.statusColTarget.textContent = data.status
      })
    }
  }
}
