import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:opalia_client/models/dossierMed.dart';

import '../../services/remote/apiService.dart';

part 'med_event.dart';
part 'med_state.dart';

class MedBloc extends Bloc<MedEvent, MedState> {
  MedBloc() : super(MedInitial()) {
    on<MedInitialFetchEvent>(medInitialFetchEvent);
  }

  FutureOr<void> medInitialFetchEvent(
      MedInitialFetchEvent event, Emitter<MedState> emit) async {
    emit(MedFetchLoadingState());
    List<DossierMed> dossier = await ApiService.fetchDossserMed(event.userID);
    print('here');
    print(event.userID);
    emit(MedFetchSucess(dossierMed: dossier));
  }
}
