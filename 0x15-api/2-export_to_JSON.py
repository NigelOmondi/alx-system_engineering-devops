#!/usr/bin/python3
"""Export to JSON"""

import json
import requests
import sys


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(1)

    employee_id = sys.argv[1]

    # Fetch user data
    user_url = \
        "https://jsonplaceholder.typicode.com/users/{}".format(employee_id)
    user_response = requests.get(user_url)
    user_data = user_response.json()
    employee_name = user_data.get("username")

    # Fetch TODO list data
    todo_url = "https://jsonplaceholder.typicode.com/todos?userId={}"\
        .format(employee_id)
    todo_response = requests.get(todo_url)
    todo_data = todo_response.json()

    # Create a dictionary to store the JSON data
    json_data = {employee_id: []}

    # Iterate through tasks and populate the JSON data
    for task in todo_data:
        task_data = {
            "task": task.get("title"),
            "completed": task.get("completed"),
            "username": employee_name,
        }
        json_data[employee_id].append(task_data)

    # Define the output file name
    output_filename = f"{employee_id}.json"

    # Write the JSON data to the output file
    with open(output_filename, "w") as json_file:
        json.dump(json_data, json_file, indent=4)

    print(f"Data exported to {output_filename}")
