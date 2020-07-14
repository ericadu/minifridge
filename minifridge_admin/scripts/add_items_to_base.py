import argparse
import csv
from datetime import datetime
from dateutil import tz
import firebase_admin
from firebase_admin import credentials, firestore
import json

PATH = "/Users/ericadu/dev/minifridge/minifridge-firebase-adminsdk-z4sw9-387a25099d.json"
CREDS_PATH = "/Users/ericadu/github/minifridge/minifridge_admin/data/creds.json"

def get_datetime(time_string, time_zone):
  from_zone = tz.gettz('UTC')
  to_zone = tz.gettz(time_zone)
  utc = datetime.strptime(time_string, "%Y-%m-%d")

  utc = utc.replace(tzinfo=from_zone)
  eastern = utc.astimezone(to_zone)
  return eastern

def valid_user(userid_string):
  if userid_string is not None and len(userid_string) > 0:
    return True
  return False

def valid_file(filepath_string):
  if filepath_string is not None and len(filepath_string) > 0 and '.csv' in filepath_string:
    return True
  return False

if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('--user', action='store', help='Firestore USER_ID', default="erica")

  args = parser.parse_args()

  USER_NAME = args.user

  with open (CREDS_PATH) as d:
    creds_dict = json.load(d)
    user = creds_dict[USER_NAME]

    user_id = user["userId"]
    base_id = user["baseId"]
    filepath = user["filepath"]
    timezone = user["time"]

    if (valid_user(user_id) and valid_file(filepath) and valid_user(base_id)):
      cred = credentials.Certificate(PATH)
      firebase_admin.initialize_app(cred)
      datab = firestore.client()

      userItemsRef = datab.collection('bases', base_id, 'items')

      with open(filepath, 'r') as f:
        reader = csv.reader(f)
        next(reader)
        for row in reader:
          new_item = {
            'displayName': row[1],
            'buyTimestamp': get_datetime(row[2], timezone),
            'shelfLife': {
              'dayRangeStart': int(row[3]),
              'dayRangeEnd': int(row[4])
            },
            'price': float(row[5]) if len(row[5]) > 0 else None,
            'quantity': int(row[6]) if len(row[6]) > 0 else 1,
            'referenceTimestamp': get_datetime(row[2], timezone),
            'unit': row[7],
            'addedByUserId': user_id,
            'storageType': row[8],
            'state': row[9],
          }

          userItemsRef.document().create(new_item)
          print(new_item)
    else:
      print("invalid user or filepath.")