#/bin/sh

file="../../app.properties" 
echo 'test file' >> test.txt
diff=$(git diff --unified=0 HEAD -- $file  | grep -Ev '(index|@@|--git|---|\+\+\+|new)' | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' )
fileM=$(git diff --name-only HEAD -- $file)
date=$(date '+%Y-%m-%d %H:%M:%S')
sep1="\n____________________________________________\n"
sep2='\n--------------------------------------------\n'

if [ -f "$file" ] && [ "$diff" ]
then  
  echo -e $sep1$date'   '$fileM$sep2$diff$sep1 >> changelog.txt
  grep -v '^#' < "$file" | 
    while IFS='=' read -r key value
    do
      if [ "$key" ] 
      then
        testKey="${key}"
      fi
    done 
else
  echo "**** $file not found or no changes."
fi