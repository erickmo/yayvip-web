import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

/// Preset nominal donasi.
const _presetAmounts = [10000, 50000, 100000, 250000, 500000, 1000000];

/// Form input untuk donatur terdaftar.
class NamedDonorForm extends StatelessWidget {
  final String fullName;
  final String email;
  final String phone;
  final int? selectedAmount;
  final String customAmount;
  final String? errorMessage;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<int> onAmountSelected;
  final ValueChanged<String> onCustomAmountChanged;
  final VoidCallback onSubmit;

  const NamedDonorForm({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.selectedAmount,
    required this.customAmount,
    required this.errorMessage,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onPhoneChanged,
    required this.onAmountSelected,
    required this.onCustomAmountChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Nama
        _buildTextField(
          label: AppStrings.donorFormName,
          value: fullName,
          onChanged: onNameChanged,
          icon: Icons.person_outlined,
        ),
        const SizedBox(height: AppDimensions.spacingM),
        // Email
        _buildTextField(
          label: AppStrings.donorFormEmail,
          value: email,
          onChanged: onEmailChanged,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppDimensions.spacingM),
        // Phone
        _buildTextField(
          label: AppStrings.donorFormPhone,
          value: phone,
          onChanged: onPhoneChanged,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: AppDimensions.spacingL),
        // Nominal Donasi
        const Text(
          AppStrings.donorFormAmount,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        // Preset amount chips
        Wrap(
          spacing: AppDimensions.spacingS,
          runSpacing: AppDimensions.spacingS,
          children: _presetAmounts.map((amount) {
            final isSelected = selectedAmount == amount;
            return ChoiceChip(
              label: Text(_formatRupiah(amount)),
              selected: isSelected,
              onSelected: (_) => onAmountSelected(amount),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              backgroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                ),
              ),
              showCheckmark: false,
            );
          }).toList(),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        // Custom amount
        _buildTextField(
          label: AppStrings.donorFormAmountHint,
          value: customAmount,
          onChanged: onCustomAmountChanged,
          icon: Icons.edit_rounded,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          prefix: 'Rp ',
        ),
        const SizedBox(height: AppDimensions.spacingL),
        // Error
        if (errorMessage != null) ...[
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: AppColors.error, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
        ],
        // Submit
        ElevatedButton.icon(
          onPressed: onSubmit,
          icon: const Icon(Icons.arrow_forward_rounded),
          label: const Text(AppStrings.donorFormSubmit),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? prefix,
  }) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        prefixText: prefix,
        filled: true,
        fillColor: AppColors.background,
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
