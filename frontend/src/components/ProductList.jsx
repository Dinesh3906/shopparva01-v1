import React from 'react';
import ProductCard from './ProductCard.jsx';

function SkeletonCard() {
  return (
    <div
      className="card-surface skeleton-card skeleton-shimmer"
      aria-hidden="true"
      style={{ padding: 12, display: 'flex', flexDirection: 'column', gap: 10 }}
    >
      <div
        style={{
          borderRadius: 12,
          background: 'linear-gradient(135deg,#111318,#050608)',
          height: 150,
        }}
      />
      <div style={{ display: 'flex', justifyContent: 'space-between', gap: 8 }}>
        <div
          style={{
            height: 16,
            width: '60%',
            borderRadius: 999,
            background: 'rgba(31,41,55,0.9)',
          }}
        />
        <div
          style={{
            height: 16,
            width: 60,
            borderRadius: 999,
            background: 'rgba(31,41,55,0.9)',
          }}
        />
      </div>
      <div
        style={{
          display: 'flex',
          justifyContent: 'space-between',
          gap: 8,
        }}
      >
        <div
          style={{
            height: 12,
            width: 80,
            borderRadius: 999,
            background: 'rgba(31,41,55,0.9)',
          }}
        />
        <div
          style={{
            height: 12,
            width: 70,
            borderRadius: 999,
            background: 'rgba(31,41,55,0.9)',
          }}
        />
      </div>
      <div
        style={{
          height: 20,
          width: '75%',
          borderRadius: 999,
          background: 'rgba(31,41,55,0.9)',
        }}
      />
    </div>
  );
}

export default function ProductList({ products, query, loading, onCardClick }) {
  if (loading) {
    return (
      <div className="products-grid" aria-label="Loading products">
        {Array.from({ length: 8 }).map((_, index) => (
          <SkeletonCard key={index} />
        ))}
      </div>
    );
  }

  return (
    <div className="products-grid" aria-label="Search results">
      {products.map((product) => (
        <ProductCard
          key={product.id}
          product={product}
          query={query}
          onClick={() => onCardClick?.(product)}
        />
      ))}
    </div>
  );
}
