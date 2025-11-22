#!/bin/bash

echo "=========================================="
echo " Atualizando sistema e instalando pacotes "
echo "=========================================="
sudo apt update -y && sudo apt upgrade -y
pip install boto3
sudo apt install -y jq tree openjdk-17-jdk
sudo npm install -g npm@latest

echo "=========================================="
echo " Redimensionando disco do Cloud9 "
echo "=========================================="

# Tamanho desejado do disco (GiB)
export CLOUD9_DISK_NEW_SIZE=150

# ID da instância
export CLOUD9_EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
echo "EC2 Instance ID: $CLOUD9_EC2_INSTANCE_ID"

# Volume da instância
export CLOUD9_EC2_VOLUME_ID=$(aws ec2 describe-instances \
  --instance-id $CLOUD9_EC2_INSTANCE_ID \
  | jq -r '.Reservations[0].Instances[0].BlockDeviceMappings[0].Ebs.VolumeId')

echo "Volume EBS ID: $CLOUD9_EC2_VOLUME_ID"

# Solicitar expansão do volume
aws ec2 modify-volume --volume-id $CLOUD9_EC2_VOLUME_ID --size $CLOUD9_DISK_NEW_SIZE

echo "Aguardando expansão do volume..."
while [ "$(aws ec2 describe-volumes-modifications \
  --volume-id $CLOUD9_EC2_VOLUME_ID \
  --filters Name=modification-state,Values="optimizing","completed" \
  | jq '.VolumesModifications | length')" != "1" ]; do
    echo "Esperando volume ficar pronto..."
    sleep 2
done

echo "Volume expandido com sucesso!"
echo "=========================================="

echo "Detectando disco..."
lsblk

export DISK_NAME=$(lsblk -o NAME -n | grep -E '^nvme0n1$|^xvda$')
echo "Disco encontrado: $DISK_NAME"

if [[ "$DISK_NAME" == "nvme0n1" ]]; then
    echo "Expandindo partição NVMe..."
    sudo growpart /dev/nvme0n1 1
    sudo resize2fs /dev/nvme0n1p1

elif [[ "$DISK_NAME" == "xvda" ]]; then
    echo "Expandindo partição padrão xvda..."
    sudo growpart /dev/xvda 1
    sudo resize2fs /dev/xvda1

else
    echo "ERRO: Não foi possível encontrar NVMe ou Xvda!"
    exit 1
fi

echo "=========================================="
echo " Redimensionamento concluído! "
echo "=========================================="
df -h
