import argparse
import csv
from datetime import datetime
from dateutil import tz
import firebase_admin
from firebase_admin import credentials, firestore, messaging
import json

PATH = "/Users/ericadu/dev/minifridge/minifridge-firebase-adminsdk-z4sw9-387a25099d.json"
CREDS_PATH = "/Users/ericadu/github/minifridge/minifridge_admin/data/creds.json"

categories = [
  'Dairy & Alternatives',
  'Proteins',
  'Grains',
  'Fruits',
  'Vegetables',
  'Snacks & Sweets',
  'Sauces & Spreads',
  'Beverages',
  'Alcohol',
  'Supplements',
  'Prepared meals',
  'Misc',
  'Uncategorized'
]

category_map = {
  'dairy': categories[0],
  'dairy and alternatives': categories[0],
  'animal based protein': categories[1],
  'plant based protein': categories[1],
  'protein': categories[1],
  'protein (animal and plant based)': categories[1],
  'grains': categories[2],
  'fruit': categories[3],
  'vegetables': categories[4],
  'snacks and sweets': categories[5],
  'sauces': categories[6],
  'condiments, sauces, spreads': categories[6],
  'beverages': categories[7],
  'beverages, non alcoholic': categories[7],
  'alcohol': categories[8],
  'supplements': categories[9],
  'prepared': categories[10],
  'prepared meals': categories[10],
  'misc': categories[11]
}

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

# TODO: change to handle multiple tokens.
def send_to_token(token):
  message = messaging.Message(
    notification=messaging.Notification(
      title='Your fridge is stocked! 🚀',
      body='Your receipt was processed and new food has been added to your base. Eat up 🐛'
    ),
    token=token
  )

  response = messaging.send(message)

  print('Successfully sent message:', response)

if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('--user', action='store', help='Firestore USER_ID', default="erica")
  parser.add_argument('--dryrun', dest='dryrun', action='store_true')
  parser.set_defaults(dryrun=False)
  args = parser.parse_args()

  USER_NAME = args.user
  DRYRUN = args.dryrun

  with open (CREDS_PATH) as d:
    creds_dict = json.load(d)
    user = creds_dict[USER_NAME]

    user_id = user["userId"]
    base_id = user["baseId"]
    filepath = user["filepath"]
    timezone = user["time"]
    token = user["pushToken"]

    if (valid_user(user_id) and valid_file(filepath) and valid_user(base_id)):
      cred = credentials.Certificate(PATH)
      firebase_admin.initialize_app(cred)
      datab = firestore.client()

      userItemsRef = datab.collection('bases', base_id, 'items')

      with open(filepath, 'r') as f:
        reader = csv.reader(f)
        next(reader)
        for row in reader:
          if len(row[0]) > 0:
            shelf_life = {
              'perishable': True if len(row[6]) > 0 or len(row[10]) > 0 else False
            }

            if (len(row[10]) > 0):
              shelf_life['dayRangeStart'] = int(row[10])
            
            if (len(row[11]) > 0):
              shelf_life['dayRangeEnd'] = int(row[11])

            new_item = {
              'displayName': row[0].strip(),
              'category': category_map[row[1]] if len(row[1]) > 0  else 'Uncategorized',
              'buyTimestamp': get_datetime(row[2], timezone),
              'shelfLife': shelf_life,
              'price': float(row[3]) if len(row[3]) > 0 else None,
              'quantity': int(float(row[4])) if len(row[4]) > 0 else 1,
              'referenceTimestamp': get_datetime(row[2], timezone),
              'unit': row[5],
              'addedByUserId': user_id,
              'storageType': row[7],
              'state': row[8],
              'endType': 'alive',
              'hasPrintedDate': True if len(row[9]) > 0 else False
            }

            if not DRYRUN:
              userItemsRef.document().create(new_item)
              print("Created: ")
            else:
              print("Generated: ")

            print(new_item)
      
        if not DRYRUN:
          send_to_token(token)
        else:
          print("\ncompleted dryrun!")
    else:
      print("invalid user or filepath.")