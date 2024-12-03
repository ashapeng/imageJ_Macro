////////////////////////////////////////////////////////////////////////////
// process master saved folder
input_dir = getDirectory("Choose image input Folder");

// Check if the user canceled the input
if (input_dir == "")
    exit("User canceled the input. The macro will stop here.");
    
draw_bg_nuclei_projection(input_dir);
////////////////////////////////////////////////////////////////////////////
//// self defined function	
////////////////////////////////////////////////////////////////////////////
function draw_bg_nuclei_projection(dir) {
	list = getFileList(dir);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(dir + list[i])){
			draw_bg_nuclei_projection(dir  + list[i]);
			}
		if(matches(toLowerCase(list[i]), "largest_slice_img.tif")){
			open(dir + list[i]);
			filename = File.getNameWithoutExtension(dir+list[i]);
			file_dir = getDirectory("file");
			print(file_dir);
			
			// check if nuclei mask exist
			nuclei_mask_path = file_dir + "nuclei_mask.tif";
			if (!File.exists(nuclei_mask_path)){
				// draw region for nuclei
				selectWindow(filename + ".tif");
				run("Duplicate...", "duplicate channels=2");
				run("Brightness/Contrast...");
				resetMinAndMax();
				setTool("polygon");
				waitForUser("draw nuclei", "then click OK");
				wait(25);
				run("Clear Outside", "stack");
				run("Threshold...");// choose create new stack
				resetThreshold();
				setThreshold(1, 65535, "raw");
				waitForUser("change the threshold", "then click OK");
				//setAutoThreshold("Default dark");
				run("Convert to Mask", "method=Default background=Default black");
				title = getTitle();
				selectWindow(title);
				saveAs("Tiff", file_dir +"nuclei_mask.tif");
				close("*");
				}
			else{print("nuclei mask exist");
				close("*");}
			}
		}
	}
