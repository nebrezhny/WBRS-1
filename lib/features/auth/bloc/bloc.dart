import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wbrs/features/auth/bloc/event.dart';
import 'package:wbrs/features/auth/bloc/state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth;

  //AuthBloc(super.initialState, {required FirebaseAuth auth}) : _auth = auth;

  AuthBloc(this._auth) : super(AuthInitial()) {
    on<SignInRequested>((event, emit) async {
      emit(AuthFailure('test'));
    });
  }

  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignInRequested) {
      yield AuthLoading();
      try {
        final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        print(result);
        yield Authenticated(result.user! as User);
      } catch (e) {
        yield AuthFailure(e.toString());
      }
    }

    if (event is SignOutRequested) {
      yield AuthLoading();
      try {
        await _auth.signOut();
        yield Unauthenticated();
      } catch (e) {
        yield AuthFailure(e.toString());
      }
    }
  }
}
