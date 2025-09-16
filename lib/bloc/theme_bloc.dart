import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:deneme/repositories/local_storage_repository.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final LocalStorageRepository _localStorageRepository;

  ThemeBloc(this._localStorageRepository) : super(const ThemeState(ThemeMode.light)) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  void _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) {
    final isDarkMode = _localStorageRepository.isDarkMode();
    emit(ThemeState(isDarkMode ? ThemeMode.dark : ThemeMode.light));
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    final newMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _localStorageRepository.saveTheme(isDarkMode: newMode == ThemeMode.dark);
    emit(ThemeState(newMode));
  }
}
