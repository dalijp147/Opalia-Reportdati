part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class MedicamentInitialFetchEvent extends ProductEvent {}
