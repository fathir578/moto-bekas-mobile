import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginSheet extends StatefulWidget {
  final VoidCallback? onSuccess;

  const LoginSheet({super.key, this.onSuccess});

  @override
  State<LoginSheet> createState() => _LoginSheetState();
}

class _LoginSheetState extends State<LoginSheet> {
  bool _isRegister = false;
  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();
  final _nameCtl = TextEditingController();
  String _role = 'buyer';
  String? _error;

  @override
  void dispose() {
    _emailCtl.dispose();
    _passwordCtl.dispose();
    _nameCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    final auth = context.read<AuthProvider>();

    String? err;
    if (_isRegister) {
      if (_nameCtl.text.trim().isEmpty) {
        setState(() => _error = 'Nama harus diisi');
        return;
      }
      err = await auth.register(_nameCtl.text.trim(), _emailCtl.text.trim(), _passwordCtl.text, _role);
    } else {
      err = await auth.login(_emailCtl.text.trim(), _passwordCtl.text);
    }

    if (err != null) {
      setState(() => _error = err);
    } else {
      Navigator.pop(context);
      widget.onSuccess?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isRegister ? 'Daftar Akun' : 'Masuk',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 6),
            Text(
              _isRegister ? 'Buat akun untuk mulai bertransaksi' : 'Masuk untuk melanjutkan transaksi',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            if (_isRegister) ...[
              _inputField('Nama Lengkap', 'Masukkan nama', controller: _nameCtl),
              const SizedBox(height: 14),
            ],

            _inputField('Email', 'Masukkan email', controller: _emailCtl),
            const SizedBox(height: 14),

            _inputField('Password', 'Masukkan password', controller: _passwordCtl, obscure: true),
            const SizedBox(height: 14),

            if (_isRegister) ...[
              _roleSelector(),
              const SizedBox(height: 14),
            ],

            if (_error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_error!, style: const TextStyle(color: Color(0xFFC62828), fontSize: 13)),
              ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: auth.isLoading ? null : _submit,
                child: auth.isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(_isRegister ? 'Daftar' : 'Masuk'),
              ),
            ),
            const SizedBox(height: 14),

            Center(
              child: TextButton(
                onPressed: () => setState(() {
                  _isRegister = !_isRegister;
                  _error = null;
                }),
                child: Text(
                  _isRegister ? 'Sudah punya akun? Masuk' : 'Belum punya akun? Daftar',
                  style: const TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Daftar sebagai', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _role = 'buyer'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _role == 'buyer' ? const Color(0xFFE3F0FF) : const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _role == 'buyer' ? const Color(0xFF1565C0) : const Color(0xFFE0E0E0)),
                  ),
                  child: const Center(
                    child: Text('Pembeli', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1A1A2E))),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _role = 'showroom'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _role == 'showroom' ? const Color(0xFFE3F0FF) : const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _role == 'showroom' ? const Color(0xFF1565C0) : const Color(0xFFE0E0E0)),
                  ),
                  child: const Center(
                    child: Text('Showroom', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1A1A2E))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _inputField(String label, String hint, {TextEditingController? controller, bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFFF5F7FA),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}
