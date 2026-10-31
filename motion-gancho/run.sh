# render completo no sandbox do Higgsfield (dentro de ~/w/h/mg). Uso: bash run.sh '<upload_url>'
set -e
rm -rf frames && mkdir -p frames
N=1322; W=6; STEP=$(( (N+W-1)/W ))
for i in $(seq 0 $((W-1))); do s=$((i*STEP)); e=$(( s+STEP<N ? s+STEP : N )); node render.js $s $e frames > r$i.log 2>&1 & done
wait
ls frames | wc -l
ffmpeg -v error -y -framerate 30 -i frames/%05d.jpg -i ../voz.m4a -map 0:v -map 1:a -c:v libx264 -preset medium -crf 17 -pix_fmt yuv420p -c:a aac -b:a 192k -shortest -movflags +faststart final.mp4
ffprobe -v error -show_entries format=duration:stream=width,height -of csv=p=0 final.mp4
curl -sf -o /dev/null -w "%{http_code}" -X PUT -H "Content-Type: video/mp4" -H "If-None-Match: *" --upload-file final.mp4 "$1" > put.txt
echo DONE $(cat put.txt)
