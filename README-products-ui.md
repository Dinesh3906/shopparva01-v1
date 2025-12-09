# Product Search UI (Node + React)

This is a small demo that implements a product list + search UI with filters backed by an Express server.

## Tech stack

- Backend: Node.js + Express (`server.js` at project root)
- Frontend: React + Vite (in `frontend/`)

## Prerequisites

- Node.js 18+ and npm

## Install & run

1. Install backend dependencies (root):

   ```bash
   npm install
   ```

2. Install frontend dependencies:

   ```bash
   cd frontend
   npm install
   cd ..
   ```

3. Start the backend server (port 4000):

   ```bash
   npm run server
   ```

   This runs `node server.js` and exposes:

   - `GET /products` — all products
   - `GET /products?q=<term>` — search (case-insensitive across title, brand, description)
   - `GET /products?brand=HP&priceMin=500&priceMax=1000&category=Gaming` — filtered listing

4. In a second terminal, start the React dev server (Vite on port 5173):

   ```bash
   npm run start
   ```

   This proxies API requests to `http://localhost:4000/products` via `frontend/vite.config.mjs`.

5. Open the app in the browser:

   - Frontend: http://localhost:5173

## Frontend behavior

### Initial load

- On first render, the app calls `GET /products` and shows all available products in a responsive grid (4/3/2/1 columns based on viewport width).
- If the server were to return an empty list, a centered empty state appears with:
  - Title: **"No products found."**
  - Subtitle: **"Try different keywords or clear filters."**
  - Suggested chips and a **Clear filters** button.

### Search box

- Large search bar at the top with search icon on the left and mic icon on the right.
- Typing updates the query in real time; API calls are debounced by **300ms** using a custom hook.
- When query is non-empty, requests go to:
  - `GET /products?q=<term>` (plus any active brand/price filters)
- After results load, the header under the search bar shows:
  - `Showing results for "Laptop"`
- If query is cleared, the header disappears and the default listing (all products) shows again.
- Matches in product titles are highlighted using a `<mark>` wrapper.

### No results

- When the server returns `{ count: 0, results: [] }` (or an empty array), the app **does not** show the grid.
- Instead it renders the `EmptyState` component:
  - Title: **"No products found."**
  - Subtitle: **"Try different keywords or clear filters."**
  - Suggested search chips: `Laptop`, `Gaming`, `HP`, `ASUS`.
  - A **Clear filters** button that resets query and filters, then re-fetches all products.
  - A small decorative icon/illustration and a subtle outline box matching the dark theme.
  - If there are any previous searches, a **Recent searches** bar shows clickable chips.

### Filters panel

- Left-hand floating panel (`FiltersPanel`) with these groups:
  - **Brands** — HP, Dell, Lenovo, Apple, ASUS (pill chips)
  - **Price range** — radio buttons:
    - Under $500 → `priceMax=499`
    - $500–$1000 → `priceMin=500&priceMax=1000`
    - Above $1000 → `priceMin=1001`
    - Any price
  - **Performance** — checkboxes for `i5`, `i7`, `Dedicated GPU`, `SSD Storage`
  - **Usage type** — chips: Gaming, Office Work, Student, Programming
- Clicking **Apply filters** triggers an API request:

  - `GET /products` with appropriate query params (brand + price range).
  - Performance and usage are then refined client-side using `tags` and `category` fields.

- Filters state is kept in React state so it persists while navigating within the page.

### Product grid / cards

- Each card (`ProductCard`) shows:
  - Image (from `product.image`)
  - Title (with highlighted matches)
  - Price with `$`
  - Rating (numeric + visual stars)
  - Store count (e.g., `5 stores`)
  - Teal pill badges for tags such as `SSD Storage`, `Dedicated GPU`, `Gaming`.
- Cards are keyboard-focusable and clickable (`role="button"`, `tabIndex=0`); pressing Enter/Space triggers the same click handler.
- Layout:
  - 4 columns on large desktop
  - 3 columns on medium
  - 2 columns on tablet
  - 1 column on mobile

### Loading & error states

- While waiting for `/products` to resolve, `ProductList` shows a grid of **skeleton cards** instead of an incorrect "No products found" message.
- If a network or server error occurs:
  - An inline error banner appears: **"Could not load products."** plus a **Retry** button.
  - Retry re-uses the last query + filters and calls the API again.

### Accessibility

- Search input, filters, chips, and product cards are all keyboard-interactive.
- ARIA labels:
  - Search bar root section: `aria-label="Product search"`
  - Filters panel: `aria-label="Filter products"`
  - Product grid: `aria-label="Search results"`
  - Empty state section: `aria-label="No products found. Suggestions and actions"`
  - Each product card uses `role="button"` and an `aria-label` summarizing the item.

## Acceptance checks

With the provided `server.js` data:

- **Initial load**: run `npm run server` and `npm run start`, open http://localhost:5173 — you should see all four example laptop products.
- **Search "Laptop"**: type `Laptop` in the search box — all four items show and a header appears: `Showing results for "Laptop"`.
- **Search by brand**: type `HP` or click the `HP` filter chip — only **HP Pavilion 15** should be returned.
- **Nonsense search**: type `asdasdas` — the empty state appears with suggested search chips and **Clear filters**; clicking **Clear filters** restores the full list.
- **Price filter**: choose `$500-$1000` in the filters panel — only products in that range are shown (combined with any active search term).
- **Empty-state correctness**: the UI only shows "No products found." when the server (after filters) returns zero items; while loading it uses skeletons instead.

## Notes

- Image URLs in the sample dataset point to `/images/...`. You can add matching files under an `images/` folder and uncomment the `express.static` line in `server.js` if you want local images, or swap to remote URLs.
- This project is intentionally small and focused on search/filter UX rather than full routing or product detail pages.
