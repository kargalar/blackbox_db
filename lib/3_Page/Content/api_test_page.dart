import 'package:flutter/material.dart';
import 'package:blackbox_db/3_Page/Content/content_detail_page_example.dart';
import 'package:blackbox_db/3_Page/Content/discover_page_example.dart';
import 'package:blackbox_db/3_Page/Content/search_page_example.dart';
import 'package:blackbox_db/3_Page/Content/recommendations_page_example.dart';

/// Backend API Integration Test Page
/// Backend'teki tüm endpoint'lerin Flutter karşılığını test eder
class ApiTestPage extends StatelessWidget {
  final int? userId = 1; // Test user ID

  const ApiTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend API Integration'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.api,
                      size: 48,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Backend Replacement',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Heroku backend\'i tamamen Flutter\'a taşındı\nSUPABASE + TMDB/IGDB API entegrasyonu',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Content Detail Tests
            Text(
              'CONTENT DETAIL (/content_detail)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContentDetailPage(
                            contentId: 550, // Fight Club
                            contentTypeId: 1, // Movie
                            userId: 1,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.movie),
                    label: const Text('Film Detail\n(Fight Club)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContentDetailPage(
                            contentId: 1942, // The Witcher 3
                            contentTypeId: 2, // Game
                            userId: 1,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.sports_esports),
                    label: const Text('Oyun Detail\n(Witcher 3)'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Discover Tests
            Text(
              'DISCOVER (/discoverMovie, /discoverGame)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiscoverPageExample(
                            contentTypeId: 1, // Movies
                            userId: userId,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.explore),
                    label: const Text('Film Keşfet'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiscoverPageExample(
                            contentTypeId: 2, // Games
                            userId: userId,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.explore),
                    label: const Text('Oyun Keşfet'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Search Tests
            Text(
              'SEARCH (/searchContent)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPageExample(
                            contentTypeId: 1, // Movies
                            userId: userId,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Film Ara'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPageExample(
                            contentTypeId: 2, // Games
                            userId: userId,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Oyun Ara'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recommendations
            Text(
              'RECOMMENDATIONS (/recommendContent)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecommendationsPageExample(
                      userId: userId!,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.recommend),
              label: const Text('Size Özel Öneriler'),
            ),

            const SizedBox(height: 32),

            // Info Card
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'SMART CACHING SİSTEMİ',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '1. Önce Supabase\'de ara\n2. Yoksa TMDB/IGDB\'den çek\n3. Supabase\'e kaydet\n4. User logs ile birleştir',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
