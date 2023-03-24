import 'package:equatable/equatable.dart';

class ShowPasswordState extends Equatable {
  final bool showPassword;

  const ShowPasswordState({required this.showPassword});
  @override
  List<Object?> get props => [showPassword];
}
