import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_event.dart';
import 'package:dialup_mobile_app/bloc/checkBox.dart/check_box_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckBoxBloc extends Bloc<CheckBoxEvent, CheckBoxState> {
  CheckBoxBloc()
      : super(
          const CheckBoxState(isChecked: false),
        ) {
    on<CheckBoxEvent>(
      (event, emit) => emit(
        CheckBoxState(isChecked: event.isChecked),
      ),
    );
  }
}
