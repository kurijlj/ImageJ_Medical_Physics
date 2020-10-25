// TODO: Put some description here
//

// Get image from a user selection.
img_dir = getDirectory("Select the Image Directory");
img_ls = getFileList(img_dir);
Dialog.create("Select an Image");
Dialog.addChoice("List of Available Images:", img_ls);
Dialog.show();
img_path = Dialog.getChoice();

// Check if file is a .tif image.
if (!endsWith(img_path, '.tif')) {
	exit("Not TIF: " + img_dir + img_path);
}

open(img_dir + img_path);
run("Split Channels");
selectWindow("C2-" + img_path);
selectWindow("C3-" + img_path);
close();
close();
selectWindow("C1-" + img_path);
run("Invert");
run("Fire");
rename(substring(img_path, 0, indexOf(img_path, '.tif')) + '_Red_Channel.tif');

exit;
