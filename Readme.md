<html>
<head><title="backup.sh - Readme.md"></head>
<body>
<h1>backup.sh</h1>
<br />
<p>
<h2>Summary:</h2>
<br />
Useful BASH script for backing up a users home directory (if the user is not 'root') or for backing up entire system (if run as 'root' / with root permissions)
</p>
<br />
<p>
<h2>Usage:</h2>
<br />
<blockquote>sh backup.sh</blockquote>
<br />
</p>
<br />
<p>
<h2>Description:</h2>
<br />
Creates a gzip'd tarball in the directory the script is run from.
</p>
<br />
<p>
<h2>Notes:</h2>
<br />
As of now the script does <b>not</b> accept any arguments, however you can modify the .sh file itself for customization of variables;<br \>
I plan to add code allowing for runtime arguments to be used to set the backup source, destination, backup retention (and duration of retention) among other things...<br />
See the TO-DO file for planned upcoming features;<br />
Also feel free to submit requests for features or bug fixes at my <a href="https://github.com/cbrightly/backup-script/" target="_blank">github page</a> for this project.
</p>
</body>
</html>
