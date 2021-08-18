# Flutter Clean Architecture with TDD

Building a Todo app in Flutter.
Based on Reso Coder course.

## Screenshots
<p>
<img src="https://i.ibb.co/hgZqv2F/Screenshot-1629289018.png" alt="Screen 1" width="250">
<img src="https://i.ibb.co/98M7k6h/Screenshot-1629289022.png" alt="Screen 2" width="250">
  <img src="https://i.ibb.co/nsvNxMp/Screenshot-1629289031.png" alt="Screen 3" width="250">
</p>

## Clean Architecture proposal by Reso
![architecture-proposal](https://raw.githubusercontent.com/robsonsilv4/clean-architecture-tdd/main/architecture-proposal.png)


## Implementations
- Dependency Injection with injectable and get_it
- Testing with mockito and bloc_test
- Caching with Hive
- Functional programing thingies with dartz

### _lib_ structure

```
├── lib
│   ├── core
│   │   ├── errors
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── network
│   │   │   └── network_info.dart
│   │   └── use_cases
│   │       └── use_case.dart
│   ├── dependencies 
│   │       └── app_dependencies.dart
│   ├── extensions 
│   │       └── task_extension.dart
│   ├── features
│   │   └── home
│   │       ├── data
│   │       │   ├── datasources
│   │       │   │   ├── task_local_datasource.dart
│   │       │   │   └── task_remote_datasource.dart
│   │       │   ├── models
│   │       │   │   └── my_task_model.dart
│   │       │   └── repositories
│   │       │       └── task_repository.dart
│   │       ├── domain
│   │       │   ├── entities
│   │       │   │   └── task.dart
│   │       │   ├── repositories
│   │       │   │   └── task_repository.dart
│   │       │   └── use_cases
│   │       │       ├── create_task_usecase.dart
│   │       │       ├── get_all_tasks_usecase.dart
│   │       │       └── update_task_usecase.dart
│   │       └── presentation
│   │           ├── blocs
│   │           │   ├── tabs
│   │           │   │   ├── tabs_bloc.dart
│   │           │   │   ├── tabs_event.dart
│   │           │   │   └── tabs_state.dart
│   │           │   └── tasks
│   │           │       ├── tasks_bloc.dart
│   │           │       ├── tasks_event.dart
│   │           │       └── tasks_state.dart
│   │           ├── pages
│   │           │   └── home_page.dart
│   │           └── widgets
│   │               ├── add_task_container.dart
│   │               ├── app_snack_bar.dart
│   │               ├── bottom_nav_bar.dart
│   │               ├── loading_dialog.dart
│   │               ├── status_empty.dart
│   │               ├── task_item.dart
│   │               └── task_list.dart
│   ├── mixins
│   │   └── bottom_sheet_mixin.dart           
│   ├── enums.dart
│   └── main.dart
```

### _test_ structure

```
├── test
│   ├── core
│   │   └── network
│   │       └── network_info_test.dart
│   ├── features
│   │   └── home
│   │       ├── data
│   │       │   ├── data_sources
│   │       │   │   ├── task_local_datasource_test.dart
│   │       │   │   └── task_remote_datasource_test.dart
│   │       │   ├── models
│   │       │   │   └── task_model_test.dart
│   │       │   └── repositories
│   │       │       └── task_repository_test.dart
│   │       ├── domain
│   │       │   └── use_cases
│   │       │       ├── create_task_test.dart
│   │       │       ├── update_task_test.dart
│   │       │       └── get_all_tasks_test.dart
│   │       └── presentation
│   │           └── bloc
│   │               └── tasks_bloc_test.dart
│   └── fixtures
│       ├── fixture_reader.dart
│       ├── my_task.json
│       ├── my_tasks_cache.json
│       └── my_tasks.json
```

## Thanks to
- [resocoder](https://github.com/ResoDev) (Followed his style in Clean architecture)
- [Axel Fuhrmann](https://github.com/afuh) (For the Rick and Morty [GraphQL API](https://rickandmortyapi.com))

## Backlog issues
- Still haven't created the mock block into another block 
- Still can't write test for tabs_bloc.dart

