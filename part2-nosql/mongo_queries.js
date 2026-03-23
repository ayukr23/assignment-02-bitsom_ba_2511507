use("ecommerce_db");
 
 
// OP1: insertMany() — insert all 3 documents from sample_documents.json
// Inserts all 5 product documents (Electronics x2, Clothing x1, Groceries x2)
// into the 'products' collection in one atomic batch operation.
 
db.products.insertMany([
  {
    "_id": "ELEC001",
    "product_id": "ELEC001",
    "name": "Samsung 55-inch 4K Smart TV",
    "category": "Electronics",
    "brand": "Samsung",
    "price": 55000,
    "stock_quantity": 30,
    "availability": true,
    "specifications": {
      "display": {
        "screen_size_inches": 55,
        "resolution": "3840x2160",
        "panel_type": "QLED",
        "refresh_rate_hz": 120
      },
      "connectivity": ["HDMI", "USB 3.0", "Wi-Fi", "Bluetooth 5.0", "ARC"],
      "smart_features": {
        "os": "Tizen OS",
        "voice_assistant": ["Bixby", "Alexa", "Google Assistant"],
        "screen_mirroring": true
      },
      "power": { "voltage": "220-240V", "wattage": 120 }
    },
    "warranty": {
      "duration_years": 2,
      "type": "Comprehensive",
      "service_center": "Samsung Authorized Service"
    },
    "ratings": { "average": 4.5, "total_reviews": 1240 },
    "tags": ["4K", "Smart TV", "QLED", "Samsung"],
    "added_date": new Date("2024-01-15")
  },
  {
    "_id": "CLTH001",
    "product_id": "CLTH001",
    "name": "Men's Slim Fit Formal Shirt",
    "category": "Clothing",
    "brand": "Arrow",
    "price": 1899,
    "stock_quantity": 150,
    "availability": true,
    "specifications": {
      "material": "60% Cotton, 40% Polyester",
      "fit_type": "Slim Fit",
      "collar_type": "Spread Collar",
      "sleeve": "Full Sleeve",
      "care_instructions": ["Machine Wash Cold", "Do Not Bleach", "Tumble Dry Low"],
      "sizes_available": ["S", "M", "L", "XL", "XXL"],
      "colors_available": [
        { "color": "White", "hex_code": "#FFFFFF", "stock": 50 },
        { "color": "Light Blue", "hex_code": "#ADD8E6", "stock": 60 },
        { "color": "Charcoal", "hex_code": "#36454F", "stock": 40 }
      ],
      "gender": "Men",
      "occasion": ["Formal", "Business", "Office"]
    },
    "warranty": { "duration_years": 0, "type": "No Warranty", "return_policy_days": 30 },
    "ratings": { "average": 4.2, "total_reviews": 832 },
    "tags": ["formal", "shirt", "slim fit", "Arrow", "office wear"],
    "added_date": new Date("2024-02-10")
  },
  {
    "_id": "GROC001",
    "product_id": "GROC001",
    "name": "Organic Whole Wheat Flour (5kg)",
    "category": "Groceries",
    "brand": "Aashirvaad",
    "price": 320,
    "stock_quantity": 500,
    "availability": true,
    "specifications": {
      "weight_kg": 5,
      "pack_type": "Sealed Bag",
      "organic_certified": true,
      "nutritional_info": {
        "serving_size_g": 100,
        "calories": 340,
        "total_fat_g": 1.9,
        "carbohydrates_g": 71.2,
        "protein_g": 12.1,
        "fiber_g": 10.7,
        "sodium_mg": 2
      },
      "allergens": ["Gluten", "Wheat"],
      "storage_instructions": "Store in a cool, dry place.",
      "country_of_origin": "India"
    },
    "expiry": {
      "manufactured_date": new Date("2024-10-01"),
      "expiry_date": new Date("2025-09-30"),
      "shelf_life_months": 12
    },
    "certifications": ["FSSAI Approved", "Organic India Certified", "ISO 22000"],
    "ratings": { "average": 4.7, "total_reviews": 3540 },
    "tags": ["organic", "wheat flour", "atta", "whole wheat", "healthy"],
    "added_date": new Date("2024-10-05")
  },
  {
    "_id": "ELEC002",
    "product_id": "ELEC002",
    "name": "Sony WH-1000XM5 Noise Cancelling Headphones",
    "category": "Electronics",
    "brand": "Sony",
    "price": 29990,
    "stock_quantity": 85,
    "availability": true,
    "specifications": {
      "type": "Over-Ear",
      "connectivity": ["Bluetooth 5.2", "3.5mm Jack", "USB-C"],
      "noise_cancellation": {
        "type": "Active Noise Cancellation",
        "levels": ["Light", "Medium", "Strong", "Adaptive"]
      },
      "battery": { "life_hours": 30, "quick_charge": true, "charge_time_minutes": 180 },
      "audio": { "driver_size_mm": 30, "frequency_response": "4Hz - 40kHz", "impedance_ohms": 48 },
      "power": { "voltage": "5V DC via USB-C", "wattage": 3 },
      "weight_grams": 250,
      "foldable": true
    },
    "warranty": {
      "duration_years": 1,
      "type": "Manufacturer Warranty",
      "service_center": "Sony Service Centre"
    },
    "ratings": { "average": 4.8, "total_reviews": 2105 },
    "tags": ["headphones", "noise cancelling", "Sony", "wireless", "premium audio"],
    "added_date": new Date("2024-03-20")
  },
  {
    "_id": "GROC002",
    "product_id": "GROC002",
    "name": "Tropicana Orange Juice 1L (Pack of 6)",
    "category": "Groceries",
    "brand": "Tropicana",
    "price": 540,
    "stock_quantity": 200,
    "availability": true,
    "specifications": {
      "volume_ml": 1000,
      "pack_size": 6,
      "juice_type": "100% Pure Juice",
      "no_added_sugar": true,
      "nutritional_info": {
        "serving_size_ml": 200,
        "calories": 90,
        "total_fat_g": 0,
        "carbohydrates_g": 21,
        "sugars_g": 18,
        "protein_g": 1.2,
        "vitamin_c_mg": 50
      },
      "allergens": [],
      "storage_instructions": "Refrigerate after opening. Consume within 5 days.",
      "country_of_origin": "India"
    },
    "expiry": {
      "manufactured_date": new Date("2024-09-01"),
      "expiry_date": new Date("2024-12-31"),
      "shelf_life_months": 4
    },
    "certifications": ["FSSAI Approved"],
    "ratings": { "average": 4.3, "total_reviews": 1870 },
    "tags": ["juice", "orange", "Tropicana", "no added sugar", "breakfast"],
    "added_date": new Date("2024-09-10")
  }
]);
 
 
// OP2: find() — retrieve all Electronics products with price > 20000
// Filters documents where category is "Electronics" AND price is greater than 20000.
// Returns: Samsung Smart TV (₹55,000) and Sony Headphones (₹29,990)
 
db.products.find(
  {
    category: "Electronics",
    price: { $gt: 20000 }
  },
  {
    product_id: 1,
    name: 1,
    brand: 1,
    price: 1,
    category: 1,
    _id: 0
  }
);
 
 
// OP3: find() — retrieve all Groceries expiring before 2025-01-01
// Uses dot notation to query the nested "expiry.expiry_date" field.
// Returns: Tropicana Orange Juice (expires 2024-12-31)
 
db.products.find(
  {
    category: "Groceries",
    "expiry.expiry_date": { $lt: new Date("2025-01-01") }
  },
  {
    product_id: 1,
    name: 1,
    brand: 1,
    "expiry.expiry_date": 1,
    price: 1,
    _id: 0
  }
);
 
 
// OP4: updateOne() — add a "discount_percent" field to a specific product
// Adds discount_percent: 10 to the Samsung Smart TV (ELEC001)
// using $set operator — does not overwrite the rest of the document.
 
db.products.updateOne(
  { product_id: "ELEC001" },
  {
    $set: {
      discount_percent: 10,
      discounted_price: 49500
    }
  }
);
 
// Verify the update was applied:
db.products.findOne(
  { product_id: "ELEC001" },
  { name: 1, price: 1, discount_percent: 1, discounted_price: 1, _id: 0 }
);
 
 
// OP5: createIndex() — create an index on the category field and explain why
// WHY: The most frequent query pattern in a product catalogue is filtering by category.
// Without an index, MongoDB performs a full collection scan (O(n)) on every category query.
// With this index, lookups like find({ category: "Electronics" }) use a B-tree index O(log n),
// dramatically improving performance as the catalogue grows to millions of products.
 
db.products.createIndex(
  { category: 1 },
  {
    name: "idx_category",
    background: true
  }
);
