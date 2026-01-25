const BaseTracker = require('../base.tracker');

class AmazonTracker extends BaseTracker {
    constructor() {
        super('Amazon');
    }

    /**
     * @param {string} productUrl 
     */
    async fetchRawData(productUrl) {
        // TODO: In production, use Amazon PA-API or a legal crawler
        // For now, this is a structural mock
        console.log(`[AmazonTracker] Fetching data for: ${productUrl}`);

        // Mocking a response
        return {
            asin: productUrl.split('/dp/')[1]?.split('/')[0] || 'B0XXXX',
            title: "Mock Amazon Product",
            price: 999.00,
            mrp: 1299.00,
            currency: 'INR',
            inStock: true,
            imageUrl: "https://via.placeholder.com/150",
            url: productUrl
        };
    }

    normalize(rawData) {
        return {
            id: `amazon-${rawData.asin}`,
            platform: 'Amazon',
            externalId: rawData.asin,
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

module.exports = AmazonTracker;
