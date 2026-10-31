# prepara assets no sandbox do Higgsfield (executar dentro de ~/w/h/mg)
set -e
mkdir -p assets seq/kv0 seq/kv1 seq/k4
for i in 0 1 2 3 4 5; do convert ../ad$i.png -resize 600x -quality 90 assets/ad$i.png; done
ffmpeg -v error -y -i ../kv0.mp4 -vf "scale=432:-2" -q:v 3 seq/kv0/%04d.jpg
ffmpeg -v error -y -i ../kv1.mp4 -vf "scale=432:-2" -q:v 3 seq/kv1/%04d.jpg
ffmpeg -v error -y -ss 1.5 -t 8 -i ../k4.mp4 -vf "fps=30,scale=1080:-2" -q:v 3 seq/k4/%04d.jpg
echo "window.SEQN={kv0:$(ls seq/kv0|wc -l),kv1:$(ls seq/kv1|wc -l),k4:$(ls seq/k4|wc -l)};" > seq.js
cat seq.js
