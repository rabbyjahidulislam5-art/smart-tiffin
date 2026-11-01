import 'package:st_domain/st_domain.dart';

/// Texts of the Partner app hand-off (CUSTOMER_PUBLIC_AND_AUTH_SCREENS.md 2.3).
abstract final class PartnerHandoffText {
  static const title = StText('Apply in the Partner app', 'পার্টনার অ্যাপে আবেদন করুন');
  static const supplierBody = StText(
    'Kitchen applications are made in the Smart Tiffin Partner app. An admin reviews every application, and kitchen work stays locked until it is approved.',
    'কিচেনের আবেদন স্মার্ট টিফিন পার্টনার অ্যাপে করতে হয়। প্রতিটি আবেদন অ্যাডমিন যাচাই করেন, অনুমোদনের আগে কিচেনের কাজ বন্ধ থাকে।',
  );
  static const riderBody = StText(
    'Rider applications are made in the Smart Tiffin Partner app. An admin reviews every application, and deliveries stay locked until it is approved.',
    'রাইডারের আবেদন স্মার্ট টিফিন পার্টনার অ্যাপে করতে হয়। প্রতিটি আবেদন অ্যাডমিন যাচাই করেন, অনুমোদনের আগে ডেলিভারি বন্ধ থাকে।',
  );
  static const open = StText('Open the Partner app', 'পার্টনার অ্যাপ খুলুন');

  static const all = <String, StText>{
    'title': title,
    'supplierBody': supplierBody,
    'riderBody': riderBody,
    'open': open,
  };
}
