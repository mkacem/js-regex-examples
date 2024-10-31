#/bin/sh
propfiles=$(find ../../ -type f -name '*\.properties' )
commitDate=false
i=1
count=$(find ../../ -type f -name '*\.properties'  | wc -l)
for file in $propfiles; do
  echo "Processing $file $i"  
  diff=$(git diff --unified=0 --ignore-all-space --ignore-cr-at-eol --ignore-space-at-eol --ignore-blank-lines HEAD^^ HEAD -- $file  | grep -Ev '(index|@@|--git|---|\+\+\+|new)' | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' | sed -e 's/\+\\n//g' -e 's/-\\n//g' -e 's/\\n+$//g'  -e 's/\\n-$//g'  )
  fileM=$(git diff --name-status --ignore-all-space --ignore-blank-lines HEAD^^ HEAD -- $file)
  date=$(date '+%Y-%m-%d %H:%M:%S')
  sep1="========================================================================"
  sep2='\n----------------------------------------------------------------------\n'
  sep3='\n======================================================================\n'
  if [ -f "$file" ] && [ "$diff" ]
  then 
    if [ "$commitDate" = false ] 
    then
      output=$date$sep3$fileM$sep2$diff
    else
      output=$sep2$fileM$sep2$diff
    fi    
    echo -e $output >> ../../env.log.txt
    commitDate=true
  else
    echo "!$file not found or no changes."
  fi
  if [ "$i" -eq $count ] && [ "$commitDate" ]; then
    echo $sep1 >> ../../env.log.txt
  fi
  i=$(( i + 1 ))
done