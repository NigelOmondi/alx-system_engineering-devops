#!/usr/bin/python3
"""Titles of first 10 hot posts listed on a iven subreddit"""
import requests
import sys


def top_ten(subreddit):
    """Print top 10 hot posts"""
    url = f"https://www.reddit.com/r/{subreddit}/hot.json?limit=10"

    # Provide a User-Agent to identify my script
    headers = {"User-Agent": "MyRedditBot/1.0"}

    response = requests.get(url, headers=headers)

    # Check if the request was successful
    if response.status_code == 200:
        data = response.json()
        if 'data' in data and 'children' in data['data']:
            posts = data['data']['children']
            for post in posts:
                print(post['data']['title'])
    else:
        print(None)  # Print None for invalid subreddits or other errors


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Please pass an argument for the subreddit to search.")
    else:
        top_ten(sys.argv[1])
