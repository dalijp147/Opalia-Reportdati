import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/bloc/participant/partipant_bloc.dart';
import 'package:opalia_client/screens/pro/pages/Events/DetailEventScreen.dart';
import 'package:opalia_client/services/remote/apiServicePro.dart';

import '../../../../bloc/reminder/reminder_bloc.dart';

class ListEventSceen extends StatefulWidget {
  const ListEventSceen({super.key});

  @override
  State<ListEventSceen> createState() => _ListEventSceenState();
}

class _ListEventSceenState extends State<ListEventSceen> {
  final PartipantBloc partipantBloc = PartipantBloc();

  @override
  void initState() {
    partipantBloc.add(PartipantInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: [1, 0.1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red.shade50, Colors.white],
            ),
          ),
        ),
        title: const Text(
          'Evenement au quel vous étes inscrie',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<PartipantBloc, PartipantState>(
        bloc: partipantBloc,
        listenWhen: (previous, current) => current is PartipantActionState,
        buildWhen: (previous, current) => current is! PartipantActionState,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case PartipantFetchLoadingState:
              return Center(
                child: Lottie.asset(
                  'assets/animation/heartrate.json',
                ),
              );

            case PartipantFetchSucess:
              final successState = state as PartipantFetchSucess;

              return successState.particpants.isEmpty
                  ? Center(
                      child: Lottie.asset(
                        'assets/animation/emptybox.json',
                        height: 210,
                        width: 210,
                      ),
                    )
                  : Container(
                      height: double.infinity,
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: successState.particpants.length,
                        itemBuilder: (context, index) {
                          final reminder = successState.particpants[index];
                          return Dismissible(
                            background: Container(
                              color:
                                  Colors.red, // Background color when swiping
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 36,
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                            ),
                            key: Key(reminder.toString()),
                            onDismissed: (direction) async {
                              await ApiServicePro.deleteParticipant(
                                reminder.participantId!,
                              );
                            },
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                  DetailEventScreen(
                                    event: reminder.eventId!,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(width: 2, color: Colors.red),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        loadingBuilder: (
                                          BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress,
                                        ) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Container(
                                            height: 100,
                                            width: double.infinity,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                        (reminder.eventId!.eventimage == null ||
                                                reminder.eventId!.eventimage!
                                                    .isEmpty)
                                            ? "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg"
                                            : reminder.eventId!.eventimage!,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.scaleDown,
                                        errorBuilder: (
                                          BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace,
                                        ) {
                                          print('Error loading image: $error');
                                          return Image.network(
                                            "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                                            height: 100,
                                            width: 100,
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Nom de l'évenement:",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              reminder.eventId!.eventname!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              "Date de l'évenement:",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              formatter.format(
                                                  reminder.eventId!.dateEvent!),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await ApiServicePro.deleteParticipant(
                                            reminder.participantId!,
                                          );
                                        },
                                        icon: const Icon(
                                          Iconsax.trash,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
            default:
              return Center(
                child: Lottie.asset(
                  'assets/animation/heartrate.json',
                  height: 210,
                  width: 210,
                ),
              );
          }
        },
      ),
    );
  }
}
