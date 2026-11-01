import 'package:flutter/material.dart';
import 'package:st_shell/st_shell.dart';

import '../features/supplier_earnings/screens/supplier_earnings_text.dart';

import '../features/kitchen_capacity/screens/capacity_text.dart';
import '../features/menu_pricing/screens/menu_pricing_text.dart';
import '../features/pickup_handoff/screens/handoff_text.dart';
import '../features/supplier_forecast/screens/forecast_text.dart';

import '../features/cod_collection/screens/cod_text.dart';
import '../features/delivery_disputes/screens/delivery_dispute_text.dart';
import '../features/rider_earnings/screens/rider_earnings_text.dart';

// Host entry text imports

/// Entry controls added to Built host screens (LC-11). The registry wraps a
/// host in `StHostEntries`; the host files are not edited.
const partnerHostEntries = <String, List<StHostEntry>>{
  'S-08': [
    StHostEntry(
      id: 'NS-01',
      label: SupplierEarningsText.title,
      icon: Icons.receipt_long_outlined,
    ),
    StHostEntry(
      id: 'NS-02',
      label: SupplierEarningsText.requestPayout,
      icon: Icons.payments_outlined,
    ),
    StHostEntry(
      id: 'NS-03',
      label: SupplierEarningsText.historyTitle,
      icon: Icons.history_rounded,
    ),
  ],
  'S-09': [
    StHostEntry(
      id: 'NS-03',
      label: SupplierEarningsText.historyTitle,
      icon: Icons.history_rounded,
    ),
  ],
  'S-01': [
    StHostEntry(
      id: 'NS-04',
      label: ForecastText.title,
      icon: Icons.insights_outlined,
    ),
  ],
  'S-07': [
    StHostEntry(
      id: 'NS-04',
      label: ForecastText.title,
      icon: Icons.insights_outlined,
    ),
  ],
  'S-04': [
    StHostEntry(
      id: 'NS-05',
      label: CapacityText.title,
      icon: Icons.tune_outlined,
    ),
  ],
  'S-05': [
    StHostEntry(
      id: 'NS-06',
      label: MenuPricingText.title,
      icon: Icons.sell_outlined,
    ),
  ],
  'S-03': [
    StHostEntry(
      id: 'NS-07',
      label: HandoffText.title,
      icon: Icons.handshake_outlined,
    ),
  ],
  'R-08': [
    StHostEntry(
      id: 'NR-01',
      label: RiderEarningsText.title,
      icon: Icons.receipt_long_outlined,
    ),
    StHostEntry(
      id: 'NR-02',
      label: RiderEarningsText.requestPayout,
      icon: Icons.payments_outlined,
    ),
    StHostEntry(
      id: 'NR-04',
      label: CodText.remitTitle,
      icon: Icons.upload_rounded,
    ),
    StHostEntry(
      id: 'NR-05',
      label: CodText.discrepancies,
      icon: Icons.rule_rounded,
    ),
  ],
  'R-01': [
    StHostEntry(
      id: 'NR-03',
      label: CodText.collectTitle,
      icon: Icons.local_atm_rounded,
      params: {'id': 'COD-913'},
    ),
    StHostEntry(
      id: 'NR-06',
      label: DeliveryDisputeText.title,
      icon: Icons.flag_outlined,
      params: {'delivery': 'DL-913'},
    ),
  ],
  'R-03': [
    StHostEntry(
      id: 'NR-03',
      label: CodText.collectTitle,
      icon: Icons.local_atm_rounded,
      params: {'id': 'COD-913'},
    ),
  ],
  // New_Screen hosts
};
