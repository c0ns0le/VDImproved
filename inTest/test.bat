
v:

if not exist v:\test
	mkdir v:\test
::set DEST = cd
cd "cd\test"
echo "cd"
copy z:\startup\misc\* "cd"
exit -b