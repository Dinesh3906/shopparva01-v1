const https = require('https');
const secrets = require('./secrets.js');

const categories = [
    'smartphones', 'laptops', 'fragrances', 'skincare', 'groceries',
    'home-decoration', 'furniture', 'tops', 'womens-dresses', 'womens-shoes'
];

function fetchCategory(category) {
    return new Promise((resolve, reject) => {
        const options = {
            hostname: 'ecommerce-api15.p.rapidapi.com',
            port: null,
            path: `/api/${category}`,
            method: 'GET',
            headers: {
                'x-rapidapi-key': secrets.rapidApiKey,
                'x-rapidapi-host': 'ecommerce-api15.p.rapidapi.com'
            }
        };

        const req = https.request(options, (res) => {
            const chunks = [];
            res.on('data', (chunk) => chunks.push(chunk));
            res.on('end', () => {
                const body = Buffer.concat(chunks).toString();
                if (res.statusCode === 200) {
                    try {
                        const json = JSON.parse(body);
                        resolve({ category, count: json.length, sample: json[0] });
                    } catch (e) {
                        reject(e);
                    }
                } else {
                    reject(new Error(`Status ${res.statusCode}: ${body}`));
                }
            });
        });

        req.on('error', (e) => reject(e));
        req.end();
    });
}

// Fetch all categories sequentially to avoid rate limits
async function fetchAll() {
    console.log('Starting fetch...');
    for (const category of categories) {
        try {
            console.log(`Fetching ${category}...`);
            const result = await fetchCategory(category);
            console.log(`✅ ${category}: ${result.count} items`);
        } catch (e) {
            console.error(`❌ ${category}: ${e.message}`);
        }
        // Wait 1s between requests
        await new Promise(r => setTimeout(r, 1000));
    }
}

fetchAll();
