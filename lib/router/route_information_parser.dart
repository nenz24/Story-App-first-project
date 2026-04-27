import 'package:flutter/material.dart';

class StoryRouteInformationParser
    extends RouteInformationParser<RouteConfiguration> {
  @override
  Future<RouteConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;

    if (uri.pathSegments.isEmpty) {
      return RouteConfiguration.home();
    }

    if (uri.pathSegments.length == 1) {
      final segment = uri.pathSegments[0];
      if (segment == 'login') return RouteConfiguration.login();
      if (segment == 'register') return RouteConfiguration.register();
      if (segment == 'add') return RouteConfiguration.addStory();
    }

    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'story') {
      return RouteConfiguration.storyDetail(uri.pathSegments[1]);
    }

    return RouteConfiguration.home();
  }

  @override
  RouteInformation? restoreRouteInformation(RouteConfiguration configuration) {
    if (configuration.isLoginPage) {
      return RouteInformation(uri: Uri.parse('/login'));
    }
    if (configuration.isRegisterPage) {
      return RouteInformation(uri: Uri.parse('/register'));
    }
    if (configuration.isAddStoryPage) {
      return RouteInformation(uri: Uri.parse('/add'));
    }
    if (configuration.storyId != null) {
      return RouteInformation(
        uri: Uri.parse('/story/${configuration.storyId}'),
      );
    }
    return RouteInformation(uri: Uri.parse('/'));
  }
}

class RouteConfiguration {
  final bool isLoginPage;
  final bool isRegisterPage;
  final bool isAddStoryPage;
  final String? storyId;

  RouteConfiguration({
    this.isLoginPage = false,
    this.isRegisterPage = false,
    this.isAddStoryPage = false,
    this.storyId,
  });

  factory RouteConfiguration.home() => RouteConfiguration();
  factory RouteConfiguration.login() =>
      RouteConfiguration(isLoginPage: true);
  factory RouteConfiguration.register() =>
      RouteConfiguration(isRegisterPage: true);
  factory RouteConfiguration.addStory() =>
      RouteConfiguration(isAddStoryPage: true);
  factory RouteConfiguration.storyDetail(String id) =>
      RouteConfiguration(storyId: id);
}
