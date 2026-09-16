import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(const PhysioApp());

class PhysioApp extends StatelessWidget {
  const PhysioApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'عيادة العلاج الطبيعي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0D47A1),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _idx = 0;
  final _pages = [
    const PatientDataPage(),
    const ExamPage(),
    const FollowPage(),
    const ReportPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text(
          'Physio Clinic / عيادة العلاج الطبيعي',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: _pages[_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0D47A1),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'بيانات'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'فحص'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'متابعة'),
          BottomNavigationBarItem(icon: Icon(Icons.picture_as_pdf), label: 'تقرير'),
        ],
      ),
    );
  }
}

const List<String> genderList = ['Male / ذكر', 'Female / انثى'];
const List<String> socialList = ['Child / طفل', 'Single / عازب', 'Married / متزوج', 'Married / متزوجة', 'Elderly / كبار السن'];

const List<String> diagnosisList = [
  'ANKYLOSING SPONDYLITIS','POLIOMYELITIS','OSTEOARTHRITIS','RHEUMATOID ARTHRITIS','SHOULDER SYNDROME','Bursitis','Painful arc Syndrome','Tendinitis','Rotator cuff Tear','Shoulder Hand Finger Syndrome','Scapulo - Costal Syndrome','Painful Shoulder','Adhesive Capsulitis','Thoracic - Outlet Syndrome','Capsulitis of Glenohumeral joint','MUSCULAR DYSTROPHY','CERVICAL SYNDROME','Cervical Spondylosis','Cervical Rib','Torticollis','Prolapse Cervical Disc','Vertebro - Basilar Syndrome','Cervical Spondylolisthesis','HEMIPLEGIA','POLYNEUROPATHY','Alcoholic Polyneuropathy','Carcinomatous Polyneuropathy','Diphtherial Polyneuropathy','Diabetic Polyneuropathy','Guillain Barre Syndrome','CEREBRAL PALSY','Fracture of phalanges','Mallet finger','Metacarpal fracture',"Bennett's fracture dislocation",'Fracture Scaphoid','Lunate fracture dislocation',"Colle's fracture","Smith's fracture","Barton's fracture",'Fractures of radius and ulna','Monteggia fracture',"Galleazzi's fracture",'Supracondylar fracture of humerus','Fracture Capitulum','Fracture Olecranon','Bicondylar fractures of humerus','Unicondylar fracture of humerus','Dislocation of elbow','Fracture of head and neck of radius','Shoulder dislocation','Fracture of proximal humerus','Fracture of surgical neck','Fracture of greater tuberosity','Acromio clavicular joint dislocation','Sternoclavicularjoint dislocation','Fracture of scapula','Fracture of clavicle','Fracture neck femur','Fracture shaft femur','Supracondylar fracture of femur','Intercondylar fracture','Fracture of condyles of tibia','Fracture of shaft of tibia and fibula','Fracture of calcaneum','Fracture of talus','Fracture of navicular','Fracture of metatarsal','Fracture of toes','Congenital flat foot','Spina bifida','Scoliosis','Club hand','C.D.H','Genu valgum','Genu varum','Hallux valgus','Pes cavus','Kyphosis','Lordosis','Ankle ligament','Collateral ligament [knee joint]','Cruciate ligament [knee joint]','Injury to meniscus','Injury to muscle','Injury to tendon','Injury to synovial membrane','Injury to nerve'
];

const List<String> programList = ['Manual Mobilization','PROM','AROM','AAROM','ARROM','Stretch ex\'s','Sitting program and balance ex\'s','Sanding program and balance ex\'s','Walking program and balance ex\'s','Manual Massage'];
const List<String> electroList = ['TENS','Faradic Current','Galvanic','MS','IFT','Accup.','IRR','US','WAX THERAPY','HOT PACK','Massage Machine','Traction','Shoulder Wheel'];

Widget excelLabel(String text) => Container(
  width: double.infinity,
  padding: const EdgeInsets.all(10),
  color: const Color(0xFF0D47A1),
  child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
);class PatientDataPage extends StatefulWidget {
  const PatientDataPage({super.key});
  @override
  State<PatientDataPage> createState() => _PatientDataPageState();
}

class _PatientDataPageState extends State<PatientDataPage> {
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  String? gender, social;

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('patients') ?? [];
    final id = 'P${(list.length + 1).toString().padLeft(3, '0')}';
    list.add(jsonEncode({
      'id': id,
      'name': nameCtrl.text,
      'age': ageCtrl.text,
      'gender': gender,
      'social': social,
      'phone': phoneCtrl.text
    }));
    await prefs.setStringList('patients', list);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم الحفظ $id / Saved')));
      nameCtrl.clear(); ageCtrl.clear(); phoneCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(8), children: [
      excelLabel('بيانات المريض / Patient Data - نفس تصميم الاكسل'),
      const SizedBox(height: 12),
      TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name / اسم المريض', border: OutlineInputBorder())),
      const SizedBox(height: 8),
      TextField(controller: ageCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Age / العمر', border: OutlineInputBorder())),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Gender / الجنس', border: OutlineInputBorder()),
        items: genderList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => gender = v,
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Social / الحالة الاجتماعية', border: OutlineInputBorder()),
        items: socialList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => social = v,
      ),
      const SizedBox(height: 8),
      TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone / الهاتف', border: OutlineInputBorder())),
      const SizedBox(height: 16),
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D47A1), minimumSize: const Size(double.infinity, 50)),
        onPressed: save,
        child: const Text('حفظ / Save - نفس معادلة الاكسل', style: TextStyle(color: Colors.white)),
      ),
    ]);
  }
}

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});
  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  String? d1, d2, d3, p1, p2, p3, e1, e2, e3;
  String get finalDiag => [d1, d2, d3].where((e) => e != null && e!.isNotEmpty).join(' + ');
  String get finalProg => [p1, p2, p3, e1, e2, e3].where((e) => e != null && e!.isNotEmpty).join(' + ');

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(8), children: [
      excelLabel('الفحص السريري / Clinical Examination'),
      const SizedBox(height: 8),
      Container(padding: const EdgeInsets.all(10), color: const Color(0xFFFFF9C4), child: Text('التشخيص النهائي / Final Diagnosis: $finalDiag', style: const TextStyle(fontWeight: FontWeight.bold))),
      const SizedBox(height: 8),
      _drop('التشخيص 1 / Diagnosis 1', diagnosisList, (v) => setState(() => d1 = v)),
      _drop('التشخيص 2 / Diagnosis 2', diagnosisList, (v) => setState(() => d2 = v)),
      _drop('التشخيص 3 / Diagnosis 3', diagnosisList, (v) => setState(() => d3 = v)),
      const Divider(),
      _drop('البرنامج 1 / Program 1', programList, (v) => setState(() => p1 = v)),
      _drop('البرنامج 2 / Program 2', programList, (v) => setState(() => p2 = v)),
      _drop('البرنامج 3 / Program 3', programList, (v) => setState(() => p3 = v)),
      _drop('الكهربائي 1 / Electro 1', electroList, (v) => setState(() => e1 = v)),
      _drop('الكهربائي 2 / Electro 2', electroList, (v) => setState(() => e2 = v)),
      _drop('الكهربائي 3 / Electro 3', electroList, (v) => setState(() => e3 = v)),
      const SizedBox(height: 8),
      Container(padding: const EdgeInsets.all(10), color: const Color(0xFFC8E6C9), child: Text('البرنامج النهائي / Final Program: $finalProg', style: const TextStyle(fontWeight: FontWeight.bold))),
    ]);
  }

  Widget _drop(String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class FollowPage extends StatelessWidget {
  const FollowPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(8), children: [
      excelLabel('كشف المتابعة اليومية / Daily Follow-up'),
      const SizedBox(height: 12),
      const Text('المعادلة نفس الاكسل:\nSession No = COUNTIF(A:A, ID)\nRemaining = Total - Session', style: TextStyle(fontSize: 13)),
    ]);
  }
}

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(8), children: [
      excelLabel('تقرير المريض / Patient Report - نفس تصميم الاكسل'),
      const SizedBox(height: 200, child: Center(child: Text('ابحث بالـ ID لعرض التقرير\nSearch by ID'))),
    ]);
  }
}
