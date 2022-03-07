# simpleremotebackup.sh

A simple backup script to copy a local directory via *sftp* protocol
to a remote server, using the program *lftp*.

Have fun, but use this script at your own risk! No warranties at all.

## Optional creation of sourcedir's name as target's basedir

It is possible to have the sourcedir's basename be created on the target side too.
Or to just copy the **contents** of sourcedir to the target server.
See the example below (TGTCREATEBASEDIR).

## Optional versioning strategies (VERSIONDIR)

* no versioning, one target directory
* one subdirectory for every date (YYYY-MM-DD)
* one subdirectory for every day of week (1..7)
* one subdirectory for every day of week (Mon..Sun, by locale)
* one subdirectory per week (W01..W53) with sub-subdirectories per day of week (1..7)
* one subdirectory per week (W01..W53) with sub-subdirectories per day of week (Mon..Sun, by locale)
* one subdirectory per month (01..12) with sub-subdirectories per day (01..31)

## Configuration

The above mentioned different behaviors can be configured right within the scripts sourceode.
There are some more details explained.

## Examples

With two files in 'SRCDIR' '.../data' to be saved
on 'Sunday Mar 6 2022' the above types of VERSIONDIR
would produce the following structures in the target directory 'TGTROOTDIR':

```
                          with
  TGTCREATEBASEDIR=no                 TGTCREATEBASEDIR=yes


  ├── file1.txt                       └── data
  ├── file2.txt                           ├── file1.txt
                                          └── file2.txt

  ├── 2022-03-06                      ├── 2022-03-06
  │   ├── file1.txt                   │   └── data
  │   └── file2.txt                   │       ├── file1.txt
                                      │       └── file2.txt

  ├── 7                               ├── 7
  │   ├── file1.txt                   │   └── data
  │   └── file2.txt                   │       ├── file1.txt
                                      │       └── file2.txt

  ├── Sun                             ├── Sun
  │   ├── file1.txt                   │   └── data
  │   └── file2.txt                   │       ├── file1.txt
                                      │       └── file2.txt

  ├── W09                             ├── W09
  │   └── 7                           │   └── 7
  │       ├── file1.txt               │       └── data
          └── file2.txt               │           ├── file1.txt
                                      │           └── file2.txt

  ├── W09                             ├── W09
  │   └── Sun                         │   └── Sun
  │       ├── file1.txt               │       └── data
          └── file2.txt               │           ├── file1.txt
                                      │           └── file2.txt

  ├── M03                             ├── M03
  │   └── 06                          │   └── 06
  │       ├── file1.txt               │       └── data
  │       └── file2.txt               │           ├── file1.txt
                                      │           └── file2.txt
```

## Notes

When connecting to a remote server for the first time, *lftp* might complain or hang.  
Please use an initial manual `ssh user@server` to complete the "known-hosts" dialog.  
That should be fixed now, but I'll keep this note here.
