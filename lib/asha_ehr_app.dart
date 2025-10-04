import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Make DateFormat accessible throughout the file
final dateFormatter = DateFormat('dd MMM yyyy');

class ASHAEHRApp extends StatelessWidget {
  const ASHAEHRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASHA Health Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        // Using Material 3 for modern styling
        useMaterial3: true,
      ),
      home: const LoginPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/medicine_store': (context) => const MedicineStorePage(),
      },
    );
  }
}

// Login Page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate login delay
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        // For demo purposes, any credentials will work
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.local_hospital,
                  size: 80,
                  color: Colors.teal,
                ),
                const SizedBox(height: 24),
                const Text(
                  'ASHA Health Companion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('LOGIN', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Medicine Store Page
class MedicineStorePage extends StatefulWidget {
  const MedicineStorePage({super.key});

  @override
  State<MedicineStorePage> createState() => _MedicineStorePageState();
}

class _MedicineStorePageState extends State<MedicineStorePage> {
  final List<Map<String, dynamic>> _cart = [];

  void _addToCart(Medicine medicine) {
    setState(() {
      final existingIndex = _cart.indexWhere((item) => item['medicine'].id == medicine.id);
      if (existingIndex >= 0) {
        _cart[existingIndex]['quantity'] += 1;
      } else {
        _cart.add({'medicine': medicine, 'quantity': 1});
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${medicine.name} added to cart')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Store'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  _showCart();
                },
              ),
              if (_cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _cart.fold<int>(0, (sum, item) => sum + (item['quantity'] as int)).toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.teal),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'ASHA Worker',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'ID: ASHA001',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Medicine Store'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/medicine_store');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          final medicine = medicines[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Container(
                    color: Colors.teal.shade100,
                    child: Center(
                      child: Icon(
                        medicine.isSyringe ? Icons.medical_services : Icons.medication,
                        size: 50,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${medicine.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _addToCart(medicine),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(30),
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Add to Cart'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final total = _cart.fold(
                0.0,
                (sum, item) =>
                    sum + (item['medicine'].price * item['quantity']));

            return Container(
              padding: const EdgeInsets.all(16),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Your Cart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _cart.isEmpty
                        ? const Center(
                            child: Text('Your cart is empty'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _cart.length,
                            itemBuilder: (context, index) {
                              final item = _cart[index];
                              final medicine = item['medicine'];
                              final quantity = item['quantity'];

                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: Icon(
                                    medicine.isSyringe
                                        ? Icons.medical_services
                                        : Icons.medication,
                                    color: Colors.teal,
                                  ),
                                  title: Text(medicine.name),
                                  subtitle: Text(
                                      '₹${medicine.price.toStringAsFixed(2)} x $quantity'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          setState(() {
                                            if (quantity > 1) {
                                              _cart[index]['quantity'] -= 1;
                                            } else {
                                              _cart.removeAt(index);
                                            }
                                          });
                                          this.setState(() {});
                                        },
                                      ),
                                      Text('$quantity'),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          setState(() {
                                            _cart[index]['quantity'] += 1;
                                          });
                                          this.setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total: ₹${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _cart.isEmpty
                        ? null
                        : () {
                            Navigator.pop(context);
                            _generateReceipt(total);
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('CHECKOUT'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  void _generateReceipt(double total) {
    // Generate a random order number
    final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    
    // Calculate estimated delivery date (2-3 days from now)
    final deliveryDate = DateTime.now().add(const Duration(days: 2));
    final alternateDeliveryDate = DateTime.now().add(const Duration(days: 3));
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.receipt_long, color: Colors.teal),
            const SizedBox(width: 8),
            const Text('Order Receipt'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'ASHA Health Companion',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.teal.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'Medicine Order Receipt',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
              _receiptRow('Order Number:', orderNumber),
              _receiptRow('Date:', DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())),
              const Divider(),
              const Text(
                'Items:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._cart.map((item) {
                final medicine = item['medicine'];
                final quantity = item['quantity'];
                final itemTotal = medicine.price * quantity;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('${medicine.name} x $quantity'),
                      ),
                      Text('₹${itemTotal.toStringAsFixed(2)}'),
                    ],
                  ),
                );
              }),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const Text(
                'Delivery Information:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _receiptRow('Estimated Delivery:', 
                '${DateFormat('dd MMM').format(deliveryDate)} - ${DateFormat('dd MMM yyyy').format(alternateDeliveryDate)}'),
              _receiptRow('Delivery Method:', 'Standard Delivery'),
              const SizedBox(height: 16),
              const Text(
                'Thank you for your order!',
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order #$orderNumber placed successfully!'),
                  backgroundColor: Colors.teal,
                ),
              );
              setState(() {
                _cart.clear();
              });
            },
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order #$orderNumber placed successfully!'),
                  backgroundColor: Colors.teal,
                ),
              );
              setState(() {
                _cart.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );
  }
  
  Widget _receiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Medicine Model
class Medicine {
  final String id;
  final String name;
  final double price;
  final String description;
  final bool isSyringe;

  Medicine({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.isSyringe = false,
  });
}

// Mock Medicines Data
final List<Medicine> medicines = [
  Medicine(
    id: 'M001',
    name: 'Paracetamol',
    price: 15.50,
    description: 'Pain reliever and fever reducer. Used for headaches, muscle aches, arthritis, backaches, toothaches, colds, and fevers.',
  ),
  Medicine(
    id: 'M002',
    name: 'Amoxicillin',
    price: 45.75,
    description: 'Antibiotic used to treat a number of bacterial infections. It is a first line treatment for middle ear infections and strep throat.',
  ),
  Medicine(
    id: 'M003',
    name: 'Omeprazole',
    price: 65.20,
    description: 'Used to treat certain stomach and esophagus problems such as acid reflux and ulcers.',
  ),
  Medicine(
    id: 'M004',
    name: 'Metformin',
    price: 38.90,
    description: 'Oral diabetes medicine that helps control blood sugar levels in patients with type 2 diabetes.',
  ),
  Medicine(
    id: 'M005',
    name: 'Atorvastatin',
    price: 75.50,
    description: 'Used to lower blood cholesterol and reduce the risk of cardiovascular disease.',
  ),
  Medicine(
    id: 'M006',
    name: 'Aspirin',
    price: 12.25,
    description: 'Pain reliever, anti-inflammatory, and blood thinner. Used to treat pain, fever, and inflammation.',
  ),
  Medicine(
    id: 'S001',
    name: 'Insulin Syringe',
    price: 8.50,
    description: 'Used for insulin injection in diabetes patients. Available in different sizes with fine needles for minimal discomfort.',
    isSyringe: true,
  ),
  Medicine(
    id: 'S002',
    name: 'Tuberculin Syringe',
    price: 7.25,
    description: 'Precision syringe used for administering small doses of medication or for tuberculin skin tests.',
    isSyringe: true,
  ),
  Medicine(
    id: 'S003',
    name: 'Hypodermic Syringe',
    price: 9.75,
    description: 'General purpose syringe used for injecting medications or withdrawing fluids from the body.',
    isSyringe: true,
  ),
];

// Mock Data Models
class Patient {
  final String id;
  final String name;
  final String age;
  final String gender;
  final String bloodGroup;
  final String village;
  final String phone;
  final List<HealthRecord> records;
  final List<Reminder> reminders;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.village,
    required this.phone,
    required this.records,
    required this.reminders,
  });
}

class HealthRecord {
  final String date;
  final String type;
  final String description;
  final String? doctor;

  HealthRecord({
    required this.date,
    required this.type,
    required this.description,
    this.doctor,
  });
}

class Reminder {
  final String title;
  final String date;
  final String type;
  final bool completed;

  Reminder({
    required this.title,
    required this.date,
    required this.type,
    required this.completed,
  });
}

// Mock Data
final List<Patient> mockPatients = [
  Patient(
    id: 'P001',
    name: 'Lakshmi Devi',
    age: '32',
    gender: 'Female',
    bloodGroup: 'O+',
    village: 'Rampur',
    phone: '9876543210',
    records: [
      HealthRecord(
        date: '2025-09-15',
        type: 'Checkup',
        description: 'Regular health checkup - BP: 120/80, Weight: 55kg',
        doctor: 'Dr. Kumar',
      ),
      HealthRecord(
        date: '2025-08-20',
        type: 'Vaccination',
        description: 'Tetanus booster administered',
      ),
    ],
    reminders: [
      Reminder(
        title: 'Diabetes Checkup',
        date: '2025-10-05',
        type: 'checkup',
        completed: false,
      ),
      Reminder(
        title: 'Blood Pressure Medicine',
        date: '2025-10-01',
        type: 'medicine',
        completed: false,
      ),
    ],
  ),
  Patient(
    id: 'P004',
    name: 'Lina',
    age: '28',
    gender: 'Female',
    bloodGroup: 'AB+',
    village: 'Rampur',
    phone: '9876543213',
    records: [
      HealthRecord(
        date: '2025-09-18',
        type: 'Checkup',
        description: 'Prenatal checkup - BP: 110/70, Weight: 58kg',
        doctor: 'Dr. Patel',
      ),
    ],
    reminders: [
      Reminder(
        title: 'Prenatal Vitamins',
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        type: 'medicine',
        completed: false,
      ),
    ],
  ),
  Patient(
    id: 'P005',
    name: 'Akilesh',
    age: '42',
    gender: 'Male',
    bloodGroup: 'O-',
    village: 'Nandpur',
    phone: '9876543214',
    records: [
      HealthRecord(
        date: '2025-09-12',
        type: 'Treatment',
        description: 'Hypertension follow-up - BP: 140/90',
        doctor: 'Dr. Gupta',
      ),
    ],
    reminders: [
      Reminder(
        title: 'Blood Pressure Check',
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        type: 'checkup',
        completed: false,
      ),
    ],
  ),
  Patient(
    id: 'P002',
    name: 'Ravi Kumar',
    age: '45',
    gender: 'Male',
    bloodGroup: 'B+',
    village: 'Rampur',
    phone: '9876543211',
    records: [
      HealthRecord(
        date: '2025-09-20',
        type: 'Treatment',
        description: 'Treated for seasonal flu - Prescribed antibiotics',
        doctor: 'Dr. Sharma',
      ),
    ],
    reminders: [
      Reminder(
        title: 'Flu Medicine Course',
        date: '2025-10-02',
        type: 'medicine',
        completed: false,
      ),
    ],
  ),
  Patient(
    id: 'P006',
    name: 'Janvi',
    age: '35',
    gender: 'Female',
    bloodGroup: 'B-',
    village: 'Rampur',
    phone: '9876543215',
    records: [
      HealthRecord(
        date: '2025-09-05',
        type: 'Checkup',
        description: 'General health assessment - All parameters normal',
        doctor: 'Dr. Reddy',
      ),
    ],
    reminders: [
      Reminder(
        title: 'Annual Health Checkup',
        date: DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1))),
        type: 'checkup',
        completed: false,
      ),
    ],
  ),
  Patient(
    id: 'P007',
    name: 'Dharsan',
    age: '50',
    gender: 'Male',
    bloodGroup: 'A-',
    village: 'Nandpur',
    phone: '9876543216',
    records: [
      HealthRecord(
        date: '2025-09-08',
        type: 'Treatment',
        description: 'Diabetes follow-up - Blood sugar: 140mg/dL',
        doctor: 'Dr. Singh',
      ),
    ],
    reminders: [
      Reminder(
        title: 'Insulin Injection',
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        type: 'medicine',
        completed: false,
      ),
    ],
  ),
  Patient(
    id: 'P008',
    name: 'Akash',
    age: '22',
    gender: 'Male',
    bloodGroup: 'O+',
    village: 'Rampur',
    phone: '9876543217',
    records: [
      HealthRecord(
        date: '2025-09-14',
        type: 'Treatment',
        description: 'Sprained ankle - Applied bandage and prescribed pain relievers',
        doctor: 'Dr. Verma',
      ),
    ],
    reminders: [
      Reminder(
        title: 'Follow-up for ankle',
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        type: 'checkup',
        completed: false,
      ),
    ],
  ),
  Patient(
    id: 'P009',
    name: 'Jammal',
    age: '60',
    gender: 'Male',
    bloodGroup: 'AB+',
    village: 'Nandpur',
    phone: '9876543218',
    records: [
      HealthRecord(
        date: '2025-09-01',
        type: 'Checkup',
        description: 'Cardiac evaluation - ECG normal, BP: 130/85',
        doctor: 'Dr. Khan',
      ),
    ],
    reminders: [
      Reminder(
        title: 'Heart Medication',
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        type: 'medicine',
        completed: false,
      ),
    ],
  ),
  Patient(
    id: 'P003',
    name: 'Baby Priya',
    age: '2',
    gender: 'Female',
    bloodGroup: 'A+',
    village: 'Nandpur',
    phone: '9876543212',
    records: [
      HealthRecord(
        date: '2025-09-10',
        type: 'Vaccination',
        description: 'MMR vaccine administered',
      ),
    ],
    reminders: [
      Reminder(
        title: 'Polio Drops - 3rd Dose',
        date: '2025-10-10',
        type: 'vaccination',
        completed: false,
      ),
      Reminder(
        title: 'Growth Monitoring',
        date: '2025-10-15',
        type: 'checkup',
        completed: false,
      ),
    ],
  ),
];

// Home Page
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool isOnline = false;

  final List<Widget> _pages = [
    const DashboardPage(),
    const PatientsListPage(),
    const RemindersPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASHA Health Companion'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(isOnline ? Icons.cloud_done : Icons.cloud_off, size: 20),
                const SizedBox(width: 4),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patients'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Dashboard Page
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  
  Widget _buildReportItem(String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withOpacity(0.2),
          child: Icon(icon, color: Colors.orange, size: 20),
        ),
        title: Text(title),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.download, color: Colors.teal),
        onTap: () {},
      ),
    );
  }
  
  void _showTodaysCheckups(BuildContext context) {
    final todaysDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todaysReminders = mockPatients
        .expand((p) => p.reminders.map((r) => {'patient': p, 'reminder': r}))
        .where((item) => (item['reminder'] as Reminder).date == todaysDate)
        .toList();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.calendar_today, color: Colors.green),
            SizedBox(width: 8),
            Text('Today\'s Checkups'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: todaysReminders.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('No checkups scheduled for today'),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: todaysReminders.length,
                  itemBuilder: (context, index) {
                    final item = todaysReminders[index];
                    final patient = item['patient'] as Patient;
                    final reminder = item['reminder'] as Reminder;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Text(
                            patient.name[0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(reminder.title),
                        subtitle: Text(patient.name),
                        trailing: IconButton(
                          icon: Icon(
                            reminder.completed ? Icons.check_circle : Icons.check_circle_outline,
                            color: reminder.completed ? Colors.green : Colors.grey,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientDetailPage(patient: patient),
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientDetailPage(patient: patient),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPatients = mockPatients.length;
    final totalReminders = mockPatients
        .expand((p) => p.reminders)
        .where((r) => !r.completed)
        .length;
    final todayCheckups = mockPatients
        .expand((p) => p.reminders)
        .where((r) => r.date == DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome, ASHA Worker',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Patients',
                  totalPatients.toString(),
                  Icons.people,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Pending Reminders',
                  totalReminders.toString(),
                  Icons.notifications_active,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _showTodaysCheckups(context);
                  },
                  child: _buildStatCard(
                    context,
                    'Today\'s Checkups',
                    todayCheckups.toString(),
                    Icons.calendar_today,
                    Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Synced Records',
                  '${mockPatients.length * 2}',
                  Icons.sync,
                  Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildQuickAction(
            context,
            'Add New Patient',
            Icons.person_add,
            Colors.teal,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPatientPage()),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildQuickAction(context, 'Sync Data', Icons.sync, Colors.blue, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data sync initiated. Will sync when online.'),
              ),
            );
          }),
          const SizedBox(height: 8),
          _buildQuickAction(
            context,
            'Medicine Store',
            Icons.medical_services,
            Colors.purple,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MedicineStorePage()),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildQuickAction(
            context,
            'View Reports',
            Icons.assessment,
            Colors.orange,
            () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Row(
                    children: [
                      const Icon(Icons.assessment, color: Colors.orange),
                      const SizedBox(width: 8),
                      const Text('Health Reports'),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildReportItem(
                          'Monthly Patient Summary',
                          'Last updated: ${DateFormat('dd MMM yyyy').format(DateTime.now().subtract(const Duration(days: 2)))}',
                          Icons.people,
                        ),
                        _buildReportItem(
                          'Vaccination Coverage',
                          'Last updated: ${DateFormat('dd MMM yyyy').format(DateTime.now().subtract(const Duration(days: 5)))}',
                          Icons.medical_services,
                        ),
                        _buildReportItem(
                          'Maternal Health Statistics',
                          'Last updated: ${DateFormat('dd MMM yyyy').format(DateTime.now().subtract(const Duration(days: 7)))}',
                          Icons.pregnant_woman,
                        ),
                        _buildReportItem(
                          'Child Health Metrics',
                          'Last updated: ${DateFormat('dd MMM yyyy').format(DateTime.now().subtract(const Duration(days: 3)))}',
                          Icons.child_care,
                        ),
                        _buildReportItem(
                          'Medicine Distribution',
                          'Last updated: ${DateFormat('dd MMM yyyy').format(DateTime.now().subtract(const Duration(days: 1)))}',
                          Icons.medication,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// Patients List Page
class PatientsListPage extends StatefulWidget {
  const PatientsListPage({super.key});

  @override
  State<PatientsListPage> createState() => _PatientsListPageState();
}

class _PatientsListPageState extends State<PatientsListPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredPatients = mockPatients.where((patient) {
      return patient.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          patient.id.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search patients...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredPatients.length,
            itemBuilder: (context, index) {
              final patient = filteredPatients[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text(
                      patient.name[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    patient.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${patient.id} • ${patient.age} yrs • ${patient.gender}',
                      ),
                      Text('Village: ${patient.village}'),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (patient.reminders.any((r) => !r.completed))
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${patient.reminders.where((r) => !r.completed).length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PatientDetailPage(patient: patient),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Patient Detail Page
class PatientDetailPage extends StatelessWidget {
  final Patient patient;

  const PatientDetailPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
        actions: [IconButton(icon: const Icon(Icons.edit), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.teal,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      patient.name[0],
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    patient.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'ID: ${patient.id}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Basic Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Age', patient.age),
                  _buildInfoRow('Gender', patient.gender),
                  _buildInfoRow('Blood Group', patient.bloodGroup),
                  _buildInfoRow('Village', patient.village),
                  _buildInfoRow('Phone', patient.phone),
                  const SizedBox(height: 24),
                  const Text(
                    'Health Records',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...patient.records.map(
                    (record) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getRecordColor(record.type),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    record.type,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  dateFormatter.format(
                                    DateTime.parse(record.date),
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(record.description),
                            if (record.doctor != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'By: ${record.doctor}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Upcoming Reminders',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...patient.reminders
                      .where((r) => !r.completed)
                      .map(
                        (reminder) => Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: Icon(
                              _getReminderIcon(reminder.type),
                              color: Colors.teal,
                            ),
                            title: Text(reminder.title),
                            subtitle: Text(
                              DateFormat(
                                'dd MMM yyyy',
                              ).format(DateTime.parse(reminder.date)),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.check_circle_outline),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRecordPage(patient: patient),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRecordColor(String type) {
    switch (type.toLowerCase()) {
      case 'checkup':
        return Colors.blue;
      case 'vaccination':
        return Colors.green;
      case 'treatment':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getReminderIcon(String type) {
    switch (type.toLowerCase()) {
      case 'checkup':
        return Icons.medical_services;
      case 'vaccination':
        return Icons.vaccines;
      case 'medicine':
        return Icons.medication;
      default:
        return Icons.notification_important;
    }
  }
}

// Reminders Page
class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final allReminders = mockPatients
        .expand((p) => p.reminders.map((r) => {'patient': p, 'reminder': r}))
        .where((item) => !(item['reminder'] as Reminder).completed)
        .toList();

    allReminders.sort((a, b) {
      final dateA = DateTime.parse((a['reminder'] as Reminder).date);
      final dateB = DateTime.parse((b['reminder'] as Reminder).date);
      return dateA.compareTo(dateB);
    });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allReminders.length,
      itemBuilder: (context, index) {
        final item = allReminders[index];
        final patient = item['patient'] as Patient;
        final reminder = item['reminder'] as Reminder;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
              child: Text(
                patient.name[0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(reminder.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(patient.name),
                Text(
                  DateFormat(
                    'dd MMM yyyy',
                  ).format(DateTime.parse(reminder.date)),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reminder marked as completed')),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// Add Patient Page
class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _villageController = TextEditingController();
  String _selectedGender = 'Male';
  String _selectedBloodGroup = 'O+';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Patient')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter age';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.wc),
              ),
              items: ['Male', 'Female', 'Other']
                  .map(
                    (gender) =>
                        DropdownMenuItem(value: gender, child: Text(gender)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedBloodGroup,
              decoration: const InputDecoration(
                labelText: 'Blood Group',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.bloodtype),
              ),
              items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                  .map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBloodGroup = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _villageController,
              decoration: const InputDecoration(
                labelText: 'Village',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter village';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Patient added successfully. Will sync when online.',
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Patient', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _villageController.dispose();
    super.dispose();
  }
}

// Add Record Page
class AddRecordPage extends StatefulWidget {
  final Patient patient;

  const AddRecordPage({super.key, required this.patient});

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _doctorController = TextEditingController();
  String _selectedType = 'Checkup';
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Health Record')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Record Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: ['Checkup', 'Vaccination', 'Treatment', 'Test Result']
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(dateFormatter.format(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _doctorController,
              decoration: const InputDecoration(
                labelText: 'Doctor Name (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.medical_services),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Record added successfully. Will sync when online.',
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Record', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _doctorController.dispose();
    super.dispose();
  }
}

// Profile Page
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.teal,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Text(
          'ASHA Worker',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'ID: ASHA001',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 32),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Edit Profile'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.sync),
                title: const Text('Sync Settings'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Notification Settings'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                subtitle: const Text('English'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.storage),
                title: const Text('Data Storage'),
                subtitle: const Text('125 MB used'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.cloud_download),
                title: const Text('Export Data'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data export will start when online'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                subtitle: const Text('Version 1.0.0'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logged out successfully'),
                        ),
                      );
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
