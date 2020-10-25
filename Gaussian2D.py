#==============================================================================
# Copyright (C) 2020 Ljubomir Kurij <kurijlj@gmail.com>
#
# This file is part of Gaussian2D.
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option)
# any later version.
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
# more details.
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.
#
#==============================================================================


#==============================================================================
#
# 2020-10-24 Ljubomir Kurij <ljubomir_kurij@protonmail.com>
#
# * Gaussian2D.py: created.
#
#==============================================================================


# ============================================================================
#
# TODO: Put the docstrings.
#
#
# ============================================================================


# =============================================================================
# Modules import section
# =============================================================================

from ij import IJ
from math import exp
from array import zeros
from ij import ImagePlus
from ij.gui import GenericDialog
from collections import namedtuple  # Required by InputOptions custom class.
from ij.process import FloatProcessor


#==============================================================================
# Utility classes and functions
#==============================================================================

# Named tuple used to represent user input options.
InputOptions = namedtuple('InputOptions', ['width', 'height', 'sigma_x', 'sigma_y'])


def getOptions():
	"""TODO: Put function docstring here.
	"""
	
	gd = GenericDialog('Gaussian 2D Window')
	gd.addMessage('Input options:')
	gd.addMessage('Gaussian window width in pixels.\nValue must be >= 3 pixels.')
	gd.addNumericField('width', 3.0, 0, 5, 'pixels')
	gd.addMessage('Gaussian window height in pixels.\nValue must be >= 3 pixels.')
	gd.addNumericField('height', 3.0, 0, 5, 'pixels')
	gd.addMessage('Standard deviation in the x direction\nas precentage of window width.')
	gd.addNumericField('sigma x', 0.33, 2, 5, '%')
	gd.addMessage('Standard deviation in the y direction\nas precentage of window width.')
	gd.addNumericField('sigma y', 0.33, 2, 5, '%') 
	gd.showDialog()

	# Handle if user hits the 'Cancel' button.
	if gd.wasCanceled():
		return None

	# Validate and collect the user input data.
	width = gd.getNextNumber()
	if width < 3.0:
		width = 3.0
	height = gd.getNextNumber()
	if height < 3.0:
		height = 3.0
	sigma_x = gd.getNextNumber()
	if sigma_x < 0.0:
		sigma_x = 0.0
	if sigma_x > 1.0:
		sigma_x = 1.0
	sigma_y = gd.getNextNumber()
	if sigma_y < 0.0:
		sigma_y = 0.0
	if sigma_y > 1.0:
		sigma_y = 1.0
	
	return InputOptions(
		width=int(width),
		height=int(height),
		sigma_x=float(sigma_x),
		sigma_y=float(sigma_y)
		)


class MapPositionToIndex():
	"""TODO: Put class docstring here.
	"""

	def __init__(self, data_set_width):
		self._width = data_set_width

	def at(self, x, y):
		"""TODO: Put method docstring here.
		"""

		return x + (self._width * y)

		
def Gaussian2D(x0, y0, x, y, sigma_x, sigma_y):
	"""TODO: Put function docstring here.
	"""
	
	x_part = (x - x0) / sigma_x
	y_part = (y - y0) / sigma_y
	return exp(-0.5 * (pow(x_part, 2) + pow(y_part, 2)))


#==============================================================================
# Script main body
#==============================================================================

options = getOptions()  
if options is not None:
	width = options.width
	height = options.height
	x0 = width / 2.0
	sigma_x = width * options.sigma_x
	y0 = height / 2.0
	sigma_y = height * options.sigma_y
	pixels = zeros('f', width * height)
	pixels_index = MapPositionToIndex(width)
	val_sum = 0
	
	for y in range(height):
   		IJ.showProgress(y, height-1)
   		for x in range(width):
   			val = Gaussian2D(x0, y0, x, y, sigma_x, sigma_y)
   			val_sum += val
   			pixels[pixels_index.at(x, y)] = val

   	for i in range(len(pixels)):
   		IJ.showProgress(i, len(pixels) - 1)
   		pixels[i] = pixels[i] / val
   		
   	pixels_fp = FloatProcessor(width, height, pixels, None)

   	imp = ImagePlus('2D Gaussian', pixels_fp)
   	imp.show()
