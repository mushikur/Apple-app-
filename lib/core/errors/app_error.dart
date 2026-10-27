/// Base error class for graceful error handling.
class AppError implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppError(this.message, {this.code, this.originalError});

  @override
  String toString() => 'AppError($code): $message';
}

class ServiceUnavailableError extends AppError {
  const ServiceUnavailableError(String service)
      : super('$service is not available on this platform', code: 'SERVICE_UNAVAILABLE');
}

class StorageError extends AppError {
  const StorageError(super.message, {super.originalError})
      : super(code: 'STORAGE_ERROR');
}

class AssetNotFoundError extends AppError {
  const AssetNotFoundError(String asset)
      : super('Asset not found: $asset', code: 'ASSET_NOT_FOUND');
}
