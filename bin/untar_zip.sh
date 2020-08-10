#!/bin/sh
#Will untar the most recent  .tar in a given incoming directory to a temp directory, then attempt to zip the contents of the temp directory and write the .zip to an outbound directory. stdout and stderr piped to ~/scripts/logs untar_log_[run date]
#ex: source untar_zip.sh /data/incoming /data/tmp /data/out /scripts/logs/

TODAY_DATE=$(date +'%Y%m%d')

INCOMING_DIR=$1
TEMP_DIR=$2
OUT_DIR=$3
LOG_LOCATION=$4

exec > >(tee -i "$LOG_LOCATION/untar_log_$TODAY_DATE.log")


MAX_TAR_PATH=$(ls $INCOMING_DIR/test*.tar|sort -rn|head -1)
MAX_TAR_FILE="$(basename -- $MAX_TAR_PATH)"
MAX_TAR_FNAME="${MAX_TAR_FILE%.*}"

#echo  $MAX_TAR_PATH
echo "Highest .tar: $MAX_TAR_FILE"
#echo $MAX_TAR_FNAME


echo "Attempt to Untar to $TEMP_DIR"
tar -C $TEMP_DIR -xvf $MAX_TAR_PATH

echo "Attempt to zip untarred contents to $OUT_DIR"
zip -rj "$OUT_DIR/$MAX_TAR_FNAME.zip" "$TEMP_DIR"
rm "$TEMP_DIR"/*


