part of 'crud_bloc.dart';

abstract class CrudState extends Equatable {
  const CrudState();
}

class CrudInitial extends CrudState {
  @override
  List<Object> get props => [];
}

class DisplayItems extends CrudState {
  final List<CommodityItem> cItem;

  const DisplayItems({required this.cItem});
  @override
  List<Object> get props => [cItem];
}

class DisplaySpecificItem extends CrudState {
  final CommodityItem cItem;

  const DisplaySpecificItem({required this.cItem});
  @override
  List<Object> get props => [cItem];
}
