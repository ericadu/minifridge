import argparse
import csv
from datetime import datetime
from dateutil import tz
import firebase_admin
from firebase_admin import credentials, firestore

PATH = "/Users/ericadu/dev/minifridge/minifridge-firebase-adminsdk-z4sw9-387a25099d.json"

def get_datetime(time_string):
  from_zone = tz.gettz('UTC')
  to_zone = tz.gettz('America/New_York')
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
  parser.add_argument('--filepath', action='store', help='Data import path', default="data/erica-new-Grid.csv")
  parser.add_argument('--user', action='store', help='Firestore USER_ID', default="3N6fMDSeV4bcCd59ZzrjGYTXGwG2")
  parser.add_argument('--base', action='store', help="Firestore BASE_ID", default="nHfhaJGTmV8x2Qu4llL9")

  args = parser.parse_args()

  USER_ID = args.user
  FILEPATH = args.filepath
  BASE_ID = args.base

  if (valid_user(USER_ID) and valid_file(FILEPATH) and valid_user(BASE_ID)):
    cred = credentials.Certificate(PATH)
    firebase_admin.initialize_app(cred)
    datab = firestore.client()

    userItemsRef = datab.collection('bases', BASE_ID, 'items')

    with open(FILEPATH, 'r') as f:
      reader = csv.reader(f)
      next(reader)
      for row in reader:
        new_item = {
          'displayName': row[1],
          'buyTimestamp': get_datetime(row[2]),
          'shelfLife': {
            'dayRangeStart': int(row[3]),
            'dayRangeEnd': int(row[4])
          },
          'quantity': int(row[5]) if len(row[5]) > 0 else 1,
          'referenceTimestamp': get_datetime(row[2]),
          'unit': 'item',
          'addedByUserId': USER_ID,
          # 'quantity': int(row[4]) if len(row[3]) > 0 else 1,
          # 'unit': row[5],
          # 'storageType': row[6],
          # 'state': row[7],
          # 'eaten': False
        }

        userItemsRef.document().create(new_item)
        print(new_item)
  else:
    print("invalid user or filepath.")