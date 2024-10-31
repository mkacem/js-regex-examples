#/bin/sh
propfiles=$(find ../../ -type f -name '*\.properties')
for file in $propfiles; do
  echo "Processing $file"
  diff=$(git diff --unified=0 --ignore-all-space --ignore-blank-lines HEAD^^ HEAD -- $file  | grep -Ev '(index|@@|--git|---|\+\+\+|new)' | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' )
  fileM=$(git diff --name-status --ignore-all-space --ignore-blank-lines HEAD^^ HEAD -- $file)
  date=$(date '+%Y-%m-%d %H:%M:%S')
  sep1="____________________________________________\n"
  sep2='\n--------------------------------------------\n'
  if [ -f "$file" ] && [ "$diff" ]
  then  
    echo -e $sep1$date'   '$fileM$sep2$diff'\n'$sep1 >> ../../env.log.txt
    # grep -v '^#' < "$file" | 
    #   while IFS='=' read -r key value
    #   do
    #     if [ "$key" ] 
    #     then
    #       testKey="${key}"
    #     fi
    #   done 
  else
    echo "!$file not found or no changes."
  fi
done