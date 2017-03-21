# Report generator
It's a set of scripts that help's in the construction of a report using latex format.
The solution is targeted to the long steps reports, as guides that require an image and a description for each step, but has too many of them to copy and paste or insert the images as normally in a word processor, plus latex format has te advantage of image numbering and auto size'em.

make_new_report_base.sh is the main script that wraps all the functionality.

Usage is as follows:
```bash
./make_new_report_base.sh <target_directory> <project_name> <images_step_lists> ["overwrite"]
```

Where the project_name can't have spaces
The directories could have spaces in theory but I haven't had time to try that yet correctly
The script creates a new folder within target_directory and if it already exists stops process without lefting any change, except if the word "overwrite" is provided as 4th parameter
