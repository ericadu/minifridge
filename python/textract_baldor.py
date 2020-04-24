import boto3

# Document
s3BucketName = "textract-console-us-east-1-6b6790b0-d00a-490d-ad40-bab80b3ee061"
documentName = "baldor-table.png"

# Amazon Textract client
session = boto3.Session(profile_name='textract', region_name='us-east-1')
textract = session.client('textract')

# Call Amazon Textract
response = textract.analyze_document(
    Document={
        'S3Object': {
            'Bucket': s3BucketName,
            'Name': documentName
        }
    },
    FeatureTypes=["TABLES"])

blocks = response["Blocks"]
for block in blocks:
  if block['BlockType'] == "TABLE":
    print(block)

# doc = Document(response)

# for page in doc.pages:
#     # Print fields
#     print("Fields:")
#     for field in page.form.fields:
#         print("Key: {}, Value: {}".format(field.key, field.value))

    # Get field by key
    # print("\nGet Field by Key:")
    # key = "Phone Number:"
    # field = page.form.getFieldByKey(key)
    # if(field):
    #     print("Key: {}, Value: {}".format(field.key, field.value))

    # Search fields by key
    # print("\nSearch Fields:")
    # key = "address"
    # fields = page.form.searchFieldsByKey(key)
    # for field in fields:
    #     print("Key: {}, Value: {}".format(field.key, field.value))