const BaseTracker = require('../base.tracker');

class MyntraTracker extends BaseTracker {
    constructor() {
        super('Myntra');
    }

    async fetchRawData(productUrl) {
        console.log(`[MyntraTracker] Fetching data for: ${productUrl}`);

        return {
            id: productUrl.split('/p/')[1]?.split('?')[0] || 'MYXXXX',
            title: "Mock Myntra Product",
            price: 2999,
            mrp: 4999,
            currency: 'INR',
            inStock: true,
            imageUrl: "https://via.placeholder.com/150",
            url: productUrl
        };
    }

    normalize(rawData) {
        return {
            id: `myntra-${rawData.id}`,
            platform: 'Myntra',
            externalId: rawData.id,
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

module.exports = MyntraTracker;
