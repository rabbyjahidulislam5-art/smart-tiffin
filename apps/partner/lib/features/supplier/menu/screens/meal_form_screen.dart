import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class MealFormScreen extends ConsumerStatefulWidget {
  const MealFormScreen({super.key});
  @override
  ConsumerState<MealFormScreen> createState() => _MealFormScreenState();
}
class _MealFormScreenState extends ConsumerState<MealFormScreen> {
  late final TextEditingController en;
  late final TextEditingController bn;
  late final TextEditingController price;
  late final TextEditingController qty;
  Map<String, String> e = {};
  Meal? m;
  @override
  void initState() {
    super.initState();
    final id = ref.read(appProvider).current.params['id'];
    m = id == null ? null : mealById(id);
    en = TextEditingController(text: m?.en ?? '');
    bn = TextEditingController(text: m?.bn ?? '');
    price = TextEditingController(text: m == null ? '' : '${m!.price}');
    qty = TextEditingController(text: m == null ? '' : '20');
  }
  @override
  void dispose() { en.dispose(); bn.dispose(); price.dispose(); qty.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;
    void save() {
      final x = <String, String>{};
      if (en.text.trim().isEmpty) x['en'] = t('Name required', 'নাম প্রয়োজন');
      if (!(num.tryParse(price.text) != null && num.parse(price.text) > 0)) x['price'] = t('Enter a price', 'দাম দিন');
      if (!(num.tryParse(qty.text) != null && num.parse(qty.text) > 0)) x['qty'] = t('Enter portions', 'পোর্শন দিন');
      setState(() => e = x);
      if (x.isEmpty) { ctrl.toast(m != null ? t('Meal updated', 'খাবার আপডেট') : t('Meal added', 'খাবার যোগ হয়েছে')); ctrl.back(); }
    }
    return StScreen(
      title: m != null ? t('Edit meal', 'খাবার এডিট') : t('Add meal', 'খাবার যোগ'),
      states: false,
      footer: StBtn(label: t('Save meal', 'সংরক্ষণ'), full: true, size: StBtnSize.lg, onTap: save),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (m != null)
          ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset(m!.img, height: 160, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 160, color: Theme.of(context).dividerColor)))
        else
          InkWell(onTap: () => ctrl.toast(t('Photo picker (sample)', 'ছবি নির্বাচন (নমুনা)')), child: Container(height: 160, decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), border: Border.all(color: Theme.of(context).dividerColor, width: 2)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.photo_camera_outlined, color: Theme.of(context).hintColor), Text(t('Add photo', 'ছবি যোগ'), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Theme.of(context).hintColor))]))),
          AppReveal(
            index: 0,
            child: const SizedBox(height: 12),
          ),
          AppReveal(
            index: 1,
            child: StField(label: t('Name (English)', 'নাম (ইংরেজি)'), controller: en, error: e['en']),
          ),
          AppReveal(
            index: 2,
            child: const SizedBox(height: 12),
          ),
          AppReveal(
            index: 3,
            child: StField(label: t('Name (বাংলা)', 'নাম (বাংলা)'), controller: bn),
          ),
          AppReveal(
            index: 4,
            child: const SizedBox(height: 12),
          ),
          AppReveal(
            index: 5,
            child: Row(children: [
          Expanded(child: StField(label: t('Price (BDT)', 'দাম (টাকা)'), controller: price, keyboardType: TextInputType.number, error: e['price'])),
          const SizedBox(width: 12),
          Expanded(child: StField(label: t('Daily portions', 'দৈনিক পোর্শন'), controller: qty, keyboardType: TextInputType.number, error: e['qty'])),
        ]),
          ),
          AppReveal(
            index: 6,
            child: const SizedBox(height: 12),
          ),
          AppReveal(
            index: 7,
            child: Text(t('Available days', 'যে দিন পাওয়া যাবে'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          AppReveal(
            index: 8,
            child: const SizedBox(height: 8),
          ),
          AppReveal(
            index: 9,
            child: Row(children: [for (var i = 0; i < 7; i++) Expanded(child: Container(height: 36, margin: const EdgeInsets.symmetric(horizontal: 2), alignment: Alignment.center, decoration: BoxDecoration(color: i < 6 ? role : (Theme.of(context).brightness==Brightness.dark?StColors.darkMuted:StColors.muted), borderRadius: BorderRadius.circular(12)), child: Text(['S','M','T','W','T','F','S'][i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: i < 6 ? Colors.white : null))))]),
          ),
          if (m != null) ...[const SizedBox(height: 16), StBtn(label: t('Delete meal', 'খাবার মুছুন'), full: true, variant: StBtnVariant.ghost, onTap: () => ctrl.showConfirm(ConfirmOpts(title: t('Delete this meal?', 'খাবার মুছবেন?'), ok: t('Delete', 'মুছুন'), danger: true, onOk: () { ctrl.toast(t('Meal deleted', 'মুছে ফেলা হয়েছে')); ctrl.back(); })))],
        ]),
    );
  }
}
