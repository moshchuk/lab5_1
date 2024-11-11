#include <iostream>
#include <iomanip>
#include <string>
#include <vector>
#include <Windows.h>

using namespace std;

// Перерахування для спеціальностей студентів
enum Speciality { ComputerScience, Informatics, MathAndEconomics, PhysicsAndInformatics, LaborTraining };

// Структура для зберігання інформації про студента
struct Student {
    string surname;
    int course;
    Speciality speciality;
    int physicsGrade;
    int mathGrade;
    union {
        int programmingGrade;       // Для ComputerScience
        int numericalMethodsGrade;   // Для Informatics
        int pedagogyGrade;           // Для інших спеціальностей
    };
};

// Функція для введення даних про студентів
void inputStudent(vector<Student>& students, int numStudents) {
    for (int i = 0; i < numStudents; ++i) {
        Student student;
        cout << "Enter surname of student " << i + 1 << ": ";
        cin >> student.surname;
        cout << "Enter course of student (1-5): ";
        cin >> student.course;

        int specialityInput;
        cout << "Enter speciality (0 - Computer Science, 1 - Informatics, 2 - Math & Economics, 3 - Physics & Informatics, 4 - Labor Training): ";
        cin >> specialityInput;
        student.speciality = static_cast<Speciality>(specialityInput);

        cout << "Enter physics grade: ";
        cin >> student.physicsGrade;
        cout << "Enter math grade: ";
        cin >> student.mathGrade;

        // Введення третьої оцінки залежно від спеціальності
        if (student.speciality == ComputerScience) {
            cout << "Enter programming grade: ";
            cin >> student.programmingGrade;
        }
        else if (student.speciality == Informatics) {
            cout << "Enter numerical methods grade: ";
            cin >> student.numericalMethodsGrade;
        }
        else {
            cout << "Enter pedagogy grade: ";
            cin >> student.pedagogyGrade;
        }

        students.push_back(student);
    }
}

// Функція для виведення таблиці студентів
void printStudentsTable(const vector<Student>& students) {
    cout << "--------------------------------------------------------------------------------------------------\n";
    cout << "| # |   Surname   | Course |      Speciality     | Physics | Math | Programming | Numerical Methods | Pedagogy |\n";
    cout << "--------------------------------------------------------------------------------------------------\n";

    for (size_t i = 0; i < students.size(); ++i) {
        cout << "| " << setw(2) << i + 1 << " | "
            << setw(11) << left << students[i].surname << " | "
            << setw(6) << right << students[i].course << " | ";

        // Відображення спеціальності студента
        switch (students[i].speciality) {
        case ComputerScience: cout << setw(18) << left << "Computer Science"; break;
        case Informatics: cout << setw(18) << left << "Informatics"; break;
        case MathAndEconomics: cout << setw(18) << left << "Math & Economics"; break;
        case PhysicsAndInformatics: cout << setw(18) << left << "Physics & Informatics"; break;
        case LaborTraining: cout << setw(18) << left << "Labor Training"; break;
        }

        // Виведення оцінок
        cout << " | " << setw(7) << right << students[i].physicsGrade;
        cout << " | " << setw(4) << students[i].mathGrade;

        // Виведення третьої оцінки залежно від спеціальності
        if (students[i].speciality == ComputerScience) {
            cout << " | " << setw(11) << students[i].programmingGrade << " | " << setw(17) << " " << " | " << setw(9) << " " << " |\n";
        }
        else if (students[i].speciality == Informatics) {
            cout << " | " << setw(11) << " " << " | " << setw(17) << students[i].numericalMethodsGrade << " | " << setw(9) << " " << " |\n";
        }
        else {
            cout << " | " << setw(11) << " " << " | " << setw(17) << " " << " | " << setw(9) << students[i].pedagogyGrade << " |\n";
        }
    }

    cout << "--------------------------------------------------------------------------------------------------\n";
}

// Функція для підрахунку кількості оцінок "5" з кожного предмета
int countExcellent(const vector<Student>& students, const string& subject) {
    int count = 0;
    for (const auto& student : students) {
        if (subject == "physics" && student.physicsGrade == 5) {
            ++count;
        }
        else if (subject == "math" && student.mathGrade == 5) {
            ++count;
        }
        else if (subject == "programming" && student.speciality == ComputerScience && student.programmingGrade == 5) {
            ++count;
        }
        else if (subject == "numerical_methods" && student.speciality == Informatics && student.numericalMethodsGrade == 5) {
            ++count;
        }
        else if (subject == "pedagogy" && student.speciality != ComputerScience && student.speciality != Informatics && student.pedagogyGrade == 5) {
            ++count;
        }
    }
    return count;
}

// Функція для підрахунку студентів, які отримали "5" з фізики та математики
int countPhysicsAndMath(const vector<Student>& students) {
    int count = 0;
    for (const auto& student : students) {
        if (student.physicsGrade == 5 && student.mathGrade == 5) {
            ++count;
        }
    }
    return count;
}

int main() {
    int numStudents;
    cout << "Enter the number of students: ";
    cin >> numStudents;
    cin.ignore();

    vector<Student> students;
    students.reserve(numStudents);

    inputStudent(students, numStudents);
    printStudentsTable(students);

    int excellentPhysics = countExcellent(students, "physics");
    cout << "Number of 'excellent' grades in Physics: " << excellentPhysics << endl;

    int excellentMath = countExcellent(students, "math");
    cout << "Number of 'excellent' grades in Math: " << excellentMath << endl;

    int excellentProgramming = countExcellent(students, "programming");
    cout << "Number of 'excellent' grades in Programming: " << excellentProgramming << endl;

    int excellentNumericalMethods = countExcellent(students, "numerical_methods");
    cout << "Number of 'excellent' grades in Numerical Methods: " << excellentNumericalMethods << endl;

    int excellentPedagogy = countExcellent(students, "pedagogy");
    cout << "Number of 'excellent' grades in Pedagogy: " << excellentPedagogy << endl;

    int studentsWithExcellentPhysicsAndMath = countPhysicsAndMath(students);
    cout << "Number of students with '5' in Physics and Math: " << studentsWithExcellentPhysicsAndMath << endl;

    return 0;
}
