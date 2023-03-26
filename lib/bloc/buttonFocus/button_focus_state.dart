// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ButtonFocussedState extends Equatable {
  final bool isFocussed;
  final int toggles;
  const ButtonFocussedState({
    required this.isFocussed,
    required this.toggles,
  });

  @override
  List<Object?> get props => [isFocussed, toggles];
}
