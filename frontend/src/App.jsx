import React, { useCallback, useEffect, useMemo, useState } from 'react';
import SearchBar from './components/SearchBar.jsx';
import ProductList from './components/ProductList.jsx';
import FiltersPanel from './components/FiltersPanel.jsx';
import EmptyState from './components/EmptyState.jsx';

const initialFilters = {
  brand: '',
  priceRange: '', // 'under500' | '500-1000' | 'above1000'
  performance: {
    i5: false,
    i7: false,
    gpu: false,
    ssd: false,
  },
  usage: {
    Gaming: false,
    'Office Work': false,
    Student: false,
    Programming: false,
  },
};

function buildQueryParams(searchTerm, filters) {
  const params = new URLSearchParams();

  if (searchTerm) {
    params.set('q', searchTerm);
  }

  if (filters.brand) {
    params.set('brand', filters.brand);
  }

  if (filters.priceRange === 'under500') {
    params.set('priceMax', '499');
  } else if (filters.priceRange === '500-1000') {
    params.set('priceMin', '500');
    params.set('priceMax', '1000');
  } else if (filters.priceRange === 'above1000') {
    params.set('priceMin', '1001');
  }

  // category param could be wired to usage chips if your dataset supported it
  return params;
}

function applyClientSideFilters(products, filters) {
  let results = [...products];

  const activePerf = Object.entries(filters.performance)
    .filter(([, active]) => active)
    .map(([key]) => key);

  if (activePerf.length > 0) {
    results = results.filter((p) => {
      const tags = (p.tags || []).map((t) => t.toLowerCase());
      return activePerf.every((flag) => {
        if (flag === 'gpu') return tags.includes('dedicated gpu'.toLowerCase());
        if (flag === 'ssd') return tags.some((t) => t.includes('ssd'));
        return tags.includes(flag);
      });
    });
  }

  const activeUsage = Object.entries(filters.usage)
    .filter(([, active]) => active)
    .map(([label]) => label.toLowerCase());

  if (activeUsage.length > 0) {
    results = results.filter((p) => {
      const tags = (p.tags || []).map((t) => t.toLowerCase());
      const cat = (p.category || '').toLowerCase();
      return activeUsage.every((label) => tags.includes(label) || cat.includes(label));
    });
  }

  return results;
}

export default function App() {
  const [products, setProducts] = useState([]);
  const [rawCount, setRawCount] = useState(0);
  const [query, setQuery] = useState('');
  const [appliedQuery, setAppliedQuery] = useState('');
  const [filters, setFilters] = useState(initialFilters);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [recentSearches, setRecentSearches] = useState([]);

  const debouncedQuery = useDebouncedValue(query, 300);

  const visibleProducts = useMemo(
    () => applyClientSideFilters(products, filters),
    [products, filters]
  );

  const fetchProducts = useCallback(
    async (opts = {}) => {
      const searchTerm = opts.searchTerm ?? debouncedQuery ?? '';
      const useFilters = opts.filters ?? filters;

      setLoading(true);
      setError(null);

      try {
        const params = buildQueryParams(searchTerm, useFilters);
        const url = params.toString() ? `/products?${params.toString()}` : '/products';
        const response = await fetch(url);

        if (!response.ok) {
          throw new Error('Network response was not ok');
        }

        const payload = await response.json();
        const results = Array.isArray(payload.results) ? payload.results : payload;

        setProducts(results);
        setRawCount(payload.count ?? results.length);

        if (searchTerm) {
          setAppliedQuery(searchTerm);
          setRecentSearches((prev) => {
            const next = [searchTerm, ...prev.filter((term) => term !== searchTerm)];
            return next.slice(0, 6);
          });
        } else {
          setAppliedQuery('');
        }
      } catch (err) {
        console.error(err);
        setError('Could not load products.');
      } finally {
        setLoading(false);
      }
    },
    [debouncedQuery, filters]
  );

  // Initial load
  useEffect(() => {
    fetchProducts({ searchTerm: '', filters: initialFilters });
  }, [fetchProducts]);

  // Debounced search
  useEffect(() => {
    if (query === '') {
      // Reset to default listing
      fetchProducts({ searchTerm: '', filters });
      return;
    }
    fetchProducts({ searchTerm: query, filters });
  }, [debouncedQuery]);

  const handleApplyFilters = () => {
    fetchProducts({ searchTerm: query, filters });
  };

  const handleClearAll = () => {
    setQuery('');
    setFilters(initialFilters);
    fetchProducts({ searchTerm: '', filters: initialFilters });
  };

  const handleSuggestedSearch = (term) => {
    setQuery(term);
  };

  const handleRetry = () => {
    fetchProducts({ searchTerm: query, filters });
  };

  const hasResults = !loading && !error && visibleProducts.length > 0;

  return (
    <div className="app-shell">
      <header style={{ marginBottom: 12 }}>
        <p
          style={{
            margin: 0,
            fontSize: 12,
            textTransform: 'uppercase',
            letterSpacing: 2,
            color: 'var(--text-muted)',
          }}
        >
          Product search
        </p>
        <h1
          style={{
            margin: '4px 0 0 0',
            fontSize: 24,
          }}
        >
          Compare laptop deals across stores
        </h1>
      </header>

      <SearchBar
        query={query}
        onQueryChange={setQuery}
        onSubmit={() => fetchProducts({ searchTerm: query, filters })}
      />

      {appliedQuery && hasResults && (
        <div
          aria-live="polite"
          style={{
            marginBottom: 12,
            fontSize: 13,
            color: 'var(--text-muted)',
          }}
        >
          Showing results for <span style={{ color: '#e0fbff' }}>&quot;{appliedQuery}&quot;</span>
        </div>
      )}

      <main className="app-layout">
        <FiltersPanel
          filters={filters}
          onFiltersChange={setFilters}
          onApply={handleApplyFilters}
          onClear={handleClearAll}
        />

        <section aria-label="Product results" style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
          {error && (
            <div
              className="card-surface"
              style={{
                padding: 12,
                border: '1px solid rgba(248,113,113,0.6)',
                background:
                  'linear-gradient(135deg, rgba(248,113,113,0.18), rgba(15,15,18,0.9))',
                fontSize: 13,
              }}
            >
              <span>{error} </span>
              <button
                type="button"
                onClick={handleRetry}
                style={{
                  marginLeft: 8,
                  border: 'none',
                  background: 'transparent',
                  color: '#fee2e2',
                  textDecoration: 'underline',
                  cursor: 'pointer',
                }}
              >
                Retry
              </button>
            </div>
          )}

          {hasResults && (
            <>
              <div
                style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  fontSize: 12,
                  color: 'var(--text-muted)',
                }}
              >
                <span>
                  {rawCount} result{rawCount === 1 ? '' : 's'} found
                </span>
                {recentSearches.length > 0 && (
                  <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                    <span style={{ fontSize: 11, textTransform: 'uppercase', letterSpacing: 1 }}>
                      Recent
                    </span>
                    <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
                      {recentSearches.slice(0, 3).map((term) => (
                        <button
                          key={term}
                          type="button"
                          className="pill-button"
                          onClick={() => handleSuggestedSearch(term)}
                        >
                          {term}
                        </button>
                      ))}
                    </div>
                  </div>
                )}
              </div>

              <ProductList
                products={visibleProducts}
                query={appliedQuery}
                loading={loading}
                onCardClick={(product) => {
                  // Placeholder detail navigation
                  alert(`Open detail view for ${product.title}`);
                }}
              />
            </>
          )}

          {!hasResults && !loading && !error && (
            <EmptyState
              onChipClick={handleSuggestedSearch}
              onClearFilters={handleClearAll}
              recentSearches={recentSearches}
            />
          )}
        </section>
      </main>
    </div>
  );
}

function useDebouncedValue(value, delay) {
  const [debounced, setDebounced] = useState(value);

  useEffect(() => {
    const id = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(id);
  }, [value, delay]);

  return debounced;
}
