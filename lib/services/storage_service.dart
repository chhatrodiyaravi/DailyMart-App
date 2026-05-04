import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file to `products/{productId}/{filename}` and returns download URL
  Future<String?> uploadProductImage(String productId, File file) async {
    try {
      final String fileName = file.path.split(RegExp(r'[\\/]')).last;
      final ref = _storage
          .ref()
          .child('products')
          .child(productId)
          .child(fileName);
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }
}
