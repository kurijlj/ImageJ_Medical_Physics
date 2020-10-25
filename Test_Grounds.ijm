// TODO: Put some description here
//

width = getWidth();
height = getHeight();
sel_dia = width * 0.30;
sel_x = (width - sel_dia) / 2;
sel_y = (height - sel_dia) / 2;
makeOval(sel_x, sel_y, sel_dia, sel_dia);
run("Measure");

selectWindow("QA_20200727_046.tif (RGB) (red)");
run("Duplicate...", "title=duplicate");
run("Find Edges");
run("Gaussian Blur...", "sigma=2");
run("Auto Threshold", "method=Default white");
setOption("BlackBackground", true);
run("Erode");
run("Hough Circle Transform");
run("Hough Circle Transform","minRadius=30, maxRadius=50, inc=1, minCircles=1, maxCircles=5, threshold=0.5, resolution=385, ratio=1.0, bandwidth=10, local_radius=10,  reduce show_mask results_table");
selectWindow("Centroid overlay");
