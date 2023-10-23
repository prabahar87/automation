#!/bin/bash

# Initialize the HTML file
echo "<html><body><table>" > ping_results.html

# Loop through the servers in the inventory file
while IFS=, read -r server ssh_password; do
    # Execute the Ansible ping module with the appropriate password using 'expect'
    ping_output=$(expect -c "
        spawn ansible $server -i ip_list -m ping
        expect { # If this command is not installed on your machine, do the installation using dnf/yum for RHEL/Centos/Fedora based OS and apt for debian based OS.
            \"*password:\" {
                send \"$ssh_password\r\"
                exp_continue
            }
            \"UNREACHABLE\" {
                exit 1
            }
            \"SUCCESS\" {
                exit 0
            }
            eof
        }
    ")
    result=$?

    if [ $result -eq 0 ]; then
        status="Success"
    else
        status="Failed"
    fi

    # Append the result to the HTML file
    echo "<tr><td>$server</td><td>$status</td></tr>" >> ping_results.html

done < ip_list

# Close the HTML file
echo "</table></body></html>" >> ping_results.html

echo "Ping results for servers are saved in ping_results.html"
