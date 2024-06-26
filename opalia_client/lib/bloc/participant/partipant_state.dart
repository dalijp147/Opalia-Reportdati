part of 'partipant_bloc.dart';

sealed class PartipantState extends Equatable {
  const PartipantState();

  @override
  List<Object> get props => [];
}

final class PartipantInitial extends PartipantState {}

sealed class PartipantActionState extends PartipantState {}

final class PartipantFetchLoadingState extends PartipantState {}

final class PartipantFetchErrorState extends PartipantState {}

class PartipantFetchSucess extends PartipantState {
  final List<Particpant> particpants;
  PartipantFetchSucess({required this.particpants});
}
