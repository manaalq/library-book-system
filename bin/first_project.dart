import 'dart:io'; // For file operations and user input
import 'dart:convert'; // For converting to/from JSON
//aa
// Book class
class Book {
  int id;
  String author;
  String title;
  int year;
  String category;

  Book(this.id, this.author, this.title, this.year, this.category);

  @override
  String toString() {
    return 'id: $id | author: $author | title: $title | year: $year | category: $category';
  }
}

void main() {
  List<Book> library = []; // Main list to store books
  bool isArabic = false; // Language toggle

  loadFromFile(library); // Load books from file at startup

  // Ask the user to choose a language
  print("Choose language / اختر اللغة:");
  print("1. English");
  print("2. العربية");
  String? lang = stdin.readLineSync();
  if (lang == '2') {
    isArabic = true;
  }

  //  menu loop
  while (true) {
    if (isArabic) {
      print('\n إدارة مكتبة الكتب');
      print('1. عرض جميع الكتب');
      print('2. إضافة كتاب جديد');
      print('3. تعديل كتاب');
      print('4. البحث عن كتاب');
      print('5. حذف كتاب');
      print('6. ترتيب الكتب');
      print('7. تغيير اللغة');
      print('8. خروج');
    } else {
      //English
      print('\n Book Library Management');
      print('1. List all books');
      print('2. Add a new book');
      print('3. Edit a book');
      print('4. Search for a book');
      print('5. Delete a book');
      print('6. Sort books');
      print('7. Change language');
      print('8. Exit');
    }

    String? choice = stdin.readLineSync();

    try {
      switch (choice) {
        case '1':
          ListBooks(library);
          break;
        case '2':
          addBook(library);
          break;
        case '3':
          print(isArabic ? "أدخل رقم الكتاب للتعديل" : "Enter id book you want to edit");
          int? editId = int.parse(stdin.readLineSync()!);
          editBook(library, editId);
          break;
        case '4':
          print(isArabic ? "أدخل كلمة للبحث (عنوان أو مؤلف)" : "Enter keyword (part of a title or author name)");
          String? keyword = stdin.readLineSync();
          searchBooks(library, keyword!);
          break;
        case '5':
          print(isArabic ? "أدخل رقم الكتاب للحذف" : "Enter id book you want to delete");
          int? deleteId = int.parse(stdin.readLineSync()!);
          deleteBook(library, deleteId);
          break;
        case '6':
          sortBooks(library);
          break;
        case '7':
          print("Choose language / اختر اللغة:");
          print("1. English");
          print("2. العربية");
          String? lang = stdin.readLineSync();
          isArabic = (lang == '2');
          break;
        case '8':
          exitProgram();
          break;
        default:
          print(isArabic ? "خيار غير صالح" : "Invalid input");
      }
    } catch (e) {
      print(isArabic ? " خطأ في الإدخال" : " Error: Invalid input or unexpected issue.");
    }
  }
}

// Add one or more books
void addBook(List<Book> library) {
  print('How many books you want to add');
  int numOfBooks = int.parse(stdin.readLineSync()!);

  for (int i = 0; i < numOfBooks; i++) {
    print('Enter id book');
    int newBookID = int.parse(stdin.readLineSync()!);

    print('Enter author:');
    String newBookAuthor = stdin.readLineSync()!;

    print('Enter title:');
    String newBookTitle = stdin.readLineSync()!;

    print('Enter Year:');
    int newBookYear = int.parse(stdin.readLineSync()!);

    print('Enter Category:');
    String newBookCategory = stdin.readLineSync()!;

    // Check for duplicate book by title and author
    bool exists = false;
    for (var book in library) {
      if (book.title.toLowerCase() == newBookTitle.toLowerCase() &&
          book.author.toLowerCase() == newBookAuthor.toLowerCase()) {
        exists = true;
        break;
      }
    }

    if (exists) {
      print(' This book already exists.');
    } else {
      library.add(Book(newBookID, newBookAuthor, newBookTitle, newBookYear, newBookCategory));
      print(' Book added successfully!');
      saveToFile(library);
    }
  }
}

// Display all books in the library
void ListBooks(List<Book> library) {
  if (library.isEmpty) {
    print("The list is empty.");
  } else {
    print(" Book List:");
    library.forEach((book) {
      print(book);
    });
  }
}

// Search for books by title or author
void searchBooks(List<Book> library, String keyword) {
  bool found = false;

  library.forEach((book) {
    if (book.author.contains(keyword) || book.title.contains(keyword)) {
      print(book);
      found = true;
    }
  });

  if (!found) {
    print("Sorry, no matching books found.");
  }
}

// Edit book data
void editBook(List<Book> library, int id) {
  library.forEach((book) {
    if (book.id == id) {
      print('What do you want to edit?');
      print('1. Author');
      print('2. Title');
      print('3. Year');
      print('4. All');

      String? choiceEdit = stdin.readLineSync();

      switch (choiceEdit) {
        case '1':
          print('Enter new author:');
          book.author = stdin.readLineSync()!;
          break;
        case '2':
          print('Enter new title:');
          book.title = stdin.readLineSync()!;
          break;
        case '3':
          print('Enter new year:');
          book.year = int.parse(stdin.readLineSync()!);
          break;
        case '4':
          print('Enter new author:');
          book.author = stdin.readLineSync()!;
          print('Enter new title:');
          book.title = stdin.readLineSync()!;
          print('Enter new year:');
          book.year = int.parse(stdin.readLineSync()!);
          break;
        default:
          print("Invalid input");
      }

      print(' Book updated successfully!');
      saveToFile(library);
    }
  });
}

// Delete a book by ID
void deleteBook(List<Book> library, int id) {
  for (int i = 0; i < library.length; i++) {
    if (library[i].id == id) {
      library.removeAt(i);
      print(' Book with ID $id deleted.');
      saveToFile(library);
      return;
    }
  }

  print(' Book with ID $id not found.');
}

// Exit the program
void exitProgram() {
  print(' Thank you for using the Book Library!');
  exit(0);
}

// Sort the book list by title or year
void sortBooks(List<Book> library) {
  print('Sort By:');
  print('1. Title');
  print('2. Year');
  String? sortChoice = stdin.readLineSync();

  if (sortChoice == '1') {
    library.sort((a, b) => a.title.compareTo(b.title));
    print(' Sorted by Title:');
    ListBooks(library);
  } else if (sortChoice == '2') {
    library.sort((a, b) => a.year.compareTo(b.year));
    print(" Sorted by Year:");
    ListBooks(library);
  } else {
    print(" Invalid sorting option.");
  }
}

// Save the book list to a JSON file
void saveToFile(List<Book> library) {
  final file = File('books.json');

  List<Map<String, dynamic>> data = library.map((book) => {
    'id': book.id,
    'author': book.author,
    'title': book.title,
    'year': book.year,
    'category': book.category
  }).toList();

  file.writeAsStringSync(jsonEncode(data));
}

// Load book data from a JSON file
void loadFromFile(List<Book> library) {
  final file = File('books.json'); // Create a file 

  // Check if the file exists before reading
  if (file.existsSync()) {
    String contents = file.readAsStringSync(); // Read the file content as a string
    List<dynamic> data = jsonDecode(contents); // Decode the JSON string into a list

    // Loop each item in the list and convert it into a Book object
    for (var item in data) {
      library.add(Book(
        item['id'],
        item['author'],
        item['title'],
        item['year'],
        item['category']
      ));
    }
  }
}
