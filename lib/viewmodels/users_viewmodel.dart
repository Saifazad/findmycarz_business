import 'package:flutter/material.dart';
import '../core/constants/api_config.dart';
import '../core/network/dio_client.dart';
import '../models/registered_user_model.dart';

class UsersViewModel extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  /// Paginated fetch from GET /users
  Future<List<RegisteredUser>> fetchUsersPage({
    required int pageKey,
    required int pageSize,
    String searchQuery = "",
  }) async {
    final response = await _dioClient.get(
      ApiConfig.users,
      queryParameters: {
        'page': pageKey,
        'per_page': pageSize,
        if (searchQuery.trim().isNotEmpty) 'search': searchQuery.trim(),
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final body = response.data;
      dynamic rawList;
      if (body is List) {
        rawList = body;
      } else if (body is Map) {
        final usersNode = body['users'];
        final dataNode = body['data'];
        if (usersNode is Map && usersNode['data'] is List) {
          rawList = usersNode['data'];
        } else if (dataNode is Map && dataNode['data'] is List) {
          rawList = dataNode['data'];
        } else if (dataNode is List) {
          rawList = dataNode;
        } else if (usersNode is List) {
          rawList = usersNode;
        }
      }

      if (rawList is List) {
        final parsed = rawList
            .whereType<Map>()
            .map((e) => RegisteredUser.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        if (searchQuery.trim().isNotEmpty) {
          final q = searchQuery.trim().toLowerCase();
          return parsed.where((u) {
            return u.id.toLowerCase().contains(q) ||
                u.name.toLowerCase().contains(q) ||
                u.email.toLowerCase().contains(q) ||
                u.phone.toLowerCase().contains(q) ||
                u.city.toLowerCase().contains(q) ||
                u.status.toLowerCase().contains(q);
          }).toList();
        }
        return parsed;
      }
    }
    return [];
  }
}
