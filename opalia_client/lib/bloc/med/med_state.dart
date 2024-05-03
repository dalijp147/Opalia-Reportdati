part of 'med_bloc.dart';

@immutable
sealed class MedState {}

sealed class MedActionState extends MedState {}

final class MedInitial extends MedState {}

final class MedFetchLoadingState extends MedState {}

final class MedFetchErrorState extends MedState {}

class MedFetchSucess extends MedState {
  final List<DossierMed> dossierMed;
  MedFetchSucess({required this.dossierMed});
}
