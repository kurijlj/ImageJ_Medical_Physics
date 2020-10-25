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

// Get exposed image from a user selection.
ex_dir = getDirectory("Select Exposed Film Images Directory");
ex_fl = getFileList(ex_dir);
Dialog.create("Select Exposed Film Image");
Dialog.addChoice("List of Available Images:", ex_fl);
Dialog.show();
ex_path = Dialog.getChoice();

// Check if file is a .tif image.
if (!endsWith(ex_path, '.tif')) {
	// print("Not TIF: " + un_dir + un_path);
	exit("Not TIF: " + ex_dir + ex_path);
}

// Open files and convert it to RGB.
open(un_dir + un_path);
run("Stack to RGB");
open(ex_dir + ex_path);
run("Stack to RGB");
selectWindow(un_path);
selectWindow(ex_path);
close();
close();

// Split channels and leave only red channel open.
selectWindow(un_path + " (RGB)");
run("Split Channels");
selectWindow(ex_path + " (RGB)");
run("Split Channels");
selectWindow(un_path + " (RGB) (green)");
selectWindow(ex_path + " (RGB) (green)");
selectWindow(un_path + " (RGB) (blue)");
selectWindow(ex_path + " (RGB) (blue)");
close();
close();
close();
close();

// Invert images.
selectWindow(un_path + " (RGB) (red)");
run("Invert");
run("Fire");
selectWindow(ex_path + " (RGB) (red)");
run("Invert");
run("Fire");

exit;
