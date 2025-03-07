import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'hydrated_blocs.mocks.dart';

@GenerateMocks([HydratedStorage])
void initHydratedStorage() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final hydratedStorage = MockHydratedStorage();
  when(hydratedStorage.write(any, any)).thenAnswer((_) async {});
  HydratedBloc.storage = hydratedStorage;
}
