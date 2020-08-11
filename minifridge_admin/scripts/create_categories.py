import firebase_admin
from firebase_admin import credentials, firestore, messaging

PATH = "/Users/ericadu/dev/minifridge/minifridge-firebase-adminsdk-z4sw9-387a25099d.json"
CREDS_PATH = "/Users/ericadu/github/minifridge/minifridge_admin/data/creds.json"


categories = [
  'dairy and dairy alternatives',
  'animal-based protein',
  'plant-based protein',
  'grains',
  'fruit',
  'vegetables',
  'snacks and sweets',
  'condiments, sauces, and spreads',
  'non-alcoholic beverages',
  'alcohol',
  'supplements',
  'prepared meals',
  'misc',
  'uncategorized'
]

desc = [
  'Milk, plant-based milk, and other dairy adjacent products.',
  'Meat, seafood, and eggs.',
  'Lentils, legumes, nuts, soy, etc.',
  'Rice, pasta, breads, cereal, etc.',
  'Fresh and frozen fruits.',
  'Fresh and frozen vegetables.',
  'Savory snacks, crackers, desserts, candy, etc.',
  'Mustard, marinara, dips, gravies, jams, etc.',
  'Coffee, tea, setlzer, and juices.',
  'Beer, wine, and liquor.',
  'Vitamins, protein powder, etc.',
  'Ready to eat frozen and to-go foods.',
  'Not included in a food category.',
  'Not categorized yet.'
]

if __name__ == '__main__':
  cred = credentials.Certificate(PATH)
  firebase_admin.initialize_app(cred)
  datab = firestore.client()
  categoriesRef = datab.collection('categories')

  for index, category in enumerate(categories):
    new_category = {
      'name': category.title(),
      'description': desc[index]
    }

    categoriesRef.document().create(new_category)



  