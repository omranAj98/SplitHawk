import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:splithawk/src/core/error/custom_error.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit() : super(SigninState.initial());
}
