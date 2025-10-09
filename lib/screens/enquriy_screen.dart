import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_beez/utils/app_colors.dart';


class PropertySummary {
  final String id, title, location, imageUrl;
  final double price;
  PropertySummary({
    required this.id,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.price,
  });
}

class Enquiry {
  final String name, email, phone, message, contactMethod, propertyId, locale;
  final TimeOfDay startTime, endTime;
  final double budgetMin, budgetMax;
  final bool consent;
  final DateTime timestamp;
  Enquiry({
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
    required this.contactMethod,
    required this.propertyId,
    required this.locale,
    required this.startTime,
    required this.endTime,
    required this.budgetMin,
    required this.budgetMax,
    required this.consent,
    required this.timestamp,
  });
}

class EnquiryResult {
  final bool success;
  final String? error;
  EnquiryResult({required this.success, this.error});
}

abstract class EnquiryRepository {
  Future<EnquiryResult> submitEnquiry(Enquiry enquiry);
}

class SubmitEnquiryUseCase {
  final EnquiryRepository repo;
  SubmitEnquiryUseCase(this.repo);
  Future<EnquiryResult> call(Enquiry e) => repo.submitEnquiry(e);
}

// =================== CONTROLLER ===================

class EnquiryController extends ChangeNotifier {
  final SubmitEnquiryUseCase useCase;
  EnquiryController(this.useCase);

  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final msg = TextEditingController();
  
  String contactMethod = 'Call';
  TimeOfDay? start, end;
  RangeValues budget = const RangeValues(20, 80);
  bool consent = false;
  bool loading = false;
  String? error;

  // Lightweight validation for UI state only
  bool get isValid {
    final nameOk = name.text.trim().length >= 2;
    final emailOk = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email.text.trim());
    final phoneOk = RegExp(r'^\+\d{8,15}$').hasMatch(phone.text.trim());
    final msgOk = msg.text.trim().length >= 10;
    return nameOk && emailOk && phoneOk && msgOk && consent && start != null && end != null;
  }

  void updateContactMethod(String method) {
    contactMethod = method;
    notifyListeners();
  }

  void updateStartTime(TimeOfDay time) {
    start = time;
    notifyListeners();
  }

  void updateEndTime(TimeOfDay time) {
    end = time;
    notifyListeners();
  }

  void updateBudget(RangeValues newBudget) {
    budget = newBudget;
    notifyListeners();
  }

  void updateConsent(bool value) {
    consent = value;
    notifyListeners();
  }

  Future<void> submit(String propertyId, Locale locale) async {
    if (!isValid) return;
    loading = true;
    error = null;
    notifyListeners();
    final enquiry = Enquiry(
      name: name.text,
      email: email.text,
      phone: phone.text,
      message: msg.text,
      contactMethod: contactMethod,
      propertyId: propertyId,
      locale: locale.languageCode,
      startTime: start!,
      endTime: end!,
      budgetMin: budget.start,
      budgetMax: budget.end,
      consent: consent,
      timestamp: DateTime.now(),
    );
    final result = await useCase(enquiry);
    loading = false;
    error = result.success ? null : result.error ?? 'Submission failed';
    notifyListeners();
  }
}

// =================== PRESENTATION ===================

class EnquiryScreen extends StatefulWidget {
  final String propertyId;
  final PropertySummary summary;
  final VoidCallback onViewDetails, onBackToListing;
  final EnquiryController controller;

  const EnquiryScreen({
    super.key,
    required this.propertyId,
    required this.summary,
    required this.controller,
    required this.onViewDetails,
    required this.onBackToListing,
  });

  @override
  State<EnquiryScreen> createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends State<EnquiryScreen> {
  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECD9),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Form(
              key: c.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(summary: widget.summary, onTap: widget.onViewDetails),
                    const SizedBox(height: 20),
                    
                    // Text fields - completely isolated from controller rebuilds
                    _NameField(controller: c.name),
                    _EmailField(controller: c.email),
                    _PhoneField(controller: c.phone),
                    _MessageField(controller: c.msg),
                    
                    const SizedBox(height: 10),
                    
                    // Only reactive widgets listen to controller
                    _ReactiveSection(controller: c),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _LoadingOverlay(controller: c),
          ],
        ),
      ),
    );
  }
}

// =================== ISOLATED TEXT FIELD WIDGETS ===================

class _NameField extends StatelessWidget {
  final TextEditingController controller;
  const _NameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          labelText: 'Full Name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (v) {
          final value = v?.trim() ?? '';
          if (value.isEmpty) return 'Enter valid name';
          if (value.length < 2) return 'Enter valid name';
          return null;
        },
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        decoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (v) {
          final value = v?.trim() ?? '';
          if (value.isEmpty) return 'Invalid email';
          final emailRe = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
          return emailRe.hasMatch(value) ? null : 'Invalid email';
        },
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[+\d]'))],
        decoration: InputDecoration(
          labelText: 'Phone (+CountryCode)',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (v) {
          final value = v?.trim() ?? '';
          if (value.isEmpty) return 'Invalid phone';
          final phoneRe = RegExp(r'^\+\d{8,15}$');
          return phoneRe.hasMatch(value) ? null : 'Invalid phone';
        },
      ),
    );
  }
}

class _MessageField extends StatelessWidget {
  final TextEditingController controller;
  const _MessageField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          labelText: 'Message',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (v) {
          final value = v?.trim() ?? '';
          if (value.length < 10) return 'Min 10 chars';
          return null;
        },
      ),
    );
  }
}

// =================== REACTIVE SECTION ===================

class _ReactiveSection extends StatelessWidget {
  final EnquiryController controller;
  const _ReactiveSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ContactSelector(c: controller),
            const SizedBox(height: 10),
            _TimeWindow(c: controller),
            const SizedBox(height: 10),
            Text('Budget Range (₹${controller.budget.start.toInt()}L - ₹${controller.budget.end.toInt()}L)',
                style: Theme.of(context).textTheme.bodyMedium),
            RangeSlider(
              values: controller.budget,
              min: 0,
              max: 200,
              divisions: 40,
              labels: RangeLabels(
                  '${controller.budget.start.toInt()}L', '${controller.budget.end.toInt()}L'),
              onChanged: (v) => controller.updateBudget(v),
            ),
            Row(
              children: [
                Checkbox(
                    value: controller.consent,
                    onChanged: (v) => controller.updateConsent(v ?? false)),
                const Text("I agree to be contacted"),
              ],
            ),
            const SizedBox(height: 10),
            if (controller.error != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8)),
                child: Text(controller.error!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (!controller.loading && controller.isValid)
                    ? () async {
                        if (!(controller.formKey.currentState?.validate() ?? false)) return;
                        await controller.submit('propertyId', Localizations.localeOf(context));
                        if (controller.error == null && !controller.loading) {
                          // Show success sheet
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.beeYellow,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(controller.loading ? 'Submitting...' : 'Submit Enquiry',
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }
}

// =================== LOADING OVERLAY ===================

class _LoadingOverlay extends StatelessWidget {
  final EnquiryController controller;
  const _LoadingOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return controller.loading
            ? Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(child: CircularProgressIndicator()),
              )
            : const SizedBox.shrink();
      },
    );
  }
}

// =================== EXISTING WIDGETS (UNCHANGED) ===================

class _Header extends StatelessWidget {
  final PropertySummary summary;
  final VoidCallback onTap;
  const _Header({required this.summary, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 4, offset: const Offset(0, 2))
        ]),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
              child: SizedBox(
                width: 90,
                height: 90,
                child: summary.imageUrl.startsWith('assets/')
                    ? Image.asset(summary.imageUrl, fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                              child: const Icon(Icons.error, color: Colors.grey),
                            ))
                    : Image.network(summary.imageUrl, fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                              child: const Icon(Icons.error, color: Colors.grey),
                            )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(summary.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  Text(summary.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey)),
                  Text('₹${summary.price.toStringAsFixed(0)} Lakh',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ContactSelector extends StatelessWidget {
  final EnquiryController c;
  const _ContactSelector({required this.c});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: ['Call', 'WhatsApp', 'Email']
          .map((m) => ChoiceChip(
                label: Text(m),
                selected: c.contactMethod == m,
                onSelected: (_) => c.updateContactMethod(m),
              ))
          .toList(),
    );
  }
}

class _TimeWindow extends StatelessWidget {
  final EnquiryController c;
  const _TimeWindow({required this.c});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _timeBtn(context, 'Start', c.start, (t) => c.updateStartTime(t)),
        const SizedBox(width: 12),
        _timeBtn(context, 'End', c.end, (t) => c.updateEndTime(t)),
      ],
    );
  }

  Widget _timeBtn(BuildContext ctx, String label, TimeOfDay? time,
      ValueChanged<TimeOfDay> onPick) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          final picked = await showTimePicker(context: ctx, initialTime: TimeOfDay.now());
          if (picked != null) onPick(picked);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(time != null ? time.format(ctx) : label),
      ),
    );
  }
}

// ignore: unused_element
class _SuccessSheet extends StatelessWidget {
  final VoidCallback onBack, onView;
  const _SuccessSheet({required this.onBack, required this.onView});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 60),
        const SizedBox(height: 10),
        const Text("Enquiry Sent Successfully!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: OutlinedButton(onPressed: onBack, child: const Text("Back to Listing"))),
            const SizedBox(width: 12),
            Expanded(
                child: ElevatedButton(
                    onPressed: onView,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white),
                    child: const Text("View Property"))),
          ],
        ),
        const SizedBox(height: 10),
      ]),
    );
  }
}

// =================== MOCK REPOSITORY SAMPLE ===================

class MockEnquiryRepository implements EnquiryRepository {
  @override
  Future<EnquiryResult> submitEnquiry(Enquiry e) async {
    await Future.delayed(const Duration(seconds: 2));
    if (e.name.toLowerCase().contains('fail')) {
      return EnquiryResult(success: false, error: "Network error, try again");
    }
    return EnquiryResult(success: true);
  }
}

void main() {
  final repo = MockEnquiryRepository();
  final controller = EnquiryController(SubmitEnquiryUseCase(repo));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EnquiryScreen(
      propertyId: 'P101',
      summary: PropertySummary(
          id: 'P101',
          title: '2BHK Apartment in Koramangala',
          location: 'Bangalore',
          imageUrl:
              'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=500',
          price: 75),
      controller: controller,
      onViewDetails: () {},
      onBackToListing: () {},
    ),
  ));
}