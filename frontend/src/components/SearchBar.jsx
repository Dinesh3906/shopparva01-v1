import React from 'react';

export default function SearchBar({ query, onQueryChange, onSubmit }) {
  const handleKeyDown = (e) => {
    if (e.key === 'Enter') {
      e.preventDefault();
      onSubmit?.();
    }
  };

  return (
    <section aria-label="Product search" style={{ marginBottom: 18 }}>
      <div
        className="card-surface"
        style={{
          padding: 12,
          borderRadius: 999,
          display: 'flex',
          alignItems: 'center',
          gap: 12,
          background:
            'linear-gradient(135deg, rgba(15,163,177,0.22), transparent 50%), #050608',
        }}
      >
        <button
          type="button"
          aria-label="Search"
          style={{
            borderRadius: 999,
            border: 'none',
            background: 'rgba(15,163,177,0.14)',
            width: 36,
            height: 36,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: '#e0fbff',
          }}
        >
          <span aria-hidden="true">🔍</span>
        </button>
        <input
          aria-label="Search products"
          placeholder="Search laptops, brands, tags…"
          value={query}
          onChange={(e) => onQueryChange?.(e.target.value)}
          onKeyDown={handleKeyDown}
          style={{
            flex: 1,
            border: 'none',
            outline: 'none',
            background: 'transparent',
            color: 'var(--text)',
            fontSize: 15,
          }}
        />
        <button
          type="button"
          aria-label="Voice search (placeholder)"
          style={{
            borderRadius: 999,
            border: '1px solid rgba(15,163,177,0.5)',
            background:
              'radial-gradient(circle at 0 0, rgba(15,163,177,0.4), transparent 55%), #020308',
            width: 40,
            height: 40,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: '#e0fbff',
            boxShadow: '0 10px 25px rgba(0,0,0,0.65)',
          }}
        >
          <span aria-hidden="true">🎙️</span>
        </button>
      </div>
    </section>
  );
}
