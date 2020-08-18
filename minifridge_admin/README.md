# Foodbase Admin Scripts

## Add Items to Base
### Initial Set-Up
1. At top of `add_items_to_base.py` file, replace `PATH` and `CREDS_PATH` with firebase admin creds, and foodbase creds.
2. In `creds.json`, replace all `filepath` strings in foodbase creds with where you will be saving user data locally. CTRL+F and replace `/Users/ericadu/github/minifridge/minifridge_admin/data/` in `creds.json`. Note: never push user creds to github. `data/*` is in `.gitignore` so you can create a `data` folder in the `minifridge_admin` folder.

### On New User
1. Add another user to `creds.json` filling out all necessary items.
2. Create an Airtable tab
3. Add to firebase functions

### On New Upload
1. After processing on Airtable, export as CSV and download.
2. IMPORTANT: You have to edit file so that only new items exist in file, otherwise you will upload existing items. To do this, open the file. Look from bottom until you see first row of commas. Delete everything above that row of commas so only newest items remain.
3. Move file into specified `data` folder.
4. go into `minifridge_admin` folder on command line and run script with users's first name as a flag:
```
$ cd minifridge/minifridge_admin
$ python scripts/add_items_to_base.py --user USERS_NAME
```
5. If you want to do a dry run test (aka, do not create items or send notification), you can do:
```
$ python scripts/add_items_to_base.py --user USERS_NAME --dryrun
```