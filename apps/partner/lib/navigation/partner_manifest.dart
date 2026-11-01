import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

import '../features/supplier_earnings/screens/supplier_earnings_text.dart';

import '../features/kitchen_capacity/screens/capacity_text.dart';
import '../features/menu_pricing/screens/menu_pricing_text.dart';
import '../features/pickup_handoff/screens/handoff_text.dart';
import '../features/supplier_forecast/screens/forecast_text.dart';

import '../features/cod_collection/screens/cod_text.dart';
import '../features/delivery_disputes/screens/delivery_dispute_text.dart';
import '../features/rider_earnings/screens/rider_earnings_text.dart';

// New_Screen text imports

/// `StScreenSpec` entries of the Partner app's New_Screens.
const partnerManifest = <StScreenSpec>[
  StScreenSpec(
    id: 'NS-01',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: SupplierEarningsText.title,
    source: 'design/screens/SUPPLIER_SCREENS.md NS-01; partner-app/SUPPLIER_EARNINGS.md',
    hosts: ['S-08'],
    links: ['NS-02', 'NS-03'],
  ),
  StScreenSpec(
    id: 'NS-02',
    form: StScreenForm.fullScreen,
    states: {StVariant.loading, StVariant.error, StVariant.offline},
    anchor: SupplierEarningsText.requestTitle,
    source: 'design/screens/SUPPLIER_SCREENS.md NS-02; partner-app/SUPPLIER_EARNINGS.md payout flow',
    connectedControls: {'requestPayout'},
    hosts: ['S-08'],
    links: ['NS-03'],
  ),
  StScreenSpec(
    id: 'NS-03',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: SupplierEarningsText.historyTitle,
    source: 'design/screens/SUPPLIER_SCREENS.md NS-03, S-09 rule',
    hosts: ['S-08', 'S-09'],
    links: ['NS-02'],
  ),
  StScreenSpec(
    id: 'NS-04',
    form: StScreenForm.section,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: ForecastText.title,
    source: 'design/screens/SUPPLIER_SCREENS.md NS-04; partner-app/SUPPLIER_MODULES.md M8',
    hosts: ['S-07', 'S-01'],
    links: ['NS-05'],
  ),
  StScreenSpec(
    id: 'NS-05',
    form: StScreenForm.section,
    states: {StVariant.loading, StVariant.error, StVariant.offline},
    anchor: CapacityText.title,
    source: 'design/screens/SUPPLIER_SCREENS.md NS-05; partner-app/SUPPLIER_MODULES.md M7',
    connectedControls: {'saveCapacity', 'setSlotAvailability'},
    hosts: ['S-04'],
  ),
  StScreenSpec(
    id: 'NS-06',
    form: StScreenForm.section,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: MenuPricingText.title,
    source: 'design/screens/SUPPLIER_SCREENS.md NS-06; partner-app/SUPPLIER_MODULES.md M6',
    connectedControls: {'schedulePriceChange'},
    hosts: ['S-05'],
  ),
  StScreenSpec(
    id: 'NS-07',
    form: StScreenForm.sheet,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: HandoffText.title,
    source: 'design/screens/SUPPLIER_SCREENS.md NS-07; partner-app/SUPPLIER_MODULES.md M9',
    connectedControls: {'recordHandoff'},
    hosts: ['S-03'],
  ),
  StScreenSpec(
    id: 'NR-01',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: RiderEarningsText.title,
    source:
        'design/screens/RIDER_SCREENS.md NR-01; partner-app/RIDER_EARNINGS.md',
    hosts: ['R-08'],
    links: ['NR-02', 'NR-04'],
  ),
  StScreenSpec(
    id: 'NR-02',
    form: StScreenForm.fullScreen,
    states: {StVariant.loading, StVariant.error, StVariant.offline},
    anchor: RiderEarningsText.payoutTitle,
    source: 'design/screens/RIDER_SCREENS.md NR-02; partner-app/RIDER_EARNINGS.md payout flow (BR-026)',
    connectedControls: {'requestPayout'},
    hosts: ['R-08'],
  ),
  StScreenSpec(
    id: 'NR-03',
    form: StScreenForm.sheet,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: CodText.collectTitle,
    source: 'design/screens/RIDER_SCREENS.md NR-03; partner-app/COD_COLLECTION.md section 1',
    connectedControls: {'recordCodCollection'},
    hosts: ['R-01', 'R-03'],
    links: ['NR-04'],
  ),
  StScreenSpec(
    id: 'NR-04',
    form: StScreenForm.fullScreen,
    states: {StVariant.loading, StVariant.error, StVariant.offline},
    anchor: CodText.remitTitle,
    source: 'design/screens/RIDER_SCREENS.md NR-04; partner-app/COD_COLLECTION.md section 2 (INV-12)',
    connectedControls: {'submitCodRemittance'},
    hosts: ['R-08'],
    links: ['NR-05'],
  ),
  StScreenSpec(
    id: 'NR-05',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: CodText.discrepancyTitle,
    source: 'design/screens/RIDER_SCREENS.md NR-05; partner-app/COD_COLLECTION.md section 3 (SC-09)',
    connectedControls: {'respondToDiscrepancy'},
    hosts: ['R-08', 'NR-04'],
  ),
  StScreenSpec(
    id: 'NR-06',
    form: StScreenForm.fullScreen,
    states: {
      StVariant.loading,
      StVariant.error,
      StVariant.empty,
      StVariant.offline,
    },
    anchor: DeliveryDisputeText.title,
    source: 'design/screens/RIDER_SCREENS.md NR-06; partner-app/RIDER_MODULES.md section 4 (SC-21)',
    connectedControls: {'reportDeliveryFailure'},
    hosts: ['R-01'],
    links: ['R-05'],
  ),
  // New_Screen specs
];

/// Text tables of the Partner app's new features (key-completeness test).
const partnerTextTables = <String, Map<String, StText>>{
  'supplier_earnings': SupplierEarningsText.all,
  'supplier_forecast': ForecastText.all,
  'kitchen_capacity': CapacityText.all,
  'menu_pricing': MenuPricingText.all,
  'pickup_handoff': HandoffText.all,
  'rider_earnings': RiderEarningsText.all,
  'cod_collection': CodText.all,
  'delivery_disputes': DeliveryDisputeText.all,
  // New_Screen texts
};
