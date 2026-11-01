import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';

/// Latency and failure injection for every mock repository of the app.
/// Tests override it with `MockBehavior.instant()`.
final mockBehaviorProvider = Provider<MockBehavior>((ref) => MockBehavior());
