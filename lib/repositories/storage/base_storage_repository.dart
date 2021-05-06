import 'dart:io';

abstract class BaseStorageRepository {
  Future<String> uploadProfileImage({String url, File image});
  Future<String> uploadPostImage({File image});
  Future<String> uploadPlayerImage({File image});
}
