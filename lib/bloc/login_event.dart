part of 'login_bloc.dart';

// Это простой абстрактный класс
// который можно расширить для других событий
abstract class LoginEvent {
  const LoginEvent();
}

/*
Будет использован позже
class LoginButtonTappedEvent extends LoginEvent {}
class ShowSnackBarButtonTappedEvent extends LoginEvent {}
*/
