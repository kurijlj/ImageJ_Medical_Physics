// TODO: Put some description here
//

// Get unexposed image from a user selection.
un_dir = getDirectory("Select Unexposed Film Images Directory");
un_fl = getFileList(un_dir);
Dialog.create("Select Unexposed Film Image");
Dialog.addChoice("List of Available Images:", un_fl);
Dialog.show();
un_path = Dialog.getChoice();

// Check if file is a .tif image.
if (!endsWith(un_path, '.tif')) {
	// print("Not TIF: " + un_dir + un_path);
	exit("Not TIF: " + un_dir + un_path);
}

// Convert to an RGB image
open(un_dir + un_path);
run("Stack to RGB");

// We don't need TIF image anymore so close it.
selectWindow(un_path);
close();

// Split channels from the RGB image and leave only red channel open.
selectWindow(un_path + " (RGB)");
run("Split Channels");
selectWindow(un_path + " (RGB) (green)");
selectWindow(un_path + " (RGB) (blue)");
close();  // Close green channel.
close();  // Close red channel.

// Invert image and display as "Fire" color palette.
selectWindow(un_path + " (RGB) (red)");
run("Invert");
run("Fire");

// Duplicate image to make a selection mask using auto thresholding.
run("Duplicate...", "title=selection");
run("Auto Threshold", "method=Default white");
setOption("BlackBackground", true);
run("Erode");  // Shrink selection area a bit.
run("Create Mask");
selectWindow("selection");
close();  // We have a mask so we can close thresholded image.
run("Create Selection");
selectWindow(un_path + " (RGB) (red)");
run("Restore Selection");  // Transfer selection to originl image.
run("Crop");  // Crop to selection. 
run("Select None");  // Clear selection.
selectWindow("mask");
close();  // Close maske window.