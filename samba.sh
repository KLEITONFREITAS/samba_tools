#!/usr/bin/env bash
## @Programa 
# 	@name: samba_tools
#	@versao: 1.0
#	@Data 22 de Junho de 2021
# 	
# 	@Direitos 
# 		@autor: Kleiton Freitas
#		@e-mail: kleiton.bittencourt@gmail.com
#	@Licenca: GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 <http://www.gnu.org/licenses/lgpl.txt>
#	
#	@Objetivo:
#		Este script tem como objetivo realizar a administração basica de um servidor Samba Share
#
#
while true; do
clear
echo "================================================

 ### Administracao de Servicos Samba Share ###

1) Adicionar Usuário

2) Bloquear Usuário

3) Habilitar Usuário

4) Redefinir Senha do Usuário

5) Criar Grupo

6) Adicionar Usuário a um Grupo

7) Criar Pasta Compartilhada

99)Sair do programa

================================================"

read -p "Digite a opção desejada: " x
echo "Opção informada ($x)
================================================"

case "$x" in
1)
echo "Adicionar Usuário:"
read -p "Insira o nome do usuário: " usuario
useradd -M $usuario
if [ $? -eq 0 ]
then
	echo "Insira uma senha para o usuário: $usuario"
	smbpasswd -a $usuario
	echo "Usuário $usuario criado com Sucesso!"
else
	echo "!!! ERROR !!! "
fi
sleep 2s
echo "================================================"
;;
2)
echo "Bloquear Usuário:"
read -p "Insira o nome do usuário: " usuario
smbpasswd -d $usuario
if [ $? -eq 0 ]
then
	echo "Usuário $usuario Bloqueado com Sucesso!"
else
	echo "!!! ERROR !!! "
fi
sleep 2s
echo "================================================"
;;
3)
echo "Habilitar Usuário:"
read -p "Insira o nome do usuário: " usuario
smbpasswd -e $usuario
if [ $? -eq 0 ]
then
	echo "Usuário" $usuario "Habilitado com Sucesso!"
else
	echo "!!! ERROR !!! "
fi
sleep 2s
echo "================================================"
;;
4)
echo "Redefinir Senha do Usuário:"
read -p "Insira o nome do usuário: " usuario
smbpasswd -U $usuario
if [ $? -eq 0 ]
then
	echo "Senha do usuário" $usuario "Redefinida com Sucesso!"
else
	echo "!!! ERROR !!! "
fi
sleep 2s
echo "================================================"
;;
5)
echo "Criar um grupo:"
read -p "Insira o nome do grupo: " grupo
addgroup $grupo 
sleep 2s
echo "================================================"
;;
6)
echo "Adicionar Usuário a um Grupo"
read -p "Insira o nome do usuário: " usuario
read -p "Insira o nome do grupo: " grupo
addgroup $usuario $grupo
if [ $? -eq 0 ]
then
	echo "Usuário" $usuario "adicionado ao Grupo:" $grupo "com sucesso"
else
	echo "!!! ERROR !!! "
fi
sleep 2s
echo "================================================"
;;
7)
echo "Criar Uma Pasta Compartilhada"
read -p "Nome da pasta Compartilhada " pasta
mkdir /home/$pasta
if [ $? -eq 0 ]
then
	read -p "Insira o grupo da pasta $pasta: " grupo
	cat /etc/group | cut -d: -f1 | grep "$grupo"		
	if [ $? -eq 0 ]
		then
		chgrp $grupo /home/$pasta #EM PRODUÇÃO ALTERAR O CAMINHO ONDE OS COMPARTILHAMENTOS SERAM CRIADOS
		echo "Pasta $pasta criada com sucesso!"
		echo "Adicionado o Grupo $grupo a pasta $pasta com sucesso!"
		cd /home #EM PRODUÇÃO COLOCAR CAMINHO ONDE FOI MONTADO A PARTIÇÃO DOS DADOS
		chmod 770 -R $pasta
		echo "[$pasta]
		comment = Pasta $pasta
		path = /home/$pasta
		writable = yes
		browseable = yes
		create mode = 0770
		directory mode = 0770
		valid users = @$grupo " >> /etc/samba/smb.conf.old.old
		systemctl restart smbd nmbd
		fi
else
	echo "!!! ERROR !!! ao Criar a Pasta $pasta "
fi
sleep 5s
echo "================================================"
;;
99)
echo "saindo..."
sleep 2s
clear
exit 0
;;
*) echo "Opção inválida!"
esac
done

