const https = require('https');

https.get('https://fakestoreapiserver.reactbd.org/api/products', (resp) => {
    let data = '';
    resp.on('data', chunk => data += chunk);
    resp.on('end', () => {
        try {
            const json = JSON.parse(data);
            console.log("Is Array?", Array.isArray(json));
            if (!Array.isArray(json)) {
                console.log("Keys:", Object.keys(json));
            }
        } catch (e) {
            console.log("Error parsing JSON");
        }
    });
});
