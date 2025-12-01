import 'package:bloc/bloc.dart';
import 'package:flutter_application_1/data/data.dart';
import 'package:flutter_application_1/data/repo/repository.dart';
import 'package:meta/meta.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<TaskEntity> repository;
  TaskListBloc(this.repository) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is TaskListStarted || event is TaskListSearch) {
        final String searchTerm;
        emit(TaskListLoading());
        await Future.delayed(const Duration(seconds: 1));
        if (event is TaskListSearch) {
          searchTerm = event.searchTerm;
        } else {
          searchTerm = '';
        }

        try {
          final items = await repository.getAll(searchkeyword: searchTerm);
          if (items.isNotEmpty) {
            emit(TaskListSuccess(items));
          } else {
            emit(TaskListEmpty());
          }
        } catch (e) {
          emit(TaskListError('خطای نامشخص'));
        }
      } else if (event is TaskListDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      }
    });
  }
}
