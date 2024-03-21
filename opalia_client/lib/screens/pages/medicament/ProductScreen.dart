import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../bloc/product/product_bloc.dart';
import '../../../widegts/Medicament/Medicamentitem.dart';
import 'DetailScreen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductBloc productBloc = ProductBloc();

  @override
  void initState() {
    productBloc.add(MedicamentInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<ProductBloc, ProductState>(
          bloc: productBloc,
          listenWhen: (previous, current) => current is ProductActionState,
          buildWhen: (previous, current) => current is! ProductActionState,
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.runtimeType) {
              case ProductFetchSucess:
                final sucessState = state as ProductFetchSucess;
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // number of items in each row
                      mainAxisSpacing: 15.0, // spacing between rows
                      crossAxisSpacing: 10.0, // spacing between columns
                      childAspectRatio: 2 / 3,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    itemCount: sucessState.medi.length,
                    itemBuilder: (context, index) {
                      final medicament = sucessState.medi![index];
                      return GestureDetector(
                          onTap: () {
                            Get.to(DetailProduct(
                              medi: medicament,
                            ));
                          },
                          child: MedicamentItem(
                            model: medicament,
                          ));
                    },
                  ),
                );
              default:
                return Lottie.asset('assets/animation/heartrate.json',
                    height: 210, width: 210);
            }
          },
        ),
      ),
    );
  }
}
