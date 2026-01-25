/**
 * Abstract Base Class for Platform Trackers
 */
class BaseTracker {
    constructor(platformName) {
        if (this.constructor === BaseTracker) {
            throw new Error("Cannot instantiate abstract class BaseTracker");
        }
        this.platformName = platformName;
    }

    /**
     * Fetch product details from the platform.
     * Must be implemented by subclasses.
     * @param {string} productUrl - The URL of the product to track.
     * @returns {Promise<Object>} - Raw product data from the platform.
     */
    async fetchRawData(productUrl) {
        throw new Error("Method 'fetchRawData()' must be implemented.");
    }

    /**
     * Normalize raw data into UnifiedProduct schema.
     * @param {Object} rawData - Raw data from fetchRawData.
     * @returns {Object} - UnifiedProduct object.
     */
    normalize(rawData) {
        throw new Error("Method 'normalize()' must be implemented.");
    }

    /**
     * Main entry point to track a product.
     * @param {string} productUrl 
     */
    async track(productUrl) {
        try {
            const rawData = await this.fetchRawData(productUrl);
            return this.normalize(rawData);
        } catch (error) {
            console.error(`[${this.platformName}] Tracking failed for ${productUrl}:`, error.message);
            throw error;
        }
    }
}

module.exports = BaseTracker;
