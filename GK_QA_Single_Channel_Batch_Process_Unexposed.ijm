// TODO: Put some description here
//

// Set required options
requires("1.45s");
setOption("ExpandableArrays", true);

// Get unexposed image from a user selection.
un_dir = getDirectory("Select Unexposed Film Images Directory");
un_fl = getFileList(un_dir);
un_il = newArray();

// Check if all of files are a .tif image. Store result in the un_il. Ignore files that are not .tif image.
j=0;
for (i=0; i<un_fl.length; i++) {
	if (!endsWith(un_fl[i], '.tif')) {
		print("Not TIF: " + un_dir + un_fl[i]);
	} else {
		un_il[j] = un_fl[i];
		j++;
	}
}


// Open files and convert it to RGB.
for (i=0; i<un_il.length; i++) {
	open(un_dir + un_il[i]);
	run("Stack to RGB");
	selectWindow(un_il[i]);
	close();
	selectWindow(un_il[i] + " (RGB)");
	run("Split Channels");
	selectWindow(un_il[i] + " (RGB) (green)");
	selectWindow(un_il[i] + " (RGB) (blue)");
	close();
	close();
	selectWindow(un_il[i] + " (RGB) (red)");
	run("Invert");
	run("Fire");
	run("Duplicate...", "title=selection");
	run("Auto Threshold", "method=Default white");
	setOption("BlackBackground", true);
	run("Erode");
	run("Create Mask");
	selectWindow("selection");
	close();
	run("Create Selection");
	selectWindow(un_il[i] + " (RGB) (red)");
	run("Restore Selection");
	run("Crop");
	run("Select None");
	selectWindow("mask");
	close();
}

// Split channels and leave only red channel open.
//selectWindow(un_path + " (RGB)");
//run("Split Channels");
//selectWindow(ex_path + " (RGB)");
//run("Split Channels");
//selectWindow(un_path + " (RGB) (green)");
//selectWindow(ex_path + " (RGB) (green)");
//selectWindow(un_path + " (RGB) (blue)");
//selectWindow(ex_path + " (RGB) (blue)");
//close();
//close();
//close();
//close();

// Invert images.
//selectWindow(un_path + " (RGB) (red)");
//run("Invert");
//run("Fire");
//selectWindow(ex_path + " (RGB) (red)");
//run("Invert");
//run("Fire");

exit;
