let peopleWhoLikedPost = []

async function getPeopleWhoLikedPost () {
  const username = document.querySelector('#username').value
  const password = document.querySelector('#password').value
  const postId = document.querySelector('#post-id').value

  const response = await fetch('/getPeopleWhoLikedPost', {
    method: 'POST',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      username: username,
      password: password,
      postId: postId
    })
  })

  peopleWhoLikedPost = await response.json()
}
