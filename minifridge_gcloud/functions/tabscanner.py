import requests
import json
from dotenv import load_dotenv
import os

# load your environment containing the api key
BASEDIR = os.path.abspath(os.path.dirname(__file__))
load_dotenv(os.path.join(BASEDIR, '.env'))
API_KEY = os.getenv("TABSCANNER_API_KEY")

def callResult(token):
    url = "https://api.tabscanner.com/api/result/{0}"
    endpoint = url.format(token)

    headers = {'apikey': API_KEY}

    response = requests.get(endpoint,headers=headers)
    result = json.loads(response.text)

    return result


def callProcess(image):
  endpoint = "https://api.tabscanner.com/api/2/process"
  receipt_image = image

  payload = {
    "documentType":"receipt",
    "region": "us"
  }
  with open(receipt_image, 'rb') as f:
    # contents = f.read()
    files = {'file': f}
    headers = {'apikey': API_KEY}

    response = requests.post( endpoint,
                              files=files,
                              data=payload,
                              headers=headers)
    result = json.loads(response.text)
    return result

def extract(result):
  for item in result['lineItems']:
    if item['lineTotal'] > 0:
      print('{},{}'.format(item['descClean'],item['lineTotal']))

response = callProcess()
result = callResult(response['token'])
result = callResult('ty0HZLekhDC4DqNr')

print(result)
