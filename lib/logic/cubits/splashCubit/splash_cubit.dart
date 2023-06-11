import 'package:flutter_bloc/flutter_bloc.dart';

enum SplashState {
  loading, moveNext
}

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState.loading) {
    moveToNextScreen();
  }

  moveToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      emit(SplashState.moveNext);
    });
  }
}
