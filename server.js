const http = require('http');

const products = [
  {
    "id": "prod_1",
    "title": "Apple iPhone 14 Pro",
    "modelName": "Apple iPhone 14 Pro",
    "brand": "Apple",
    "description": "6.1-inch Super Retina XDR display with ProMotion. A16 Bionic chip. Pro camera system with 48MP Main camera. Up to 29 hours video playback.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=iphone14"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Amazon India",
        "price": 119900,
        "marketplace": "Amazon",
        "url": "https://amazon.com",
        "discount": "10%",
        "delivery": "2 days"
      }
    ]
  },
  {
    "id": "prod_2",
    "title": "Apple iPhone 14 Pro",
    "modelName": "Apple iPhone 14 Pro",
    "brand": "Apple",
    "description": "6.1-inch Super Retina XDR display with ProMotion. A16 Bionic chip. Pro camera system with 48MP Main camera. Up to 29 hours video playback.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=iphone14"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Flipkart Retail",
        "price": 121499,
        "marketplace": "Flipkart",
        "url": "https://flipkart.com",
        "discount": "8%",
        "delivery": "3 days"
      }
    ]
  },
  {
    "id": "prod_3",
    "title": "Apple iPhone 14 Pro",
    "modelName": "Apple iPhone 14 Pro",
    "brand": "Apple",
    "description": "6.1-inch Super Retina XDR display with ProMotion. A16 Bionic chip. Pro camera system with 48MP Main camera. Up to 29 hours video playback.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=iphone14"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Croma Retail",
        "price": 124990,
        "marketplace": "Croma",
        "url": "https://croma.com",
        "discount": "5%",
        "delivery": "5 days"
      }
    ]
  },
  {
    "id": "prod_4",
    "title": "Apple iPhone 14 Pro",
    "modelName": "Apple iPhone 14 Pro",
    "brand": "Apple",
    "description": "6.1-inch Super Retina XDR display with ProMotion. A16 Bionic chip. Pro camera system with 48MP Main camera. Up to 29 hours video playback.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=iphone14"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Reliance Digital",
        "price": 122900,
        "marketplace": "Reliance Digital",
        "url": "https://reliancedigital.com",
        "discount": "7%",
        "delivery": "4 days"
      }
    ]
  },
  {
    "id": "prod_5",
    "title": "Samsung Galaxy S23 Ultra",
    "modelName": "Samsung Galaxy S23 Ultra",
    "brand": "Samsung",
    "description": "6.8-inch Dynamic AMOLED 2X display. Snapdragon 8 Gen 2. 200MP camera with 100x Space Zoom. S Pen included. All-day battery.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=s23ultra"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "Appario Retail",
        "price": 109999,
        "marketplace": "Amazon",
        "url": "https://amazon.com",
        "discount": "15%",
        "delivery": "1 day"
      }
    ]
  },
  {
    "id": "prod_6",
    "title": "Samsung Galaxy S23 Ultra",
    "modelName": "Samsung Galaxy S23 Ultra",
    "brand": "Samsung",
    "description": "6.8-inch Dynamic AMOLED 2X display. Snapdragon 8 Gen 2. 200MP camera with 100x Space Zoom. S Pen included. All-day battery.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=s23ultra"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "Samsung Brand Store",
        "price": 112999,
        "marketplace": "Flipkart",
        "url": "https://flipkart.com",
        "discount": "12%",
        "delivery": "2 days"
      }
    ]
  },
  {
    "id": "prod_7",
    "title": "Samsung Galaxy S23 Ultra",
    "modelName": "Samsung Galaxy S23 Ultra",
    "brand": "Samsung",
    "description": "6.8-inch Dynamic AMOLED 2X display. Snapdragon 8 Gen 2. 200MP camera with 100x Space Zoom. S Pen included. All-day battery.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=s23ultra"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "Myntra Electronics",
        "price": 114999,
        "marketplace": "Myntra",
        "url": "https://myntra.com",
        "discount": "10%",
        "delivery": "4 days"
      }
    ]
  },
  {
    "id": "prod_8",
    "title": "Samsung Galaxy S23 Ultra",
    "modelName": "Samsung Galaxy S23 Ultra",
    "brand": "Samsung",
    "description": "6.8-inch Dynamic AMOLED 2X display. Snapdragon 8 Gen 2. 200MP camera with 100x Space Zoom. S Pen included. All-day battery.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=s23ultra"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "Croma",
        "price": 111499,
        "marketplace": "Croma",
        "url": "https://croma.com",
        "discount": "13%",
        "delivery": "3 days"
      }
    ]
  },
  {
    "id": "prod_9",
    "title": "Samsung Galaxy S23 Ultra",
    "modelName": "Samsung Galaxy S23 Ultra",
    "brand": "Samsung",
    "description": "6.8-inch Dynamic AMOLED 2X display. Snapdragon 8 Gen 2. 200MP camera with 100x Space Zoom. S Pen included. All-day battery.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=s23ultra"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "ShopParva Official",
        "price": 108999,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com",
        "discount": "16%",
        "delivery": "2 days"
      }
    ]
  },
  {
    "id": "prod_10",
    "title": "OnePlus 11 5G",
    "modelName": "OnePlus 11 5G",
    "brand": "OnePlus",
    "description": "6.7-inch AMOLED display with 120Hz. Snapdragon 8 Gen 2. Hasselblad Camera for Mobile. 100W SUPERVOOC fast charging.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=oneplus11"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "OnePlus Official",
        "price": 56999,
        "marketplace": "Amazon",
        "url": "https://amazon.com",
        "discount": "12%",
        "delivery": "2 days"
      }
    ]
  },
  {
    "id": "prod_11",
    "title": "OnePlus 11 5G",
    "modelName": "OnePlus 11 5G",
    "brand": "OnePlus",
    "description": "6.7-inch AMOLED display with 120Hz. Snapdragon 8 Gen 2. Hasselblad Camera for Mobile. 100W SUPERVOOC fast charging.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=oneplus11"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "Flipkart",
        "price": 58499,
        "marketplace": "Flipkart",
        "url": "https://flipkart.com",
        "discount": "10%",
        "delivery": "3 days"
      }
    ]
  },
  {
    "id": "prod_12",
    "title": "OnePlus 11 5G",
    "modelName": "OnePlus 11 5G",
    "brand": "OnePlus",
    "description": "6.7-inch AMOLED display with 120Hz. Snapdragon 8 Gen 2. Hasselblad Camera for Mobile. 100W SUPERVOOC fast charging.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=oneplus11"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "Reliance Digital",
        "price": 59999,
        "marketplace": "Reliance Digital",
        "url": "https://reliancedigital.com",
        "discount": "8%",
        "delivery": "5 days"
      }
    ]
  },
  {
    "id": "prod_13",
    "title": "MacBook Air M2",
    "modelName": "MacBook Air M2",
    "brand": "Apple",
    "description": "13.6-inch Liquid Retina display. Apple M2 chip with 8-core CPU. 8GB unified memory. 256GB SSD storage. All-day battery life.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=macbookair"
    ],
    "rating": "4.8",
    "offers": [
      {
        "seller": "Appario Retail",
        "price": 114900,
        "marketplace": "Amazon",
        "url": "https://amazon.com",
        "discount": "5%",
        "delivery": "3 days"
      }
    ]
  },
  {
    "id": "prod_14",
    "title": "MacBook Air M2",
    "modelName": "MacBook Air M2",
    "brand": "Apple",
    "description": "13.6-inch Liquid Retina display. Apple M2 chip with 8-core CPU. 8GB unified memory. 256GB SSD storage. All-day battery life.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=macbookair"
    ],
    "rating": "4.8",
    "offers": [
      {
        "seller": "Apple Authorized",
        "price": 116900,
        "marketplace": "Flipkart",
        "url": "https://flipkart.com",
        "discount": "3%",
        "delivery": "4 days"
      }
    ]
  },
  {
    "id": "prod_15",
    "title": "MacBook Air M2",
    "modelName": "MacBook Air M2",
    "brand": "Apple",
    "description": "13.6-inch Liquid Retina display. Apple M2 chip with 8-core CPU. 8GB unified memory. 256GB SSD storage. All-day battery life.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=macbookair"
    ],
    "rating": "4.8",
    "offers": [
      {
        "seller": "Croma Electronics",
        "price": 119900,
        "marketplace": "Croma",
        "url": "https://croma.com",
        "discount": "0%",
        "delivery": "2 days"
      }
    ]
  },
  {
    "id": "prod_16",
    "title": "MacBook Air M2",
    "modelName": "MacBook Air M2",
    "brand": "Apple",
    "description": "13.6-inch Liquid Retina display. Apple M2 chip with 8-core CPU. 8GB unified memory. 256GB SSD storage. All-day battery life.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=macbookair"
    ],
    "rating": "4.8",
    "offers": [
      {
        "seller": "Reliance Digital",
        "price": 117900,
        "marketplace": "Reliance Digital",
        "url": "https://reliancedigital.com",
        "discount": "2%",
        "delivery": "5 days"
      }
    ]
  },
  {
    "id": "prod_17",
    "title": "Dell XPS 13",
    "modelName": "Dell XPS 13",
    "brand": "Dell",
    "description": "13.4-inch FHD+ display. 12th Gen Intel Core i7. 16GB RAM. 512GB SSD. Premium InfinityEdge display.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=dellxps"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "Dell Official",
        "price": 109990,
        "marketplace": "Amazon",
        "url": "https://amazon.com",
        "discount": "8%",
        "delivery": "4 days"
      }
    ]
  },
  {
    "id": "prod_18",
    "title": "Dell XPS 13",
    "modelName": "Dell XPS 13",
    "brand": "Dell",
    "description": "13.4-inch FHD+ display. 12th Gen Intel Core i7. 16GB RAM. 512GB SSD. Premium InfinityEdge display.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=dellxps"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "RetailNet",
        "price": 112490,
        "marketplace": "Flipkart",
        "url": "https://flipkart.com",
        "discount": "6%",
        "delivery": "5 days"
      }
    ]
  },
  {
    "id": "prod_19",
    "title": "Dell XPS 13",
    "modelName": "Dell XPS 13",
    "brand": "Dell",
    "description": "13.4-inch FHD+ display. 12th Gen Intel Core i7. 16GB RAM. 512GB SSD. Premium InfinityEdge display.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=dellxps"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "Croma",
        "price": 114990,
        "marketplace": "Croma",
        "url": "https://croma.com",
        "discount": "4%",
        "delivery": "3 days"
      }
    ]
  },
  {
    "id": "prod_20",
    "title": "Sony WH-1000XM5",
    "modelName": "Sony WH-1000XM5",
    "brand": "Sony",
    "description": "Industry-leading noise cancellation. 30-hour battery life. Premium sound quality with LDAC. Multipoint connection.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=sonywh1000"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Cloudtail India",
        "price": 29990,
        "marketplace": "Amazon",
        "url": "https://amazon.com",
        "discount": "15%",
        "delivery": "1 day"
      }
    ]
  },
  {
    "id": "prod_21",
    "title": "Sony WH-1000XM5",
    "modelName": "Sony WH-1000XM5",
    "brand": "Sony",
    "description": "Industry-leading noise cancellation. 30-hour battery life. Premium sound quality with LDAC. Multipoint connection.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=sonywh1000"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Sony India",
        "price": 31490,
        "marketplace": "Flipkart",
        "url": "https://flipkart.com",
        "discount": "12%",
        "delivery": "2 days"
      }
    ]
  },
  {
    "id": "prod_22",
    "title": "Sony WH-1000XM5",
    "modelName": "Sony WH-1000XM5",
    "brand": "Sony",
    "description": "Industry-leading noise cancellation. 30-hour battery life. Premium sound quality with LDAC. Multipoint connection.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=sonywh1000"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Myntra Audio",
        "price": 32990,
        "marketplace": "Myntra",
        "url": "https://myntra.com",
        "discount": "10%",
        "delivery": "3 days"
      }
    ]
  },
  {
    "id": "prod_23",
    "title": "Sony WH-1000XM5",
    "modelName": "Sony WH-1000XM5",
    "brand": "Sony",
    "description": "Industry-leading noise cancellation. 30-hour battery life. Premium sound quality with LDAC. Multipoint connection.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=sonywh1000"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Croma",
        "price": 30990,
        "marketplace": "Croma",
        "url": "https://croma.com",
        "discount": "13%",
        "delivery": "2 days"
      }
    ]
  },
  {
    "id": "prod_24",
    "title": "Sony WH-1000XM5",
    "modelName": "Sony WH-1000XM5",
    "brand": "Sony",
    "description": "Industry-leading noise cancellation. 30-hour battery life. Premium sound quality with LDAC. Multipoint connection.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=sonywh1000"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "ShopParva",
        "price": 29490,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com",
        "discount": "16%",
        "delivery": "1 day"
      }
    ]
  },
  {
    "id": "prod_25",
    "title": "Nike Air Max 270",
    "modelName": "Nike Air Max 270",
    "brand": "Nike",
    "description": "Max Air unit for ultimate cushioning. Breathable mesh upper. Durable rubber outsole. Iconic Nike style.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=nikeairmax"
    ],
    "rating": "4.4",
    "offers": [
      {
        "seller": "Nike Official",
        "price": 12995,
        "marketplace": "Amazon",
        "url": "https://amazon.com",
        "discount": "20%",
        "delivery": "3 days"
      }
    ]
  },
  {
    "id": "prod_26",
    "title": "Nike Air Max 270",
    "modelName": "Nike Air Max 270",
    "brand": "Nike",
    "description": "Max Air unit for ultimate cushioning. Breathable mesh upper. Durable rubber outsole. Iconic Nike style.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=nikeairmax"
    ],
    "rating": "4.4",
    "offers": [
      {
        "seller": "Nike Store",
        "price": 13495,
        "marketplace": "Flipkart",
        "url": "https://flipkart.com",
        "discount": "18%",
        "delivery": "4 days"
      }
    ]
  },
  {
    "id": "prod_27",
    "title": "Nike Air Max 270",
    "modelName": "Nike Air Max 270",
    "brand": "Nike",
    "description": "Max Air unit for ultimate cushioning. Breathable mesh upper. Durable rubber outsole. Iconic Nike style.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=nikeairmax"
    ],
    "rating": "4.4",
    "offers": [
      {
        "seller": "Myntra Fashion",
        "price": 12795,
        "marketplace": "Myntra",
        "url": "https://myntra.com",
        "discount": "21%",
        "delivery": "2 days"
      }
    ]
  },
  {
    "id": "prod_28",
    "title": "Nike Air Max 270",
    "modelName": "Nike Air Max 270",
    "brand": "Nike",
    "description": "Max Air unit for ultimate cushioning. Breathable mesh upper. Durable rubber outsole. Iconic Nike style.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=nikeairmax"
    ],
    "rating": "4.4",
    "offers": [
      {
        "seller": "ShopParva Sports",
        "price": 12495,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com",
        "discount": "23%",
        "delivery": "3 days"
      }
    ]
  },
  {
    "id": "prod_29",
    "title": "Adidas Ultraboost 22",
    "modelName": "Adidas Ultraboost 22",
    "brand": "Adidas",
    "description": "Responsive BOOST cushioning. Primeknit+ upper. Continental rubber outsole. Energy-returning performance.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=ultraboost"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "Adidas Official",
        "price": 16999,
        "marketplace": "Amazon",
        "url": "https://amazon.com",
        "discount": "15%",
        "delivery": "2 days"
      }
    ]
  },
  {
    "id": "prod_30",
    "title": "Adidas Ultraboost 22",
    "modelName": "Adidas Ultraboost 22",
    "brand": "Adidas",
    "description": "Responsive BOOST cushioning. Primeknit+ upper. Continental rubber outsole. Energy-returning performance.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=ultraboost"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "Adidas Store",
        "price": 17499,
        "marketplace": "Flipkart",
        "url": "https://flipkart.com",
        "discount": "12%",
        "delivery": "3 days"
      }
    ]
  },
  {
    "id": "prod_31",
    "title": "Adidas Ultraboost 22",
    "modelName": "Adidas Ultraboost 22",
    "brand": "Adidas",
    "description": "Responsive BOOST cushioning. Primeknit+ upper. Continental rubber outsole. Energy-returning performance.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=ultraboost"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "Myntra",
        "price": 16799,
        "marketplace": "Myntra",
        "url": "https://myntra.com",
        "discount": "16%",
        "delivery": "2 days"
      }
    ]
  },
  {
    "id": "prod_32",
    "title": "Levi's 501 Original Jeans",
    "modelName": "Levi's 501 Original Jeans",
    "brand": "Levi's",
    "description": "Classic straight fit. Button fly. Iconic 501 style. Premium denim quality. Timeless design.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=levis501"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "Levi's Official",
        "price": 3999,
        "marketplace": "Amazon",
        "url": "https://amazon.com",
        "discount": "25%",
        "delivery": "3 days"
      }
    ]
  },
  {
    "id": "prod_33",
    "title": "Levi's 501 Original Jeans",
    "modelName": "Levi's 501 Original Jeans",
    "brand": "Levi's",
    "description": "Classic straight fit. Button fly. Iconic 501 style. Premium denim quality. Timeless design.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=levis501"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "Levi's Store",
        "price": 4199,
        "marketplace": "Flipkart",
        "url": "https://flipkart.com",
        "discount": "22%",
        "delivery": "4 days"
      }
    ]
  },
  {
    "id": "prod_34",
    "title": "Levi's 501 Original Jeans",
    "modelName": "Levi's 501 Original Jeans",
    "brand": "Levi's",
    "description": "Classic straight fit. Button fly. Iconic 501 style. Premium denim quality. Timeless design.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=levis501"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "Myntra Fashion",
        "price": 3899,
        "marketplace": "Myntra",
        "url": "https://myntra.com",
        "discount": "27%",
        "delivery": "2 days"
      }
    ]
  },
  {
    "id": "prod_35",
    "title": "Levi's 501 Original Jeans",
    "modelName": "Levi's 501 Original Jeans",
    "brand": "Levi's",
    "description": "Classic straight fit. Button fly. Iconic 501 style. Premium denim quality. Timeless design.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=levis501"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "ShopParva Fashion",
        "price": 3799,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com",
        "discount": "29%",
        "delivery": "3 days"
      }
    ]
  },
  {
    "id": "prod_36",
    "title": "Dyson V15 Detect",
    "modelName": "Dyson V15 Detect",
    "brand": "Dyson",
    "description": "Laser dust detection. Powerful suction. LCD screen shows particle count. Up to 60 minutes runtime.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=dysonv15"
    ],
    "rating": "4.8",
    "offers": [
      {
        "seller": "Dyson India",
        "price": 58900,
        "marketplace": "Amazon",
        "url": "https://amazon.com",
        "discount": "10%",
        "delivery": "4 days"
      }
    ]
  },
  {
    "id": "prod_37",
    "title": "Dyson V15 Detect",
    "modelName": "Dyson V15 Detect",
    "brand": "Dyson",
    "description": "Laser dust detection. Powerful suction. LCD screen shows particle count. Up to 60 minutes runtime.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=dysonv15"
    ],
    "rating": "4.8",
    "offers": [
      {
        "seller": "Dyson Official",
        "price": 59900,
        "marketplace": "Flipkart",
        "url": "https://flipkart.com",
        "discount": "8%",
        "delivery": "5 days"
      }
    ]
  },
  {
    "id": "prod_38",
    "title": "Dyson V15 Detect",
    "modelName": "Dyson V15 Detect",
    "brand": "Dyson",
    "description": "Laser dust detection. Powerful suction. LCD screen shows particle count. Up to 60 minutes runtime.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=dysonv15"
    ],
    "rating": "4.8",
    "offers": [
      {
        "seller": "Croma",
        "price": 61900,
        "marketplace": "Croma",
        "url": "https://croma.com",
        "discount": "5%",
        "delivery": "3 days"
      }
    ]
  },
  {
    "id": "prod_39",
    "title": "Dyson V15 Detect",
    "modelName": "Dyson V15 Detect",
    "brand": "Dyson",
    "description": "Laser dust detection. Powerful suction. LCD screen shows particle count. Up to 60 minutes runtime.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=dysonv15"
    ],
    "rating": "4.8",
    "offers": [
      {
        "seller": "Reliance Digital",
        "price": 60900,
        "marketplace": "Reliance Digital",
        "url": "https://reliancedigital.com",
        "discount": "7%",
        "delivery": "4 days"
      }
    ]
  },
  {
    "id": "prod_40",
    "title": "LG 55-inch OLED TV",
    "modelName": "LG 55-inch OLED TV",
    "brand": "LG",
    "description": "4K OLED display. α9 Gen5 AI Processor. Dolby Vision IQ. webOS smart platform. Perfect for gaming.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=lgoled"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Cloudtail",
        "price": 129990,
        "marketplace": "Amazon",
        "url": "https://amazon.com",
        "discount": "12%",
        "delivery": "5 days"
      }
    ]
  },
  {
    "id": "prod_41",
    "title": "LG 55-inch OLED TV",
    "modelName": "LG 55-inch OLED TV",
    "brand": "LG",
    "description": "4K OLED display. α9 Gen5 AI Processor. Dolby Vision IQ. webOS smart platform. Perfect for gaming.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=lgoled"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "LG Official",
        "price": 132990,
        "marketplace": "Flipkart",
        "url": "https://flipkart.com",
        "discount": "10%",
        "delivery": "6 days"
      }
    ]
  },
  {
    "id": "prod_42",
    "title": "LG 55-inch OLED TV",
    "modelName": "LG 55-inch OLED TV",
    "brand": "LG",
    "description": "4K OLED display. α9 Gen5 AI Processor. Dolby Vision IQ. webOS smart platform. Perfect for gaming.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=lgoled"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Croma Electronics",
        "price": 127990,
        "marketplace": "Croma",
        "url": "https://croma.com",
        "discount": "13%",
        "delivery": "4 days"
      }
    ]
  },
  {
    "id": "prod_43",
    "title": "LG 55-inch OLED TV",
    "modelName": "LG 55-inch OLED TV",
    "brand": "LG",
    "description": "4K OLED display. α9 Gen5 AI Processor. Dolby Vision IQ. webOS smart platform. Perfect for gaming.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=lgoled"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Reliance Digital",
        "price": 131990,
        "marketplace": "Reliance Digital",
        "url": "https://reliancedigital.com",
        "discount": "11%",
        "delivery": "5 days"
      }
    ]
  },
  {
    "id": "prod_44",
    "title": "LG 55-inch OLED TV",
    "modelName": "LG 55-inch OLED TV",
    "brand": "LG",
    "description": "4K OLED display. α9 Gen5 AI Processor. Dolby Vision IQ. webOS smart platform. Perfect for gaming.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=lgoled"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "ShopParva Home",
        "price": 126990,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com",
        "discount": "14%",
        "delivery": "5 days"
      }
    ]
  },
  {
    "id": "prod_45",
    "title": "Dyson Airwrap Styler",
    "modelName": "Dyson Airwrap Styler",
    "brand": "Dyson",
    "description": "Multi-styler for multiple hair types. Coanda effect styling. No extreme heat. Complete styling system.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=airwrap"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "Dyson Official",
        "price": 45900,
        "marketplace": "Amazon",
        "url": "https://amazon.com",
        "discount": "8%",
        "delivery": "3 days"
      }
    ]
  },
  {
    "id": "prod_46",
    "title": "Dyson Airwrap Styler",
    "modelName": "Dyson Airwrap Styler",
    "brand": "Dyson",
    "description": "Multi-styler for multiple hair types. Coanda effect styling. No extreme heat. Complete styling system.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=airwrap"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "Dyson India",
        "price": 46900,
        "marketplace": "Flipkart",
        "url": "https://flipkart.com",
        "discount": "6%",
        "delivery": "4 days"
      }
    ]
  },
  {
    "id": "prod_47",
    "title": "Dyson Airwrap Styler",
    "modelName": "Dyson Airwrap Styler",
    "brand": "Dyson",
    "description": "Multi-styler for multiple hair types. Coanda effect styling. No extreme heat. Complete styling system.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=airwrap"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "Myntra Beauty",
        "price": 47900,
        "marketplace": "Myntra",
        "url": "https://myntra.com",
        "discount": "4%",
        "delivery": "5 days"
      }
    ]
  },
  {
    "id": "prod_48",
    "title": "Dyson Airwrap Styler",
    "modelName": "Dyson Airwrap Styler",
    "brand": "Dyson",
    "description": "Multi-styler for multiple hair types. Coanda effect styling. No extreme heat. Complete styling system.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=airwrap"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "Croma",
        "price": 46400,
        "marketplace": "Croma",
        "url": "https://croma.com",
        "discount": "7%",
        "delivery": "3 days"
      }
    ]
  },
  {
    "id": "prod_49",
    "title": "Yonex Astrox 99 Pro",
    "modelName": "Yonex Astrox 99 Pro",
    "brand": "Yonex",
    "description": "Professional badminton racket. Rotational Generator System. Namd graphite. Head-heavy balance for power.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=yonex"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Yonex Official",
        "price": 16990,
        "marketplace": "Amazon",
        "url": "https://amazon.com",
        "discount": "10%",
        "delivery": "3 days"
      }
    ]
  },
  {
    "id": "prod_50",
    "title": "Yonex Astrox 99 Pro",
    "modelName": "Yonex Astrox 99 Pro",
    "brand": "Yonex",
    "description": "Professional badminton racket. Rotational Generator System. Namd graphite. Head-heavy balance for power.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=yonex"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Sports365",
        "price": 17490,
        "marketplace": "Flipkart",
        "url": "https://flipkart.com",
        "discount": "8%",
        "delivery": "4 days"
      }
    ]
  },
  {
    "id": "prod_51",
    "title": "Yonex Astrox 99 Pro",
    "modelName": "Yonex Astrox 99 Pro",
    "brand": "Yonex",
    "description": "Professional badminton racket. Rotational Generator System. Namd graphite. Head-heavy balance for power.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=yonex"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "ShopParva Sports",
        "price": 16790,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com",
        "discount": "11%",
        "delivery": "3 days"
      }
    ]
  }
];

function normalizeProduct(product) {
  if (!product) return product;

  const categories = Array.isArray(product.categories)
    ? product.categories
    : [product.category];

  const rating = typeof product.rating === 'string'
    ? Number(product.rating)
    : product.rating;

  const modelName = product.modelName || product.title;

  return { ...product, categories, rating, modelName };
}

function normalizeQuery(query) {
  // Remove noise words and normalize
  const noiseWords = ['buy', 'price', 'online', 'best', 'cheapest', 'deal', 'offer'];
  let normalized = query.toLowerCase().trim();
  
  noiseWords.forEach(word => {
    normalized = normalized.replace(new RegExp(`\\b${word}\\b`, 'gi'), '');
  });
  
  return normalized.trim().replace(/\s+/g, ' ');
}

function groupProductsByModel(products) {
  const grouped = {};
  
  products.forEach(product => {
    const modelName = product.modelName || product.title;
    if (!grouped[modelName]) {
      grouped[modelName] = {
        modelName: modelName,
        productId: product.id,
        brand: product.brand,
        category: product.category,
        rating: typeof product.rating === 'string' ? Number(product.rating) : product.rating,
        image: product.images && product.images.length > 0 ? product.images[0] : '',
        deals: []
      };
    }
    
    // Add each offer as a deal
    if (product.offers && product.offers.length > 0) {
      product.offers.forEach(offer => {
        grouped[modelName].deals.push({
          platform: offer.marketplace || 'Unknown',
          seller: offer.seller || 'Unknown',
          price: offer.price,
          url: offer.url || '',
          currency: '₹',
          discount: offer.discount || null,
          delivery: offer.delivery || null
        });
      });
    }
  });
  
  // Identify best price for each model and sort deals by price
  Object.values(grouped).forEach(model => {
    if (model.deals.length > 0) {
      // Sort deals by price (lowest first)
      model.deals.sort((a, b) => a.price - b.price);
      
      // Mark best price
      const minPrice = Math.min(...model.deals.map(d => d.price));
      model.deals.forEach(deal => {
        deal.isBestPrice = deal.price === minPrice;
      });
    }
  });
  
  return Object.values(grouped);
}

const server = http.createServer((req, res) => {
  // CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  const url = new URL(req.url, `http://${req.headers.host}`);
  const path = url.pathname;
  const method = req.method;

  if (path === '/api/v1/products/search') {
    const query = url.searchParams.get('q')?.toLowerCase() || '';
    const category = url.searchParams.get('category')?.toLowerCase() || '';
    
    const results = products
      .filter(p => {
        const matchesQuery = query === '' ||
          p.title.toLowerCase().includes(query) ||
          p.brand.toLowerCase().includes(query) ||
          p.category.toLowerCase().includes(query) ||
          (p.modelName && p.modelName.toLowerCase().includes(query));
          
        const matchesCategory = category === '' || 
          p.category.toLowerCase() === category;
          
        return matchesQuery && matchesCategory;
      })
      .map(normalizeProduct);
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(results));
  }

  else if (path === '/api/v1/search/compare') {
    const query = url.searchParams.get('q')?.toLowerCase() || '';
    const normalizedQuery = normalizeQuery(query);
    
    // Filter products matching query (search in title, brand, modelName)
    const matchedProducts = products.filter(p =>
      p.title.toLowerCase().includes(normalizedQuery) ||
      p.brand.toLowerCase().includes(normalizedQuery) ||
      (p.modelName && p.modelName.toLowerCase().includes(normalizedQuery)) ||
      p.category.toLowerCase().includes(normalizedQuery) ||
      p.description.toLowerCase().includes(normalizedQuery)
    );
    
    // Group by model and create comparison structure
    const comparisonResults = groupProductsByModel(matchedProducts);
    
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
      query: query,
      normalizedQuery: normalizedQuery,
      results: comparisonResults
    }));
  }

  else if (path === '/api/v1/products/compare') {
    const id = url.searchParams.get('id');
    const product = products.find(p => p.id === id);
    if (product) {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify(normalizeProduct(product)));
    } else {
      res.writeHead(404);
      res.end(JSON.stringify({ error: 'Not found' }));
    }
  }

  else if (method === 'POST' && path === '/api/v1/track') {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ success: true, message: 'Product tracked successfully' }));
  }

  else if (path.match(/^\/api\/v1\/products\/[^/]+$/)) {
      const id = path.split('/').pop();
      const product = products.find(p => p.id === id);
      if (product) {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(normalizeProduct(product)));
      } else {
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Product not found' }));
      }
  }

  else if (path === '/api/v1/kits/generate') {
    if (req.method === 'POST') {
      let body = '';
      req.on('data', chunk => body += chunk);
      req.on('end', () => {
        const { type, budget } = JSON.parse(body || '{}');
        const kitItems = products.slice(0, 5).map(normalizeProduct);
        const totalPrice = kitItems.reduce((sum, item) => sum + item.offers[0].price, 0);

        const kit = {
          id: "kit_" + Date.now(),
          name: `${type} Build`,
          budget: budget,
          items: kitItems,
          totalPrice: totalPrice
        };
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(kit));
      });
    }
  }

  else if (path === '/api/v1/user/profile') {
    const mockProfile = {
      id: "user_123",
      name: "Demo User",
      email: "demo@shopparva.com",
      preferences: {
        theme: "dark",
        notifications: true
      }
    };
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(mockProfile));
  }

  else if (path === '/api/v1/ar-assets') {
    const assets = [
      { id: "ar_1", type: "glasses", modelUrl: "/models/glasses.glb", preview: "/images/glasses_preview.png" }
    ];
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(assets));
  }

  else {
    res.writeHead(404);
    res.end('Not Found');
  }
});

const PORT = 3000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
