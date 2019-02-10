#!/bin/bash

DATE=`date +%Y%m%d`
#EBSURL="rtsp://new_iradio.ebs.co.kr/iradio/iradiolive_m4a "
EBSURL="rtmp://ebsandroid.ebs.co.kr:1935/fmradiofamilypc/familypc1m"
FPATH="/mnt/timecapsule/ebs/$DATE"
FNAME="$1_$DATE"
RECTIME=$(($2*60))

FLVFNAME="$FPATH/$FNAME.flv"
WAVFNAME="$FPATH/$FNAME.wav"
MP3FNAME="$FPATH/$FNAME.mp3"
RTMP="rtmpdump"
LAME="lame"

if [ ! -d $FPATH ]
then
     mkdir -p $FPATH
fi
$RTMP  -r  $EBSURL -o $FLVFNAME &
pid_player=$!    #child process PID
echo "PID : $pid_player"

#sleep `expr $RECTIME \* 60`
sleep $RECTIME
kill  $pid_player

#convert to mp3
ffmpeg -i $FLVFNAME -acodec pcm_s16le -ac 2 -ab 128 -vn -y $WAVFNAME
$LAME -h $WAVFNAME $MP3FNAME > /dev/null 2>&1

rm -f $FLVFNAME
rm -f $WAVFNAME

