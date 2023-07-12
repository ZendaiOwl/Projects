async function followUsers() {
	const username = document.querySelector('#username').value
    const password = document.querySelector('#password').value
    const postId = document.querySelector('#postID').value

    const min = 5
    const max = 15
    
    // generate random number between 5 - 15
    const random = Math.floor(Math.random() * (max - min + 1) + min)
    
    // multiply with a minute
    const timer = random * 60000
    
    const response = await fetch('http://192.168.178.42:60545/userlist', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        username: username,
        password: password,
        postID: postID
      })
    })

    const p = document.createElement("p")
    p.textContent = "Hello, World"
    document.body.appendChild(p)

    const users = await response.json()
    

    // t.ex.
    users.forEach(userID => {
      setTimeout(() => {
        follow(userID)
      }, timer) // 5 sek
    })
}

async function follow(userID) {
    const username = document.querySelector('#username').value
    const password = document.querySelector('#password').value

    const response = await fetch('http://192.168.178.42:60545/follow', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        username: username,
        password: password,
        userID: userID
      })
    })

    const message = await response.json()

    console.log(message)
}

async function testing() {
	const response = await fetch('http://192.168.178.42:60545/something', {
		method: 'GET',
		headers: {
			'Accept': 'application/json',
			'Content-Type': 'application/json'
		}
	})
	const message = response.json()
	const p = document.createElement("p")
	p.textContent = "Hello there"
	p.textContent += message
	document.body.appendChild(p)
}
