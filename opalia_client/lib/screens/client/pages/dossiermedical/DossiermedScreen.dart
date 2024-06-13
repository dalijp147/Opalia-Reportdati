import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../bloc/med/med_bloc.dart';
import '../../../../models/dossierMed.dart';
import '../../../../services/local/sharedprefutils.dart';

class DossierMedScreen extends StatefulWidget {
  const DossierMedScreen({super.key});

  @override
  State<DossierMedScreen> createState() => _DossierMedScreenState();
}

class _DossierMedScreenState extends State<DossierMedScreen> {
  final MedBloc medBloc = MedBloc();
  @override
  void initState() {
    medBloc.add(MedInitialFetchEvent(PreferenceUtils.getuserid()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<MedBloc, MedState>(
        bloc: medBloc,
        listenWhen: (previous, current) => current is MedActionState,
        buildWhen: (previous, current) => current is! MedActionState,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case MedFetchLoadingState:
              return Lottie.asset('assets/animation/heartrate.json',
                  height: 210, width: 210);

            case MedFetchSucess:
              final sucessState = state as MedFetchSucess;
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: sucessState.dossierMed.length,
                  itemBuilder: (context, index) {
                    final dossierMed = sucessState.dossierMed[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Age :",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${dossierMed.age.toString()} ans',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "poids :",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${dossierMed.poids.toString()} kg',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Maladie :",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                dossierMed.maladies.toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            default:
              return Lottie.asset('assets/animation/heartrate.json',
                  height: 210, width: 210);
          }
        },
      ),
    );
  }
}
