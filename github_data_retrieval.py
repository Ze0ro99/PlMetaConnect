import requests
import json

# Repository details
REPO_OWNER = "Ze0ro99"
REPO_NAME = "PiMetaConnect"

# GitHub API Base URL
GITHUB_API_URL = "https://api.github.com"

# Headers for API requests (no authentication by default to stay within free limits)
HEADERS = {
    "Accept": "application/vnd.github.v3+json"
}

# Function to fetch repository details
def get_repo_details():
    url = f"{GITHUB_API_URL}/repos/{REPO_OWNER}/{REPO_NAME}"
    response = requests.get(url, headers=HEADERS)
    if response.status_code == 200:
        return response.json()
    return {"error": response.json()}

# Function to fetch issues
def get_issues(state="open"):
    url = f"{GITHUB_API_URL}/repos/{REPO_OWNER}/{REPO_NAME}/issues"
    params = {"state": state}
    response = requests.get(url, headers=HEADERS, params=params)
    if response.status_code == 200:
        return response.json()
    return {"error": response.json()}

# Function to fetch pull requests
def get_pull_requests(state="open"):
    url = f"{GITHUB_API_URL}/repos/{REPO_OWNER}/{REPO_NAME}/pulls"
    params = {"state": state}
    response = requests.get(url, headers=HEADERS, params=params)
    if response.status_code == 200:
        return response.json()
    return {"error": response.json()}

# Function to fetch contributors
def get_contributors():
    url = f"{GITHUB_API_URL}/repos/{REPO_OWNER}/{REPO_NAME}/contributors"
    response = requests.get(url, headers=HEADERS)
    if response.status_code == 200:
        return response.json()
    return {"error": response.json()}

# Function to format and print data
def format_and_print(data, title):
    print(f"\n{'=' * 10} {title} {'=' * 10}")
    if isinstance(data, list):
        for item in data:
            print(json.dumps(item, indent=4))
    else:
        print(json.dumps(data, indent=4))

# Main function to automate data retrieval and formatting
def main():
    print(f"Automating data retrieval for repository: {REPO_OWNER}/{REPO_NAME}")
    
    # Fetch and display repository details
    repo_details = get_repo_details()
    format_and_print(repo_details, "Repository Details")
    
    # Fetch and display open issues
    issues = get_issues()
    format_and_print(issues, "Open Issues")
    
    # Fetch and display open pull requests
    pull_requests = get_pull_requests()
    format_and_print(pull_requests, "Open Pull Requests")
    
    # Fetch and display contributors
    contributors = get_contributors()
    format_and_print(contributors, "Contributors")

if __name__ == "__main__":
    main()
