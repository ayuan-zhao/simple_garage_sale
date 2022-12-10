part of 'crud_bloc.dart';

abstract class CrudEvent extends Equatable {
  const CrudEvent();
}

class AddItem extends CrudEvent {
  final String title;
  final int c_price;
  final int number;
  final String description;
  final DateTime createdTime;

  const AddItem(
      {required this.title,
      required this.c_price,
      required this.number,
      required this.description,
      required this.createdTime});

  @override
  List<Object?> get props =>
      [title, c_price, number, description, createdTime];
}

class UpdateItem extends CrudEvent {
  final CommodityItem cItem;
  const UpdateItem({required this.cItem});
  @override
  List<Object?> get props => [cItem];
}

class FetchItems extends CrudEvent {
  const FetchItems();

  @override
  List<Object?> get props => [];
}

class FetchSpecificItem extends CrudEvent {
  final int id;
  const FetchSpecificItem({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteItem extends CrudEvent {
  final int id;
  const DeleteItem({required this.id});
  @override
  List<Object?> get props => [id];
}
