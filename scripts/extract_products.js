const fs = require('fs');
const path = require('path');

const serverPath = path.join(__dirname, '../backend/server.js');
const outputPath = path.join(__dirname, '../assets/products.json');

try {
    const data = fs.readFileSync(serverPath, 'utf8');

    // Find the start of "const products = ["
    const startMarker = 'const products = [';
    const startIndex = data.indexOf(startMarker);

    if (startIndex === -1) {
        console.error('Could not find products array');
        process.exit(1);
    }

    let openBrackets = 0;
    let arrayStartIndex = startIndex + startMarker.length - 1; // index of '['
    let arrayEndIndex = -1;

    for (let i = arrayStartIndex; i < data.length; i++) {
        if (data[i] === '[') openBrackets++;
        if (data[i] === ']') openBrackets--;

        if (openBrackets === 0) {
            arrayEndIndex = i;
            break;
        }
    }

    if (arrayEndIndex === -1) {
        console.error('Could not find end of products array');
        process.exit(1);
    }

    let rawArray = data.substring(startIndex + startMarker.length - 1, arrayEndIndex + 1);

    // Simple regex to remove single line comments
    // ONLY remove lines that start with optional whitespace followed by //
    // This avoids breaking URLs like https://... which contain //
    const jsonString = rawArray.replace(/^\s*\/\/.*$/gm, '');

    console.log('Extracted string length:', jsonString.length);
    console.log('First 100 chars:', jsonString.substring(0, 100));

    // Also check if there are any remaining // that are NOT part of URLs
    // This is hard to perfect without a parser, but let's hope the file is clean
    // server.js seems to use // only for full line headers or comments

    let products;
    try {
        products = eval(jsonString);
    } catch (e) {
        console.error('Eval failed:', e);
        // fallback: try to parse manually? No, too hard.
        process.exit(1);
    }

    const dir = path.dirname(outputPath);
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
    }

    fs.writeFileSync(outputPath, JSON.stringify(products, null, 2));
    console.log(`Successfully extracted ${products.length} products to ${outputPath}`);

} catch (err) {
    console.error('Error:', err);
    process.exit(1);
}
