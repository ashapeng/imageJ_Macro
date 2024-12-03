// save stacks as movies
// process main folder/1st order subfolder/ 2nd subfolder/files
orig_dir = getDirectory("Choose a Directory");
list=getFileList(orig_dir);
list=Array.sort(list);

// create the 1st order saving directory
result_main_dir = "D:/McGill_Data/FRAP"+ File.separator + "images_movies"  + File.separator;
File.makeDirectory(result_main_dir);
var result_dir_created = false; // define final saving folder as a variable

for (i = 0; i < list.length; i++) {
	if(File.isDirectory(orig_dir + File.separator + list[i])){
		processfolders(orig_dir + File.separator + list[i]);
		}
	}

///////////////////////////////////////////////////////////////////////////////////////////////////////
function processfolders(input_dir){
	list=getFileList(input_dir);
	list=Array.sort(list);
	Array.print(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input_dir + File.separator + list[i])){
			stack_avi(input_dir + File.separator + list[i]);}
	}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
function stack_avi(dir){
	list=getFileList(dir);
	list=Array.sort(list);

	setOption("ExpandableArrays", true);
	open_img_name =newArray;

	for (i=0; i < list.length; i++){
		if (endsWith(list[i], ".tif")){
			open(dir + list[i]);
			open_img_name[i]=getInfo("window.title");}
		}
	open_img_name = Array.deleteValue(open_img_name, "undefined");
	Array.print(open_img_name);
	name1= substring(open_img_name[0], lastIndexOf(open_img_name[0], "d"), lastIndexOf(open_img_name[0], "."));
	name2 = substring(open_img_name[1], lastIndexOf(open_img_name[1], "r"), lastIndexOf(open_img_name[1], "."));
	//create directory for each image folder in the main result folder
	imgs_dir = getInfo("image.directory"); // get images' directory
	imgs_folder = File.getName(imgs_dir);//get images' folder name
	folder1 = File.getName(File.getParent(imgs_dir));// get img_folder's folder
	// first layer folder should be created in order to create the next layer folder
	result_dir1 = result_main_dir + folder1 + File.separator;
	File.makeDirectory(result_dir1);
	// create folder containing processed images
	result_dir = result_dir1 + imgs_folder + File.separator;
	File.makeDirectory(result_dir);
	result_dir_created=result_dir;// update saving folder as 
	////////////////////////////////////////////////////////////////////////////////////////////////////////////
	selectWindow(open_img_name[0]);
	run("AVI... ", "compression=JPEG frame=5 save="+result_dir + name1+".avi");
	
	selectWindow(open_img_name[1]);
	run("AVI... ", "compression=JPEG frame=5 save=" + result_dir + name2+".avi");
	close("*");
}
}