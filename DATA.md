# Data Model Planning

## Concepts
- Dietary restrictions: common ones (vegan, keto, gluten free), as well as specific allergens (no tomatos, or peanut butter
- Dietary preferences: prefer pescatarian, but not strict, or, "i don't like cilantro"
- Seasonality: dependent on location, and what item is
- Shelf life components
  - what item is
  - ripeness/optimal eating time
  - how processed (cut or opened or whole)
  - storage (pantry, fridge, freezer)
- Shelf life extension (processing & storage)
  - Processing: blanching. cutting
  - Freezing, jarring, drying
- Grocery trip
  - each item -- has a date that it was brought home, as well as what state the produce item looks (pre-ripe, ripe, past ripe?)
  - date

## Special Notes
Seems to be a distinction between food item concept, and also food item once it comes home (food item concept = encyclopedia you look up, food item once it comes home has a few extra attributes attached)

Could use [jcomo/shelf-life api](https://github.com/jcomo/shelf-life), or write a script to load data into firebase.

## Models

### ProduceItem

| Property       | Description      | Type  |
| -------------  |------------------| ------|
| `name`           | Commonly used name    | `string` |
| `other_names`   | Other colloquial names people might search         |   `string[]` |
| `description`    | Unsure if needed?         |    `string` |
|`shelf_life` | shelf life for item in many states | has_many `ShelfLife`|
|`default_shelf_life` | the most common?| has_one `ShelfLife` |


### ShelfLife

| Property       | Description      | Type  |
| -------------  |------------------| ------|
| `state`        | State of food    | `enum`|
| `storage_type` | How stored       | has_one `Storage` |
| `time`         | Time to spoil    | `number` |

#### State enum

| Enum           | Description      | 
| -------------  |------------------| 
| `whole`        | Entire item as is    | 
| `cut`          | Item cut or chopped      | 
| `cooked`       | Prepared item    | 
| `frozen`       | Frozen  | 

### Storage
| Property       | Description      | Type  |
| -------------  |------------------| ------|
| `method`       |   Name of method  | `string` |
| `location`     | Location of storage | `string` |
| `temp`         | temp range in F? C? |   `number[]` |
| `notes`        |    extra notes    |    `string` |


### MyItem
| Property       | Description      | Type  |
| -------------  |------------------| ------|
| `produce_item` |   What the item is  | has_one `ProduceItem` |
| `buy_date`     | Date bought | `date` |
| `buy_state`    | state it was bought |   `enum` |
| `freshness`    | where it is on its journey | `enum` |
| `storage`      |    where stored   |   has_one `Storage` |

#### Freshness enum
| Enum           | Description      | 
| -------------  |------------------| 
| `underripe`      | Can't eat it yet    | 
| `ripe`          | Ready to eat    | 
| `overripe`      | Safe to eat but past its prime  | 