import 'package:st_domain/st_domain.dart';

/// Localized message for every [RepoErrorKind]. No exception text ever
/// reaches the screen (requirement 11.4).
abstract final class StErrorText {
  static const loadFailed = StText('Could not load. Try again.', 'লোড করা যায়নি। আবার চেষ্টা করুন।');
  static const unavailable = StText('This is no longer available.', 'এটি আর পাওয়া যাচ্ছে না।');
  static const unavailableSub = StText(
    'It may have been removed or you may not be able to view it.',
    'এটি সরানো হতে পারে বা আপনি এটি দেখতে পারবেন না।',
  );
  static const retry = StText('Retry', 'আবার চেষ্টা');
  static const back = StText('Back', 'ফিরে যান');
  static const commandFailed = StText(
    '{0} did not go through. Your entries are kept.',
    '{0} সম্পন্ন হয়নি। আপনার তথ্য রাখা আছে।',
  );

  static StText message(RepoErrorKind kind) => switch (kind) {
        RepoErrorKind.unauthenticated => const StText('Sign in to continue.', 'চালিয়ে যেতে সাইন ইন করুন।'),
        RepoErrorKind.permissionDenied => unavailable,
        RepoErrorKind.invalidInput => const StText('Check the highlighted field.', 'চিহ্নিত ঘরটি দেখুন।'),
        RepoErrorKind.policyNotConfigured => const StText('Not yet configured.', 'এখনো নির্ধারণ করা হয়নি।'),
        RepoErrorKind.businessRuleRejected =>
          const StText('This is not allowed by the current rules.', 'বর্তমান নিয়মে এটি অনুমোদিত নয়।'),
        RepoErrorKind.conflict => const StText(
            'A newer version is available. Review it and apply your changes again.',
            'নতুন সংস্করণ আছে। দেখে আবার পরিবর্তন করুন।',
          ),
        RepoErrorKind.notAvailable => unavailable,
        RepoErrorKind.rateLimited =>
          const StText('Too many tries. Try again shortly.', 'অনেকবার চেষ্টা হয়েছে। একটু পরে চেষ্টা করুন।'),
        RepoErrorKind.temporarilyUnavailable => loadFailed,
        RepoErrorKind.outcomeUnknown => const StText('We are checking the result.', 'ফলাফল যাচাই করা হচ্ছে।'),
        RepoErrorKind.internalError => const StText('Something went wrong.', 'কিছু ভুল হয়েছে।'),
      };

  /// True when the error offers Retry (not for neutral or rule outcomes).
  static bool canRetry(RepoErrorKind kind) => switch (kind) {
        RepoErrorKind.temporarilyUnavailable ||
        RepoErrorKind.internalError ||
        RepoErrorKind.rateLimited ||
        RepoErrorKind.outcomeUnknown =>
          true,
        _ => false,
      };

  /// True when the error must show the neutral unavailable panel (5.8).
  static bool isUnavailable(RepoErrorKind kind) =>
      kind == RepoErrorKind.notAvailable || kind == RepoErrorKind.permissionDenied;
}
