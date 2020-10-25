from ij import IJ
from array import zeros
from ij.gui import MessageDialog
from ij.process import FloatProcessor
from ij import ImagePlus
from math import exp


class MapPositionToIndex():
	"""TODO: Put class docstring here.
	"""

	def __init__(self, data_set_width):
		"""TODO: Put method docstring here.
		"""

		self._width = data_set_width

	def at(self, x, y):
		"""TODO: Put method docstring here.
		"""

		return x + (self._width * y)

		
def gaussian_2d(x0, y0, x, y, sigma_x, sigma_y):
	"""TODO: Put function docstring here.
	"""
	
	x_part = (x - x0) / sigma_x
	y_part = (y - y0) / sigma_y
	return exp(-0.5 * (pow(x_part, 2) + pow(y_part, 2)))
	
img = IJ.getImage()
if img == None:
	md = MessageDialog("ERROR!", "Ther is no open image")
	md.showDialog()

else:
	width = 51
	height = 51
	x0 = width / 2.0
	sigma_x = width / 3.0
	y0 = height / 2.0
	sigma_y = height / 3.0
	pixels = zeros('f', width * height)
	pixels_index = MapPositionToIndex(width)
	val_sum = 0
	
	for y in range(height):
   		IJ.showProgress(y, height-1)
   		for x in range(width):
   			val = gaussian_2d(x0, y0, x, y, sigma_x, sigma_y)
   			val_sum += val
   			pixels[pixels_index.at(x, y)] = val

   	for i in range(len(pixels)):
   		IJ.showProgress(i, len(pixels) - 1)
   		pixels[i] = pixels[i] / val
   		
   	pixels_fp = FloatProcessor(width, height, pixels, None)

   	imp = ImagePlus("Synthetic Image", pixels_fp)
   	imp.show()