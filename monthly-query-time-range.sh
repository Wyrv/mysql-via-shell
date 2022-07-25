#!/bin/sh
############################################################################################
# SCRIPT COMPONENTE
# CRIADO POR: VINICIOS ARAUJO
# USO:
# AUTOMATIZACAO DE SELECTS MENSAIS COM RANGE DE TEMPO
############################################################################################

#ARGUMENTOS
# 1 - NOME DA SELECT (/scripts/monthly-queries/sql-queries)

#INICIO
ARG_1=$1
NAME_OUTPUT=$(echo $1 | cut -d. -f1 | tr -d '\r')
MACHINE=$(uname -n)

#STATUS FILE
	SELF_PATH="/scripts/monthly-queries"
	STATUS_FILE="$SELF_PATH/param/status"
	STATUS_NOW=$(cat $STATUS_FILE | tr -d '\r')
	
#ARQUIVOS DE EXEMPLO
	SAMPLE_DIR="/scripts/monthly-queries/sql-queries"
	SAMPLE_FULL_PATH="$SAMPLE_DIR/$1"
	
#DIRETORIO DE TRABALHO
	WORK_IN="$SAMPLE_DIR/work-in"
	
#DIRETORIO DE OUTPUT
	OUTPUT="$SELF_PATH/output"

#TIME STAMP E DATA P/ SQL
	TIME_STAMP=$(/bin/date +%d_%m_%Y-%H:%M:%S)

	D_INI=$(/bin/date --date="$(date +%Y-%m-01) -1 month" +%d)
	M_INI=$(/bin/date --date="$(date +%Y-%m-01) -1 month" +%m)
	Y_INI=$(/bin/date --date="$(date +%Y-%m-01) -1 day" +%Y)

	D_END=$(/bin/date --date="$(date +%Y-%m-01) -1 day" +%d)
	M_END=$(/bin/date --date="$(date +%Y-%m-01) -1 month" +%m)
	Y_END=$(/bin/date --date="$(date +%Y-%m-01) -1 day" +%Y)

echo "Inicializando query automatizada"

mkdir -p $OUTPUT
mkdir -p $WORK_IN

if [ $STATUS_NOW = 0 ]; then
	echo "Execucao nao autorizada. Verificar $STATUS_FILE"
	exit
fi

#VERIFICA SE ARGUMENTO FOI INPUTADO
if [[ !$ARG_1 ]]; then

#VERIFICAR SE O ARQUIVO DE SELECT EXISTE
  if [ -e $SAMPLE_FULL_PATH ]; then
    cp -v $SAMPLE_FULL_PATH $WORK_IN/
	echo "Substituindo Parametros de data da Query (INICIAL)"
	echo " " 
    sed -i "s/*D_INI\*/$D_INI/g" $WORK_IN/$ARG_1 #SUBSTITUI DIA INICIAL *D_INI*
    sed -i "s/*M_INI\*/$M_INI/g" $WORK_IN/$ARG_1 #SUBSTITUI MES INICIAL *M_INI*
    sed -i "s/*Y_INI\*/$Y_INI/g" $WORK_IN/$ARG_1 #SUBSTITUI ANO INICIAL *Y_INI*
	echo "Substituindo Parametros de data da Query (FINAL)"
	echo " " 
    sed -i "s/*D_END\*/$D_END/g" $WORK_IN/$ARG_1 #SUBSTITUI DIA FINAL *D_END*
    sed -i "s/*M_END\*/$M_END/g" $WORK_IN/$ARG_1 #SUBSTITUI MES FINAL *M_END*
    sed -i "s/*Y_END\*/$Y_END/g" $WORK_IN/$ARG_1 #SUBSTITUI ANO FINAL *Y_END*
	COPYSAMPLE=1
  else 
    echo "Sample SQL nao existe"
  COPYSAMPLE=0
  fi

else 
  echo "Faltando argumento"
  COPYSAMPLE=0
fi

#echo "NOME: $NAME_OUTPUT"
#echo "CONEXAO: $WORK_IN/$ARG_1"
#echo "OUTPUT: $OUTPUT/$ARG_1-$D_INI-$M_INI-$Y_INI-ate-$D_END-$M_END-$Y_END.txt"
#COPYSAMPLE=0

echo " "

#EXECUTANDO QUERY
if [ $COPYSAMPLE != 0 ]; then
  /usr/bin/mysql < $WORK_IN/$ARG_1 > $OUTPUT/$MACHINE-$NAME_OUTPUT-$D_INI-$M_INI-$Y_INI-ate-$D_END-$M_END-$Y_END.txt
  echo "Query concluida: "
  ls -ltah $OUTPUT/* | grep $TIME_STAMP

else
  echo "Query nao executada: COPYSAMPLE: $COPYSAMPLE"
 
fi

echo " "
echo "Apagando arquivo da area de trabalho: $WORK_IN/$ARG_1"
rm -fv $WORK_IN/$ARG_1
 
 #FINAL
