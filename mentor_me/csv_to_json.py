import csv
import json

def main():
    # Read CSV file and convert to JSON
    csv_file_path = 'assets/csv/courses.csv'
    json_file_path = 'assets/json/course_codes.json'

    courses = {}

    with open(csv_file_path, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            courses[row['CourseCode']] = row['CourseName']

    # Write JSON file
    with open(json_file_path, 'w') as jsonfile:
        json.dump(courses, jsonfile, indent=2)

if __name__ == '__main__':
    main()