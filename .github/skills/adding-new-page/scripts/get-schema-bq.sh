#!/bin/bash

mkdir -p .memo/dbt_elementary

DATASET="dbt_elementary"

TABLES=$(bq ls --max_results=10000 ${DATASET} | awk 'NR>2 {print $1}')

for TABLE in ${TABLES}; do
  echo "Processing ${DATASET}.${TABLE}..."
  bq show --schema --format=prettyjson ${DATASET}.${TABLE} > .memo/${DATASET}/${TABLE}.json
done

echo "Schema information generation complete."
