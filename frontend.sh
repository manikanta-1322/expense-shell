log_file="/tmp/expense.log"
color="\e[33m"

echo -e "${color} Installing ngInx \e[0m"
dnf install nginx -y &>>$log_file
echo $?

echo -e "${color} Copy expense conf.. \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
echo $?

echo -e "${color} Clean old NgInx content \e[0m"
rm -rf /usr/share/nginx/html/* &>>$log_file
echo $?

echo -e "${color} Download frontend application code \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
echo $?

echo -e "${color} Extract downloaded application content \e[0m"
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
echo $?

echo -e "${color} Starting NgInx service \e[0m"
systemctl enable nginx &>>$log_file
systemctl start nginx &>>$log_file
echo $?
