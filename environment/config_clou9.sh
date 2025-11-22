#!/bin/bash

echo "========================="
echo " Atualizando o sistema "
echo "========================="
sudo apt update -y && sudo apt upgrade -y

echo "========================="
echo " Instalando boto3 "
echo "========================="
pip install boto3

echo "========================="
echo " Instalando dependências "
echo "========================="
sudo apt install -y jq tree openjdk-17-jdk

echo "========================="
echo " Atualizando NPM "
echo "========================="
sudo npm install -g npm@latest

echo "========================="
echo " Redimensionando o disco Cloud9 "
echo "========================="

# --- DEFINIR TAMANHO NOVO DO DISCO (em GiB)
export CLOUD9_DISK_NEW_SIZE=150
echo "Novo tamanho definido: ${CLOUD9_DISK_NEW_SIZE} GiB"

# --- PEGAR ID DA INSTÂNCIA DO CLOUD9
export CLOUD9_EC2_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
echo "EC2 Instance ID: $CLOUD9_EC2_INSTANCE_ID"

# --- PEGAR ID DO VOLUME EBS
export CLOUD9_EC2_VOLUME_ID=$(aws ec2 describe-instances \
  --instance-id $CLOUD9_EC2_INSTANCE_ID \
  | jq -r .Reservations[0].Instances[0].BlockDeviceMappings[0].Ebs.VolumeId)

echo "Volume EBS ID: $CLOUD9_EC2_VOLUME_ID"

# --- ALTERAR O TAMANHO DO VOLUME EBS
echo "Enviando requisição para expandir o EBS..."
aws ec2 modify-volume --volume-id $CLOUD9_EC2_VOLUME_ID --size $CLOUD9_DISK_NEW_SIZE

echo "Aguardando finalização do redimensionamento..."
while [ "$(aws ec2 describe-volumes-modifications \
  --volume-id $CLOUD9_EC2_VOLUME_ID \
  --filters Name=modification-state,Values="optimizing","completed" \
  | jq '.VolumesModifications | length')" != "1" ]; do
    echo "Esperando o volume ser expandido..."
    sleep 1
done

echo "Volume expandido com sucesso!"

echo "========================="
echo " Ajustando partições "
echo "========================="

# Listar discos
lsblk

# Detectar nome correto do disco (nvme ou xvda)
export DISK_NAME=$(lsblk -o NAME -n | grep -E '^nvme0n1$|^xvda$')

echo "Disco detectado: $DISK_NAME"

if [[ "$DISK_NAME" == "nvme0n1" ]]; then
    echo "Expandindo partição NVMe..."
    sudo growpart /dev/nvme0n1 1
    sudo resize2fs /dev/nvme0n1p1

elif [[ "$DISK_NAME" == "xvda" ]]; then
    echo "Expandindo partição padrão (xvda)..."
    sudo growpart /dev/xvda 1
    sudo resize2fs /dev/xvda1

else
    echo "ERRO: Não foi possível localizar nvme0n1 ou xvda."
    exit 1
fi

echo "========================="
echo " Redimensionamento concluído! "
echo "========================="

df -h
