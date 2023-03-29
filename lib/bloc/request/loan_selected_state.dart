// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LoanSelectedState extends Equatable {
  final bool isLoanSelected;
  final int toggles;
  const LoanSelectedState({
    required this.isLoanSelected,
    required this.toggles,
  });

  @override
  List<Object?> get props => [isLoanSelected, toggles];
}
