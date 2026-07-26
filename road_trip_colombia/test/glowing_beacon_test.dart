import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:road_trip_colombia/ui/commons/beacon/glowing_beacon.dart';

void main() {
  testWidgets('GlowingBeacon renders both states without errors',
      (tester) async {
    for (final state in BeaconState.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlowingBeacon(state: state),
          ),
        ),
      );

      expect(find.byType(GlowingBeacon), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(milliseconds: 700));

      expect(tester.takeException(), isNull);
    }
  });
}
