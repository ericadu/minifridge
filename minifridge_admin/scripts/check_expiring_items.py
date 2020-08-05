import argparse
import datetime
from dateutil import tz
import firebase_admin
from firebase_admin import credentials, firestore, messaging
import json

PATH = "/Users/ericadu/dev/minifridge/minifridge-firebase-adminsdk-z4sw9-387a25099d.json"
CREDS_PATH = "/Users/ericadu/github/minifridge/minifridge_admin/data/creds.json"

def valid_user(userid_string):
  if userid_string is not None and len(userid_string) > 0:
    return True
  return False

# TODO: modify to send to many tokens
def send_to_token(token, items):
  text = ''
  if (len(items) < 3):
    text = "Your " + ' and '.join(items) + " are about to go bad. Maybe add them to the menu today!"
  else:
    text = "Your " + items[0] + " and " + str(len(items) - 1) + " other items are about to go bad. Maybe add them to the menu today!"

  message = messaging.Message(
    notification=messaging.Notification(
      title='Pssst... 👀',
      body=text
    ),
    token=token
  )

  response = messaging.send(message)

  print(", ".join(items))
  print('Successfully sent message:', response)

if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  args = parser.parse_args()

  cred = credentials.Certificate(PATH)
  firebase_admin.initialize_app(cred)
  datab = firestore.client()
  today = datetime.date.today()
  with open (CREDS_PATH) as d:
    creds_dict = json.load(d)

    ## TODO: for each user
    for name, user in creds_dict.items():
    # user_name = 'erica'
    # user = creds_dict[user_name]

      user_id = user["userId"]
      base_id = user["baseId"]
      filepath = user["filepath"]
      timezone = user["time"]
      token = user["pushToken"]

      if (valid_user(user_id) and valid_user(base_id)):
        user_items = datab.collection('bases', base_id, 'items').stream()
        expiring_items = []
        for doc in user_items:
          item = doc.to_dict()
          if ('endType' not in item) or ('endType' in item and item['endType'] == 'alive'):
            if ('perishable' in item['shelfLife'] and item['shelfLife']['perishable'] == False):
              continue

            reference_timestamp = item['referenceTimestamp']
            days = datetime.timedelta(days=item['shelfLife']['dayRangeStart'])
            enter_zone = reference_timestamp + days
            difference = (enter_zone.date() - today).days
            if difference == 0:
              expiring_items.append(item['displayName'])
        
        if len(expiring_items) > 0:
          send_to_token(token, expiring_items)
          print("sent notification to: ", name)
      else:
        print("invalid user or filepath: ", name)