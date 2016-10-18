let Room = {
  init(socket) {
    if (document.getElementById('msg-container')) {
      socket.connect()
      this.onReady(socket)
    }
  },

  onReady(socket) {
    let msgContainer = document.getElementById('msg-container')
    let msgInput = document.getElementById('msg-input')
    let postButton = document.getElementById('msg-submit')
    let roomChannel = socket.channel('chat:lobby')

    postButton.addEventListener('click', (e) => {
      let payload = { body: msgInput.value, at: Date.now() }
      roomChannel.push('new_message', payload)
        .receive('error', (e) => console.log(e) )
      msgInput.value = ''
    })

    roomChannel.on('new_message', (resp) => {
      roomChannel.params.last_seen_id = resp.id
      this.renderMessage(msgContainer, resp)
    })

    roomChannel.join()
      .receive('ok', ({messages}) => {
        let ids = messages.map((msg) => msg.id)
        if (ids.length > 0) {
          roomChannel.params.last_seen_id = Math.max(...ids)
        }
        this.renderMessages(msgContainer, messages)
      })
      .receive('error', (reason) => console.log('join failed', reason))
  },

  esc(str) {
    let div = document.createElement('div')
    div.appendChild(document.createTextNode(str))
    return div.innerHTML
  },

  renderMessage(msgContainer, {user, body, at}) {
    let template = document.createElement('div')

    template.innerHTML = `
    <img src='https://www.gravatar.com/avatar/${user.gravatar}?s=45' />
    <strong>${this.esc(user.username)}</strong>: ${this.esc(body)}
    `

    msgContainer.appendChild(template)
    msgContainer.scrollTop = msgContainer.scrollHeight
  },

  renderMessages(msgContainer, messages) {
    let sorted_messages = messages.sort((a, b) => {
      if (a.at < b.at) return -1
      if (a.at > b.at) return 1
      return 0
    })
    sorted_messages.forEach((msg) => { this.renderMessage(msgContainer, msg) })
  },
}

export default Room
