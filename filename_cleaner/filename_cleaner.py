#!/usr/bin/env python3

# by Rafael Karosuo (rafaelkarsuo@gmail.com)

# # Performs a rename of all filesnames within the passed directory path
	#Parameters are:
	# (positional) dirpath => The directory where all files will be renamed		


import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument("dirpath", help="The directory path where all files will be renamed (positional argument)")
parser.add_argument("--verbose", help="increase output verbosity", action="store_true")
args = parser.parse_args()

args_dirpath = args.dirpath


if os.path.isdir(args_dirpath):		
	for root, dirs, files in os.walk(top=args_dirpath, topdown=False):
		for fn in files:			
			old_abspath_fn = os.path.abspath(os.path.join(root, fn))
			print("\nwithin files, root: {!s}\n".format(root))
			if os.path.isfile(old_abspath_fn):
				fn = " ".join(fn.split()) # remove repeated spaces						
				fn = "".join(ch for ch in fn if ch.isalnum() or ch in "._() ")
				fn = fn.strip() # remove leading and trailing spaces		
				fn = fn.replace(" ", "_") # change spaces for underscores			
				new_abspath_fn = os.path.abspath(os.path.join(root, fn))
				os.rename(old_abspath_fn, new_abspath_fn)				
				if(args.verbose):
					print("\n->old_filename: {!s}\n->new_filename: {!s}\n".format(old_abspath_fn, new_abspath_fn))
		for dirname in dirs:			
			old_abspath_dir = os.path.abspath(os.path.join(root, dirname))
			print("\nwithin dirs, root: {!s}\n".format(root))
			if os.path.isdir(old_abspath_dir):					
				dirname = " ".join(dirname.split()) # remove repeated spaces						
				dirname = "".join(ch for ch in dirname if ch.isalnum() or ch in "._() ")
				dirname = dirname.strip() # remove leading and trailing spaces		
				dirname = dirname.replace(" ", "_") # change spaces for underscores			
				new_abspath_dir = os.path.abspath(os.path.join(root, dirname))				
				os.rename(old_abspath_dir, new_abspath_dir)
				if(args.verbose):
					print("\n->old_dirname: {!s}\n->new_dirname: {!s}\n".format(old_abspath_dir, new_abspath_dir))

else:
	print("\nError: {!s} not a valid directory\n".format(args_dirpath))
