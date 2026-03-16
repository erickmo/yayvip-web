import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../../../landing/presentation/widgets/responsive_layout.dart';
import '../../../landing/presentation/widgets/section_title.dart';
import '../cubits/donation_form_cubit.dart';
import '../cubits/donation_form_state.dart';
import '../widgets/donor_type_selector.dart';
import '../widgets/named_donor_form.dart';
import '../widgets/qr_code_display.dart';

final _c = ContentProvider.instance;

/// Section 2: Form donatur terdaftar atau donasi langsung (QR Code).
class DonationFormSection extends StatelessWidget {
  const DonationFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? AppDimensions.spacingL
            : AppDimensions.spacingXXL * 2,
        vertical: AppDimensions.spacingXXL * 1.5,
      ),
      child: Column(
        children: [
          SectionTitle(
            title: _c.getString('donation', 'form.title'),
            subtitle: _c.getString('donation', 'form.subtitle'),
          ),
          const SizedBox(height: AppDimensions.spacingXXL),
          // Main content area
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: BlocBuilder<DonationFormCubit, DonationFormState>(
              builder: (context, state) {
                return Column(
                  children: [
                    // Type selector
                    DonorTypeSelector(
                      selectedType: state.donorType,
                      onChanged: (type) {
                        context.read<DonationFormCubit>().setDonorType(type);
                      },
                    ),
                    const SizedBox(height: AppDimensions.spacingXL),
                    // Content based on type
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: state.donorType == DonorType.anonymous
                          ? _buildAnonymousDonation()
                          : _buildNamedDonation(context, state),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnonymousDonation() {
    return Container(
      key: const ValueKey('anonymous'),
      padding: const EdgeInsets.all(AppDimensions.spacingXL),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.divider),
      ),
      child: QrCodeDisplay(
        title: _c.getString('donation', 'form.anonymous_title'),
        description: _c.getString('donation', 'form.anonymous_desc'),
      ),
    );
  }

  Widget _buildNamedDonation(BuildContext context, DonationFormState state) {
    final cubit = context.read<DonationFormCubit>();

    if (state.formStep == DonationFormStep.showingQr) {
      return Container(
        key: const ValueKey('named-qr'),
        padding: const EdgeInsets.all(AppDimensions.spacingXL),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            // Donor info summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Column(
                children: [
                  Text(
                    'Donasi dari ${state.fullName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (state.activeAmount != null)
                    Text(
                      _formatRupiah(state.activeAmount!),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            QrCodeDisplay(
              title: _c.getString('donation', 'form.payment_title'),
              description: _c.getString('donation', 'form.payment_desc'),
              onBackPressed: cubit.backToForm,
            ),
          ],
        ),
      );
    }

    return Container(
      key: const ValueKey('named-form'),
      padding: const EdgeInsets.all(AppDimensions.spacingXL),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.divider),
      ),
      child: NamedDonorForm(
        fullName: state.fullName,
        email: state.email,
        phone: state.phone,
        selectedAmount: state.selectedAmount,
        customAmount: state.customAmount,
        errorMessage: state.errorMessage,
        onNameChanged: cubit.updateName,
        onEmailChanged: cubit.updateEmail,
        onPhoneChanged: cubit.updatePhone,
        onAmountSelected: cubit.selectAmount,
        onCustomAmountChanged: cubit.updateCustomAmount,
        onSubmit: cubit.submitForm,
      ),
    );
  }

  String _formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp$buffer';
  }
}
