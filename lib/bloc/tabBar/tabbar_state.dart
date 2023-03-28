// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class TabbarState extends Equatable {
  final int index;
  const TabbarState({
    required this.index,
  });

  @override
  List<Object?> get props => [index];
}
