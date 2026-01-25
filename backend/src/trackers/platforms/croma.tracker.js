const BaseTracker = require('../base.tracker');

class CromaTracker extends BaseTracker {
    constructor() {
        super('Croma');
    }

    async fetchRawData(productUrl) {
        console.log(`[CromaTracker] Fetching data for: ${productUrl}`);

        return {
            sku: productUrl.split('/p/')[1]?.split('?')[0] || 'CRXXXX',
            title: "Mock Croma Product",
            price: 66990,
            mrp: 69900,
            currency: 'INR',
            inStock: true,
            imageUrl: "https://via.placeholder.com/150",
            url: productUrl
        };
    }

    normalize(rawData) {
        return {
            id: `croma-${rawData.sku}`,
            platform: 'Croma',
            externalId: rawData.sku,
            title: rawData.title,
            currentPrice: rawData.price,
            originalPrice: rawData.mrp,
            currency: rawData.currency,
            discountPercentage: Math.round(((rawData.mrp - rawData.price) / rawData.mrp) * 100),
            isAvailable: rawData.inStock,
            image: rawData.imageUrl,
            url: rawData.url,
            timestamp: new Date().toISOString()
        };
    }
}

module.exports = CromaTracker;
