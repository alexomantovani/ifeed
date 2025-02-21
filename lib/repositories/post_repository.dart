import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ifeed/core/utils/typedefs.dart';

import '../core/environments/environments.dart';
import '../core/errors/exceptions.dart';
import '../models/post_model.dart';

class PostRepository {
  final http.Client client;

  const PostRepository({required this.client});

  Future<List<PostModel>> getPosts() async {
    try {
      final response =
          await client.get(Uri.parse('${Environments.prod}/posts'));

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        if (decodedResponse is! List || decodedResponse.isEmpty) {
          throw ServerException(
            message: 'Missing required data from server',
            statusCode: 1,
          );
        }

        return decodedResponse.map((json) => PostModel.fromMap(json)).toList();
      } else {
        throw ServerException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        UnknownException(exception: e.toString()),
        stackTrace,
      );
    }
  }

  Future<PostModel> addPost({required PostModel post}) async {
    try {
      final body = jsonEncode({
        "userId": post.userId,
        "id": post.id,
        "title": post.title,
        "body": post.body,
      });

      final response = await client.post(
        Uri.parse('${Environments.prod}/posts'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 201) {
        final DataMap? decodedResponse = jsonDecode(response.body);

        if (decodedResponse == null || decodedResponse.isEmpty) {
          throw ServerException(
            message: 'Missing required data from server',
            statusCode: 1,
          );
        }

        return PostModel.fromMap(decodedResponse);
      } else {
        throw ServerException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(
        UnknownException(exception: e.toString()),
        stackTrace,
      );
    }
  }
}
