import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../provider/story_provider.dart';

class StoryDetailPage extends StatefulWidget {
  final String storyId;
  final VoidCallback onBack;

  const StoryDetailPage({
    super.key,
    required this.storyId,
    required this.onBack,
  });

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<StoryProvider>().fetchStoryDetail(widget.storyId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: Text(
          localizations.storyDetail,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<StoryProvider>(
        builder: (context, provider, _) {
          switch (provider.detailState) {
            case ResultState.loading:
              return const Center(child: CircularProgressIndicator());
            case ResultState.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline_rounded,
                          size: 64, color: colorScheme.error),
                      const SizedBox(height: 16),
                      Text(
                        provider.errorMessage ?? localizations.errorOccurred,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () =>
                            provider.fetchStoryDetail(widget.storyId),
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(localizations.retry),
                      ),
                    ],
                  ),
                ),
              );
            case ResultState.noData:
            case ResultState.hasData:
              final story = provider.storyDetail;
              if (story == null) {
                return Center(child: Text(localizations.errorOccurred));
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Image.network(
                        story.photoUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: colorScheme.surfaceContainerHighest,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: colorScheme.surfaceContainerHighest,
                            child: Icon(Icons.broken_image_rounded,
                                size: 48,
                                color: colorScheme.onSurfaceVariant),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: colorScheme.primaryContainer,
                                child: Text(
                                  story.name.isNotEmpty
                                      ? story.name[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    color: colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      story.name,
                                      style: textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      DateFormat.yMMMMd().add_Hm().format(
                                            story.createdAt.toLocal(),
                                          ),
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            story.description,
                            style: textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
