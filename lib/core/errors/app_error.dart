/// Hierarchia błędów aplikacji w standardzie Clean Architecture.
sealed class AppError implements Exception {
  final String message;
  const AppError(this.message);

  @override
  String toString() => message;
}

/// Błąd walidacji schematu JSON lub spójności referencyjnej grafu.
class ValidationError extends AppError {
  const ValidationError(super.message);
}

/// Błąd braku wymaganego zasobu (np. brak węzła startowego lub docelowego).
class NotFoundError extends AppError {
  const NotFoundError(super.message);
}

/// Błąd operacji wejścia/wyjścia lub odczytu zasobów.
class StorageError extends AppError {
  const StorageError(super.message);
}

/// Nieoczekiwany błąd wykonania.
class UnexpectedError extends AppError {
  const UnexpectedError(super.message);
}
