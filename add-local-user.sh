#!/bin/bash

# The goal is to create a shell script that adds users to the same Linux system as the script is executed on

# Make sure the script is being executed with superuser privileges
if [[ "${UID}" -ne 0 ]]
then
	echo 'Run with sudo'
	exit 1
fi

# Get the username (login)
read -p 'Enter the username to create: ' USER_NAME

# Get the real name (contents for the description field)
read -p 'Enter your real name of the person who will be using this account: ' REAL_NAME

# Get the password
read -p 'Enter the password: ' PASSWORD

# Create the user with the password
adduser -c "${REAL_NAME}" -m ${USER_NAME}

# Check to see if the useradd command succeeded
if [[ "${?}" -ne 0 ]]
then
	echo 'The account was not created'
	exit 1
fi

# Set the password
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# Check to see if the passwd command succeeded
if [[ "${?}" -ne 0 ]]
then
	echo 'The password for the account could not be set'
	exit 1
fi

# Force password change on first login
passwd -e ${USER_NAME}

# Display the username, password and the host where the user was created
echo
echo "Username: ${USER_NAME}"
echo
echo "Password: ${PASSWORD}"
echo
echo "Host: ${HOSTNAME}"
exit 0
