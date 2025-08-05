import 'package:flutter/material.dart';
import 'package:blackbox_db/5_Service/external_api_service.dart';
import 'package:blackbox_db/8_Model/content_model.dart';

/// Content Detail Page - External API ile veri çekme örneği
class ContentDetailPage extends StatefulWidget {
  final int contentId;
  final int contentTypeId; // 1: Movie, 2: Game
  final int? userId;

  const ContentDetailPage({
    super.key,
    required this.contentId,
    required this.contentTypeId,
    this.userId,
  });

  @override
  State<ContentDetailPage> createState() => _ContentDetailPageState();
}

class _ContentDetailPageState extends State<ContentDetailPage> {
  final ExternalApiService _apiService = ExternalApiService();
  ContentModel? content;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadContentDetail();
  }

  Future<void> _loadContentDetail() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Bu method önce Supabase'de arar, yoksa external API'den çeker
      final result = await _apiService.getContentDetail(
        contentId: widget.contentId,
        contentTypeId: widget.contentTypeId,
        userId: widget.userId,
      );

      setState(() {
        content = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(content?.title ?? 'Content Detail'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadContentDetail,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (content == null) {
      return const Center(
        child: Text('Content not found'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          if (content!.posterPath != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.contentTypeId == 1 ? 'https://image.tmdb.org/t/p/w500${content!.posterPath}' : content!.posterPath!,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 300,
                      width: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
            ),
          const SizedBox(height: 16),

          // Title
          Text(
            content!.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),

          // Release Date
          if (content!.releaseDate != null)
            Text(
              'Release Date: ${content!.releaseDate!.year}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          const SizedBox(height: 8),

          // Length
          if (content!.length != null)
            Text(
              widget.contentTypeId == 1 ? 'Duration: ${content!.length} minutes' : 'Length: ${content!.length}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          const SizedBox(height: 16),

          // Description
          if (content!.description != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  content!.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add to favorites logic
                  },
                  icon: Icon(
                    content!.isFavorite == true ? Icons.favorite : Icons.favorite_border,
                  ),
                  label: const Text('Favorite'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add to watch later logic
                  },
                  icon: const Icon(Icons.watch_later),
                  label: const Text('Watch Later'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
