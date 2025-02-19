import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  const ServerException({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class SerializationException extends Equatable implements Exception {
  const SerializationException({
    this.message = 'Error deserializing model from map.',
    required this.error,
  });

  final String message;
  final String error;

  @override
  List<Object?> get props => [message, error];
}

class CacheException extends Equatable implements Exception {
  const CacheException({
    this.message = 'Error deserializing model from map.',
    required this.error,
  });

  final String message;
  final String error;

  @override
  List<Object?> get props => [message, error];
}

class UnknownException extends Equatable implements Exception {
  const UnknownException({required this.exception});

  final String? exception;

  @override
  String toString() {
    return 'UnknownException: $exception';
  }

  @override
  List<Object?> get props => [exception];
}
