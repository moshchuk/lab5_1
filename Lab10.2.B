#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
#include <algorithm>
#include <numeric> // Для iota
#include <Windows.h> // Для налаштування кодування на Windows
using namespace std;

// Перелік спеціальностей
enum Specialty { COMPUTER_SCIENCE, INFORMATICS, MATH_AND_ECONOMICS, PHYSICS_AND_INFORMATICS, LABOR_EDUCATION };
string specialtyStr[] = { "Комп'ютерні науки", "Інформатика", "Математика та економіка", "Фізика та інформатика", "Трудове навчання" };

// Об'єднання для третьої оцінки залежно від спеціальності
union ThirdGrade {
    double programming;        // Для Комп'ютерних наук
    double numericalMethods;   // Для Інформатики
    double pedagogy;           // Для інших спеціальностей
};

// Структура для зберігання даних студента
struct Student {
    string lastName;
    int year;
    Specialty specialty;
    double physicsGrade;
    double mathGrade;
    ThirdGrade thirdGrade;
};

// Прототипи функцій
void CreateStudents(vector<Student>& students);
void PrintStudents(const vector<Student>& students);
void SortStudents(vector<Student>& students);
void CreateIndexArray(const vector<Student>& students, vector<int>& indexArray);
int BinarySearch(const vector<Student>& students, const string& lastName, Specialty specialty, double avgGrade);
double Average(const Student& student);

int main() {
    // Налаштування кодування консолі для української мови на Windows
    SetConsoleCP(1251);
    SetConsoleOutputCP(1251);

    vector<Student> students;
    int menuItem;

    do {
        cout << endl << "Виберіть дію:" << endl;
        cout << "[1] - Введення даних студентів" << endl;
        cout << "[2] - Виведення таблиці студентів" << endl;
        cout << "[3] - Фізичне впорядкування студентів" << endl;
        cout << "[4] - Індексне впорядкування студентів" << endl;
        cout << "[5] - Пошук студента" << endl;
        cout << "[0] - Вихід" << endl;
        cout << "Введіть значення: ";
        cin >> menuItem;

        switch (menuItem) {
        case 1:
            CreateStudents(students);
            break;
        case 2:
            PrintStudents(students);
            break;
        case 3:
            SortStudents(students);
            break;
        case 4: {
            vector<int> indexArray;
            CreateIndexArray(students, indexArray);
            cout << "Індексне впорядкування успішно виконано." << endl;
            break;
        }
        case 5: {
            string lastName;
            int specialtyIndex;
            double avgGrade;
            cout << "Введіть прізвище для пошуку: ";
            cin >> lastName;
            cout << "Введіть спеціальність (0 - Комп'ютерні науки, 1 - Інформатика, 2 - Математика та економіка, 3 - Фізика та інформатика, 4 - Трудове навчання): ";
            cin >> specialtyIndex;
            cout << "Введіть середній бал для пошуку: ";
            cin >> avgGrade;
            int index = BinarySearch(students, lastName, static_cast<Specialty>(specialtyIndex), avgGrade);
            if (index != -1) {
                cout << "Студент знайдений: " << students[index].lastName << endl;
            }
            else {
                cout << "Студента не знайдено." << endl;
            }
            break;
        }
        case 0:
            break;
        default:
            cout << "Невірний ввід! Спробуйте ще раз." << endl;
            break;
        }
    } while (menuItem != 0);

    return 0;
}

void CreateStudents(vector<Student>& students) {
    int N;
    cout << "Введіть кількість студентів: ";
    cin >> N;
    students.resize(N);

    for (int i = 0; i < N; i++) {
        cout << "Студент № " << i + 1 << ":" << endl;
        cout << "Прізвище: ";
        cin >> students[i].lastName;

        cout << "Курс: ";
        cin >> students[i].year;

        int specialtyIndex;
        cout << "Спеціальність (0 - Комп'ютерні науки, 1 - Інформатика, 2 - Математика та економіка, 3 - Фізика та інформатика, 4 - Трудове навчання): ";
        cin >> specialtyIndex;
        students[i].specialty = static_cast<Specialty>(specialtyIndex);

        cout << "Оцінка з фізики: ";
        cin >> students[i].physicsGrade;

        cout << "Оцінка з математики: ";
        cin >> students[i].mathGrade;

        switch (students[i].specialty) {
        case COMPUTER_SCIENCE:
            cout << "Оцінка з програмування: ";
            cin >> students[i].thirdGrade.programming;
            break;
        case INFORMATICS:
            cout << "Оцінка з чисельних методів: ";
            cin >> students[i].thirdGrade.numericalMethods;
            break;
        default:
            cout << "Оцінка з педагогіки: ";
            cin >> students[i].thirdGrade.pedagogy;
            break;
        }
    }
}

void PrintStudents(const vector<Student>& students) {
    cout << "=================================================================" << endl;
    cout << "| № | Прізвище           | Курс | Спеціальність       | Фізика | Математика | Третя Оцінка |" << endl;
    cout << "-----------------------------------------------------------------" << endl;

    for (size_t i = 0; i < students.size(); i++) {
        cout << "| " << setw(2) << i + 1 << " | " << setw(15) << students[i].lastName << " | " << setw(4) << students[i].year
            << " | " << setw(20) << specialtyStr[students[i].specialty] << " | " << setw(6) << students[i].physicsGrade
            << " | " << setw(10) << students[i].mathGrade << " | ";

        if (students[i].specialty == COMPUTER_SCIENCE)
            cout << setw(11) << students[i].thirdGrade.programming;
        else if (students[i].specialty == INFORMATICS)
            cout << setw(11) << students[i].thirdGrade.numericalMethods;
        else
            cout << setw(11) << students[i].thirdGrade.pedagogy;

        cout << " |" << endl;
    }

    cout << "=================================================================" << endl;
}

void SortStudents(vector<Student>& students) {
    sort(students.begin(), students.end(), [](const Student& a, const Student& b) {
        double avgA = Average(a);
        double avgB = Average(b);
        if (avgA != avgB) return avgA > avgB;
        if (a.specialty != b.specialty) return a.specialty < b.specialty;
        return a.lastName < b.lastName;
        });
}

void CreateIndexArray(const vector<Student>& students, vector<int>& indexArray) {
    indexArray.resize(students.size());
    iota(indexArray.begin(), indexArray.end(), 0);
    sort(indexArray.begin(), indexArray.end(), [&students](int i, int j) {
        double avgI = Average(students[i]);
        double avgJ = Average(students[j]);
        if (avgI != avgJ) return avgI > avgJ;
        if (students[i].specialty != students[j].specialty) return students[i].specialty < students[j].specialty;
        return students[i].lastName < students[j].lastName;
        });
}

int BinarySearch(const vector<Student>& students, const string& lastName, Specialty specialty, double avgGrade) {
    int left = 0, right = students.size() - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        double midAvg = Average(students[mid]);

        if (students[mid].lastName == lastName && students[mid].specialty == specialty && midAvg == avgGrade) {
            return mid;
        }
        else if (midAvg > avgGrade || (midAvg == avgGrade && (students[mid].specialty < specialty || (students[mid].specialty == specialty && students[mid].lastName < lastName)))) {
            left = mid + 1;
        }
        else {
            right = mid - 1;
        }
    }
    return -1;
}

double Average(const Student& student) {
    double thirdGrade;
    if (student.specialty == COMPUTER_SCIENCE)
        thirdGrade = student.thirdGrade.programming;
    else if (student.specialty == INFORMATICS)
        thirdGrade = student.thirdGrade.numericalMethods;
    else
        thirdGrade = student.thirdGrade.pedagogy;

    return (student.physicsGrade + student.mathGrade + thirdGrade) / 3.0;
}
