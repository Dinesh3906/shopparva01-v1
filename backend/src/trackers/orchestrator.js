const AmazonTracker = require('./platforms/amazon.tracker');
const FlipkartTracker = require('./platforms/flipkart.tracker');
const CromaTracker = require('./platforms/croma.tracker');
const MyntraTracker = require('./platforms/myntra.tracker');
const AjioTracker = require('./platforms/ajio.tracker');

class TrackerOrchestrator {
    constructor() {
        this.trackers = {
            'amazon.in': new AmazonTracker(),
            'amazon.com': new AmazonTracker(),
            'flipkart.com': new FlipkartTracker(),
            'croma.com': new CromaTracker(),
            'myntra.com': new MyntraTracker(),
            'ajio.com': new AjioTracker(),
        };
    }

    /**
     * Determine which tracker to use based on the URL.
     * @param {string} url 
     */
    getTracker(url) {
        const domain = new URL(url).hostname.replace('www.', '');
        return this.trackers[domain];
    }

    /**
     * Core method to track a product by URL.
     * @param {string} url 
     */
    async trackProduct(url) {
        const tracker = this.getTracker(url);
        if (!tracker) {
            throw new Error(`No tracker implemented for domain: ${new URL(url).hostname}`);
        }
        return await tracker.track(url);
    }
}

module.exports = new TrackerOrchestrator();
