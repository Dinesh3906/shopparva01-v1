const http = require('http');

const products = [
  {
    "id": "prod_1",
    "title": "Dyson Electronics Item 1",
    "brand": "Dyson",
    "description": "This is a high-quality electronics product from Dyson. Great value for money.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=1"
    ],
    "rating": "4.4",
    "offers": [
      {
        "seller": "Official Store",
        "price": 475.24,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 522.76,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_2",
    "title": "Adidas Beauty Item 2",
    "brand": "Adidas",
    "description": "This is a high-quality beauty product from Adidas. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=2"
    ],
    "rating": "3.5",
    "offers": [
      {
        "seller": "Official Store",
        "price": 921.2,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 1013.32,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_3",
    "title": "Apple Electronics Item 3",
    "brand": "Apple",
    "description": "This is a high-quality electronics product from Apple. Great value for money.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=3"
    ],
    "rating": "4.4",
    "offers": [
      {
        "seller": "Official Store",
        "price": 478.66,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 526.53,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_4",
    "title": "Adidas Fashion Item 4",
    "brand": "Adidas",
    "description": "This is a high-quality fashion product from Adidas. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=4"
    ],
    "rating": "3.8",
    "offers": [
      {
        "seller": "Official Store",
        "price": 104.53,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 114.98,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_5",
    "title": "Nike Electronics Item 5",
    "brand": "Nike",
    "description": "This is a high-quality electronics product from Nike. Great value for money.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=5"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "Official Store",
        "price": 217.72,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 239.49,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_6",
    "title": "Adidas Fashion Item 6",
    "brand": "Adidas",
    "description": "This is a high-quality fashion product from Adidas. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=6"
    ],
    "rating": "4.9",
    "offers": [
      {
        "seller": "Official Store",
        "price": 736.69,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 810.36,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_7",
    "title": "Samsung Fashion Item 7",
    "brand": "Samsung",
    "description": "This is a high-quality fashion product from Samsung. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=7"
    ],
    "rating": "4.0",
    "offers": [
      {
        "seller": "Official Store",
        "price": 689.12,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 758.03,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_8",
    "title": "Nike Sports Item 8",
    "brand": "Nike",
    "description": "This is a high-quality sports product from Nike. Great value for money.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=8"
    ],
    "rating": "4.0",
    "offers": [
      {
        "seller": "Official Store",
        "price": 589.83,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 648.81,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_9",
    "title": "Samsung Home Item 9",
    "brand": "Samsung",
    "description": "This is a high-quality home product from Samsung. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=9"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "Official Store",
        "price": 892.86,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 982.15,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_10",
    "title": "Dyson Fashion Item 10",
    "brand": "Dyson",
    "description": "This is a high-quality fashion product from Dyson. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=10"
    ],
    "rating": "3.8",
    "offers": [
      {
        "seller": "Official Store",
        "price": 194.53,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 213.98,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_11",
    "title": "LG Beauty Item 11",
    "brand": "LG",
    "description": "This is a high-quality beauty product from LG. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=11"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "Official Store",
        "price": 955.74,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 1051.31,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_12",
    "title": "Samsung Home Item 12",
    "brand": "Samsung",
    "description": "This is a high-quality home product from Samsung. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=12"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Official Store",
        "price": 853,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 938.3,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_13",
    "title": "LG Home Item 13",
    "brand": "LG",
    "description": "This is a high-quality home product from LG. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=13"
    ],
    "rating": "3.7",
    "offers": [
      {
        "seller": "Official Store",
        "price": 993.82,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 1093.2,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_14",
    "title": "Adidas Beauty Item 14",
    "brand": "Adidas",
    "description": "This is a high-quality beauty product from Adidas. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=14"
    ],
    "rating": "3.9",
    "offers": [
      {
        "seller": "Official Store",
        "price": 593.08,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 652.39,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_15",
    "title": "LG Beauty Item 15",
    "brand": "LG",
    "description": "This is a high-quality beauty product from LG. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=15"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "Official Store",
        "price": 418.11,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 459.92,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_16",
    "title": "Adidas Electronics Item 16",
    "brand": "Adidas",
    "description": "This is a high-quality electronics product from Adidas. Great value for money.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=16"
    ],
    "rating": "4.1",
    "offers": [
      {
        "seller": "Official Store",
        "price": 151.04,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 166.14,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_17",
    "title": "Dyson Home Item 17",
    "brand": "Dyson",
    "description": "This is a high-quality home product from Dyson. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=17"
    ],
    "rating": "4.2",
    "offers": [
      {
        "seller": "Official Store",
        "price": 441.67,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 485.84,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_18",
    "title": "Sony Home Item 18",
    "brand": "Sony",
    "description": "This is a high-quality home product from Sony. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=18"
    ],
    "rating": "3.7",
    "offers": [
      {
        "seller": "Official Store",
        "price": 141.69,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 155.86,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_19",
    "title": "Nike Fashion Item 19",
    "brand": "Nike",
    "description": "This is a high-quality fashion product from Nike. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=19"
    ],
    "rating": "3.7",
    "offers": [
      {
        "seller": "Official Store",
        "price": 732.94,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 806.23,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_20",
    "title": "Apple Home Item 20",
    "brand": "Apple",
    "description": "This is a high-quality home product from Apple. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=20"
    ],
    "rating": "4.1",
    "offers": [
      {
        "seller": "Official Store",
        "price": 94.58,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 104.04,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_21",
    "title": "Samsung Beauty Item 21",
    "brand": "Samsung",
    "description": "This is a high-quality beauty product from Samsung. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=21"
    ],
    "rating": "4.3",
    "offers": [
      {
        "seller": "Official Store",
        "price": 416.84,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 458.52,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_22",
    "title": "Samsung Fashion Item 22",
    "brand": "Samsung",
    "description": "This is a high-quality fashion product from Samsung. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=22"
    ],
    "rating": "4.1",
    "offers": [
      {
        "seller": "Official Store",
        "price": 800.9,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 880.99,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_23",
    "title": "Apple Electronics Item 23",
    "brand": "Apple",
    "description": "This is a high-quality electronics product from Apple. Great value for money.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=23"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Official Store",
        "price": 529.97,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 582.97,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_24",
    "title": "LG Home Item 24",
    "brand": "LG",
    "description": "This is a high-quality home product from LG. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=24"
    ],
    "rating": "3.6",
    "offers": [
      {
        "seller": "Official Store",
        "price": 682.68,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 750.95,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_25",
    "title": "Dyson Sports Item 25",
    "brand": "Dyson",
    "description": "This is a high-quality sports product from Dyson. Great value for money.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=25"
    ],
    "rating": "3.2",
    "offers": [
      {
        "seller": "Official Store",
        "price": 611.3,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 672.43,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_26",
    "title": "Dyson Fashion Item 26",
    "brand": "Dyson",
    "description": "This is a high-quality fashion product from Dyson. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=26"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "Official Store",
        "price": 846.69,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 931.36,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_27",
    "title": "Samsung Sports Item 27",
    "brand": "Samsung",
    "description": "This is a high-quality sports product from Samsung. Great value for money.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=27"
    ],
    "rating": "3.1",
    "offers": [
      {
        "seller": "Official Store",
        "price": 126.41,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 139.05,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_28",
    "title": "Adidas Home Item 28",
    "brand": "Adidas",
    "description": "This is a high-quality home product from Adidas. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=28"
    ],
    "rating": "3.9",
    "offers": [
      {
        "seller": "Official Store",
        "price": 600.46,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 660.51,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_29",
    "title": "Adidas Fashion Item 29",
    "brand": "Adidas",
    "description": "This is a high-quality fashion product from Adidas. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=29"
    ],
    "rating": "3.8",
    "offers": [
      {
        "seller": "Official Store",
        "price": 297.84,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 327.62,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_30",
    "title": "Dyson Fashion Item 30",
    "brand": "Dyson",
    "description": "This is a high-quality fashion product from Dyson. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=30"
    ],
    "rating": "3.8",
    "offers": [
      {
        "seller": "Official Store",
        "price": 481.24,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 529.36,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_31",
    "title": "Samsung Fashion Item 31",
    "brand": "Samsung",
    "description": "This is a high-quality fashion product from Samsung. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=31"
    ],
    "rating": "4.8",
    "offers": [
      {
        "seller": "Official Store",
        "price": 654.66,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 720.13,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_32",
    "title": "Sony Home Item 32",
    "brand": "Sony",
    "description": "This is a high-quality home product from Sony. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=32"
    ],
    "rating": "3.2",
    "offers": [
      {
        "seller": "Official Store",
        "price": 382.9,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 421.19,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_33",
    "title": "Adidas Beauty Item 33",
    "brand": "Adidas",
    "description": "This is a high-quality beauty product from Adidas. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=33"
    ],
    "rating": "4.9",
    "offers": [
      {
        "seller": "Official Store",
        "price": 293.99,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 323.39,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_34",
    "title": "Samsung Beauty Item 34",
    "brand": "Samsung",
    "description": "This is a high-quality beauty product from Samsung. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=34"
    ],
    "rating": "4.9",
    "offers": [
      {
        "seller": "Official Store",
        "price": 576.88,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 634.57,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_35",
    "title": "Sony Fashion Item 35",
    "brand": "Sony",
    "description": "This is a high-quality fashion product from Sony. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=35"
    ],
    "rating": "4.0",
    "offers": [
      {
        "seller": "Official Store",
        "price": 677.4,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 745.14,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_36",
    "title": "Dyson Beauty Item 36",
    "brand": "Dyson",
    "description": "This is a high-quality beauty product from Dyson. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=36"
    ],
    "rating": "3.7",
    "offers": [
      {
        "seller": "Official Store",
        "price": 316.32,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 347.95,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_37",
    "title": "Sony Sports Item 37",
    "brand": "Sony",
    "description": "This is a high-quality sports product from Sony. Great value for money.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=37"
    ],
    "rating": "4.3",
    "offers": [
      {
        "seller": "Official Store",
        "price": 514.74,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 566.21,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_38",
    "title": "LG Fashion Item 38",
    "brand": "LG",
    "description": "This is a high-quality fashion product from LG. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=38"
    ],
    "rating": "3.2",
    "offers": [
      {
        "seller": "Official Store",
        "price": 647.76,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 712.54,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_39",
    "title": "LG Home Item 39",
    "brand": "LG",
    "description": "This is a high-quality home product from LG. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=39"
    ],
    "rating": "3.0",
    "offers": [
      {
        "seller": "Official Store",
        "price": 763.2,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 839.52,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_40",
    "title": "Dyson Electronics Item 40",
    "brand": "Dyson",
    "description": "This is a high-quality electronics product from Dyson. Great value for money.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=40"
    ],
    "rating": "4.9",
    "offers": [
      {
        "seller": "Official Store",
        "price": 806.84,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 887.52,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_41",
    "title": "LG Home Item 41",
    "brand": "LG",
    "description": "This is a high-quality home product from LG. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=41"
    ],
    "rating": "3.6",
    "offers": [
      {
        "seller": "Official Store",
        "price": 839.5,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 923.45,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_42",
    "title": "Apple Electronics Item 42",
    "brand": "Apple",
    "description": "This is a high-quality electronics product from Apple. Great value for money.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=42"
    ],
    "rating": "3.1",
    "offers": [
      {
        "seller": "Official Store",
        "price": 369.43,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 406.37,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_43",
    "title": "Apple Beauty Item 43",
    "brand": "Apple",
    "description": "This is a high-quality beauty product from Apple. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=43"
    ],
    "rating": "4.4",
    "offers": [
      {
        "seller": "Official Store",
        "price": 949.83,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 1044.81,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_44",
    "title": "Sony Home Item 44",
    "brand": "Sony",
    "description": "This is a high-quality home product from Sony. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=44"
    ],
    "rating": "3.6",
    "offers": [
      {
        "seller": "Official Store",
        "price": 128.96,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 141.86,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_45",
    "title": "Apple Beauty Item 45",
    "brand": "Apple",
    "description": "This is a high-quality beauty product from Apple. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=45"
    ],
    "rating": "4.9",
    "offers": [
      {
        "seller": "Official Store",
        "price": 854.55,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 940,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_46",
    "title": "Sony Sports Item 46",
    "brand": "Sony",
    "description": "This is a high-quality sports product from Sony. Great value for money.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=46"
    ],
    "rating": "4.4",
    "offers": [
      {
        "seller": "Official Store",
        "price": 850.79,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 935.87,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_47",
    "title": "Adidas Home Item 47",
    "brand": "Adidas",
    "description": "This is a high-quality home product from Adidas. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=47"
    ],
    "rating": "4.2",
    "offers": [
      {
        "seller": "Official Store",
        "price": 1031,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 1134.1,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_48",
    "title": "Samsung Fashion Item 48",
    "brand": "Samsung",
    "description": "This is a high-quality fashion product from Samsung. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=48"
    ],
    "rating": "3.1",
    "offers": [
      {
        "seller": "Official Store",
        "price": 731.7,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 804.87,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_49",
    "title": "Sony Fashion Item 49",
    "brand": "Sony",
    "description": "This is a high-quality fashion product from Sony. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=49"
    ],
    "rating": "5.0",
    "offers": [
      {
        "seller": "Official Store",
        "price": 335.56,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 369.12,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_50",
    "title": "Adidas Beauty Item 50",
    "brand": "Adidas",
    "description": "This is a high-quality beauty product from Adidas. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=50"
    ],
    "rating": "3.2",
    "offers": [
      {
        "seller": "Official Store",
        "price": 390.44,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 429.48,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_51",
    "title": "Nike Beauty Item 51",
    "brand": "Nike",
    "description": "This is a high-quality beauty product from Nike. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=51"
    ],
    "rating": "3.0",
    "offers": [
      {
        "seller": "Official Store",
        "price": 182.76,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 201.04,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_52",
    "title": "LG Sports Item 52",
    "brand": "LG",
    "description": "This is a high-quality sports product from LG. Great value for money.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=52"
    ],
    "rating": "4.0",
    "offers": [
      {
        "seller": "Official Store",
        "price": 127.92,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 140.71,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_53",
    "title": "Dyson Home Item 53",
    "brand": "Dyson",
    "description": "This is a high-quality home product from Dyson. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=53"
    ],
    "rating": "4.8",
    "offers": [
      {
        "seller": "Official Store",
        "price": 482.49,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 530.74,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_54",
    "title": "Apple Electronics Item 54",
    "brand": "Apple",
    "description": "This is a high-quality electronics product from Apple. Great value for money.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=54"
    ],
    "rating": "4.2",
    "offers": [
      {
        "seller": "Official Store",
        "price": 188.14,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 206.95,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_55",
    "title": "Samsung Fashion Item 55",
    "brand": "Samsung",
    "description": "This is a high-quality fashion product from Samsung. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=55"
    ],
    "rating": "4.1",
    "offers": [
      {
        "seller": "Official Store",
        "price": 1004.28,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 1104.71,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_56",
    "title": "LG Home Item 56",
    "brand": "LG",
    "description": "This is a high-quality home product from LG. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=56"
    ],
    "rating": "5.0",
    "offers": [
      {
        "seller": "Official Store",
        "price": 232.47,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 255.72,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_57",
    "title": "Adidas Sports Item 57",
    "brand": "Adidas",
    "description": "This is a high-quality sports product from Adidas. Great value for money.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=57"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "Official Store",
        "price": 452.09,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 497.3,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_58",
    "title": "Dyson Beauty Item 58",
    "brand": "Dyson",
    "description": "This is a high-quality beauty product from Dyson. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=58"
    ],
    "rating": "3.3",
    "offers": [
      {
        "seller": "Official Store",
        "price": 834.44,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 917.88,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_59",
    "title": "LG Sports Item 59",
    "brand": "LG",
    "description": "This is a high-quality sports product from LG. Great value for money.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=59"
    ],
    "rating": "4.1",
    "offers": [
      {
        "seller": "Official Store",
        "price": 916.22,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 1007.84,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_60",
    "title": "Samsung Home Item 60",
    "brand": "Samsung",
    "description": "This is a high-quality home product from Samsung. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=60"
    ],
    "rating": "4.0",
    "offers": [
      {
        "seller": "Official Store",
        "price": 707.92,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 778.71,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_61",
    "title": "Dyson Home Item 61",
    "brand": "Dyson",
    "description": "This is a high-quality home product from Dyson. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=61"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Official Store",
        "price": 733.04,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 806.34,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_62",
    "title": "Apple Home Item 62",
    "brand": "Apple",
    "description": "This is a high-quality home product from Apple. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=62"
    ],
    "rating": "3.9",
    "offers": [
      {
        "seller": "Official Store",
        "price": 936.05,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 1029.65,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_63",
    "title": "Dyson Beauty Item 63",
    "brand": "Dyson",
    "description": "This is a high-quality beauty product from Dyson. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=63"
    ],
    "rating": "3.5",
    "offers": [
      {
        "seller": "Official Store",
        "price": 189.23,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 208.15,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_64",
    "title": "Adidas Sports Item 64",
    "brand": "Adidas",
    "description": "This is a high-quality sports product from Adidas. Great value for money.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=64"
    ],
    "rating": "4.3",
    "offers": [
      {
        "seller": "Official Store",
        "price": 916.38,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 1008.02,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_65",
    "title": "Apple Beauty Item 65",
    "brand": "Apple",
    "description": "This is a high-quality beauty product from Apple. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=65"
    ],
    "rating": "4.1",
    "offers": [
      {
        "seller": "Official Store",
        "price": 836.63,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 920.29,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_66",
    "title": "Nike Home Item 66",
    "brand": "Nike",
    "description": "This is a high-quality home product from Nike. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=66"
    ],
    "rating": "3.3",
    "offers": [
      {
        "seller": "Official Store",
        "price": 561.24,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 617.36,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_67",
    "title": "Apple Beauty Item 67",
    "brand": "Apple",
    "description": "This is a high-quality beauty product from Apple. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=67"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "Official Store",
        "price": 973.19,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 1070.51,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_68",
    "title": "Dyson Sports Item 68",
    "brand": "Dyson",
    "description": "This is a high-quality sports product from Dyson. Great value for money.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=68"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Official Store",
        "price": 517.02,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 568.72,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_69",
    "title": "Nike Sports Item 69",
    "brand": "Nike",
    "description": "This is a high-quality sports product from Nike. Great value for money.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=69"
    ],
    "rating": "3.3",
    "offers": [
      {
        "seller": "Official Store",
        "price": 1016.09,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 1117.7,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_70",
    "title": "Nike Electronics Item 70",
    "brand": "Nike",
    "description": "This is a high-quality electronics product from Nike. Great value for money.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=70"
    ],
    "rating": "4.3",
    "offers": [
      {
        "seller": "Official Store",
        "price": 482.81,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 531.09,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_71",
    "title": "Samsung Beauty Item 71",
    "brand": "Samsung",
    "description": "This is a high-quality beauty product from Samsung. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=71"
    ],
    "rating": "4.7",
    "offers": [
      {
        "seller": "Official Store",
        "price": 817.09,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 898.8,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_72",
    "title": "Sony Fashion Item 72",
    "brand": "Sony",
    "description": "This is a high-quality fashion product from Sony. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=72"
    ],
    "rating": "4.2",
    "offers": [
      {
        "seller": "Official Store",
        "price": 153.37,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 168.71,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_73",
    "title": "Samsung Electronics Item 73",
    "brand": "Samsung",
    "description": "This is a high-quality electronics product from Samsung. Great value for money.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=73"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "Official Store",
        "price": 373.09,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 410.4,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_74",
    "title": "Samsung Beauty Item 74",
    "brand": "Samsung",
    "description": "This is a high-quality beauty product from Samsung. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=74"
    ],
    "rating": "4.3",
    "offers": [
      {
        "seller": "Official Store",
        "price": 413.34,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 454.67,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_75",
    "title": "Sony Sports Item 75",
    "brand": "Sony",
    "description": "This is a high-quality sports product from Sony. Great value for money.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=75"
    ],
    "rating": "5.0",
    "offers": [
      {
        "seller": "Official Store",
        "price": 166.78,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 183.46,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_76",
    "title": "Adidas Electronics Item 76",
    "brand": "Adidas",
    "description": "This is a high-quality electronics product from Adidas. Great value for money.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=76"
    ],
    "rating": "4.6",
    "offers": [
      {
        "seller": "Official Store",
        "price": 118.07,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 129.88,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_77",
    "title": "Nike Home Item 77",
    "brand": "Nike",
    "description": "This is a high-quality home product from Nike. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=77"
    ],
    "rating": "4.3",
    "offers": [
      {
        "seller": "Official Store",
        "price": 636.86,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 700.55,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_78",
    "title": "Adidas Fashion Item 78",
    "brand": "Adidas",
    "description": "This is a high-quality fashion product from Adidas. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=78"
    ],
    "rating": "4.1",
    "offers": [
      {
        "seller": "Official Store",
        "price": 205.26,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 225.79,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_79",
    "title": "Nike Home Item 79",
    "brand": "Nike",
    "description": "This is a high-quality home product from Nike. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=79"
    ],
    "rating": "3.5",
    "offers": [
      {
        "seller": "Official Store",
        "price": 806.75,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 887.43,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_80",
    "title": "Samsung Fashion Item 80",
    "brand": "Samsung",
    "description": "This is a high-quality fashion product from Samsung. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=80"
    ],
    "rating": "4.8",
    "offers": [
      {
        "seller": "Official Store",
        "price": 1023.68,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 1126.05,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_81",
    "title": "Nike Electronics Item 81",
    "brand": "Nike",
    "description": "This is a high-quality electronics product from Nike. Great value for money.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=81"
    ],
    "rating": "3.4",
    "offers": [
      {
        "seller": "Official Store",
        "price": 733.19,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 806.51,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_82",
    "title": "Dyson Beauty Item 82",
    "brand": "Dyson",
    "description": "This is a high-quality beauty product from Dyson. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=82"
    ],
    "rating": "3.7",
    "offers": [
      {
        "seller": "Official Store",
        "price": 329.63,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 362.59,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_83",
    "title": "Dyson Home Item 83",
    "brand": "Dyson",
    "description": "This is a high-quality home product from Dyson. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=83"
    ],
    "rating": "3.4",
    "offers": [
      {
        "seller": "Official Store",
        "price": 346.54,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 381.19,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_84",
    "title": "Dyson Fashion Item 84",
    "brand": "Dyson",
    "description": "This is a high-quality fashion product from Dyson. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=84"
    ],
    "rating": "4.9",
    "offers": [
      {
        "seller": "Official Store",
        "price": 307.8,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 338.58,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_85",
    "title": "Apple Beauty Item 85",
    "brand": "Apple",
    "description": "This is a high-quality beauty product from Apple. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=85"
    ],
    "rating": "3.8",
    "offers": [
      {
        "seller": "Official Store",
        "price": 252.05,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 277.26,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_86",
    "title": "Sony Sports Item 86",
    "brand": "Sony",
    "description": "This is a high-quality sports product from Sony. Great value for money.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=86"
    ],
    "rating": "3.7",
    "offers": [
      {
        "seller": "Official Store",
        "price": 547.19,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 601.91,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_87",
    "title": "LG Home Item 87",
    "brand": "LG",
    "description": "This is a high-quality home product from LG. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=87"
    ],
    "rating": "3.6",
    "offers": [
      {
        "seller": "Official Store",
        "price": 674.28,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 741.71,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_88",
    "title": "Nike Home Item 88",
    "brand": "Nike",
    "description": "This is a high-quality home product from Nike. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=88"
    ],
    "rating": "4.0",
    "offers": [
      {
        "seller": "Official Store",
        "price": 693.37,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 762.71,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_89",
    "title": "Adidas Electronics Item 89",
    "brand": "Adidas",
    "description": "This is a high-quality electronics product from Adidas. Great value for money.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=89"
    ],
    "rating": "4.8",
    "offers": [
      {
        "seller": "Official Store",
        "price": 591.77,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 650.95,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_90",
    "title": "Nike Fashion Item 90",
    "brand": "Nike",
    "description": "This is a high-quality fashion product from Nike. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=90"
    ],
    "rating": "5.0",
    "offers": [
      {
        "seller": "Official Store",
        "price": 280.5,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 308.55,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_91",
    "title": "Nike Electronics Item 91",
    "brand": "Nike",
    "description": "This is a high-quality electronics product from Nike. Great value for money.",
    "category": "Electronics",
    "images": [
      "https://picsum.photos/400?random=91"
    ],
    "rating": "3.2",
    "offers": [
      {
        "seller": "Official Store",
        "price": 860.16,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 946.18,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_92",
    "title": "LG Sports Item 92",
    "brand": "LG",
    "description": "This is a high-quality sports product from LG. Great value for money.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=92"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "Official Store",
        "price": 543.7,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 598.07,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_93",
    "title": "Dyson Fashion Item 93",
    "brand": "Dyson",
    "description": "This is a high-quality fashion product from Dyson. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=93"
    ],
    "rating": "3.4",
    "offers": [
      {
        "seller": "Official Store",
        "price": 598.47,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 658.32,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_94",
    "title": "Adidas Beauty Item 94",
    "brand": "Adidas",
    "description": "This is a high-quality beauty product from Adidas. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=94"
    ],
    "rating": "3.1",
    "offers": [
      {
        "seller": "Official Store",
        "price": 627.67,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 690.44,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_95",
    "title": "LG Sports Item 95",
    "brand": "LG",
    "description": "This is a high-quality sports product from LG. Great value for money.",
    "category": "Sports",
    "images": [
      "https://picsum.photos/400?random=95"
    ],
    "rating": "4.0",
    "offers": [
      {
        "seller": "Official Store",
        "price": 687.66,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 756.43,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_96",
    "title": "Dyson Home Item 96",
    "brand": "Dyson",
    "description": "This is a high-quality home product from Dyson. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=96"
    ],
    "rating": "4.5",
    "offers": [
      {
        "seller": "Official Store",
        "price": 899.47,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 989.42,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_97",
    "title": "Sony Home Item 97",
    "brand": "Sony",
    "description": "This is a high-quality home product from Sony. Great value for money.",
    "category": "Home",
    "images": [
      "https://picsum.photos/400?random=97"
    ],
    "rating": "3.7",
    "offers": [
      {
        "seller": "Official Store",
        "price": 659.74,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 725.71,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_98",
    "title": "Samsung Beauty Item 98",
    "brand": "Samsung",
    "description": "This is a high-quality beauty product from Samsung. Great value for money.",
    "category": "Beauty",
    "images": [
      "https://picsum.photos/400?random=98"
    ],
    "rating": "4.4",
    "offers": [
      {
        "seller": "Official Store",
        "price": 658.73,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 724.6,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_99",
    "title": "Nike Fashion Item 99",
    "brand": "Nike",
    "description": "This is a high-quality fashion product from Nike. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=99"
    ],
    "rating": "3.7",
    "offers": [
      {
        "seller": "Official Store",
        "price": 1014.27,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 1115.7,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
      }
    ]
  },
  {
    "id": "prod_100",
    "title": "Nike Fashion Item 100",
    "brand": "Nike",
    "description": "This is a high-quality fashion product from Nike. Great value for money.",
    "category": "Fashion",
    "images": [
      "https://picsum.photos/400?random=100"
    ],
    "rating": "4.0",
    "offers": [
      {
        "seller": "Official Store",
        "price": 629.13,
        "marketplace": "ShopParva",
        "url": "https://shopparva.com"
      },
      {
        "seller": "Competitor A",
        "price": 692.04,
        "marketplace": "Amazon",
        "url": "https://amazon.com"
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

  return { ...product, categories, rating };
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

  if (path === '/api/v1/products/search') {
    const query = url.searchParams.get('q')?.toLowerCase() || '';
    const results = products
      .filter(p =>
        p.title.toLowerCase().includes(query) ||
        p.brand.toLowerCase().includes(query) ||
        p.category.toLowerCase().includes(query)
      )
      .map(normalizeProduct);
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(results));
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

  else if (path === '/api/v1/kits/generate') {
    if (req.method === 'POST') {
      let body = '';
      req.on('data', chunk => body += chunk);
      req.on('end', () => {
        const { type, budget } = JSON.parse(body || '{}');
        // Mock generation: pick random items fitting budget
        const kitItems = products.slice(0, 5).map(normalizeProduct); // Just pick first 5 for demo
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
    // Mock AR assets response
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
