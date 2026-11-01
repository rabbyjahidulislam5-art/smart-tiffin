import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_shell/st_shell.dart';

class AddressesScreen extends ConsumerStatefulWidget {
  const AddressesScreen({super.key});

  @override
  ConsumerState<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends ConsumerState<AddressesScreen> {
  var list = <({String labelEn, String labelBn, String line, IconData icon})>[
    (labelEn: 'Home', labelBn: 'বাসা', line: 'House 42, Road 11, Block D, Banani', icon: Icons.home_rounded),
    (labelEn: 'Office', labelBn: 'অফিস', line: 'Navana Tower, Gulshan 1', icon: Icons.apartment_rounded),
    (labelEn: 'Parents', labelBn: 'বাবা-মা', line: 'Road 27, Dhanmondi', icon: Icons.family_restroom_rounded),
  ];
  int primary = 0;

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(appProvider.notifier);
    final t = ref.watch(appProvider).t;
    final role = context.roleColor;

    return StScreen(
      title: t('Saved addresses', 'সংরক্ষিত ঠিকানা'),
      actions: [StIconBtn(icon: Icons.add_rounded, label: t('Add', 'যোগ'), onTap: () => ctrl.go('C-03'))],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StNote(child: Text(t('Primary address is used for lunch & dinner by default.', 'প্রাথমিক ঠিকানা লাঞ্চ ও ডিনারের জন্য ব্যবহৃত হয়।'))),
          ),
          const SizedBox(height: 12),
          if (list.isEmpty)
            AppReveal(
              index: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(t('No saved addresses yet', 'এখনো কোনো ঠিকানা নেই'), textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).hintColor)),
              ),
            )
          else
            for (var i = 0; i < list.length; i++)
              AppReveal(
                index: i + 1,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: StCard(
                    onTap: () => setState(() => primary = i),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(color: role.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
                          child: Icon(list[i].icon, color: role),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(child: Text(t(list[i].labelEn, list[i].labelBn), style: const TextStyle(fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                  if (primary == i) ...[
                                    const SizedBox(width: 6),
                                    StChip(tone: StTone.role, child: Text(t('Primary', 'প্রাথমিক'))),
                                  ],
                                ],
                              ),
                              Text(list[i].line, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor, height: 1.3)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: StColors.danger),
                          onPressed: () {
                            final idx = i;
                            ctrl.showConfirm(
                              ConfirmOpts(
                                title: t('Delete address?', 'ঠিকানা মুছবেন?'),
                                body: list[idx].line,
                                ok: t('Delete', 'মুছুন'),
                                danger: true,
                                onOk: () => setState(() {
                                  list = [...list]..removeAt(idx);
                                  if (primary >= list.length) primary = list.isEmpty ? 0 : list.length - 1;
                                }),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          AppReveal(
            index: list.length + 1,
            child: StBtn(
              label: t('Add address', 'ঠিকানা যোগ'),
              full: true,
              size: StBtnSize.lg,
              icon: Icons.add_rounded,
              onTap: () => ctrl.go('C-03'),
            ),
          ),
        ],
      ),
    );
  }
}
