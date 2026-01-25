const fs = require('fs');
const path = require('path');

class JSONDatabase {
    constructor() {
        this.dbPath = path.join(__dirname, '../../db/data.json');
        if (!fs.existsSync(path.dirname(this.dbPath))) {
            fs.mkdirSync(path.dirname(this.dbPath), { recursive: true });
        }
        if (!fs.existsSync(this.dbPath)) {
            fs.writeFileSync(this.dbPath, JSON.stringify({ products: [], history: [], alerts: [] }));
        }
    }

    read() {
        return JSON.parse(fs.readFileSync(this.dbPath, 'utf8'));
    }

    write(data) {
        fs.writeFileSync(this.dbPath, JSON.stringify(data, null, 2));
    }

    async saveProduct(product) {
        const data = this.read();
        const index = data.products.findIndex(p => p.id === product.id);
        if (index > -1) {
            data.products[index] = product;
        } else {
            data.products.push(product);
        }

        // Add to history
        data.history.push({
            productId: product.id,
            price: product.currentPrice,
            timestamp: product.timestamp
        });

        this.write(data);
    }

    async getProductHistory(productId) {
        const data = this.read();
        return data.history.filter(h => h.productId === productId);
    }
}

module.exports = new JSONDatabase();
