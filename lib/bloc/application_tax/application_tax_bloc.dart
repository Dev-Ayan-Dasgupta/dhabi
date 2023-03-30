import 'package:dialup_mobile_app/bloc/application_tax/application_tax_event.dart';
import 'package:dialup_mobile_app/bloc/application_tax/application_tax_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplicationTaxBloc
    extends Bloc<ApplicationTaxEvent, ApplicationTaxState> {
  ApplicationTaxBloc()
      : super(
          ApplicationTaxState(
            isUS: false,
            isPPonly: true,
            isTINvalid: false,
            isCRS: false,
            hasTIN: false,
          ),
        ) {
    on<ApplicationTaxEvent>(
      (event, emit) => emit(
        ApplicationTaxState(
          isUS: event.isUS,
          isPPonly: event.isPPonly,
          isTINvalid: event.isTINvalid,
          isCRS: event.isCRS,
          hasTIN: event.hasTIN,
        ),
      ),
    );
  }
}
