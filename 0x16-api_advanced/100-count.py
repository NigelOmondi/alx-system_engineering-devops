#!/usr/bin/python3
"""Parses titles of all hot articles"""
import requests
import sys


def count_words(subreddit, word_list, after=None, word_counts=None):
    """Print a sorted count of given keywords."""
    if word_counts is None:
        word_counts = {}
    if after is None:
        url = f"https://www.reddit.com/r/{subreddit}/hot.json?limit=10"
    else:
        url = (
               f"https://www.reddit.com/r/{subreddit}/hot.json?"
               f"limit=10&after={after}"
        )

    headers = {"User-Agent": "MyRedditBot/1.0"}

    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        data = response.json()
        if 'data' in data and 'children' in data['data']:
            posts = data['data']['children']
            if len(posts) == 0:
                sorted_words = sorted(word_counts.items(),
                                      key=lambda x: (-x[1], x[0]))
                for word, count in sorted_words:
                    print(f"{word.lower()}: {count}")
                return

            for post in posts:
                title = post['data']['title'].lower()
                for word in word_list:
                    if word.lower() in title:
                        if word.lower() in word_counts:
                            word_counts[word.lower()] += 1
                        else:
                            word_counts[word.lower()] = 1

            last_post_id = posts[-1]['data']['name']
            count_words(subreddit, word_list, last_post_id, word_counts)
        else:
            return
    else:
        return


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: {} <subreddit> <list of keywords>".format(sys.argv[0]))
        print("Ex: {} programming 'python java javascript'"
              .format(sys.argv[0]))
    else:
        subreddit = sys.argv[1]
        word_list = sys.argv[2].split()
        count_words(subreddit, word_list)
