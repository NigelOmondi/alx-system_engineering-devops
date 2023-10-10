#!/usr/bin/python3
"""Return number of subscribers"""
import requests
import sys


def number_of_subscribers(subreddit):
    """Finding total number of subscribers"""
    url = f"https://www.reddit.com/r/{subreddit}/about.json"
    headers = {'User-Agent': 'my-api/1.0'}

    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        data = response.json()
        return data['data']['subscribers']
    else:
        return 0  # Invalid subreddit


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Print pass an argument for the subreddit to search.")
    else:
        subreddit = sys.argv[1]
        subscribers = number_of_subscribers(subreddit)
        print(subscribers)
