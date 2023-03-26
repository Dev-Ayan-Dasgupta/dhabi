// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CheckBoxState extends Equatable {
  final bool isChecked;
  const CheckBoxState({
    required this.isChecked,
  });

  @override
  List<Object?> get props => [isChecked];
}
