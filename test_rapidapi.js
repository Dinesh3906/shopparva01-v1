const https = require('https');
const secrets = require('./secrets.js');

const options = {
    hostname: 'ecommerce-api3.p.rapidapi.com',
    port: null,
    path: '/search?query=phone&page=1&country=US&sort_by=RELEVANCE&product_condition=ANY',
    method: 'GET',
    headers: {
        'x-rapidapi-key': secrets.rapidApiKey,
        'x-rapidapi-host': 'ecommerce-api3.p.rapidapi.com'
    }
};

function makeRequest(opts, depth = 0) {
    const req = https.request(opts, (res) => {
        console.log('Status:', res.statusCode);
        console.log('Headers:', res.headers);

        // Handle redirects
        if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
            console.log('Redirecting to:', res.headers.location);
            if (depth < 3) {
                const url = new URL(res.headers.location);
                const newOpts = {
                    ...opts,
                    hostname: url.hostname,
                    path: url.pathname + url.search
                };
                return makeRequest(newOpts, depth + 1);
            }
        }

        const chunks = [];
        res.on('data', (chunk) => chunks.push(chunk));
        res.on('end', () => {
            const body = Buffer.concat(chunks).toString();

            if (res.statusCode === 200) {
                try {
                    const json = JSON.parse(body);
                    console.log('\n✅ SUCCESS!');
                    console.log('Type:', Array.isArray(json) ? 'Array' : 'Object');

                    if (Array.isArray(json)) {
                        console.log('Total items:', json.length);
                        if (json.length > 0) {
                            console.log('\n=== First Item ===');
                            console.log(JSON.stringify(json[0], null, 2));
                        }
                    } else {
                        console.log('Keys:', Object.keys(json));
                        console.log(JSON.stringify(json, null, 2).substring(0, 500));
                    }
                } catch (e) {
                    console.log('Parse error:', e.message);
                    console.log('Body:', body.substring(0, 200));
                }
            } else {
                console.log('Response:', body.substring(0, 200));
            }
        });
    });

    req.on('error', (e) => console.error('Request error:', e));
    req.end();
}

makeRequest(options);
