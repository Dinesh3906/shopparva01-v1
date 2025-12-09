const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());

// Optional: serve static images if you add any under ./images
// app.use('/images', express.static('images'));

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

  let results = products.filter((p) => {
    const haystack = `${p.title} ${p.description} ${p.brand}`.toLowerCase();
    const matchesQuery = q === '' || haystack.includes(q);
    const matchesBrand = brand === '' || p.brand.toLowerCase() === brand;
    const matchesCategory = category === '' || p.category.toLowerCase() === category;
    const matchesPrice = p.price >= priceMin && p.price <= priceMax;
    return matchesQuery && matchesBrand && matchesCategory && matchesPrice;
  });

  // Simulate small latency for testing
  setTimeout(() => {
    res.json({ count: results.length, results });
  }, 300);
});

app.listen(PORT, () => {
  console.log(`Server running on ${PORT}`);
});
