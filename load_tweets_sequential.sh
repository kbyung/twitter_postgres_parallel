#!/bin/bash

files=$(find data/*)

echo '================================================================================'
echo 'load denormalized'
echo '================================================================================'
time for zipfile in $files; do
    # copy your solution to the twitter_postgres assignment here
     for file in $(unzip -Z1 "$zipfile"); do
        # use SQL's COPY command to load data into pg_denormalized
        unzip -p "$zipfile" "$file" | cat | sed 's/\\u0000//g' | psql postgresql://postgres:pass@localhost:1672/postgres -c "COPY tweets_jsonb (data) FROM STDIN csv quote e'\x01' delimiter e'\x02';"
    done
done

echo '================================================================================'
echo 'load pg_normalized'
echo '================================================================================'
time for file in $files; do
    # copy your solution to the twitter_postgres assignment here
    echo "Processing $file"

    python3 load_tweets.py \
        --db "postgresql://postgres:pass@localhost:10372/postgres" \
        --inputs "$file" 

done

echo '================================================================================'
echo 'load pg_normalized_batch'
echo '================================================================================'
time for file in $files; do
    python3 -u load_tweets_batch.py --db=postgresql://postgres:pass@localhost:16439/ --inputs $file
done
