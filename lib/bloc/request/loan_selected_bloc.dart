import 'package:dialup_mobile_app/bloc/request/loan_selected_event.dart';
import 'package:dialup_mobile_app/bloc/request/loan_selected_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoanSelectedBloc extends Bloc<LoanSelectedEvent, LoanSelectedState> {
  LoanSelectedBloc()
      : super(
          const LoanSelectedState(
            isLoanSelected: false,
            toggles: 0,
          ),
        ) {
    on<LoanSelectedEvent>(
      (event, emit) => emit(
        LoanSelectedState(
          isLoanSelected: event.isLoanSelected,
          toggles: event.toggles,
        ),
      ),
    );
  }
}
