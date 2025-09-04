import { ExploreProvider } from '@/providers/ExploreProvider';
import { ExplorePage } from '@/pages/ExplorePage';
import { BrowserRouter, Link, Route, Routes } from 'react-router-dom';

export function App() {
  return (
    <BrowserRouter>
      <header className="topbar" style={{ display: 'flex', gap: 16, alignItems: 'center', padding: 12 }}>
        <Link to="/" style={{ fontWeight: 700, fontSize: 18 }}>Blackbox</Link>
        <nav style={{ display: 'flex', gap: 12 }}>
          <Link to="/">Explore</Link>
        </nav>
      </header>
      <ExploreProvider>
        <Routes>
          <Route path="/" element={<ExplorePage />} />
          <Route path="/content/:type/:id" element={<div style={{padding: 20}}>Content detail coming soon</div>} />
        </Routes>
      </ExploreProvider>
    </BrowserRouter>
  );
}
