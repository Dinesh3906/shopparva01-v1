import React from 'react';

const suggestedChips = ['Laptop', 'Gaming', 'HP', 'ASUS'];

export default function EmptyState({ onChipClick, onClearFilters, recentSearches }) {
  return (
    <div className="empty-state-shell">
      <section
        className="empty-state-box"
        aria-label="No products found. Suggestions and actions"
      >
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: 16,
            marginBottom: 20,
          }}
        >
          <div
            aria-hidden="true"
            style={{
              width: 56,
              height: 56,
              borderRadius: 18,
              border: '1px solid rgba(148,163,184,0.35)',
              background:
                'radial-gradient(circle at 20% 0%, rgba(15,163,177,0.45), transparent 55%), #05070a',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              boxShadow: '0 18px 40px rgba(0,0,0,0.75)',
            }}
          >
            <svg
              width="26"
              height="26"
              viewBox="0 0 24 24"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <rect
                x="3"
                y="5"
                width="13"
                height="10"
                rx="2.5"
                stroke="#0FA3B1"
                strokeWidth="1.3"
              />
              <path
                d="M7 9H12.5"
                stroke="#E5F9FF"
                strokeWidth="1.3"
                strokeLinecap="round"
              />
              <path
                d="M7 12H10.5"
                stroke="#9CA3AF"
                strokeWidth="1.3"
                strokeLinecap="round"
              />
              <path
                d="M16 12L20.5 16.5"
                stroke="#0FA3B1"
                strokeWidth="1.5"
                strokeLinecap="round"
              />
              <circle
                cx="14.5"
                cy="12"
                r="2.5"
                stroke="#0FA3B1"
                strokeWidth="1.3"
              />
            </svg>
          </div>
          <div>
            <h2
              style={{
                margin: 0,
                fontSize: 22,
                letterSpacing: 0.1,
              }}
            >
              No products found.
            </h2>
            <p
              style={{
                marginTop: 6,
                marginBottom: 0,
                fontSize: 14,
                color: 'var(--text-muted)',
              }}
            >
              Try different keywords or clear filters.
            </p>
          </div>
        </div>

        <div style={{ marginBottom: 18 }}>
          <p
            style={{
              margin: '0 0 8px 0',
              fontSize: 13,
              color: 'var(--text-muted)',
            }}
          >
            Suggested searches
          </p>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
            {suggestedChips.map((chip) => (
              <button
                key={chip}
                type="button"
                className="pill-button teal"
                onClick={() => onChipClick?.(chip)}
              >
                {chip}
              </button>
            ))}
          </div>
        </div>

        {recentSearches && recentSearches.length > 0 && (
          <div style={{ marginBottom: 18 }}>
            <p
              style={{
                margin: '0 0 8px 0',
                fontSize: 13,
                color: 'var(--text-muted)',
              }}
            >
              Recent searches
            </p>
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
              {recentSearches.map((term) => (
                <button
                  key={term}
                  type="button"
                  className="pill-button"
                  onClick={() => onChipClick?.(term)}
                >
                  {term}
                </button>
              ))}
            </div>
          </div>
        )}

        <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12 }}>
          <button
            type="button"
            className="pill-button teal"
            onClick={onClearFilters}
          >
            Clear filters
          </button>
          <button
            type="button"
            className="pill-button"
            onClick={() => onChipClick?.('Laptop')}
          >
            Browse laptops
          </button>
        </div>
      </section>
    </div>
  );
}
