const fetch = (...args) => import('node-fetch').then(({default: fetch}) => fetch(...args));
const express = require('express');
const app = express();
const PORT = process.env.PORT;

app.get('/', async (req, res) => {
    const url = 'https://data.binance.com/api/v3/ticker?symbol=BTCEUR';
	const options = {
		method: 'GET',
		headers: {
			'Content-Type': 'application/json',
		}
	};
	fetch(url, options)
		.then(res => res.json())
		.then(json => res.send(json))
		.catch(err => res.send('error:' + err));
});

app.listen(PORT);

module.exports = app; 

