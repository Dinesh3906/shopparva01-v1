import React from 'react';

function renderHighlightedTitle(title, query) {
  if (!query) return title;
  const lower = title.toLowerCase();
  const q = query.toLowerCase();
  const parts = [];

  let cursor = 0;
  let index = lower.indexOf(q);

  while (index !== -1) {
    if (index > cursor) {
      parts.push(title.slice(cursor, index));
    }
    parts.push(
      <mark
        key={`${index}-${q}`}
        style={{
          background: 'rgba(15,163,177,0.3)',
          color: 'inherit',
          padding: '0 1px',
          borderRadius: 3,
        }}
      >
        {title.slice(index, index + q.length)}
      </mark>
    );
    cursor = index + q.length;
    index = lower.indexOf(q, cursor);
  }

  if (cursor < title.length) {
    parts.push(title.slice(cursor));
  }

  return parts;
}

export default function ProductCard({ product, query, onClick }) {
  if (!product) return null;

  const { title, price, rating, stores, brand, image, tags = [] } = product;

  return (
    <article
      className="card-surface"
      tabIndex={0}
      role="button"
      aria-label={`${title} from ${brand}, $${price}`}
      onClick={onClick}
      onKeyDown={(e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault();
          onClick?.();
        }
      }}
      style={{
        padding: 12,
        display: 'flex',
        flexDirection: 'column',
        gap: 10,
        cursor: 'pointer',
        transition: 'transform 0.15s ease, box-shadow 0.15s ease, border-color 0.15s ease',
      }}
      onMouseEnter={(e) => {
        e.currentTarget.style.transform = 'translateY(-2px)';
        e.currentTarget.style.boxShadow = '0 22px 55px rgba(0,0,0,0.75)';
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.transform = 'none';
        e.currentTarget.style.boxShadow = 'var(--shadow-soft)';
      }}
    >
      <div
        style={{
          position: 'relative',
          borderRadius: 12,
          overflow: 'hidden',
          background: 'radial-gradient(circle at 0 0, rgba(15,163,177,0.3), #05070a)',
          minHeight: 120,
        }}
      >
        <img
          src={image}
          alt={title}
          style={{
            width: '100%',
            height: 150,
            objectFit: 'cover',
            display: 'block',
          }}
          loading="lazy"
        />
        <div
          style={{
            position: 'absolute',
            top: 8,
            left: 8,
            display: 'inline-flex',
            alignItems: 'center',
            gap: 4,
            padding: '3px 8px',
            borderRadius: 999,
            background: 'rgba(15,15,18,0.82)',
            border: '1px solid rgba(148,163,184,0.6)',
            fontSize: 11,
            color: 'var(--text-muted)',
          }}
        >
          <span
            style={{
              width: 6,
              height: 6,
              borderRadius: '999px',
              background: 'rgba(34,197,94,0.9)',
            }}
          />
          <span>{brand}</span>
        </div>
      </div>

      <div style={{ display: 'flex', justifyContent: 'space-between', gap: 8 }}>
        <h3
          style={{
            margin: 0,
            fontSize: 14,
            fontWeight: 500,
          }}
        >
          {renderHighlightedTitle(title, query)}
        </h3>
        <div
          style={{
            fontSize: 13,
            fontWeight: 600,
            color: '#e0fbff',
          }}
        >
          ${price}
        </div>
      </div>

      <div
        style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          fontSize: 12,
          color: 'var(--text-muted)',
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
          <span aria-hidden="true" style={{ color: '#facc15' }}>
            ★★★★★
          </span>
          <span>{rating.toFixed ? rating.toFixed(1) : rating}</span>
        </div>
        <span>{stores} stores</span>
      </div>

      {tags.length > 0 && (
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
          {tags.map((tag) => (
            <span key={tag} className="badge-chip teal">
              {tag}
            </span>
          ))}
        </div>
      )}
    </article>
  );
}
