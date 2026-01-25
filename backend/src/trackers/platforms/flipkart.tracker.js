const BaseTracker = require('../base.tracker');

class FlipkartTracker extends BaseTracker {
    constructor() {
        super('Flipkart');
    }

    async fetchRawData(productUrl) {
        console.log(`[FlipkartTracker] Fetching data for: ${productUrl}`);

        // Mocking a response
        return {
            fsn: productUrl.split('pid=')[1]?.split('&')[0] || 'FLKXXXX',
            title: "Mock Flipkart Product",
            price: 899.00,
            mrp: 1199.00,
            currency: 'INR',
            inStock: true,
            imageUrl: "https://via.placeholder.com/150",
            url: productUrl
        };
    }

    normalize(rawData) {
        return {
            id: `flipkart-${rawData.fsn}`,
            platform: 'Flipkart',
            externalId: rawData.fsn,
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

module.exports = FlipkartTracker;
