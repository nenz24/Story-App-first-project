import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'data/api/api_service.dart';
import 'data/preferences/preferences_helper.dart';
import 'provider/auth_provider.dart';
import 'provider/story_provider.dart';
import 'provider/localization_provider.dart';
import 'router/page_manager.dart';
import 'router/route_information_parser.dart';
import 'router/router_delegate.dart';

void main() {
  runApp(const StoryApp());
}

class StoryApp extends StatefulWidget {
  const StoryApp({super.key});

  @override
  State<StoryApp> createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  late final ApiService _apiService;
  late final PreferencesHelper _preferencesHelper;
  late final AuthProvider _authProvider;
  late final StoryProvider _storyProvider;
  late final LocalizationProvider _localizationProvider;
  late final PageManager _pageManager;
  late final StoryRouterDelegate _routerDelegate;
  late final StoryRouteInformationParser _routeInformationParser;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _preferencesHelper = PreferencesHelper();
    _authProvider = AuthProvider(
      apiService: _apiService,
      preferencesHelper: _preferencesHelper,
    );
    _storyProvider = StoryProvider(
      apiService: _apiService,
      preferencesHelper: _preferencesHelper,
    );
    _localizationProvider = LocalizationProvider(
      preferencesHelper: _preferencesHelper,
    );
    _pageManager = PageManager();
    _routerDelegate = StoryRouterDelegate(
      authProvider: _authProvider,
      pageManager: _pageManager,
    );
    _routeInformationParser = StoryRouteInformationParser();
  }

  @override
  void dispose() {
    _authProvider.dispose();
    _storyProvider.dispose();
    _localizationProvider.dispose();
    _pageManager.dispose();
    _routerDelegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider.value(value: _storyProvider),
        ChangeNotifierProvider.value(value: _localizationProvider),
        ChangeNotifierProvider.value(value: _pageManager),
      ],
      child: Consumer<LocalizationProvider>(
        builder: (context, locProv, _) {
          return MaterialApp.router(
            title: 'Story App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2563EB),
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2563EB),
                brightness: Brightness.dark,
              ),
            ),
            locale: locProv.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('id')],
            routerDelegate: _routerDelegate,
            routeInformationParser: _routeInformationParser,
          );
        },
      ),
    );
  }
}
