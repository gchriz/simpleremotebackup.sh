# simpleremotebackup.sh

A simple backup program to copy a local directory to a remote server
via *sftp* protocol, using the program *lftp*.

When connecting to a remote server for the first time, *lftp* might complain or hang.  
Please use an initial manual `ssh user@server` to complete the "known-hosts" dialog.

Have fun, but use this script on your own risk! No warranties at all.

## Optional versioning strategies

* no versioning, one target directory
* one subdirectory for every date (YYYY-MM-DD)
* one subdirectory for every day of week (1..7)
* one subdirectory per week (W01..W53) with sub-subdirectories per day of week (1..7)
* one subdirectory per month (01..12) with sub-subdirectories per day (01..31)

### Example with two files to save from 'SRCDIR'

On 'Sun Mar 6 2022' the above types of versioning would produce
in the target directory:

```
 ├── file1.txt
 ├── file2.txt

 ├── 2022-03-06
 │   ├── file1.txt
 │   └── file2.txt

 ├── 7
 │   ├── file1.txt
 │   └── file2.txt

 ├── W09
 │   └── 7
 │       ├── file1.txt
         └── file2.txt
 ├── M03
 │   └── 06
 │       ├── file1.txt
 │       └── file2.txt
```
