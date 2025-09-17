part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

/// Kayıtlı temayı yüklemek için event.
class LoadTheme extends ThemeEvent {}

/// Mevcut temayı değiştirmek için event (açıktan koyuya veya tersi).
class ToggleTheme extends ThemeEvent {}
