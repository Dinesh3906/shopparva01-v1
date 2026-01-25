const BaseTracker = require('../base.tracker');

class AjioTracker extends BaseTracker {
    constructor() {
        super('AJIO');
    }

    async fetchRawData(productUrl) {
        console.log(`[AjioTracker] Fetching data for: ${productUrl}`);

        return {
            id: productUrl.split('/p/')[1]?.split('?')[0] || 'AJXXXX',
            title: "Mock AJIO Product",
            price: 1599,
            mrp: 1999,
            currency: 'INR',
            inStock: true,
            imageUrl: "https://via.placeholder.com/150",
            url: productUrl
        };
    }

    normalize(rawData) {
        return {
            id: `ajio-${rawData.id}`,
            platform: 'AJIO',
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

module.exports = AjioTracker;
