import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalia_client/bloc/product_bloc.dart';

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
    return Scaffold(
      body: BlocConsumer<ProductBloc, ProductState>(
        bloc: productBloc,
        listenWhen: (previous, current) => current is ProductActionState,
        buildWhen: (previous, current) => current is! ProductActionState,
        listener: (context, state) {},
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }
}
