#!/bin/bash

# Linux version of the batch script for converting datat for use in Android "branches"
# see more here http://blog.bagearon.com/2012/04/terraria-on-android-progress/
# Linux requirements: Mono (for xsound app)
#                     ffmpeg for audio conversion to .ogg

md=mkdir
copy=cp
robocopy="cp -r"

$md "Wave Bank"
$copy "Content/Wave Bank.xwb" .
perl xactxtract2.pl -x "Wave Bank.xwb"
$md branches
$md branches/Content
$md branches/Content/Sounds
$md branches/Content/Fonts
$md branches/Content/Music
$md branches/Players
$md branches/Worlds
$md branches/Bin
cd "Wave Bank"
#for /f "delims=;" %%f in ('dir/b /s *.xwma') do ffmpeg -y -i "%%f" -acodec libvorbis "../branches/Content/Music/%%~nf.ogg"

for f in `ls *.xwma`; do ls $f && filename="${f%.*}" && ffmpeg -y -i $f -acodec libvorbis "../branches/Content/Music/$filename.ogg" ; done
cd ..
mkdir Sounds
$robocopy Content/Sounds/* ./Sounds/
$copy xsound.exe ./Sounds/
cd Sounds
#NOTE I had to run the below command manually - something todo with CLI and GUI modes of MONO
mono xsound
#for /f "delims=;" %%f in ('dir/b /s *.wav') do ffmpeg -y -i "%%f" -acodec libvorbis "..\branches\Content\Sounds\%%~nf.ogg"
for f in `ls *.wav`; do ls $f && filename="${f%.*}" && ffmpeg -y -i $f -acodec libvorbis "../branches/Content/Sounds/$filename.ogg" ; done
cd ..
$robocopy Content/Images/* ./branches/Content/Images/
$robocopy Content/Fonts/* ./branches/Content/Fonts/
$robocopy Players/* ./branches/Players
$robocopy Worlds/* ./branches/Worlds
$copy Terraria.exe ./branches/Bin

adb push branches /sdcard/branches

