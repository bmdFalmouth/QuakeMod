#!/usr/bin/env zsh
set -euo pipefail

Deployment_Dir="../mymod/"
Source_Dir="../src/"

#for textures and models
Source_Models_Dir="models/"
Deployment_Models_Dir="progs/"

Source_Config_Dir="config/"
Deplyment_Config_Dir=""

Source_Map_Dir="maps/"
Deployment_Map_Dir="maps/"


#check to see if the mod directory exists
if [ ! -d "$Deployment_Dir" ]; then
  echo "$Deployment_Dir does not exist, creating it"
  mkdir $Deployment_Dir
fi

#copy all texture and models from source to model dir
echo "Copying Models, Textures & Maps"
Deployment_Models_Dir=$Deployment_Dir$Deployment_Models_Dir
if [ ! -d "$Deployment_Models_Dir" ]; then
    mkdir $Deployment_Models_Dir
fi

Deployment_Map_Dir=$Deployment_Dir$Deployment_Map_Dir
if [ ! -d "$Deployment_Map_Dir" ]; then
    mkdir $Deployment_Map_Dir
fi

Source_Models_Dir=$Source_Dir$Source_Models_Dir
Source_Map_Dir=$Source_Dir$Source_Map_Dir

models=($(find $Source_Models_Dir -type f -name "*.mdl"))
textures=($(find $Source_Models_Dir -type f -name "*.png"))
maps=($(find $Source_Map_Dir -type f -name "*.bsp"))

for m in "${models[@]}"; do
    cp "$m" "$Deployment_Models_Dir/"
done

for t in "${textures[@]}"; do
    cp "$t" "$Deployment_Models_Dir/"
done

for map in "${maps[@]}"; do
    cp "$map" "$Deployment_Map_Dir/"
done

echo "Copying all config files"
Source_Config_Dir=$Source_Dir$Source_Config_Dir
configs=($(find $Source_Config_Dir -type f -name "*.cfg"))

for c in "${configs[@]}"; do
    cp "$c" "$Deployment_Dir/"
done

