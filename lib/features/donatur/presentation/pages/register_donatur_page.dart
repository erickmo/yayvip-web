import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/di/injection.dart';
import '../../../landing/presentation/sections/footer_section.dart';
import '../../../landing/presentation/sections/navbar_section.dart';
import '../cubits/register_donatur_cubit.dart';
import '../cubits/register_donatur_state.dart';
import '../widgets/register_donatur_form.dart';

/// Halaman pendaftaran donatur baru.
class RegisterDonaturPage extends StatelessWidget {
  const RegisterDonaturPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterDonaturCubit>(),
      child: const _RegisterDonaturView(),
    );
  }
}

class _RegisterDonaturView extends StatelessWidget {
  const _RegisterDonaturView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<RegisterDonaturCubit, RegisterDonaturState>(
        listener: (context, state) {
          if (state.isSuccess) {
            _showSuccessDialog(context);
          } else if (state.status == RegisterDonaturStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Terjadi kesalahan'),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              NavbarSection(activeRoute: '/daftar-donatur'),
              _buildHero(context),
              const RegisterDonaturForm(),
              const FooterSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.spacingXXL,
        horizontal: AppDimensions.spacingXL,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, AppColors.secondaryLight],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Daftar Sebagai Donatur',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.textOnDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'Bergabunglah dengan keluarga besar VIP dan bantu '
            'generasi muda Indonesia meraih mimpi mereka.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textOnDark.withOpacity(0.85),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 32),
            SizedBox(width: AppDimensions.spacingS),
            Text('Pendaftaran Berhasil!'),
          ],
        ),
        content: const Text(
          'Terima kasih telah mendaftar sebagai donatur VIP. '
          'Unduh aplikasi YayVIP Donatur untuk mulai berdonasi.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/donasi');
            },
            child: const Text(
              'Kembali ke Donasi',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
