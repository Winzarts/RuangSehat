import 'package:flutter/material.dart';
import 'package:Ruang_sehat/features/articles/data/articles_services.dart';
import 'package:Ruang_sehat/features/articles/data/articles_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ArticlesProvider with ChangeNotifier {
  List<ArticlesModel> _articles = [];
  List<ArticlesModel> _myArticles = [];
  List<ArticlesModel> _featuredArticles = [];
  ArticlesModel? _detailArticle;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  bool _hasNextPage = true;

  ArticlesModel? get detailArticle => _detailArticle;
  List<ArticlesModel> get articles => _articles;
  List<ArticlesModel> get myArticles => _myArticles;
  List<ArticlesModel> get featuredArticles => _featuredArticles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasNextPage => _hasNextPage;

  Future<void> getArticles({bool isRefresh = true}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasNextPage = true;
      _setLoading(true);
    } else {
      if (!_hasNextPage || _isFetchingMore) return;
      _setFetchingMore(true);
    }

    _resetMessage();
    notifyListeners();

    try {
      final result = await ArticlesServices.getArticles(
        page: _currentPage,
        limit: 5,
      );

      final List<ArticlesModel> data = result['articles'];
      final int totalPages = result['totalPages'];

      if (isRefresh) {
        _articles = data;

        if (totalPages > 1) {
          final lastPageData = await ArticlesServices.getArticles(
            page: totalPages,
            limit: 5,
          );
          final List<ArticlesModel> lastPageArticles = lastPageData['articles'];
          _featuredArticles = lastPageArticles;
        } else {
          _featuredArticles = data.length > 5
              ? data.sublist(data.length - 5)
              : List.from(data);
        }
      } else {
        _articles.addAll(data);
      }

      if (result.isEmpty || data.length < 5) {
        _hasNextPage = false;
      } else {
        _currentPage++;
      }

      if (data.isEmpty && isRefresh) {
        _errorMessage = "Data artikel masih kosong";
      }

    } catch (e) {
      _errorMessage = _parseError(e);
      _articles = [];
    } finally {
      if (isRefresh) {
        _setLoading(false);
      } else {
        _setFetchingMore(false);
      }
    }
  }

  Future<void> getMyArticles() async {
    _setLoading(true);
    _resetMessage();
    notifyListeners();

    try {
      final result = await ArticlesServices.getMyArticles();
      _myArticles = result;

      if (result.isEmpty) {
        _errorMessage = "Data artikel kosong";
      }
    } catch (e) {
      _errorMessage = _parseError(e);
      _myArticles = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getDetailArticle(String id) async {
    _setLoading(true);
    _resetMessage();
    notifyListeners();

    try {
      final result = await ArticlesServices.getDetailArticle(id);
      _detailArticle = result;
    } catch (e) {
      _errorMessage = _parseError(e);
      _detailArticle = null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createArticle(
    String title,
    String description,
    String category,
    String imagePath,
  ) async {
    _setLoading(true);
    _resetMessage();
    notifyListeners();

    try {
      final StreamedResponse = await ArticlesServices.createArticle(
        File(imagePath),
        title,
        description,
        category,
      );

      final response = await http.Response.fromStream(StreamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        await getMyArticles();
        await getArticles();
        _successMessage = data['message'] ?? 'Artikel Berhasil dibuat';
      } else if (response.statusCode == 400) {
        final firstError = data['errors'][0];
        _errorMessage = firstError['message'] ?? "Terjadi Kesalahan";
      } else {
        _errorMessage = data['message'] ?? 'terjadi Kesalahan';
      }
    } catch (e) {
      _errorMessage = "terjadi Kesalahan Koneksi";
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> updateArticle(
    String id, {
    String? title,
    String? description,
    String? category,
    String? imagePath,
  }) async {
    _setLoading(true);
    _resetMessage();
    notifyListeners();

    try {
      final StreamedResponse = await ArticlesServices.updateArticle(
        id,
        title: title,
        description: description,
        category: category,
        image: imagePath != null ? File(imagePath) : null,
      );

      final response = await http.Response.fromStream(StreamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await getMyArticles();
        await getArticles();
        await getDetailArticle(id);
        _successMessage = data['message'] ?? 'Artikel berhasil diperbarui';
      } else if (response.statusCode == 400) {
        final firstError = data['errors'][0];
        _errorMessage = firstError['message'] ?? "Terjadi Kesalahan";
      } else {
        _errorMessage = data['message'] ?? 'terjadi Kesalahan';
      }
    } catch (e) {
      _errorMessage = "Terjadi Kesalahan Koneksi";
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> deleteArticle(String id) async {
    _setLoading(true);
    _resetMessage();
    notifyListeners();

    try {
      final result = await ArticlesServices.deleteArticle(id);
      final data = jsonDecode(result.body);

      if (result.statusCode == 200) {
        await getMyArticles();
        await getArticles();
        _successMessage = data['message'] ?? 'Artikel berhasil dihapus';
      } else if (result.statusCode == 400) {
        final firstError = data['errors'][0];
        _errorMessage = firstError['message'] ?? "Terjadi Kesalahan";
      } else {
        _errorMessage = data['message'] ?? 'terjadi Kesalahan';
      }
    } catch (e) {
      _errorMessage = _parseError(e);
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _resetMessage() {
    _successMessage = null;
    _errorMessage = null;
  }

  String _parseError(Object e) {
    return e.toString().replaceAll('Exception: ', '');
  }

  void _setFetchingMore(bool value) {
    _isFetchingMore = value;
    notifyListeners();
  }
}
