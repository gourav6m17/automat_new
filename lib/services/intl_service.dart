import 'package:get/get.dart';

class IntlService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'home': 'Home',
          'language': 'Languages',
          'contact_us': "Contact Us",
          'add_device': "Add Device",
          'instruction_manual': "Instruction Manual",
          'scanning': "Scanning",
          'device_found': "Device Found",
          'scan_again': "Scan Again",
          'password': 'Password',
          'cancel': 'Cancel',
          'pair': 'Pair',
          'successfully_paired': 'Successfully Paired',
          'device_status': "Device Status",
          'flushing_in_dp_mode': "Flushing in DP mode",
          'flushing_in_dp_&_time_mode': "Flushing in DP & Time mode",
          'flushing_error': "Flushing Error",
          'dp_cycle_count': "DP \nCycle Count",
          'time_cycle_count': "Time \nCycle Count",
          'manual_cycle_count': "Manual \nCycle Count",
          'total_count': "Total Count",
          'flushing_interval_time_left': "Flushing interval time left",
          'flushing_duration_time_left': "Flushing duration time left",
          'manual': "Manual",
          'buzzer_off': "Buzzer Off",
          'buzzer_on': "Buzzer On",
          'reset': "Reset",
          'start': "START",
          'stop': "STOP",
          'history': "HISTORY",
          'filter_configuration': "Filter Configuration",
          'operation_mode': "Operation Mode",
          'stand_alone': "Stand Alone",
          'battery_of_filters': "Battery of filters",
          'flushing_mode': "Flushing Mode",
          'dp_only': "DP Only",
          'dp&time': "DP & Time",
          'flushing_interval': "Flushing Interval",
          "flushing_duration": "Flushing Duration",
          "hr": "hr",
          "min": "min",
          "sec": "sec",
          "dp_delay": "DP Delay",
          "looping_cycle": "Looping Cycle",
          'count': 'count',
          "restore": "Restore",
          "save": "Save",
          'enter_techinician_password': "Enter Technician Password",
          'change_name': 'Change Name',
          'change_password': "Change Password",
          'remove': 'Remove',
          'do_you_want_reset_counts': "Do you want to reset counts ?",
          "connected": "Connected",
          'connect': "Connect",
          'disconnect': "Disconnect",
          "disconnected": "Disconnected",
          'connecting': "Connecting..",
          'yes': "Yes",
          'no': "No",
          'incorrect_password': "Incorrect Password",
          'data_sent_successfully': "Data Sent Successfully",
          'notification': "Notification",
          "error": "Error",
          'apply': "Applying....",
        },
        'hi_IN': {
          'home': 'होम',
          'language': 'भाषाएँ',
          'contact_us': 'सम्पर्क करें',
          'add_device': 'उपकरण जोड़ें',
          'instruction_manual': 'दिशा निर्देश',
          'scanning': "जाँच जारी है",
          'device_found': 'उपकरण मिला',
          'scan_again': 'दुबारा जाँच करें',
          'password': 'पासवर्ड',
          'cancel': 'रिजेक्ट',
          'pair': 'जोड़ें',
          'successfully_paired': 'सफलतापूर्वक उपकरण जुड़ गया है ।',
          'device_status': "उपकरण स्थिति",
          'flushing_in_dp_mode': "डीपी के दोरन सफाई",
          'flushing_in_dp_&_time_mode': "डीपी और समय के दोरन सफाई",
          'flushing_error': "सफाई में रुकावट",
          'dp_cycle_count': "डीपी चक्र गिनती",
          'time_cycle_count': "समय चक्र गिनती",
          'manual_cycle_count': "स्वयं चक्र गिनती",
          'total_count': "पुरी गिनती",
          'flushing_interval_time_left': "सफाई शुरू करने के लिए बचा समय",
          'flushing_duration_time_left': "सफाई करते हुए बचा समय",
          'manual': "स्वयं सफाई करे",
          'buzzer_off': "आवाज़ बंद करें",
          'buzzer_on': "आवाज़ शुरू करें",
          'reset': "रीसेट",
          'start': "शुरू करें",
          'stop': "रोकें",
          'history': "पुरानी जानकारी",
          'filter_configuration': "उपकरण की आवश्यक चीजें",
          'operation_mode': "काम कर रहा है",
          'stand_alone': "अकेला फ़िल्टर",
          'battery_of_filters': "एक से अधिक फ़िल्टर",
          'flushing_mode': "सफाई कर रहा है",
          'dp_only': "केवल डीपी",
          'dp&time': "डीपी और समय",
          'flushing_interval': "सफाई का तय समय",
          "flushing_duration": "सफाई का समय",
          "hr": "घंटा",
          "min": "मिनट",
          "sec": "सेकंड",
          "dp_delay": "डीपी बिलंब",
          "looping_cycle": "लूपिंग चक्र",
          'count': "गिनती",
          "restore": "शुरुआती प्रस्थिति डालें",
          "save": "जमा करें",
          'enter_techinician_password': "कर्मचारी पास्वर्ड डालें",
          'change_name': 'नाम बदलें',
          'change_password': "पास्वर्ड बदलें",
          'remove': 'हटायें',
          'do_you_want_reset_counts':
              "क्या आप चक्र गिनती को रीसेट करना चाहते हैं?",
          "connected": "उपकरण जुड़ा है",
          "disconnected": "उपकरण नहीं जुड़ा है",
          "connecting": "उपकरण जुड़ रहा है...",
          'connect': "उपकरण जोड़ें",
          'disconnect': "उपकरण से टूटें",
          'yes': "हाँ",
          'no': "नहीं",
          'incorrect_password': "पास्वर्ड ग़लत है",
          'data_sent_successfully': "डेटा भेज दिया गया है ",
          'notification': "अधिसूचना",
          'error': "समस्या",
          "apply": "लागू हो रहा है"
        }
      };
}
