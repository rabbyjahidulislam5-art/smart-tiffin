import 'package:st_domain/st_domain.dart';

/// Texts of NA-05 (admin-web/ADMIN_DASHBOARD.md; conflict register C-06).
abstract final class AccountsOversightText {
  static const eyebrow = StText('Operations', 'অপারেশনস');
  static const title = StText('Accounts oversight', 'অ্যাকাউন্টস তদারকি');
  static const intro = StText(
    'Approved non-sensitive indicators only. Balances, ledger, payout and credit detail belong to the accounting workspace and are not shown to Admin.',
    'শুধু অনুমোদিত অ-সংবেদনশীল সূচক। ব্যালেন্স, লেজার, পেআউট ও ক্রেডিটের বিস্তারিত অ্যাকাউন্টিং ওয়ার্কস্পেসের, অ্যাডমিনকে দেখানো হয় না।',
  );
  static const volume = StText('Order volume trend', 'অর্ডারের প্রবণতা');
  static const volumeValue = StText(
    '{0}% vs last period',
    'আগের পিরিয়ডের তুলনায় {0}%',
  );
  static const collection = StText('Collection rate', 'আদায়ের হার');
  static const percent = StText('{0}%', '{0}%');
  static const exceptions = StText(
    'Open payment exceptions',
    'খোলা পেমেন্ট ব্যতিক্রম',
  );
  static const payouts = StText(
    'Payout requests waiting',
    'অপেক্ষমাণ পেআউট অনুরোধ',
  );
  static const period = StText('Accounting period', 'হিসাবের পিরিয়ড');
  static const periodOpen = StText('Open', 'খোলা');
  static const periodClosing = StText('Closing', 'বন্ধ হচ্ছে');
  static const periodClosed = StText('Closed', 'বন্ধ');
  static const periodReopened = StText('Reopened', 'পুনরায় খোলা');
  static const noAuthority = StText(
    'Admin has no payout or settlement authority. Counts are shown so operations can follow up, not to act on money.',
    'অ্যাডমিনের পেআউট বা নিষ্পত্তির কোনো ক্ষমতা নেই। অপারেশনস যেন খোঁজ নিতে পারে তাই সংখ্যা দেখানো হয়, টাকা নিয়ে কাজের জন্য নয়।',
  );

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'intro': intro,
    'volume': volume,
    'volumeValue': volumeValue,
    'collection': collection,
    'percent': percent,
    'exceptions': exceptions,
    'payouts': payouts,
    'period': period,
    'periodOpen': periodOpen,
    'periodClosing': periodClosing,
    'periodClosed': periodClosed,
    'periodReopened': periodReopened,
    'noAuthority': noAuthority,
  };
}
