const https = require('https');

function fetchProduct(id) {
    const url = `https://fakestoreapiserver.reactbd.org/api/products/${id}`;

    https.get(url, (res) => {
        let data = '';
        res.on('data', (chunk) => { data += chunk; });
        res.on('end', () => {
            try {
                const json = JSON.parse(data);
                console.log('✅ FakeStore API Success!');
                console.log(JSON.stringify(json, null, 2));
            } catch (e) {
                console.error('❌ Parse error:', e.message);
                console.log('Body:', data);
            }
        });
    }).on('error', (err) => {
        console.error('❌ Request error:', err.message);
    });
}

// Fetch product with ID 1 as requested
fetchProduct(1);
