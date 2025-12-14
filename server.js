const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());

// Helper function to generate realistic price history
function generatePriceHistory(basePrice, days) {
  const history = [];
  const now = new Date();

  // Generate a trend: -1 (downward), 0 (stable), 1 (upward)
  const trend = Math.random() < 0.4 ? -1 : (Math.random() < 0.7 ? 0 : 1);

  for (let i = days - 1; i >= 0; i--) {
    const date = new Date(now);
    date.setDate(date.getDate() - i);

    // Create price variation with trend
    const dayProgress = (days - i) / days;
    const trendEffect = trend * dayProgress * 0.15; // Max 15% trend effect
    const randomVariation = (Math.random() - 0.5) * 0.1; // Random ±5% variation
    const totalVariation = 1 + trendEffect + randomVariation;

    const price = basePrice * totalVariation;

    history.push({
      date: date.toISOString().split('T')[0],
      price: Math.round(price * 100) / 100
    });
  }

  return history;
}

// Helper to analyze price trend
function analyzePriceTrend(priceHistory) {
  if (!priceHistory || priceHistory.length < 2) {
    return { trend: 'stable', percentage: 0 };
  }

  const firstPrice = priceHistory[0].price;
  const lastPrice = priceHistory[priceHistory.length - 1].price;
  const change = ((lastPrice - firstPrice) / firstPrice) * 100;

  let trend = 'stable';
  if (change < -2) trend = 'down';
  else if (change > 2) trend = 'up';

  return {
    trend,
    percentage: Math.round(change * 10) / 10,
    lowest: Math.min(...priceHistory.map(p => p.price)),
    highest: Math.max(...priceHistory.map(p => p.price)),
    average: priceHistory.reduce((sum, p) => sum + p.price, 0) / priceHistory.length
  };
}

const products = [
  {
    id: 1,
    title: "HP Pavilion 15",
    brand: "HP",
    category: "Laptop",
    price: 749,
    rating: 4.6,
    stores: 5,
    image: "/images/hp-pavilion-15.png",
    tags: ["SSD Storage", "i5"],
    description: "HP Pavilion 15 laptop, 8GB RAM, 512GB SSD"
  },
  {
    id: 2,
    title: "Dell Inspiron 14",
    brand: "Dell",
    category: "Laptop",
    price: 699,
    rating: 4.5,
    stores: 4,
    image: "/images/dell-inspiron-14.png",
    tags: ["i7", "Dedicated GPU"],
    description: "Dell Inspiron 14, 16GB RAM, 1TB HDD"
  },
  {
    id: 3,
    title: "Lenovo IdeaPad Gaming 3",
    brand: "Lenovo",
    category: "Laptop",
    price: 899,
    rating: 4.7,
    stores: 6,
    image: "/images/lenovo-ideapad-gaming-3.png",
    tags: ["Dedicated GPU", "Gaming"],
    description: "Lenovo IdeaPad Gaming 3 with RTX-level GPU"
  },
  {
    id: 4,
    title: "ASUS VivoBook Pro",
    brand: "ASUS",
    category: "Laptop",
    price: 849,
    rating: 4.8,
    stores: 3,
    image: "/images/asus-vivobook-pro.png",
    tags: ["SSD Storage", "i7"],
    description: "ASUS VivoBook Pro — thin and powerful"
  }
  // add more items as needed for testing
];

app.get('/products', (req, res) => {
  const q = (req.query.q || '').toLowerCase();
  const brand = (req.query.brand || '').toLowerCase();
  const category = (req.query.category || '').toLowerCase();
  const priceMin = Number(req.query.priceMin || 0);
  const priceMax = Number(req.query.priceMax || Infinity);
  const includePriceHistory = req.query.priceHistory === 'true';
  const historyDays = Number(req.query.historyDays || 30);

  let results = products.filter((p) => {
    const haystack = `${p.title} ${p.description} ${p.brand}`.toLowerCase();
    const matchesQuery = q === '' || haystack.includes(q);
    const matchesBrand = brand === '' || p.brand.toLowerCase() === brand;
    const matchesCategory = category === '' || p.category.toLowerCase() === category;
    const matchesPrice = p.price >= priceMin && p.price <= priceMax;
    return matchesQuery && matchesBrand && matchesCategory && matchesPrice;
  });

  // Enrich with price history if requested
  if (includePriceHistory) {
    results = results.map(product => {
      const priceHistory = generatePriceHistory(product.price, historyDays);
      const trend = analyzePriceTrend(priceHistory);

      return {
        ...product,
        price_history: priceHistory,
        price_trend: trend
      };
    });
  }

  // Simulate small latency for testing
  setTimeout(() => {
    res.json({ count: results.length, results });
  }, 300);
});

// Get single product with full details including price history
app.get('/products/:id', (req, res) => {
  const productId = parseInt(req.params.id);
  const historyDays = Number(req.query.historyDays || 30);

  const product = products.find(p => p.id === productId);

  if (!product) {
    return res.status(404).json({ error: 'Product not found' });
  }

  const priceHistory = generatePriceHistory(product.price, historyDays);
  const trend = analyzePriceTrend(priceHistory);

  res.json({
    ...product,
    price_history: priceHistory,
    price_trend: trend
  });
});

app.listen(PORT, () => {
  console.log(`Server running on ${PORT}`);
});
