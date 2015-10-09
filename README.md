Backup Script by @cbrightly
====================
BackupScript is a useful BASH script for backing up a users home directory (if the user is not 'root') or for backing up entire system (if run as 'root' / with root permissions)<br />


<h2>Usage</h2>
For now, using the script is a rather straightforward affair:

```
bash backup.sh
```


While under heavy development, you can run some simple commands to make the script run a bit more smoothly, just copy and paste each line and you should be OK!<br /><br />
```
chmod a+x backup.sh
```
This allows you to run the script with the following command instead of the above call to BASH
```
./backup.sh
```

and then you are good to go!<br /><br />

<h2>Human Readable Changelog</h2>
<ul>
<li>FIX ME.<br /></li>
<li>FIX ME.<br /></li>
<li>FIX ME.<br /></li>
<li>FIX ME.<br /></li>
</ul>

<br />

<h2>Notes:</h2>
<br />
As of now the script does <b>not</b> accept any arguments, however you can modify the .sh file itself for customization of variables;<br \>
I plan to add code allowing for runtime arguments to be used to set the backup source, destination, backup retention (and duration of retention) among other things...<br />
See the TO-DO file for planned upcoming features;<br />
Also feel free to submit requests for features or bug fixes at my <a href="https://github.com/cbrightly/BackupScript/" target="_blank">github page</a> for this project.
