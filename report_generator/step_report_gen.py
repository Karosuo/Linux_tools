#!/usr/bin/python2.7
#
#******	Generates a Tex Studio content format as it was a sequence of steps defined by one image each
#~ 
#~		The first parameter : (directory)
#~ 			It's just a container, images within it's first level will be ignore even if they have the format
#~			The steps will be taken from the sub folders, being each sub folder an entire step list and the corresponding dir title will be the steps list title
#~ 		The second parameter : (output file name)
#~			It's the output file name where all the content will be written
#~ 		
#~ 		Also It takes the chapter/subchapter titles from file "titles.txt", if it doesn't exist it complains and must be in the same dir passed as param
#		
#~ 		Uses all the images in the subfolders of the dir passed as parameter and the file names should be "Step n - Step title [-- step description]", where "n" is the step number, and "step title" is what you want to show as step title, NOT CHAPTER
#~ 		It could have substeps "Step n.n - Step title [-- step description]"
#~ 			-Strictly speaking it doesn't have to be in english, just has the structure (as a regex) "(^[a-zA-Z]{4}_(\d{1,2})(\.\d{1,2})*_[^a-zA-Z\d]_[\w ]+)((_--_)(.+))*.[a-zA-Z]{3}$", it will be shown as is, in the output file step title
#
#~ 		The [-- step description] will be putted as a paragraph in the corresponding step, it can contain any readible character as commas, accents, etc as the regex suggest.

#		If files aren't images, program won't comply, but latex won't load any pic
#		If image file doesn't have the name pattern, it will be ignored
#		The folder and files names must be separated by a non space character, "_" character is a good idea, so this program could be used with a bash script that changes spaces by underscores in all the dirs and files within the dir passed as param
#~			The program will ignore all the dirs (and content) that doesn't match the above

#~ 		Rafael Karosuo UABC 2017

import sys #cli args
import os #open files and use paths
import re #Regex

titles_file = None #give files file/global scope
output_file = None	


#Reads the titles file, separates the titles lines a list and detects wich title size it needs, following the bellow relation
#	1 - chapter
#	2 - section
#	3 - subsection
#	4 - subsubsection
#	i - item's list (List id need a space bt it and the start of the word/line
def parse_titles_file(titles_file):
	title_types = ["\chapter {", "\section {","\subsection {","\subsubsection {"] #define tags for different title sizes
	
	titles_file_content = titles_file.read().split("\n") #Read entire file and separate it on a list, one element per new line character

	parsed_titles = [] #Prepare parsed title list
	list_start_flag = False #Define if an item list started	

	for line in titles_file_content:
		match_obj_titles = re.match("^(\d)(.+)$", line) #Parse line with titles
		match_obj_lists = re.match('^i\s(.+)$', line) #Parse line with lists
		
		if match_obj_titles is not None: #if title
			if list_start_flag: #if title and coming from list, means end of list
				list_format_end = "\\end{itemize}\n" #put end list tag
				parsed_titles.append("{!s}{!s}{!s}".format(list_format_start, array_to_string(list_format_items), list_format_end))
				list_start_flag = False #We're no longer within a list
			if int(match_obj_titles.group(1))-1 == 0: #Means it's a chapter and need to rename command
				parsed_titles.append("\\renewcommand{\chaptername}{"+ match_obj_titles.group(2)+"}\n\
				"+title_types[int(match_obj_titles.group(1))-1] + match_obj_titles.group(2) + "}")
			else:
				parsed_titles.append(title_types[int(match_obj_titles.group(1))-1] + match_obj_titles.group(2) + "}")
			
		elif match_obj_lists is not None: #if list			
			if not list_start_flag: #If not title and not coming from another item, means start of list				
				list_format_items = [] #Save all the items within a list, works for all the lists
				list_format_start = "\n\\begin{itemize}\n"
				list_format_items.append("\\item {!s}\n".format(match_obj_lists.group(1))) #add current line content as first item, since no begin considered in titles file
				list_start_flag = True #Active flag, we're in a list			
			else: #If not title and started lists, means an item in the middle
				list_format_items.append("\\item {!s}\n".format(match_obj_lists.group(1))) #add current line content as item
		
	if list_start_flag: #means the list was the last thing, so no title will enter and needs the end tag independently
		list_format_end = "\\end{itemize}\n" #put end list tag
		parsed_titles.append("{!s}{!s}{!s}".format(list_format_start, array_to_string(list_format_items), list_format_end))
		list_start_flag = False #We're no longer within a list

	return parsed_titles		
	
def array_to_string(the_array):
	the_string = ""
	for element in the_array:
		the_string = the_string + element		
	return the_string
	
	

def parse_title_from_directory(file_path):
	tmp_parse = os.path.basename(os.path.normpath(file_path)) #rid of slashes from path and get dir base name
	tmp_parse = tmp_parse.replace("_", " ") #Take away the underscores for readability
	return "\section {{{!s}}}".format(tmp_parse) #Put the title onto Tex title format

def generate_json_step_list(images_path):
	step_number = 0 #Holds the main step number, if it repeats means there's some subnum				
	for file_name in os.listdir(images_path): #Walk through dir						
		root_file_path = os.path.join(images_path, file_name) #get the complete path, including the file		
		
		if os.path.isdir(root_file_path): #Ignore all files in first level, go for the subdirs
			#~ print(root_file_path)
			
			step_holder = {} #Holds json of title name
			step_holder["step_list_title"] = parse_title_from_directory(root_file_path)
			steps_list.append(step_holder) #Save the step holder that has the Step's list title
			
			for subdir_file_name in os.listdir(root_file_path): #Walk through subdir	
				#~ print(subdir_file_name)				
				step_holder = {} #Holds json of step title, file path, represents only one step or step list title
				file_path = os.path.join(root_file_path, subdir_file_name) #get the complete path, including the file, for the subdirs

				if os.path.isfile(file_path): #If it's a valid file (should be image)
					match_obj = re.match("(^[a-zA-Z]{4}_(\d{1,2})(\.\d{1,2})*_[^a-zA-Z\d]_[\w .\(\)\"\"]+)((_--_)([\w .\(\)\"\"]+))*.([a-zA-Z]{3})$", subdir_file_name) #Get the regex match object, only the files with "stepish" title					
					if match_obj is not None:								
						if match_obj.group(6) is not None:
							step_holder["step_description"] = match_obj.group(6).replace("_"," ") #Save the step description, replacing underscores for spaces for readibility
							os.rename(file_path, os.path.join(root_file_path, match_obj.group(1) + "." + match_obj.group(7))) #strip out the description from the file's name					
							file_path = os.path.join(root_file_path, match_obj.group(1) + "." + match_obj.group(7)) #Change the path that will be written in the TeX format
							#~ print(file_path + "\n")		
							#~ print("new " + os.path.join(root_file_path, match_obj.group(1) + "." + match_obj.group(7)) + "\n")
						step_holder["step_title"] = match_obj.group(1).replace("_"," ") #Saves the title in json, replacing underscores by spaces for readability
						step_holder["step_path"] = file_path #Saves the specific full path of this file												
						if match_obj.group(2) == step_number:							
							title_tag="\subsubsection "
						else:
							title_tag="\subsection "
						step_holder["step_title_tag"] = title_tag #Defines if it's substep image, so subsubsection
							#~ print(step_holder["step_description"])
						step_number = match_obj.group(2) #Equals next step main number													
						steps_list.append(step_holder) #Add current json to the step list
	return steps_list
	

def get_titles_list(images_path):
	titles_file_path = os.path.join(images_path, "titles.txt")
	if not os.path.isfile(titles_file_path): #Check if titles file exist
		print("\n>>Error\n\"titles.txt\" file doesn't exist, needs to be in the same dir as the one passed as parameter and should be a text file\n\n")
		sys.exit(-1) #If no titles file, don't continue and exit with Non Succesful termination code
	else:						
		try:
			titles_file = open(titles_file_path) #Open titles file for read							
		except IOError as e:
			print "\n>>Error\nI/O error({0}): {1}".format(e.errno, e.strerror) #Mainly if no file with given name exists	
			
		titles_list = parse_titles_file(titles_file) #Get the titles parsed including their size
		titles_file.close() #Close titles file
		return titles_list


def write_report_file(output_file, titles_list, steps_list):
	try:
		output_file = open(sys.argv[2], 'w+') #Open output file as create/write or overwrite				
	except IOError as e:
		print "\n>>Error\nI/O error({0}): {1}".format(e.errno, e.strerror) #Mainly if no file with given name exists							
	
	print("\tWriting titles...")
	for item in titles_list: #Writes down the title list onto the output file
		output_file.write(item)
		output_file.write("\n")
	
	print("\tWriting steps...")
	for step in steps_list: #Writes down all the steps, image and titles
		if "step_title_tag" in step: #Print all the steps within the current dir
			if "step_description" in step: #If there's some description, use it as is
				output_file.write(step["step_description"])
			output_file.write("\n{!s}{{{!s}}}\n\
			\\begin{{figure}}[H]\n\
			\centering\n\
			\includegraphics [scale=0.4]\n\
			{{{!s}}}\n\
			\caption{{{!s}}}\n\
			\end{{figure}}\n\n".format(step["step_title_tag"], step["step_title"], step["step_path"], step["step_title"]))
		elif "step_list_title" in step:
			output_file.write("{!s}".format(step["step_list_title"])) #Print next list title (sub dir name)
	output_file.close() #Close the output file

try:
	if len(sys.argv) == 3: #If at least two params passed
		images_path = sys.argv[1]
		if os.path.isdir(images_path):#Check if it's a real dir, could be relative			
			steps_list = [] #Holds the list of jsons, IT'S GLOBAL SCOPE, no need to pass as param to generate_json_step_list function

			print("Parsing steps lists name and steps text...")
			#Parses all the names (files as step title, dirs as section title)
			steps_list = generate_json_step_list(images_path)
					
			print("Parsing titles and/or lists from titles.txt...")
			#Seek the titles file, opens it and gets it's pointer
			titles_list = get_titles_list(images_path)						
					
			print("Writing all the formatted text the output file...")
			#Writes down the report, titles, objective and images block
			write_report_file(output_file, titles_list, steps_list)					
			
		else:
			print("\n>>Error\nPath provided is not a valid directory\n\n") #Complains if "images" directory doesn't exist or similar
	
	else:
		print('\n>>Error\nNeed to provide at least 2 params.\n\nUsage: '+sys.argv[0]+' <steps_images_folder_path> <output_filename>\n\n')
	
except KeyboardInterrupt:
	print("\nUser interrupted...\n")
	if titles_file is not None:
		titles_file.close()
		print("\nClosing titles_file.txt...\n")
	if output_file is not None:
		output_file.close()
		print("\nClosing the ouput file...\n")	
	
