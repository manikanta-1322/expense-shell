source common.sh

MYSQL_ROOT_PASSWORD=$1

if [ -z "$1" ]; then
  echo Password is Missing
  exit
fi

echo -e "${color} Disable MySql default version \e[0m"
dnf module disable mysql -y &>>$log_file
status_check

echo -e "${color} Copy MySql Repo file \e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
status_check


echo -e "${color} Install MySql Server \e[0m"
dnf install mysql-community-server -y &>>$log_file
status_check


echo -e "${color} Start MySql Server \e[0m"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
status_check


echo -e "${color} Set MySql Password \e[0m"
mysql_secure_installation --set-root-pass ${MYSQL_ROOT_PASSWORD} &>>$log_file
status_check
