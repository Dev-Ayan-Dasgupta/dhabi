import 'package:dialup_mobile_app/data/bloc/showPassword/show_password_events.dart';
import 'package:dialup_mobile_app/data/bloc/showPassword/show_password_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowPasswordBloc extends Bloc<ShowPasswordEvent, ShowPasswordState> {
  ShowPasswordBloc() : super(const ShowPasswordState(showPassword: false)) {
    on<DisplayPasswordEvent>((event, emit) =>
        emit(ShowPasswordState(showPassword: event.showPassword)));
    on<HidePasswordEvent>((event, emit) =>
        emit(ShowPasswordState(showPassword: event.showPassword)));
  }
}
