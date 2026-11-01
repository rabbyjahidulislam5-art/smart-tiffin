import 'package:flutter/material.dart';
import 'package:st_shell/st_shell.dart';

import '../features/incident_dispatch/screens/incident_dispatch_text.dart';
import '../features/verification_queue/screens/verification_queue_text.dart';

import '../features/credit_and_refunds/screens/credit_and_refunds_text.dart';

// Host entry text imports

/// Entry controls added to Built host screens (LC-11). The registry wraps a
/// host in `StHostEntries`; the host files are not edited. A-01 reaches
/// NA-01 through its patched "Command centre" button (DN-2).
const adminAccountingHostEntries = <String, List<StHostEntry>>{
  'A-06': [
    StHostEntry(
      id: 'NA-03',
      label: VerificationQueueText.title,
      icon: Icons.how_to_reg_outlined,
    ),
  ],
  'A-07': [
    StHostEntry(
      id: 'NA-03',
      label: VerificationQueueText.title,
      icon: Icons.how_to_reg_outlined,
      forward: ['id'],
    ),
  ],
  'A-03': [
    StHostEntry(
      id: 'NA-04',
      label: IncidentDispatchText.title,
      icon: Icons.alt_route_rounded,
    ),
  ],
  'A-04': [
    StHostEntry(
      id: 'NA-04',
      label: IncidentDispatchText.title,
      icon: Icons.alt_route_rounded,
    ),
  ],
  'NF-10': [
    StHostEntry(
      id: 'NF-16',
      label: CreditAndRefundsText.adjTitle,
      icon: Icons.rule_folder_outlined,
    ),
  ],
  // New_Screen hosts
};
