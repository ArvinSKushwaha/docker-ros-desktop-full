if [ $(id -u) -eq 0 ]
then
	deluser ubuntu
else
	echo "[ERROR] Insufficient privileges to delete user ubuntu"
fi
