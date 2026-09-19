Future<String?> getStudent(int userId) async {
  await Future.delayed(const Duration(seconds: 1));

  if (userId <= 0) {
    throw Exception('Invalid user ID');
  }

  switch (userId) {
    case 1:
      return 'Sahil Pandey';
    case 2:
      return 'Naman Sethi';
    case 3:
      return 'Ayush Aryan';
    default:
      return null;
  }
}

Future<void> showStudent(int userId) async {
  print('Searching for student with ID: $userId');

  try {
    final String? studentName = await getStudent(userId);

    if (studentName != null) {
      print('Student found: $studentName');
    } else {
      print('No student found with ID $userId');
    }
  } catch (e) {
    print('Something went wrong: $e');
  }

  print('-------------------------');
}

Future<void> main() async {
  print('Student Data Fetcher');
  print('====================');

  await showStudent(1);
  await showStudent(3);
  await showStudent(5);
  await showStudent(-1);
}