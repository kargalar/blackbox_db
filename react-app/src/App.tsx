import { ExploreProvider } from '@/providers/ExploreProvider';
import { ExplorePage } from '@/pages/ExplorePage';

export function App() {
  return (
    <ExploreProvider>
      <ExplorePage />
    </ExploreProvider>
  );
}
