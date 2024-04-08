log_file="/tmp/expense.log"


echo -e "\e[36m Installing ngInx \e[0m"
dnf install nginx -y &>>$log_file

echo -e "\e[36m Installing ngInx \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file

rm -rf /usr/share/nginx/html/* &>>$log_file

curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file

cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file

systemctl enable nginx &>>$log_file
systemctl start nginx &>>$log_file
