import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../cubits/register_donatur_cubit.dart';
import '../cubits/register_donatur_state.dart';

/// Form pendaftaran donatur — wajib: nama, email, telepon.
/// Opsional: data identitas dan alamat.
class RegisterDonaturForm extends StatefulWidget {
  const RegisterDonaturForm({super.key});

  @override
  State<RegisterDonaturForm> createState() => _RegisterDonaturFormState();
}

class _RegisterDonaturFormState extends State<RegisterDonaturForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _idTypeCtrl = TextEditingController();
  final _idNumberCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _provinceCtrl = TextEditingController();
  final _postalCodeCtrl = TextEditingController();
  bool _showOptional = false;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _idTypeCtrl.dispose();
    _idNumberCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _provinceCtrl.dispose();
    _postalCodeCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<RegisterDonaturCubit>().register(
            fullName: _fullNameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            idType: _idTypeCtrl.text.trim(),
            idNumber: _idNumberCtrl.text.trim(),
            address: _addressCtrl.text.trim(),
            city: _cityCtrl.text.trim(),
            province: _provinceCtrl.text.trim(),
            postalCode: _postalCodeCtrl.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Container(
      constraints: const BoxConstraints(maxWidth: 640),
      margin: EdgeInsets.symmetric(
        horizontal: isWide ? 0 : AppDimensions.spacingM,
        vertical: AppDimensions.spacingXXL,
      ),
      padding: const EdgeInsets.all(AppDimensions.spacingXL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Data Pribadi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            _buildField(
              controller: _fullNameCtrl,
              label: 'Nama Lengkap *',
              icon: Icons.person_outline,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            _buildField(
              controller: _emailCtrl,
              label: 'Email *',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(v.trim())) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.spacingM),
            _buildField(
              controller: _phoneCtrl,
              label: 'Nomor Telepon *',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Telepon wajib diisi';
                if (v.trim().length < 8) return 'Nomor telepon minimal 8 digit';
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.spacingL),
            _buildOptionalToggle(),
            if (_showOptional) ...[
              const SizedBox(height: AppDimensions.spacingL),
              _buildOptionalFields(),
            ],
            const SizedBox(height: AppDimensions.spacingXL),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildOptionalToggle() {
    return TextButton.icon(
      onPressed: () => setState(() => _showOptional = !_showOptional),
      icon: Icon(
        _showOptional ? Icons.expand_less : Icons.expand_more,
        color: AppColors.primary,
      ),
      label: Text(
        _showOptional
            ? 'Sembunyikan data tambahan'
            : 'Tambahkan data identitas & alamat (opsional)',
        style: const TextStyle(color: AppColors.primary),
      ),
    );
  }

  Widget _buildOptionalFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Identitas & Alamat',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _buildField(
          controller: _idTypeCtrl,
          label: 'Jenis Identitas (KTP/SIM/Paspor)',
          icon: Icons.badge_outlined,
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _buildField(
          controller: _idNumberCtrl,
          label: 'Nomor Identitas',
          icon: Icons.numbers_outlined,
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _buildField(
          controller: _addressCtrl,
          label: 'Alamat',
          icon: Icons.location_on_outlined,
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Row(
          children: [
            Expanded(
              child: _buildField(
                controller: _cityCtrl,
                label: 'Kota',
                icon: Icons.location_city_outlined,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: _buildField(
                controller: _provinceCtrl,
                label: 'Provinsi',
                icon: Icons.map_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingM),
        SizedBox(
          width: 200,
          child: _buildField(
            controller: _postalCodeCtrl,
            label: 'Kode Pos',
            icon: Icons.local_post_office_outlined,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<RegisterDonaturCubit, RegisterDonaturState>(
      builder: (context, state) {
        return SizedBox(
          height: AppDimensions.buttonHeight,
          child: ElevatedButton(
            onPressed: state.isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            child: state.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Daftar Sekarang',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
