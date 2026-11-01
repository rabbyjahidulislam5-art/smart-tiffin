import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_domain/st_domain.dart';

/// Today's service date as YYYY-MM-DD. In the mock phase it is the fixed
/// mock clock; a real backend supplies the server date (BR-022 cutoffs).
final todayProvider = Provider<String>((ref) => mockToday);
