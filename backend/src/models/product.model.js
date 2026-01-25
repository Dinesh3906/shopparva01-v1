/**
 * @typedef {Object} UnifiedProduct
 * @property {string} id - Internal unique identifier
 * @property {string} platform - e.g., 'Amazon', 'Flipkart', 'Croma', 'Myntra', 'AJIO'
 * @property {string} externalId - ID on the platform (e.g., ASIN)
 * @property {string} title - Product title
 * @property {number} currentPrice - Current selling price
 * @property {number} originalPrice - MRP or original price
 * @property {string} currency - currency code (usually 'INR')
 * @property {number} discountPercentage - Calculated discount
 * @property {boolean} isAvailable - Stock status
 * @property {string} image - Main product image URL
 * @property {string} url - Product landing page URL
 * @property {string} timestamp - Last updated ISO string
 */

module.exports = {}; // Exporting nothing but the types for now
