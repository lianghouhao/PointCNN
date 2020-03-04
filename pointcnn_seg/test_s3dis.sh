#!/usr/bin/env bash

gpu=
setting=
area=
ckpt=
repeat=
save_ply=
data_folder="/home/houhao/paper_implementation/data/S3DIS/prepare_label_rgb"

usage() { echo "test pointcnn_seg with -g gpu_id -x setting -a area -l ckpt -r repeat -s options"; }

gpu_flag=0
setting_flag=0
area_flag=0
ckpt_flag=0
repeat_flag=0
while getopts g:x:a:l:r:sh opt; do
  case $opt in
  g)
    gpu_flag=1;
    gpu=$(($OPTARG))
    ;;
  x)
    setting_flag=1;
    setting=${OPTARG}
    ;;
  a)
    area_flag=1;
    area=$(($OPTARG))
    ;;
  l)
    ckpt_flag=1;
    ckpt=${OPTARG}
    ;;
  r)
    repeat_flag=1;
    repeat=$(($OPTARG))
    ;;
  s)
    save_ply=-s
    ;;
  h)
    usage; exit;;
  esac
done

shift $((OPTIND-1))

if [ $gpu_flag -eq 0 ]
then
  echo "-g option is not presented!"
  usage; exit;
fi

if [ $setting_flag -eq 0 ]
then
  echo "-x option is not presented!"
  usage; exit;
fi

if [ $area_flag -eq 0 ]
then
  echo "-a option is not presented!"
  usage; exit;
fi

if [ $ckpt_flag -eq 0 ]
then
  echo "-l option is not presented!"1
  usage; exit;
fi

if [ $repeat_flag -eq 0 ]
then
  echo "-r option is not presented!"
  usage; exit;
fi

echo "Test setting $setting on GPU $gpu with checkpoint $ckpt! with repeat $repeat"
CUDA_VISIBLE_DEVICES=$gpu python3 ../test_general_seg.py -t $data_folder/train_files_for_val_on_Area_$area.txt -t $data_folder/val_files_Area_${area}.txt -l $ckpt -m pointcnn_seg -x $setting -r $repeat $save_ply

# ./test_s3dis.sh -g 0 -x s3dis_x8_2048_fps -a 3 -l ../../models/seg/pointcnn_seg_s3dis_x8_2048_fps_2020-02-25-19-12-34_9672/ckpts/iter-17500 -r 1
