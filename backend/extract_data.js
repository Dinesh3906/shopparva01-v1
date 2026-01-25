const fs = require('fs');

const content = fs.readFileSync('server.js', 'utf8');
const match = content.match(/const products = (\[[\s\S]*?\]);/);

if (match) {
    let jsonStr = match[1];
    // Remove single-line comments
    jsonStr = jsonStr.replace(/\/\/.*$/gm, '');
    // Remove multi-line comments
    jsonStr = jsonStr.replace(/\/\*[\s\S]*?\*\//g, '');

    // Attempt to parse to verify
    try {
        // Since it's still missing quotes on keys or has trailing commas (maybe),
        // we might need a more robust approach if it's strictly JS object literal.
        // But if it was valid JSON in JS (except comments), this should work.
        // Actually, let's just use eval but safely (within this script only).
        const products = eval(match[1]);
        fs.writeFileSync('src/db/products.json', JSON.stringify(products, null, 2));
        console.log('Successfully extracted and cleaned products to src/db/products.json');
    } catch (e) {
        console.error('Error parsing cleaned JSON:', e.message);
        // Fallback: very aggressive cleaning
        fs.writeFileSync('src/db/products.json', jsonStr);
    }
} else {
    console.error('Could not find products array in server.js');
}
