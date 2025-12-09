import React from 'react';

const BRANDS = ['HP', 'Dell', 'Lenovo', 'Apple', 'ASUS'];

const PRICE_RANGES = [
  { id: 'under500', label: 'Under $500' },
  { id: '500-1000', label: '$500 - $1000' },
  { id: 'above1000', label: 'Above $1000' },
];

const PERFORMANCE = [
  { id: 'i5', label: 'Intel i5' },
  { id: 'i7', label: 'Intel i7' },
  { id: 'gpu', label: 'Dedicated GPU' },
  { id: 'ssd', label: 'SSD Storage' },
];

const USAGE = ['Gaming', 'Office Work', 'Student', 'Programming'];

export default function FiltersPanel({ filters, onFiltersChange, onApply, onClear }) {
  const update = (partial) => {
    onFiltersChange?.({ ...filters, ...partial });
  };

  const togglePerformance = (id) => {
    update({
      performance: {
        ...filters.performance,
        [id]: !filters.performance[id],
      },
    });
  };

  const toggleUsage = (label) => {
    update({
      usage: {
        ...filters.usage,
        [label]: !filters.usage[label],
      },
    });
  };

  return (
    <aside
      className="card-surface"
      style={{
        padding: 16,
        position: 'sticky',
        top: 16,
        alignSelf: 'flex-start',
        maxHeight: 'calc(100vh - 80px)',
        overflowY: 'auto',
      }}
      aria-label="Filter products"
    >
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h2 style={{ margin: 0, fontSize: 15 }}>Preferences</h2>
        <button
          type="button"
          onClick={onClear}
          style={{
            border: 'none',
            background: 'transparent',
            color: 'var(--text-muted)',
            fontSize: 12,
            textDecoration: 'underline',
            cursor: 'pointer',
          }}
        >
          Clear
        </button>
      </div>

      <section style={{ marginTop: 14 }} aria-label="Filter by brand">
        <p style={{ margin: '0 0 6px 0', fontSize: 13, color: 'var(--text-muted)' }}>Brand</p>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
          {BRANDS.map((brand) => {
            const active = filters.brand === brand;
            return (
              <button
                key={brand}
                type="button"
                className={`pill-button ${active ? 'teal' : ''}`}
                aria-pressed={active}
                onClick={() => update({ brand: active ? '' : brand })}
              >
                {brand}
              </button>
            );
          })}
        </div>
      </section>

      <section style={{ marginTop: 18 }} aria-label="Filter by price range">
        <p style={{ margin: '0 0 6px 0', fontSize: 13, color: 'var(--text-muted)' }}>Price range</p>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
          {PRICE_RANGES.map((range) => {
            const active = filters.priceRange === range.id;
            return (
              <label
                key={range.id}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: 8,
                  fontSize: 13,
                  cursor: 'pointer',
                }}
              >
                <input
                  type="radio"
                  name="price-range"
                  checked={active}
                  onChange={() => update({ priceRange: range.id })}
                />
                <span>{range.label}</span>
              </label>
            );
          })}
          <label
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: 8,
              fontSize: 13,
              cursor: 'pointer',
            }}
          >
            <input
              type="radio"
              name="price-range"
              checked={!filters.priceRange}
              onChange={() => update({ priceRange: '' })}
            />
            <span>Any price</span>
          </label>
        </div>
      </section>

      <section style={{ marginTop: 18 }} aria-label="Filter by performance">
        <p style={{ margin: '0 0 6px 0', fontSize: 13, color: 'var(--text-muted)' }}>Performance</p>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
          {PERFORMANCE.map((item) => {
            const active = !!filters.performance[item.id];
            return (
              <label
                key={item.id}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: 8,
                  fontSize: 13,
                  cursor: 'pointer',
                }}
              >
                <input
                  type="checkbox"
                  checked={active}
                  onChange={() => togglePerformance(item.id)}
                />
                <span>{item.label}</span>
              </label>
            );
          })}
        </div>
      </section>

      <section style={{ marginTop: 18 }} aria-label="Filter by usage type">
        <p style={{ margin: '0 0 6px 0', fontSize: 13, color: 'var(--text-muted)' }}>Usage type</p>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
          {USAGE.map((label) => {
            const active = !!filters.usage[label];
            return (
              <button
                key={label}
                type="button"
                className={`pill-button ${active ? 'teal' : ''}`}
                aria-pressed={active}
                onClick={() => toggleUsage(label)}
              >
                {label}
              </button>
            );
          })}
        </div>
      </section>

      <button
        type="button"
        onClick={onApply}
        style={{
          marginTop: 20,
          width: '100%',
          padding: '8px 14px',
          borderRadius: 999,
          border: 'none',
          background:
            'linear-gradient(135deg, #0fa3b1, #18c4d4)',
          color: '#051014',
          fontSize: 14,
          fontWeight: 600,
          cursor: 'pointer',
          boxShadow: '0 15px 35px rgba(15,163,177,0.6)',
        }}
        aria-label="Apply selected filters"
      >
        Apply filters
      </button>
    </aside>
  );
}
