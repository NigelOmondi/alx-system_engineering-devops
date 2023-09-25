#!/usr/bin/python3
"""
Python script that fetches data from a REST API for a given employee ID
and displays information about their TODO list progress.
"""

import requests
import sys
import csv


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(1)

    employee_id = sys.argv[1]

    # Fetch user data
    user_url = \
        "https://jsonplaceholder.typicode.com/users/{}".format(employee_id)
    user_response = requests.get(user_url)
    user_data = user_response.json()
    user_id = user_data.get("id")
    employee_name = user_data.get("name")

    # Fetch TODO list data
    todo_url = "https://jsonplaceholder.typicode.com/todos?userId={}"\
        .format(employee_id)
    todo_response = requests.get(todo_url)
    todo_data = todo_response.json()

    # Create and write to CSV file
    csv_filename = "{}.csv".format(user_id)
    with open(csv_filename, mode="w", newline="") as csv_file:
        csv_writer = csv.writer(csv_file, quoting=csv.QUOTE_ALL)
        for task in todo_data:
            task_id = task.get("id")
            completed = task.get("completed")
            task_title = task.get("title")
            csv_writer.writerow([user_id, employee_name,
                                 completed, task_title])

    print("CSV file '{}' has been created.".format(csv_filename))
