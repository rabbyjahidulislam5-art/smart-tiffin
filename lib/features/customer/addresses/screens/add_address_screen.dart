import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class AddAddressScreen extends ConsumerStatefulWidget {
  const AddAddressScreen({super.key});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  final label = TextEditingController(text: 'Home');
  final line = TextEditingController();
  final note = TextEditingController();
  var kind = 'home';
  String? err;

  @override
  void dispose() {
    label.dispose();
    line.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;

    return StScreen(
      title: t('Add address', 'ঠিকানা যোগ'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StNote(child: Text(t('Pin will be confirmed on the map in production.', 'প্রোডাকশনে ম্যাপে পিন নিশ্চিত হবে।'))),
          ),
          const SizedBox(height: 12),
          AppReveal(
            index: 1,
            child: Container(
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.place_rounded, color: role, size: 32),
                  const SizedBox(height: 6),
                  Text(t('Map preview (sample)', 'ম্যাপ প্রিভিউ (নমুনা)'), style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          AppReveal(
            index: 2,
            child: StSegmented(
              value: kind,
              onChanged: (v) {
                setState(() {
                  kind = v;
                  label.text = v == 'home' ? 'Home' : (v == 'office' ? 'Office' : 'Other');
                });
              },
              options: [
                (v: 'home', l: t('Home', 'বাসা')),
                (v: 'office', l: t('Office', 'অফিস')),
                (v: 'other', l: t('Other', 'অন্য')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppReveal(index: 3, child: StField(label: t('Label', 'লেবেল'), controller: label, placeholder: t('Home / Office', 'বাসা / অফিস'))),
          const SizedBox(height: 12),
          AppReveal(index: 4, child: StField(label: t('Full address', 'পূর্ণ ঠিকানা'), controller: line, error: err, maxLines: 3, placeholder: t('House, road, area, city', 'বাড়ি, রোড, এলাকা, শহর'))),
          const SizedBox(height: 12),
          AppReveal(index: 5, child: StField(label: t('Delivery note', 'ডেলিভারি নোট'), controller: note, placeholder: t('Gate code, floor…', 'গেট কোড, ফ্লোর…'))),
          const SizedBox(height: 12),
          AppReveal(
            index: 6,
            child: Row(
              children: [
                Icon(Icons.place_rounded, size: 18, color: role),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(t('Sample pin · Banani, Dhaka', 'নমুনা পিন · বনানী, ঢাকা'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppReveal(
            index: 7,
            child: StBtn(
              label: t('Save address', 'ঠিকানা সংরক্ষণ'),
              full: true,
              size: StBtnSize.lg,
              onTap: () {
                if (line.text.trim().length < 8) {
                  setState(() => err = t('Enter a full address', 'পূর্ণ ঠিকানা দিন'));
                  return;
                }
                ctrl.toast(t('Address saved', 'ঠিকানা সংরক্ষিত'));
                ctrl.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}
