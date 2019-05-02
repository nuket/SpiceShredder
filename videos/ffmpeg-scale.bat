@echo Script to scale and mark a video file.

@echo Easiest way to check that the drawtext filter is working is output a single
@echo frame to a .png file.

@echo Add this to do a slice of the video first
@echo -t 00:00:03

@echo First-pass for loudness normalization.
@rem ffmpeg -i %1 -movflags faststart -c:v libx264 -b:v 4096k -maxrate 4096k -bufsize 2048k -vf "scale=1920:-1,unsharp,drawtext=fontfile='C\:\\Windows\\Fonts\\Bahnschrift.ttf': text='@vilimpoc': fontcolor=gray: fontsize=36: x=(w-text_w-24): y=(h-text_h-16)" -codec:a aac -ar 48k -b:a 128k -filter:a "loudnorm=I=-16:TP=-1.5:LRA=11:print_format=json" -f null -

@echo Second-pass using first-pass measurements.
@echo [Parsed_loudnorm_0 @ 00000130d16077c0]
@echo {
@echo     "input_i" : "-42.08",
@echo     "input_tp" : "-26.18",
@echo     "input_lra" : "26.20",
@echo     "input_thresh" : "-56.17",
@echo     "output_i" : "-31.22",
@echo     "output_tp" : "-16.75",
@echo     "output_lra" : "25.10",
@echo     "output_thresh" : "-46.47",
@echo     "normalization_type" : "dynamic",
@echo     "target_offset" : "15.22"
@echo }

@rem 1920p24 version

ffmpeg -i %1 -movflags faststart -c:v libx264 -b:v 4096k -maxrate 4096k -bufsize 2048k ^
-filter:v "scale=1920:-1,unsharp,drawtext=fontfile='C\:\\Windows\\Fonts\\Bahnschrift.ttf': text='@vilimpoc': fontcolor=gray: fontsize=36: x=(w-text_w-24): y=(h-text_h-16)" ^
-codec:a aac -ar 48k -b:a 128k ^
-filter:a "loudnorm=I=-16:TP=-1.5:LRA=11:measured_I=-42.08:measured_LRA=26.20:measured_TP=-26.18:measured_thresh=-56.17:offset=15.22:linear=true:print_format=summary" %2

@rem 1280p24 version

@rem ffmpeg -i %1 -movflags faststart -c:v libx264 -b:v 2048k -maxrate 2048k -bufsize 1024k ^
@rem -filter:v "scale=1280:-1,unsharp,drawtext=fontfile='C\:\\Windows\\Fonts\\Bahnschrift.ttf': text='@vilimpoc': fontcolor=gray: fontsize=24: x=(w-text_w-13): y=(h-text_h-8)" ^
@rem -codec:a aac -ar 48k -b:a 128k ^
@rem -filter:a "loudnorm=I=-16:TP=-1.5:LRA=11:measured_I=-42.08:measured_LRA=26.20:measured_TP=-26.18:measured_thresh=-56.17:offset=15.22:linear=true:print_format=summary" %2
