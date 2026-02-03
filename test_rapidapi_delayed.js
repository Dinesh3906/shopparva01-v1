const https = require('https');

// Wait 10 seconds then make request
setTimeout(() => {
    const options = {
        method: 'GET',
        hostname: 'ecommerce-api15.p.rapidapi.com',
        path: '/api/malefootwear',
        headers: {
            'x-rapidapi-key': '04730925femsh70545419490ad98p1f07e1jsn62f7886cfed9',
            'x-rapidapi-host': 'ecommerce-api15.p.rapidapi.com'
        }
    };

    const req = https.request(options, (res) => {
        const chunks = [];
        res.on('data', (chunk) => chunks.push(chunk));
        res.on('end', () => {
            const body = Buffer.concat(chunks).toString();
            console.log('Status:', res.statusCode);

            if (res.statusCode === 200) {
                const json = JSON.parse(body);
                console.log('Type:', Array.isArray(json) ? 'Array' : 'Object');

                if (Array.isArray(json)) {
                    console.log('Total items:', json.length);
                    if (json.length > 0) {
                        console.log('\n=== First Item Structure ===');
                        console.log(JSON.stringify(json[0], null, 2));
                    }
                } else {
                    console.log('Keys:', Object.keys(json));
                    console.log('\n=== Response ===');
                    console.log(JSON.stringify(json, null, 2).substring(0, 1000));
                }
            } else {
                console.log('Error:', body);
            }
        });
    });

    req.on('error', (e) => console.error('Request error:', e));
    req.end();
}, 10000);

console.log('Waiting 10 seconds to avoid rate limit...');
