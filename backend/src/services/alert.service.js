class AlertService {
    /**
     * Check if a price drop triggers any alerts.
     * @param {Object} product - UnifiedProduct object
     * @param {Object} userAlerts - List of alert settings for this product/user
     */
    checkAlerts(product, userAlerts) {
        const triggered = [];
        for (const alert of userAlerts) {
            if (alert.type === 'target_price' && product.currentPrice <= alert.value) {
                triggered.push(alert);
            } else if (alert.type === 'pct_drop' && product.discountPercentage >= alert.value) {
                triggered.push(alert);
            }
        }
        return triggered;
    }

    /**
     * Send notifications (In-app, Email, etc.)
     * @param {Object} product 
     * @param {Array} alerts 
     */
    async notify(product, alerts) {
        for (const alert of alerts) {
            console.log(`[Alert] TRIGGERED for ${product.title}: ${alert.type} ${alert.value}`);
            // TODO: Integrate with FCM or Email service
        }
    }
}

module.exports = new AlertService();
