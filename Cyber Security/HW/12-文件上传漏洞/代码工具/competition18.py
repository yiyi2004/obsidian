import requests
url = "http://localhost:7298/upload-labs/upload/competition.php"
while True:
    html = requests.get(url)
    if html.status_code == 200:
        print("OK")
        break