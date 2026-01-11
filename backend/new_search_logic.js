app.get('/api/v1/products/search', (req, res) => {
    const query = (req.query.q || '').toLowerCase().trim();
    const category = req.query.category;

    // Filter Params
    let brands = req.query.brands;
    if (brands && !Array.isArray(brands)) brands = [brands];

    let attributes = req.query.attributes;
    if (attributes && !Array.isArray(attributes)) attributes = [attributes];

    const minPrice = parseFloat(req.query.min_price) || 0;
    const maxPrice = parseFloat(req.query.max_price) || Number.MAX_VALUE;

    let filtered = products;

    // 1. Initial Filtering by Category
    if (category && category !== 'All') {
        const catLower = category.toLowerCase();
        if (catLower === 'laptop' || catLower === 'laptops') {
            filtered = filtered.filter(p =>
                (p.category === 'Electronics' || p.category === 'Computers' || p.category === 'Laptops') &&
                (p.title.toLowerCase().includes('laptop') || (p.description && p.description.toLowerCase().includes('laptop')))
            );
        } else if (catLower === 'phone' || catLower === 'smartphone' || catLower === 'mobiles' || catLower === 'mobiles') {
            filtered = filtered.filter(p =>
                (p.category === 'Electronics' || p.category === 'Mobiles' || p.category === 'Phones' || p.category === 'Smartphones' || p.category === 'Smart Phone') &&
                (p.title.toLowerCase().includes('phone') || p.title.toLowerCase().includes('mobile') || p.id.startsWith('ph_'))
            );
        } else {
            filtered = filtered.filter(p => p.category && p.category.toLowerCase() === catLower);
        }
    }

    // 2. Initial Filtering by Query string
    if (query) {
        const searchTerms = query.split(/\s+/).filter(t => t.length > 0);
        filtered = filtered.filter(p => {
            const searchStr = `${p.title} ${p.brand} ${p.modelName || p.title} ${p.description || ''} ${p.category || ''}`.toLowerCase();
            return searchTerms.every(term => searchStr.includes(term));
        });
    }

    // Store "Regular" results state before applying specific preference filters
    const regularResults = [...filtered];

    // 3. Apply Brand Filter
    if (brands && brands.length > 0) {
        const lowerBrands = brands.map(b => b.toLowerCase());
        filtered = filtered.filter(p => p.brand && lowerBrands.includes(p.brand.toLowerCase()));
    }

    // 4. Apply Attributes (Improved fuzzy matching for "AMOLED / OLED" styles)
    if (attributes && attributes.length > 0) {
        filtered = filtered.filter(p => {
            const pStr = JSON.stringify(p).toLowerCase();
            // Lenient: match ANY selected attribute preference
            return attributes.some(attr => {
                // Handle "AMOLED / OLED" or "12GB | 16GB" by splitting
                const parts = attr.toLowerCase().split(/\s*[\/|]\s*/).filter(s => s.length > 1);
                if (parts.length === 0) return pStr.includes(attr.toLowerCase());
                return parts.some(part => pStr.includes(part));
            });
        });
    }

    // 5. Fallback Logic: If preferences filtered out everything, show the regular query results
    if (filtered.length === 0 && regularResults.length > 0 && (brands?.length > 0 || attributes?.length > 0)) {
        console.log('No preference matches, falling back to regular search results');
        filtered = regularResults;
    }

    // 6. Price Filter (Final constraint)
    if (minPrice > 0 || maxPrice < Number.MAX_VALUE) {
        filtered = filtered.filter(p => {
            let price = p.price || 0;
            if (p.offers && p.offers.length > 0) price = p.offers[0].price;
            return price >= minPrice && price <= maxPrice;
        });
    }
