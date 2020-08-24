import argparse
import cv2
import imutils
import io
import numpy as np
import pprint
import re
from google.cloud import vision
from google.cloud.vision import types
from transform import four_point_transform

ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", required = True,
	help = "Path to the image to be scanned")
args = vars(ap.parse_args())

# i. Grab Image
with io.open(args['image'], 'rb') as image_file:
	content = image_file.read()

# ii. Initiatlize client
client = vision.ImageAnnotatorClient()

first_pass = vision.types.Image(content=content)
first_response = client.text_detection(image=first_pass)

image = cv2.imread(args["image"])

# TRANSFORM!!
if len(first_response.text_annotations) > 0:
	# print(first_response.text_annotations[0].description)
	bounding_box = [(vert.x, vert.y) for vert in first_response.text_annotations[0].bounding_poly.vertices]
	pts = np.array(bounding_box, dtype="float32")

	image = four_point_transform(image, pts)

# 1) Preprocess Image
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
gray = cv2.GaussianBlur(gray, (5, 5), 0)
gray = cv2.fastNlMeansDenoising(gray,None,8)
thresh = cv2.adaptiveThreshold(gray,255,cv2.ADAPTIVE_THRESH_GAUSSIAN_C,cv2.THRESH_BINARY,11,2)
# edged = cv2.Canny(gray, 75, 200)

retval, buf = cv2.imencode('.png', thresh)
vision_image = types.Image(content=buf.tobytes())

# 2) Call OCR Client
response = client.text_detection(image=vision_image)


## 3) Parse result
## a) Calculate threshold for if same line or row
height, width, channels = image.shape
row_y = int(height * 0.01)

if len(response.text_annotations) > 0:
	texts = response.text_annotations

	# b) Find which objects are on the same line
	lines = {
		0: []
	}

	previous_line = 0

	for text in texts:
		if " " in text.description.strip():
			continue

		y_coords = [vertex.y for vertex in text.bounding_poly.vertices]
		y_coords.sort()

		if (abs(y_coords[0] - y_coords[1]) < row_y and abs(y_coords[2] - y_coords[3]) < row_y):

			trial_key = y_coords[0]

			for diff in range(row_y):
				maybe_less = y_coords[0] - diff
				maybe_more = y_coords[0] + diff
				if maybe_less in lines:
					trial_key = maybe_less
					break
				if maybe_more in lines:
					trial_key = maybe_more
					break

			if trial_key == y_coords[0]:
				lines[y_coords[0]] = [text.description]
			else:
				lines[trial_key].append(text.description)

  # c) Which lines to keep
	## REGEX
	p_line_items = re.compile(r'([A-Z ]+)(\$\d+\.\d\d)')


	for line_num in lines:
		line = lines[line_num]
		text_line = ' '.join(line)

		m = p_line_items.search(text_line)

		if m:
			print(m.group(0))

	# p_items = re.compile(r'[A-Z]+')
	# p_prices = re.compile(r'\$\d+\.\d\d')
	# known_words = ['WHOLE', 'MARKET']
	# p_capitalize = re.compile(r'[A-Z][a-z]+')
	# previous = False
	# start_index = 0
	# end_index = 0

	# for line_num in lines:
	# 	line = lines[line_num]
	# 	text_line = ' '.join(line)

	# 	not_title = text_line.strip() not in known_words
	# 	if (p_items.search(text_line) and not_title and not p_capitalize.search(text_line)):
	# 		start_index = line_num
	# 		break


	# for line_num in list(reversed(sorted(lines.keys()))):
	# 	line = lines[line_num]
	# 	text_line = ' '.join(line)
	# 	if (p_capitalize.search(text_line)):
	# 		continue
	# 	else:
	# 		end_index = line_num
	# 		break

	# for line_num in lines:
	# 	if line_num >= start_index and line_num <= end_index:
	# 		line = lines[line_num]
	# 		text_line = ' '.join(line)
	# 		print(text_line)

		# print(text_line)

		# if (p_items.search(text_line) and p_prices.search(text_line)) or previous:
		# 	previous = True
		# has_word_match = p_words.match(text_line)
		# has_num_match = p_prices.match(text_line)


		# if (has_word_match != None and has_num_match != None):
		# 	print(text_line)

	# pp = pprint.PrettyPrinter(indent=4)
	# pp.pprint(lines)
	# text_block = texts[0].description
else:
	print(response)
