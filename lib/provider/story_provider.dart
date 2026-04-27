import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../data/api/api_service.dart';
import '../data/model/story.dart';
import '../data/preferences/preferences_helper.dart';

enum ResultState { loading, hasData, noData, error }

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final PreferencesHelper preferencesHelper;

  ResultState _state = ResultState.loading;
  ResultState _detailState = ResultState.loading;
  ResultState _uploadState = ResultState.noData;

  List<Story> _stories = [];
  Story? _storyDetail;
  String? _errorMessage;
  String? _uploadMessage;

  ResultState get state => _state;
  ResultState get detailState => _detailState;
  ResultState get uploadState => _uploadState;
  List<Story> get stories => _stories;
  Story? get storyDetail => _storyDetail;
  String? get errorMessage => _errorMessage;
  String? get uploadMessage => _uploadMessage;

  StoryProvider({
    required this.apiService,
    required this.preferencesHelper,
  });

  Future<void> fetchStories() async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      final token = await preferencesHelper.getToken();
      if (token == null) {
        _state = ResultState.error;
        _errorMessage = 'No authentication token found';
        notifyListeners();
        return;
      }

      _stories = await apiService.getAllStories(token);
      if (_stories.isEmpty) {
        _state = ResultState.noData;
      } else {
        _state = ResultState.hasData;
      }
    } catch (e) {
      _state = ResultState.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    notifyListeners();
  }

  Future<void> fetchStoryDetail(String id) async {
    _detailState = ResultState.loading;
    _storyDetail = null;
    notifyListeners();

    try {
      final token = await preferencesHelper.getToken();
      if (token == null) {
        _detailState = ResultState.error;
        _errorMessage = 'No authentication token found';
        notifyListeners();
        return;
      }

      _storyDetail = await apiService.getStoryDetail(token, id);
      _detailState = ResultState.hasData;
    } catch (e) {
      _detailState = ResultState.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    notifyListeners();
  }

  Future<bool> uploadStory(
    String description,
    Uint8List photoBytes,
    String fileName,
  ) async {
    _uploadState = ResultState.loading;
    _uploadMessage = null;
    notifyListeners();

    try {
      final token = await preferencesHelper.getToken();
      if (token == null) {
        _uploadState = ResultState.error;
        _uploadMessage = 'No authentication token found';
        notifyListeners();
        return false;
      }

      await apiService.addStory(token, description, photoBytes, fileName);
      _uploadState = ResultState.hasData;
      notifyListeners();
      return true;
    } catch (e) {
      _uploadState = ResultState.error;
      _uploadMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void resetUploadState() {
    _uploadState = ResultState.noData;
    _uploadMessage = null;
    notifyListeners();
  }
}
