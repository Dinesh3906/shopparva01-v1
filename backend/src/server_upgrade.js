const trackerOrchestrator = require('./trackers/orchestrator');
const db = require('./db/json_db');
const alertService = require('./services/alert.service');

function setupTrackingRoutes(app) {
    app.post('/api/v1/track-product', async (req, res) => {
        const { url, userId } = req.body;
        try {
            const product = await trackerOrchestrator.trackProduct(url);
            await db.saveProduct(product);
            const mockUserAlerts = [{ type: 'pct_drop', value: 10 }];
            const triggeredAlerts = alertService.checkAlerts(product, mockUserAlerts);
            if (triggeredAlerts.length > 0) {
                await alertService.notify(product, triggeredAlerts);
            }
            res.json({ success: true, product, triggeredAlerts });
        } catch (error) {
            res.status(500).json({ success: false, message: error.message });
        }
    });

    app.get('/api/v1/product-history/:id', async (req, res) => {
        try {
            const history = await db.getProductHistory(req.params.id);
            res.json({ success: true, history });
        } catch (error) {
            res.status(500).json({ success: false, message: error.message });
        }
    });
}

module.exports = { setupTrackingRoutes };
