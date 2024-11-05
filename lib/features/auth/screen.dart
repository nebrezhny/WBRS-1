import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wbrs/features/auth/bloc/bloc.dart';
import 'package:wbrs/features/auth/bloc/event.dart';
import 'package:wbrs/features/auth/bloc/state.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    return Scaffold(
        backgroundColor: Colors.amber,
        body: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return Center(
              child: TextButton(
            child: Text(state.toString()),
            onPressed: () {
              print(state);
              bloc.add(SignInRequested(email: 't@t.ru', password: '123456'));
            },
          ));
        }));
  }
}
