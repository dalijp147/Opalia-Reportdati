import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:opalia_client/services/remote/apiServicePro.dart';

import '../../models/particpant.dart';

part 'partipant_event.dart';
part 'partipant_state.dart';

class PartipantBloc extends Bloc<PartipantEvent, PartipantState> {
  PartipantBloc() : super(PartipantInitial()) {
    on<PartipantInitialFetchEvent>(partipantInitialFetchEvent);
  }

  FutureOr<void> partipantInitialFetchEvent(
      PartipantInitialFetchEvent event, Emitter<PartipantState> emit) async {
    emit(
      PartipantFetchLoadingState(),
    );
    List<Particpant> parts = await ApiServicePro.fetchParticipant();
    print('here participant');
    emit(
      PartipantFetchSucess(particpants: parts),
    );
  }
}
