import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../provider/story_provider.dart';
import '../provider/localization_provider.dart';

class HomePage extends StatefulWidget {
  final void Function(String id) onStoryTapped;
  final VoidCallback onAddStory;
  final VoidCallback onShowLogoutDialog;

  const HomePage({
    super.key,
    required this.onStoryTapped,
    required this.onAddStory,
    required this.onShowLogoutDialog,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StoryProvider>().fetchStories());
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.storyList,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Consumer<LocalizationProvider>(
            builder: (context, locProv, _) {
              final isEn = locProv.locale.languageCode == 'en';
              return IconButton(
                icon: Text(
                  isEn ? '🇮🇩' : '🇬🇧',
                  style: const TextStyle(fontSize: 22),
                ),
                tooltip: localizations.changeLanguage,
                onPressed: () {
                  locProv.setLocale(
                    isEn ? const Locale('id') : const Locale('en'),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: localizations.logout,
            onPressed: widget.onShowLogoutDialog,
          ),
        ],
      ),
      body: Consumer<StoryProvider>(
        builder: (context, storyProvider, _) {
          switch (storyProvider.state) {
            case ResultState.loading:
              return const Center(child: CircularProgressIndicator());
            case ResultState.error:
              return _ErrorView(
                message:
                    storyProvider.errorMessage ?? localizations.errorOccurred,
                onRetry: () => storyProvider.fetchStories(),
              );
            case ResultState.noData:
              return _EmptyView(message: localizations.emptyStories);
            case ResultState.hasData:
              return RefreshIndicator(
                onRefresh: () => storyProvider.fetchStories(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: storyProvider.stories.length,
                  itemBuilder: (context, index) {
                    final story = storyProvider.stories[index];
                    return _StoryCard(
                      name: story.name,
                      photoUrl: story.photoUrl,
                      onTap: () => widget.onStoryTapped(story.id),
                    );
                  },
                ),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onAddStory,
        icon: const Icon(Icons.add_photo_alternate_rounded),
        label: Text(localizations.addStory),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final String name;
  final String photoUrl;
  final VoidCallback onTap;

  const _StoryCard({
    required this.name,
    required this.photoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.broken_image_rounded,
                      size: 48,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(localizations.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String message;

  const _EmptyView({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
