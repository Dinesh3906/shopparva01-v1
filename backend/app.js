const express = require('express');
const cors = require('cors');
const products = require('./src/db/products.json');
const trackerOrchestrator = require('./src/trackers/orchestrator');
const db = require('./src/db/json_db');
const alertService = require('./src/services/alert.service');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;

// Existing Logic: Product Listing
app.get('/api/v1/products', (req, res) => {
    res.json(products);
});

app.get('/api/v1/products/:id', (req, res) => {
    const product = products.find(p => p.id === req.params.id);
    if (product) {
        res.json(product);
    } else {
        res.status(404).json({ message: 'Product not found' });
    }
});

// Existing Logic: Kit Generation
app.post('/api/v1/kits/generate', (req, res) => {
    const { userId, category, budget } = req.body;
    // ... (simplified logic)
    res.json({ id: `kit-${Date.now()}`, userId, category, items: [], totalPrice: 0 });
});

// NEW: Multi-Platform Price Tracking
app.post('/api/v1/track-product', async (req, res) => {
    const { url, userId } = req.body;
    try {
        console.log(`[Server] Tracking request for ${url}`);
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
    const history = await db.getProductHistory(req.params.id);
    res.json({ success: true, history });
});

// User Endpoints (Mocks)
app.get('/api/v1/user/profile', (req, res) => {
    res.json({
        id: 'user-123',
        name: 'Dinesh',
        email: 'dinesh@shopparva.com',
        avatar: 'https://img.icons8.com/color/512/user-male-circle.png',
        preferences: {
            currency: 'INR',
            notifications: true
        }
    });
});
app.get('/api/v1/user/wishlist', (req, res) => res.json([]));
app.get('/api/v1/user/orders', (req, res) => res.json([]));

app.listen(PORT, () => {
    console.log(`[ShopParva] Clean Server running on port ${PORT}`);
});
