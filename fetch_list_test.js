const https = require('https');

https.get('https://fakestoreapiserver.reactbd.org/api/products', (resp) => {
    let data = '';

    resp.on('data', (chunk) => {
        data += chunk;
    });

    resp.on('end', () => {
        console.log(data.substring(0, 500)); // Print first 500 chars to check if it's an array
    });

}).on("error", (err) => {
    console.log("Error: " + err.message);
});
