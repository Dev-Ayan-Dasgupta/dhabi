// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class ShowPasswordEvent {}

class DisplayPasswordEvent extends ShowPasswordEvent {
  final bool showPassword;
  DisplayPasswordEvent({
    required this.showPassword,
  });
}

class HidePasswordEvent extends ShowPasswordEvent {
  final bool showPassword;

  HidePasswordEvent({
    required this.showPassword,
  });
}
