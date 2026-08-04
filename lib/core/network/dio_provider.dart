import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/secure_storage_service.dart';
import 'dio_client.dart';


final secureStorageProvider = Provider(
  (ref) {
    return SecureStorageService();
  },
);


final dioClientProvider = Provider(
  (ref) {

    final storage =
        ref.read(secureStorageProvider);

    return DioClient(storage);

  },
);