import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/content/content_provider.dart';
import '../../../donation/presentation/widgets/qr_code_display.dart';
import '../../../landing/presentation/widgets/responsive_layout.dart';
import '../../../landing/presentation/widgets/section_title.dart';
import '../cubits/scholarship_form_cubit.dart';
import '../cubits/scholarship_form_state.dart';

final _c = ContentProvider.instance;

/// Section 4: Form daftar beasiswa atau donasi langsung (QR Code).
class ScholarshipFormSection extends StatelessWidget {
  const ScholarshipFormSection({super.key});

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
            title: _c.getString('scholarship', 'form.title'),
            subtitle: _c.getString('scholarship', 'form.subtitle'),
          ),
          const SizedBox(height: AppDimensions.spacingXXL),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: BlocBuilder<ScholarshipFormCubit, ScholarshipFormState>(
              builder: (context, state) {
                return Column(
                  children: [
                    // Tab selector
                    _TabSelector(
                      selectedType: state.tabType,
                      onChanged: (type) {
                        context
                            .read<ScholarshipFormCubit>()
                            .setTabType(type);
                      },
                    ),
                    const SizedBox(height: AppDimensions.spacingXL),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: state.tabType == ScholarshipTabType.donate
                          ? _buildDonateSection()
                          : _buildApplySection(context, state),
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

  Widget _buildDonateSection() {
    return Container(
      key: const ValueKey('donate'),
      padding: const EdgeInsets.all(AppDimensions.spacingXL),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.divider),
      ),
      child: QrCodeDisplay(
        title: _c.getString('scholarship', 'form.donate_title'),
        description: _c.getString('scholarship', 'form.donate_desc'),
      ),
    );
  }

  Widget _buildApplySection(
      BuildContext context, ScholarshipFormState state) {
    if (state.status == ScholarshipFormStatus.success) {
      return Container(
        key: const ValueKey('success'),
        padding: const EdgeInsets.all(AppDimensions.spacingXXL),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  size: 48, color: AppColors.success),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            const Text(
              'Pendaftaran Berhasil!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              _c.getString('scholarship', 'form.success_message'),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            OutlinedButton.icon(
              onPressed: () =>
                  context.read<ScholarshipFormCubit>().reset(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Daftar Lagi'),
            ),
          ],
        ),
      );
    }

    final cubit = context.read<ScholarshipFormCubit>();
    final educationOptions = _c.getStringList('scholarship', 'form.education_options');
    final programItems = _c.getMapList('scholarship', 'programs.items');
    final programNames = programItems.map((p) => (p['name'] ?? '').toString()).toList();

    return Container(
      key: const ValueKey('apply-form'),
      padding: const EdgeInsets.all(AppDimensions.spacingXL),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: Nama + Email
          _buildField(
            label: AppStrings.scholarshipFormFullName,
            icon: Icons.person_outlined,
            onChanged: cubit.updateName,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          _buildField(
            label: AppStrings.scholarshipFormEmail,
            icon: Icons.email_outlined,
            onChanged: cubit.updateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          // Row 2: Telepon + Usia
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildField(
                  label: AppStrings.scholarshipFormPhone,
                  icon: Icons.phone_outlined,
                  onChanged: cubit.updatePhone,
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                flex: 1,
                child: _buildField(
                  label: AppStrings.scholarshipFormAge,
                  icon: Icons.cake_outlined,
                  onChanged: cubit.updateAge,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          // Pendidikan dropdown
          DropdownButtonFormField<String>(
            decoration: _inputDecoration(
              AppStrings.scholarshipFormEducation,
              Icons.school_outlined,
            ),
            items: educationOptions
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              if (val != null) cubit.updateEducation(val);
            },
          ),
          const SizedBox(height: AppDimensions.spacingM),
          // Program dropdown
          DropdownButtonFormField<String>(
            decoration: _inputDecoration(
              AppStrings.scholarshipFormProgram,
              Icons.work_outline_rounded,
            ),
            items: programNames
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              if (val != null) cubit.updateProgram(val);
            },
          ),
          const SizedBox(height: AppDimensions.spacingM),
          // Motivasi
          TextFormField(
            maxLines: 4,
            onChanged: cubit.updateMotivation,
            decoration: _inputDecoration(
              AppStrings.scholarshipFormMotivation,
              Icons.edit_note_rounded,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          // Error message
          if (state.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(
                          color: AppColors.error, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
          ],
          // Submit
          ElevatedButton.icon(
            onPressed: state.status == ScholarshipFormStatus.submitting
                ? null
                : cubit.submitForm,
            icon: state.status == ScholarshipFormStatus.submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.send_rounded),
            label: Text(
              state.status == ScholarshipFormStatus.submitting
                  ? 'Mengirim...'
                  : _c.getString('scholarship', 'form.submit_label'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required IconData icon,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: _inputDecoration(label, icon),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingM,
      ),
    );
  }
}

/// Toggle tab daftar beasiswa / donasi.
class _TabSelector extends StatelessWidget {
  final ScholarshipTabType selectedType;
  final ValueChanged<ScholarshipTabType> onChanged;

  const _TabSelector({
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: _TabBtn(
              label: _c.getString('scholarship', 'form.tab_apply'),
              icon: Icons.school_rounded,
              isSelected: selectedType == ScholarshipTabType.apply,
              onTap: () => onChanged(ScholarshipTabType.apply),
            ),
          ),
          Expanded(
            child: _TabBtn(
              label: _c.getString('scholarship', 'form.tab_donate'),
              icon: Icons.volunteer_activism_rounded,
              isSelected: selectedType == ScholarshipTabType.donate,
              onTap: () => onChanged(ScholarshipTabType.donate),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabBtn({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacingM,
          horizontal: AppDimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius:
              BorderRadius.circular(AppDimensions.radiusM - 2),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 20,
                color: isSelected
                    ? Colors.white
                    : AppColors.textSecondary),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
