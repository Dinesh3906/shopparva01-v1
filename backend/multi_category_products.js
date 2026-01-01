const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

// Comprehensive multi-category product data
const multiCategoryProducts = [
    // Fashion - Nike Shoes
    {
        id: "fashion-nike-airmax",
        title: "Nike Air Max 270 Running Shoes",
        brand: "Nike",
        modelName: "Air Max 270",
        description: "Nike Air Max 270 Running Shoes - Black/White",
        category: "Fashion",
        images: ["https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400"],
        rating: 4.6,
        reviewCount: "1892",
        badgeText: "Best Seller",
        offers: [{
            marketplace: "Amazon",
            seller: "Nike Official Store",
            price: 12995,
            originalPrice: 14995,
            discount: "13% Off",
            savingsText: "(Save ₹2,000)",
            delivery: "Free Delivery by Tomorrow",
            url: "https://www.amazon.in/nike-air-max-270",
            isBest: true
        }],
        priceHistory: [
            { date: "2025-12-01", price: 13500 },
            { date: "2025-12-15", price: 12995 }
        ]
    },
    // Fashion - Levi's Jeans
    {
        id: "fashion-levis-511",
        title: "Levi's 511 Slim Fit Jeans - Dark Blue",
        brand: "Levi's",
        modelName: "511 Slim Fit",
        description: "Classic Levi's 511 Slim Fit Jeans in Dark Blue Denim",
        category: "Fashion",
        images: ["https://images.unsplash.com/photo-1542272604-787c3835535d?w=400"],
        rating: 4.4,
        reviewCount: "2341",
        badgeText: "Trending",
        offers: [{
            marketplace: "Myntra",
            seller: "Levi's Official",
            price: 2999,
            originalPrice: 4999,
            discount: "40% Off",
            savingsText: "(Save ₹2,000)",
            delivery: "Delivery in 2-3 days",
            url: "https://www.myntra.com/levis-511-jeans",
            isBest: true
        }],
        priceHistory: [
            { date: "2025-12-01", price: 3499 },
            { date: "2025-12-15", price: 2999 }
        ]
    },
    // Sports - Adidas Football Boots
    {
        id: "sports-adidas-predator",
        title: "Adidas Predator Edge Football Boots",
        brand: "Adidas",
        modelName: "Predator Edge",
        description: "Professional football boots with superior grip and control",
        category: "Sports",
        images: ["https://images.unsplash.com/photo-1511886929837-354d827aae26?w=400"],
        rating: 4.7,
        reviewCount: "876",
        badgeText: "Pro Choice",
        offers: [{
            marketplace: "Decathlon",
            seller: "Adidas Official",
            price: 8999,
            originalPrice: 12999,
            discount: "31% Off",
            savingsText: "(Save ₹4,000)",
            delivery: "Free Delivery",
            url: "https://www.decathlon.in/adidas-predator",
            isBest: true
        }],
        priceHistory: [
            { date: "2025-12-01", price: 9999 },
            { date: "2025-12-15", price: 8999 }
        ]
    },
    // Sports - Yonex Badminton Racket
    {
        id: "sports-yonex-nanoray",
        title: "Yonex Nanoray 900 Badminton Racket",
        brand: "Yonex",
        modelName: "Nanoray 900",
        description: "Professional badminton racket for advanced players",
        category: "Sports",
        images: ["https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=400"],
        rating: 4.6,
        reviewCount: "543",
        badgeText: "Tournament Grade",
        offers: [{
            marketplace: "Amazon",
            seller: "Yonex India",
            price: 6499,
            originalPrice: 8999,
            discount: "28% Off",
            savingsText: "(Save ₹2,500)",
            delivery: "Free Delivery by Tomorrow",
            url: "https://www.amazon.in/yonex-nanoray-900",
            isBest: true
        }],
        priceHistory: [
            { date: "2025-12-01", price: 7499 },
            { date: "2025-12-15", price: 6499 }
        ]
    },
    // Beauty - Lakme Lipstick
    {
        id: "beauty-lakme-absolute",
        title: "Lakme Absolute Matte Lipstick - Red Rush",
        brand: "Lakme",
        modelName: "Absolute Matte",
        description: "Long-lasting matte lipstick in Red Rush shade",
        category: "Beauty",
        images: ["https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=400"],
        rating: 4.5,
        reviewCount: "3421",
        badgeText: "Best Seller",
        offers: [{
            marketplace: "Nykaa",
            seller: "Lakme Official",
            price: 599,
            originalPrice: 850,
            discount: "30% Off",
            savingsText: "(Save ₹251)",
            delivery: "Delivery in 2-3 days",
            url: "https://www.nykaa.com/lakme-absolute-lipstick",
            isBest: true
        }],
        priceHistory: [
            { date: "2025-12-01", price: 650 },
            { date: "2025-12-15", price: 599 }
        ]
    },
    // Beauty - L'Oreal Serum
    {
        id: "beauty-loreal-revitalift",
        title: "L'Oreal Paris Revitalift Hyaluronic Acid Serum",
        brand: "L'Oreal",
        modelName: "Revitalift Hyaluronic Acid",
        description: "Anti-aging serum with hyaluronic acid - 30ml",
        category: "Beauty",
        images: ["https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400"],
        rating: 4.6,
        reviewCount: "2187",
        badgeText: "Dermatologist Recommended",
        offers: [{
            marketplace: "Amazon",
            seller: "L'Oreal India",
            price: 1299,
            originalPrice: 1999,
            discount: "35% Off",
            savingsText: "(Save ₹700)",
            delivery: "Free Delivery by Tomorrow",
            url: "https://www.amazon.in/loreal-revitalift-serum",
            isBest: true
        }],
        priceHistory: [
            { date: "2025-12-01", price: 1499 },
            { date: "2025-12-15", price: 1299 }
        ]
    },
    // Essentials - Dettol Handwash
    {
        id: "essentials-dettol-handwash",
        title: "Dettol Original Handwash Refill Pack - 750ml",
        brand: "Dettol",
        modelName: "Original Handwash",
        description: "Antibacterial handwash refill pack 750ml",
        category: "Essentials",
        images: ["https://images.unsplash.com/photo-1584305574647-0cc949a2bb9f?w=400"],
        rating: 4.7,
        reviewCount: "5234",
        badgeText: "Essential Item",
        offers: [{
            marketplace: "BigBasket",
            seller: "Dettol Official",
            price: 189,
            originalPrice: 250,
            discount: "24% Off",
            savingsText: "(Save ₹61)",
            delivery: "Same Day Delivery",
            url: "https://www.bigbasket.com/dettol-handwash",
            isBest: true
        }],
        priceHistory: [
            { date: "2025-12-01", price: 199 },
            { date: "2025-12-15", price: 189 }
        ]
    },
    // Essentials - Colgate Toothpaste
    {
        id: "essentials-colgate-total",
        title: "Colgate Total Advanced Toothpaste - 200g",
        brand: "Colgate",
        modelName: "Total Advanced",
        description: "Complete oral care toothpaste 200g",
        category: "Essentials",
        images: ["https://images.unsplash.com/photo-1622597467836-f3285f2131b8?w=400"],
        rating: 4.6,
        reviewCount: "6543",
        badgeText: "Dentist Recommended",
        offers: [{
            marketplace: "Amazon",
            seller: "Colgate India",
            price: 145,
            originalPrice: 180,
            discount: "19% Off",
            savingsText: "(Save ₹35)",
            delivery: "Free Delivery",
            url: "https://www.amazon.in/colgate-total-advanced",
            isBest: true
        }],
        priceHistory: [
            { date: "2025-12-01", price: 155 },
            { date: "2025-12-15", price: 145 }
        ]
    }
];

// Export for use in main server
module.exports = multiCategoryProducts;
