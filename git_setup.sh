#!/bin/sh

echo "Configuring Git..."

expect -c "
    spawn git config --global user.name 'OliveiraEdu'
    expect \"No username configured.\"
    send \"\r\"
    spawn git config --global user.email 'eduardocostaoliveira@gmail.com'
    expect \"No email configured.\"
    send \"\r\"
"