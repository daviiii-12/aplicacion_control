import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:control_parental/main.dart';

void main() {
  testWidgets('App inicializa correctamente', (WidgetTester tester) async {
    // Usamos ProviderScope y SleepDomeApp
    await tester.pumpWidget(const ProviderScope(child: SleepDomeApp()));
    
    // Verificamos que al menos la estructura base carga
    expect(find.text('Inicio'), findsWidgets);
  });
}