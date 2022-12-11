import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/citem.dart';
import '../../services/database_service.dart';
part 'crud_event.dart';
part 'crud_state.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {
  CrudBloc() : super(CrudInitial()) {
    List<CommodityItem> items = [];
    on<AddItem>((event, emit) async {
      await DatabaseService.instance.create(
        CommodityItem(
          createdTime: event.createdTime,
          description: event.description,
          c_price: event.c_price,
          c_image: event.c_image,
          number: event.number,
          title: event.title,
        ),
      );
    });

    on<UpdateItem>((event, emit) async {
      await DatabaseService.instance.update(
        cItem: event.cItem,
      );
    });

    on<FetchItems>((event, emit) async {
      items = await DatabaseService.instance.readAllItems();
      emit(DisplayItems(cItem: items));
    });

    on<FetchSpecificItem>((event, emit) async {
      CommodityItem item = await DatabaseService.instance.readItem(id: event.id);
      emit(DisplaySpecificItem(cItem: item));
    });

    on<DeleteItem>((event, emit) async {
      await DatabaseService.instance.delete(id: event.id);
      add(const FetchItems());
    });
  }
}
