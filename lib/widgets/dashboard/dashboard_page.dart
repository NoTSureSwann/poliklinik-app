import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:poliklinik/core/responsive/responsive_layout.dart';
import 'package:poliklinik/theme/app_colors.dart';
import 'package:poliklinik/widgets/sidebar/custom_sidebar.dart';
import 'package:poliklinik/widgets/dashboard/top_header.dart';
import 'package:poliklinik/widgets/tables/recent_appointment_table.dart';
import 'package:poliklinik/widgets/dashboard/activity_timeline.dart';
import 'dashboard_header.dart';
import 'dashboard_statistics.dart';
import 'dashboard_charts.dart';
import 'dashboard_doctors.dart';
import 'package:poliklinik/widgets/dashboard/pending_bills_widget.dart';
import 'package:poliklinik/widgets/dashboard/farmasi_dashboard_widget.dart';
import 'package:poliklinik/widgets/dashboard/pembayaran_dashboard_widget.dart';
import 'package:poliklinik/widgets/dashboard/admin_activity_widget.dart';
import 'package:poliklinik/widgets/dashboard/footer_widget.dart';

import 'package:poliklinik/widgets/pasien/pasien_page.dart';
import 'package:poliklinik/widgets/dokter/dokter_page.dart';
import 'package:poliklinik/widgets/janji/janji_list_page.dart';
import 'package:poliklinik/widgets/rekam/rekam_list_page.dart';
import 'package:poliklinik/widgets/farmasi/farmasi_page.dart';
import 'package:poliklinik/widgets/loket/loket_page.dart';
import 'package:poliklinik/widgets/admin/poli_page.dart';
import 'package:poliklinik/widgets/profile/profile_settings_page.dart';
import 'package:poliklinik/widgets/auth/login_page.dart';

import 'package:poliklinik/providers/data_provider.dart';
import 'package:poliklinik/providers/auth_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<DataProvider>().fetchPatients();
        context.read<DataProvider>().fetchDoctors();
        context.read<DataProvider>().fetchAppointments();
        context.read<DataProvider>().fetchRekam();
        context.read<DataProvider>().fetchObat();
        
        // Start polling for real-time MockAPI data
        context.read<DataProvider>().startPolling();
      }
    });
  }

  void _onItemSelected(int index) {
    if (index == 10) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                
                // Clear state to avoid memory leaks or data lingering
                context.read<DataProvider>().appointments.clear();
                context.read<DataProvider>().rekamList.clear();
                context.read<DataProvider>().patients.clear();
                
                context.read<AuthProvider>().logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
              child: const Text('Keluar', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
    if (context.isMobile || context.isTablet) {
      if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return PasienPage();
      case 2:
        return DokterPage();
      case 3:
        return JanjiListPage();
      case 4:
        return RekamListPage();
      case 5:
        return FarmasiPage();
      case 6:
        return LoketPage();
      case 8:
        return PoliPage();
      case 9:
        return ProfileSettingsPage();
      default:
        return const Center(child: Text("Halaman dalam pengembangan"));
    }
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardHeader(),
          const SizedBox(height: 24),
          const FarmasiDashboardWidget(), // Only visible for farmasi
          const PendingBillsWidget(), // Only visible for pasien
          if (context.watch<AuthProvider>().currentUser?.role == 'pembayaran' || context.watch<AuthProvider>().currentUser?.role == 'jasapembayaran')
            const PembayaranDashboardWidget(),
          if (context.watch<AuthProvider>().currentUser?.role == 'admin')
            const AdminActivityMonitoringWidget(),
          const DashboardStatistics(),
          const SizedBox(height: 24),
          const DashboardCharts(),
          const SizedBox(height: 24),
          ResponsiveLayout(
            mobile: Column(
              children: const [
                RecentAppointmentTable(),
                SizedBox(height: 24),
                ActivityTimeline(),
              ],
            ),
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(flex: 2, child: RecentAppointmentTable()),
                SizedBox(width: 24),
                Expanded(flex: 1, child: ActivityTimeline()),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const DashboardDoctors(),
          const SizedBox(height: 48),
          const FooterWidget(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: (context.isMobile || context.isTablet)
          ? AppBar(
              backgroundColor: Theme.of(context).cardColor,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.textPrimary),
              title: const Text('CareHub', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            )
          : null,
      drawer: (context.isMobile || context.isTablet)
          ? Drawer(
              child: CustomSidebar(
                selectedIndex: _selectedIndex,
                onItemSelected: _onItemSelected,
                role: context.watch<AuthProvider>().currentUser?.role ?? 'pasien',
              ),
            )
          : null,
      body: Row(
        children: [
          if (context.isDesktop)
            CustomSidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: _onItemSelected,
              role: context.watch<AuthProvider>().currentUser?.role ?? 'pasien',
            ),
          Expanded(
            child: Column(
              children: [
                if (context.isDesktop) const TopHeader(),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
