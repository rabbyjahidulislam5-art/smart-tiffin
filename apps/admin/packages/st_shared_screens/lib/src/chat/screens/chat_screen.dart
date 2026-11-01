import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:st_design_system/st_design_system.dart';
import 'package:st_domain/st_domain.dart';
import 'package:st_shell/st_shell.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _c = TextEditingController();
  final msgs = <(bool me, String text)>[
    (false, 'Hi — how can we help with your order?'),
    (true, 'Rider seems delayed for lunch.'),
    (false, "We're checking live GPS. ETA ~11 min."),
  ];

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appProvider);
    final ctrl = ref.read(appProvider.notifier);
    final t = s.t;
    final who = s.current.params['who'] ?? 'Support';
    final role = context.roleColor;
    return StScreen(
      title: who,
      actions: [
        StIconBtn(
          icon: Icons.phone,
          label: 'Call',
          onTap: () => ctrl.showConfirm(
            ConfirmOpts(
              title: t('Call $who?', '$who-কে কল?'),
              body: '+880 96•• (demo)',
              ok: t('Call', 'কল'),
              onOk: () => ctrl.toast(t('Calling…', 'কল হচ্ছে…')),
            ),
          ),
        ),
      ],
      footer: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _c,
              decoration: InputDecoration(
                hintText: t('Message…', 'বার্তা…'),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(99), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 8),
          StIconBtn(icon: Icons.send, label: 'Send', bg: role, fg: Colors.white, onTap: _send),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppReveal(
            index: 0,
            child: StCard(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      meals[1].img,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 44, height: 44, color: StColors.muted),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t('Related · #TK-911 lunch', 'সম্পর্কিত · #TK-911 লাঞ্চ'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        Text(t(meals[1].en, meals[1].bn), style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  if (ref.watch(shellConfigProvider).knows('C-17')) StBtn(label: t('Order', 'অর্ডার'), size: StBtnSize.sm, variant: StBtnVariant.soft, onTap: () => ctrl.go('C-17', {'id': 'TK-911'})),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < msgs.length; i++)
            AppReveal(
              index: i + 1,
              child: Align(
                alignment: msgs[i].$1 ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
                  decoration: BoxDecoration(
                    color: msgs[i].$1 ? role : (Theme.of(context).brightness == Brightness.dark ? StColors.darkMuted : StColors.muted),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(msgs[i].$2, style: TextStyle(color: msgs[i].$1 ? Colors.white : null, fontWeight: FontWeight.w500)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _send() {
    if (_c.text.trim().isEmpty) return;
    setState(() {
      msgs.add((true, _c.text.trim()));
      _c.clear();
    });
  }
}
