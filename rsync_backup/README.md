# Performs a backup using rsync
Copy content from source folders to destiny folders (same order that they appear, first source folder content to the first destiny folder, second with second, and so forth)

## Parameters are:
1. If the destiny is compressed (*Optional*, `--compressed`)
2. Source list of paths (*Mandatory, File of dir pathd, one per line, absolute or relative to the current script dir*)
3. Destiny list of paths (*Mandatory, Same as above*)

## Examples of use
- Having the copy from source directories listed on "source_dirs" to the ones listed on "destiny_dirs" files.

`./doBackup.sh --compressed source_dirs destiny_dirs`

Where the files are plain text files with content like:
>./tmp/s1

or

>/home/my_dir/

It could be multiple directories as source and/or as destiny
but at least must be one of each

### Important Note ###

As in rsync man page is noted:

>A  trailing slash on the source changes this behavior to avoid creating
>an additional directory level at the destination.  You can think  of  a
>trailing / on a source as meaning "copy the contents of this directory"
>as opposed to "copy the directory by  name",  but  in  both  cases  the
>attributes  of the containing directory are transferred to the contain‐
>ing directory on the destination.  In other words, each of the  follow‐
>ing  commands copies the files in the same way, including their setting
>of the attributes of /dest/foo:

>  `rsync -av /src/foo /dest`

>  `rsync -av /src/foo/ /dest/foo`

>Note also that host and module  references  don’t  require  a  trailing
>slash to copy the contents of the default directory.  For example, both
>of these copy the remote directory’s contents into "/dest":

>  `rsync -av host: /dest`
  
>  `rsync -av host::module /dest`

# Options used from rsync:
- **a**: archive
- **H**: maintain hard links
- **A**: preserve ACL's (Access Control Lists)
- **X**: keeps xattrs
- **v**: verbose
- **z**: compress

# Files generated are:
- **actionLog**: Show's all the output from rsync
- **errLog**: Has any error from rsync
- **timeLog**: Has the copy time of each file
