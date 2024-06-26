source common.sh

MYSQL_ROOT_PASSWORD=$1

if [ -z "$1" ]; then
  echo Password is Missing
  exit
fi

echo -e "${color} Disable nodejs default version \e[0m"
dnf module disable nodejs -y &>>$log_file
status_check

echo -e "${color} Download node js 18 version \e[0m"
dnf module enable nodejs:18 -y &>>$log_file
status_check

echo -e "${color} install node js \e[0m"
dnf install nodejs -y &>>$log_file
status_check

echo -e "${color} Download backend application file \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
status_check

id expense &>>$log_file
if [ $? -ne 0 ]; then
  echo -e "${color} Add application user \e[0m"
  useradd expense &>>$log_file
  status_check
fi

if [ ! -d /app ]; then
  echo -e "${color} Create application directory \e[0m"
  mkdir /app &>>$log_file
  status_check
fi

echo -e "${color} Delete old content \e[0m"
rm -rf /app/* $>>$log_file
status_check

echo -e "${color} Download Application content \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
status_check

echo -e "${color} Extract application content \e[0m"
cd /app &>>$log_file
unzip /tmp/backend.zip &>>$log_file
status_check

echo -e "${color} Install nodejs dependencies \e[0m"
cd /app &>>$log_file
npm install &>>$log_file
status_check

echo -e "${color} load schema \e[0m"
dnf install mysql -y &>>$log_file
mysql -h mysql-dev.manireddy.online -uroot -p${MYSQL_ROOT_PASSWORD} < /app/schema/backend.sql &>>$log_file
status_check

echo -e "${color} Starting backend service \e[0m"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl start backend &>>$log_file
status_check