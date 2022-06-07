if [ $(id -u) -eq 0 ]
then
	if ! getent passwd | grep ubuntu
	then
		useradd -p "" ubuntu
		usermod -aG sudo ubuntu
		chown -R ubuntu /home/ubuntu
		chmod u+rxw -R /home/ubuntu
		cp /root/.ubuntu_bashrc /home/ubuntu/.bashrc

		echo "[INFO] User ubuntu is now registered"

		chsh --shell /bin/bash ubuntu

		echo "[INFO] Login shell for user ubuntu is now /bin/bash"
		echo "To change this, execute:"
		echo "    chsh --shell <path-to-shell> ubuntu"

		runuser -l ubuntu -c "rosdep update"
		cd /home/ubuntu && su ubuntu
	else
		echo "[INFO] User ubuntu has already been registered"
		cd /home/ubuntu && su ubuntu
	fi
else
	echo "[INFO] User ubuntu has already been registered"
	cd /home/ubuntu && su ubuntu
fi
