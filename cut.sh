#!/usr/bin/env bash
# Cut the gta6-clipper-01 entry clip from Rockstar's Grand Theft Auto VI
# Launch Trailer (official upload, youtube.com/watch?v=rz1B4B2yBZY).
# Source: ../footage/launch.mp4 (1080p, downloaded with yt-dlp).
# Output: 720x1280 vertical Short, ~14 s, with make.fun's pitch on end cards.
#
# The moment: the Launch Trailer's wildest seconds, hooked by the iguana
# that stops traffic - a funny, surprising frame nobody else used - then
# the lowrider crew, Lucia & Jason in the convertible, the bank vault
# walk-through with money in the air, and the motorcycle jump. The pitch
# comes last, on three plain end cards, so no admin can miss it.
#
# v2: the iguana window moved to 20.5-21.9 (the GTA logo card starts at
# ~22.0 and must not leak in), the lowrider ends at 20.5 so the iguana
# does not repeat, and the vault is tightened to 34.9-36.0, the bright
# money-flying beat before the shot goes dark.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p clip
SRC="../footage/launch.mp4"
FONT="/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
ffmpeg -y -v error -i "$SRC" -filter_complex "
[0:v]trim=start=20.5:end=21.9,setpts=PTS-STARTPTS,crop=608:1080:656:0,scale=720:1280:flags=lanczos,setsar=1,format=yuv420p,drawtext=fontfile=$FONT:text='ONLY IN GTA 6':fontsize=46:fontcolor=white:borderw=2:bordercolor=black:box=1:boxcolor=black@0.55:boxborderw=14:x=(w-text_w)/2:y=70[v0];
[0:a]atrim=start=20.5:end=21.9,asetpts=PTS-STARTPTS,aresample=48000,aformat=channel_layouts=stereo[a0];
[0:v]trim=start=19.0:end=20.5,setpts=PTS-STARTPTS,crop=608:1080:656:0,scale=720:1280:flags=lanczos,setsar=1,format=yuv420p[v1];
[0:a]atrim=start=19.0:end=20.5,asetpts=PTS-STARTPTS,aresample=48000,aformat=channel_layouts=stereo[a1];
[0:v]trim=start=25.8:end=27.8,setpts=PTS-STARTPTS,crop=608:1080:400:0,scale=720:1280:flags=lanczos,setsar=1,format=yuv420p[v2];
[0:a]atrim=start=25.8:end=27.8,asetpts=PTS-STARTPTS,aresample=48000,aformat=channel_layouts=stereo[a2];
[0:v]trim=start=34.9:end=36.0,setpts=PTS-STARTPTS,crop=608:1080:656:0,scale=720:1280:flags=lanczos,setsar=1,format=yuv420p[v3];
[0:a]atrim=start=34.9:end=36.0,asetpts=PTS-STARTPTS,aresample=48000,aformat=channel_layouts=stereo[a3];
[0:v]trim=start=48.0:end=50.0,setpts=PTS-STARTPTS,crop=608:1080:656:0,scale=720:1280:flags=lanczos,setsar=1,format=yuv420p[v4];
[0:a]atrim=start=48.0:end=50.0,asetpts=PTS-STARTPTS,aresample=48000,aformat=channel_layouts=stereo,afade=t=out:st=1.6:d=0.4[a4];
color=black:s=720x1280:r=30:d=2,format=yuv420p,drawtext=fontfile=$FONT:text='MAKE CLIPS LIKE THIS':fontsize=52:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2-45,drawtext=fontfile=$FONT:text='WITH AI':fontsize=52:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2+45[v5];
anullsrc=r=48000:cl=stereo:d=2[a5];
color=black:s=720x1280:r=30:d=2,format=yuv420p,drawtext=fontfile=$FONT:text='AND EARN MONEY':fontsize=52:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2-45,drawtext=fontfile=$FONT:text='ON MAKE.FUN':fontsize=52:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2+45[v6];
anullsrc=r=48000:cl=stereo:d=2[a6];
color=black:s=720x1280:r=30:d=2,format=yuv420p,drawtext=fontfile=$FONT:text='make.fun':fontsize=64:fontcolor=0x2fd35c:x=(w-text_w)/2:y=(h-text_h)/2-50,drawtext=fontfile=$FONT:text='/bounty/gta6-clipper-01':fontsize=40:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2+50[v7];
anullsrc=r=48000:cl=stereo:d=2[a7];
[v0][a0][v1][a1][v2][a2][v3][a3][v4][a4][v5][a5][v6][a6][v7][a7]concat=n=8:v=1:a=1[vout][aout]
" -map "[vout]" -map "[aout]" -c:v libx264 -crf 20 -preset medium -pix_fmt yuv420p -r 30 -c:a aac -b:a 128k -movflags +faststart clip/gta6-clip.mp4
ffprobe -v error -show_entries format=duration,size -show_entries stream=width,height,codec_name -of default=noprint_wrappers=1 clip/gta6-clip.mp4
