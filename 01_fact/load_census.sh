#!/bin/sh


#Pan

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR
stdbuf -oL $DIR/pan.sh -file=$DIR/census_monet.ktr

lines=`cat /tmp/out.sql|wc -l`
rm /tmp/nod.sql

mkfifo /tmp/nod.sql

mclient -d census /tmp/nod.sql &


(echo "delete from \"sys\".\"census\";" ; echo "COPY $lines RECORDS INTO \"sys\".\"census\" FROM stdin USING DELIMITERS '\t','\n','\"';" ; cat /tmp/out.sql )  >> /tmp/nod.sql

for job in `jobs -p`
do
echo $job
    wait $job 
done



rm /tmp/out.sql
rm /tmp/nod.sql



