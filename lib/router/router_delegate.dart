import 'package:flutter/material.dart';
import 'page_manager.dart';
import 'route_information_parser.dart';
import '../provider/auth_provider.dart';
import '../ui/login_page.dart';
import '../ui/register_page.dart';
import '../ui/home_page.dart';
import '../ui/story_detail_page.dart';
import '../ui/add_story_page.dart';

class StoryRouterDelegate extends RouterDelegate<RouteConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteConfiguration> {
  final AuthProvider authProvider;
  final PageManager pageManager;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  StoryRouterDelegate({
    required this.authProvider,
    required this.pageManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    authProvider.addListener(notifyListeners);
    pageManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    authProvider.removeListener(notifyListeners);
    pageManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  RouteConfiguration get currentConfiguration {
    if (!authProvider.isLoggedIn) {
      if (pageManager.isRegister) {
        return RouteConfiguration.register();
      }
      return RouteConfiguration.login();
    }

    if (pageManager.isAddStory) {
      return RouteConfiguration.addStory();
    }
    if (pageManager.selectedStoryId != null) {
      return RouteConfiguration.storyDetail(pageManager.selectedStoryId!);
    }
    return RouteConfiguration.home();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Page>[];

    if (authProvider.isLoadingSession) {
      pages.add(
        const MaterialPage(
          key: ValueKey('splash'),
          child: _SplashScreen(),
        ),
      );
    } else if (!authProvider.isLoggedIn) {
      pages.add(
        MaterialPage(
          key: const ValueKey('login'),
          child: LoginPage(
            onLogin: () {},
            onRegister: () => pageManager.openRegister(),
          ),
        ),
      );
      if (pageManager.isRegister) {
        pages.add(
          MaterialPage(
            key: const ValueKey('register'),
            child: RegisterPage(
              onRegisterSuccess: () => pageManager.closeRegister(),
              onBack: () => pageManager.closeRegister(),
            ),
          ),
        );
      }
    } else {
      pages.add(
        MaterialPage(
          key: const ValueKey('home'),
          child: HomePage(
            onStoryTapped: (id) => pageManager.selectStory(id),
            onAddStory: () => pageManager.openAddStory(),
            onLogout: () {
              pageManager.resetAllNavigation();
              authProvider.logout();
            },
          ),
        ),
      );

      if (pageManager.selectedStoryId != null) {
        pages.add(
          MaterialPage(
            key: ValueKey('detail-${pageManager.selectedStoryId}'),
            child: StoryDetailPage(
              storyId: pageManager.selectedStoryId!,
              onBack: () => pageManager.clearSelectedStory(),
            ),
          ),
        );
      }

      if (pageManager.isAddStory) {
        pages.add(
          MaterialPage(
            key: const ValueKey('add-story'),
            child: AddStoryPage(
              onUploadSuccess: () => pageManager.closeAddStory(),
              onBack: () => pageManager.closeAddStory(),
            ),
          ),
        );
      }
    }

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onDidRemovePage: (page) {
        if (page.key == const ValueKey('register')) {
          pageManager.closeRegister();
        } else if (page.key == const ValueKey('add-story')) {
          pageManager.closeAddStory();
        } else if (page.key.toString().contains('detail-')) {
          pageManager.clearSelectedStory();
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouteConfiguration configuration) async {
    if (configuration.isRegisterPage) {
      pageManager.openRegister();
    } else if (configuration.isAddStoryPage) {
      pageManager.openAddStory();
    } else if (configuration.storyId != null) {
      pageManager.selectStory(configuration.storyId!);
    } else {
      pageManager.resetAllNavigation();
    }
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_stories_rounded,
              size: 80,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 24),
            CircularProgressIndicator(color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
