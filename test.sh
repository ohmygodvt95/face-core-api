#!/bin/bash

if [[ "$1" != "" ]]; then
    FILE="$1"
else
    echo "No image argumment.";
    echo "Please run command by: ./test.sh path_to_image.png"
    exit 1;
fi

STARTTIME=$(date +%s)

if [ -f "$FILE" ]; then
    for i in {1..10}
    do
        curl --location --request POST 'http://localhost/search' --form file=@"$FILE" \
        & curl --location --request POST 'http://localhost/search' --form file=@"$FILE" \
        & curl --location --request POST 'http://localhost/search' --form file=@"$FILE" \
        & curl --location --request POST 'http://localhost/search' --form file=@"$FILE" \
        & curl --location --request POST 'http://localhost/search' --form file=@"$FILE"
    done
else 
    echo "$FILE does not exist."
fi


ENDTIME=$(date +%s)
echo "It takes $((ENDTIME - STARTTIME)) seconds to complete this task..."
