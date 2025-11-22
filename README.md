# pipeline_data_engineering

Criar ambiente

1 - Reigão = Norte da Virgínia, não alterar !
2 - Execute o comando a seguir no CloudShell da AWS:

curl -sS https://raw.githubusercontent.com/Git-Mota/pipeline_data_engineering/refs/heads/main/environment/create_cloud9.sh | bash

Configurar ambiente

3 - Abra o clou9 pelo console AWS.
4 - Dentro do cloud9, abra um terminal e execute o código: 

curl -sS https://raw.githubusercontent.com/Git-Mota/pipeline_data_engineering/refs/heads/main/environment/config_clou9.sh | bash

5 - Ainda no cloud9, execute os códigos: 

sudo apt update -y && sudo apt upgrade -y

sudo apt install -y openjdk-17-jdk


6 - Crie um ambiente virtual (recomendado):

python3 -m venv .venv

source .venv/bin/activate

pip install pyspark










