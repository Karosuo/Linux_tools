# Performs a backup using rsync
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
