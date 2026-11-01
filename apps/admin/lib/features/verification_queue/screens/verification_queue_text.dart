import 'package:st_domain/st_domain.dart';

/// Texts of NA-03 (admin-web/APPROVAL_WORKFLOWS.md, application review).
abstract final class VerificationQueueText {
  static const eyebrow = StText('Operations', 'অপারেশনস');
  static const title = StText('Verification queue', 'যাচাইয়ের তালিকা');
  static const filterAll = StText('All', 'সব');
  static const pending = StText('Pending', 'অপেক্ষমাণ');
  static const infoRequested = StText('Info requested', 'তথ্য চাওয়া হয়েছে');
  static const approved = StText('Approved', 'অনুমোদিত');
  static const rejected = StText('Rejected', 'প্রত্যাখ্যাত');
  static const cook = StText('Cook', 'রাঁধুনি');
  static const rider = StText('Rider', 'রাইডার');
  static const submitted = StText('Submitted {0}', 'জমা {0}');
  static const empty = StText(
    'No applications with this status',
    'এই অবস্থার কোনো আবেদন নেই',
  );
  static const select = StText(
    'Select an application to review it.',
    'পর্যালোচনার জন্য একটি আবেদন বেছে নিন।',
  );
  static const checklist = StText('Checklist', 'চেকলিস্ট');
  static const identity = StText(
    'Identity verified (NID)',
    'পরিচয় যাচাই (এনআইডি)',
  );
  static const premises = StText(
    'Kitchen or vehicle checked',
    'কিচেন বা যানবাহন যাচাই',
  );
  static const compliance = StText(
    'Hygiene and compliance passed',
    'স্বাস্থ্যবিধি ও নিয়ম পূরণ',
  );
  static const approve = StText('Approve', 'অনুমোদন');
  static const approveReason = StText(
    'Tick every check first.',
    'আগে প্রতিটি চেক টিক দিন।',
  );
  static const requestInfo = StText('Request information', 'তথ্য চান');
  static const reject = StText('Reject', 'প্রত্যাখ্যান');
  static const decided = StText(
    'This application is decided.',
    'এই আবেদনের সিদ্ধান্ত হয়ে গেছে।',
  );
  static const commandName = StText(
    'Recording the decision',
    'সিদ্ধান্ত রেকর্ড',
  );
  static const approvedDone = StText(
    'Application approved.',
    'আবেদন অনুমোদিত হয়েছে।',
  );
  static const infoDone = StText(
    'Information requested from the applicant.',
    'আবেদনকারীর কাছে তথ্য চাওয়া হয়েছে।',
  );
  static const rejectedDone = StText(
    'Application rejected.',
    'আবেদন প্রত্যাখ্যাত হয়েছে।',
  );
  static const infoTitle = StText('Request information', 'তথ্য চান');
  static const rejectTitle = StText(
    'Reject the application',
    'আবেদন প্রত্যাখ্যান',
  );
  static const reasonBody = StText(
    'The applicant sees this reason. Write at least 10 characters.',
    'আবেদনকারী এই কারণ দেখবেন। অন্তত ১০ অক্ষর লিখুন।',
  );
  static const reason = StText('Reason: {0}', 'কারণ: {0}');
  static const audit = StText(
    'Every decision is recorded in the audit log.',
    'প্রতিটি সিদ্ধান্ত অডিট লগে রেকর্ড হয়।',
  );

  static const all = <String, StText>{
    'eyebrow': eyebrow,
    'title': title,
    'filterAll': filterAll,
    'pending': pending,
    'infoRequested': infoRequested,
    'approved': approved,
    'rejected': rejected,
    'cook': cook,
    'rider': rider,
    'submitted': submitted,
    'empty': empty,
    'select': select,
    'checklist': checklist,
    'identity': identity,
    'premises': premises,
    'compliance': compliance,
    'approve': approve,
    'approveReason': approveReason,
    'requestInfo': requestInfo,
    'reject': reject,
    'decided': decided,
    'commandName': commandName,
    'approvedDone': approvedDone,
    'infoDone': infoDone,
    'rejectedDone': rejectedDone,
    'infoTitle': infoTitle,
    'rejectTitle': rejectTitle,
    'reasonBody': reasonBody,
    'reason': reason,
    'audit': audit,
  };
}
